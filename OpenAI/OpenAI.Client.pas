unit OpenAI.Client;

interface

uses ChatSettings, OpenAI.Classes, System.Net.HttpClient, System.Generics.Collections;

type
  TChatCompletionChunkEvent = procedure(C: TChatCompletionChunk) of object;
  TChatCompletionStreamCompleteEvent = procedure of object;
  TChatCompletionEvent = procedure(R: TChatCompletion) of object;

  TOpenAIClient = class
    constructor Create(const settings: TChatSettings);
    destructor Destroy; override;

    procedure onReceiveDataCallBackHandler(const Sender: TObject; AContentLength: Int64; AReadCount: Int64; var AAbort: Boolean);

  private
    FSystemMessage: TChatMessage;
    FMessages: TObjectList<TChatMessage>;
    FSettings: TChatSettings;
    FWebClient: THttpClient;

    FOnChunkReceived: TChatCompletionChunkEvent;
    FOnChatCompletionStreamComplete: TChatCompletionStreamCompleteEvent;
    FOnCompletionReceived: TChatCompletionEvent;

  public
    procedure SendMessage(const msg: string; stream: Boolean = False);
    procedure UpdateSettings(const settings: TChatSettings);
    procedure SetSystemMessage(const systemMessage: string);
    procedure UnsetSystemMessage;
    procedure Reset;

    procedure ImportMessageFromJson(jsonString: string);
    function ExportMessagesAsJson: string;

    property OnChunkReceived: TChatCompletionChunkEvent read FOnChunkReceived write FOnChunkReceived;
    property OnChatCompletionStreamComplete: TChatCompletionStreamCompleteEvent read FOnChatCompletionStreamComplete write FOnChatCompletionStreamComplete;
    property OnCompletionReceived: TChatCompletionEvent read FOnCompletionReceived write FOnCompletionReceived;

  end;

implementation

uses SysUtils, System.Classes, System.JSON, System.Types, REST.Types, REST.JSON, REST.JsonReflect;

var
  chunkedResponseBuilder: TStringBuilder;
  chunkedResponseStream: TStringStream;
  lastResponseStreamPosition: Integer;

  { Constructor / Destructor }
constructor TOpenAIClient.Create(const settings: TChatSettings);
begin
  FSettings := settings;
  FMessages := TObjectList<TChatMessage>.Create;

  FWebClient := THttpClient.Create;
  FWebClient.HandleRedirects := True;
  FWebClient.ResponseTimeout := 60000;
  FWebClient.ContentType := 'application/json';
  FWebClient.CustomHeaders['Authorization'] := 'Bearer ' + FSettings.ApiKey;

end;

destructor TOpenAIClient.Destroy;
begin
  inherited;
  FreeAndNil(FMessages);
  FreeAndNil(FWebClient);
  FreeAndNil(FSettings);
  FreeAndNil(FSystemMessage);
end;

{ Public Procedures }
procedure TOpenAIClient.UpdateSettings(const settings: TChatSettings);
begin
  FSettings := settings;
end;

procedure TOpenAIClient.Reset;
begin
  FMessages.Clear;
end;

function TOpenAIClient.ExportMessagesAsJson: string;
begin
  Result := TJson.ObjectToJsonString(FMessages, [TJsonOption.joIgnoreEmptyStrings, TJsonOption.joIgnoreEmptyArrays, TJsonOption.joIndentCaseLower]);
end;

procedure TOpenAIClient.ImportMessageFromJson(jsonString: string);
var
  messages: TArray<TChatMessage>;
  I: Integer;
begin
  FMessages := TJson.JsonToObject<TObjectList<TChatMessage>>(jsonString, [TJsonOption.joIgnoreEmptyStrings, TJsonOption.joIgnoreEmptyArrays, TJsonOption.joIndentCaseLower]);
end;

procedure TOpenAIClient.SetSystemMessage(const systemMessage: string);
begin
  FSystemMessage := TChatMessage.Create;
  FSystemMessage.Content := systemMessage;
  FSystemMessage.Role := 'system';
end;

procedure TOpenAIClient.UnsetSystemMessage;
begin
  FreeAndNil(FSystemMessage);
end;

procedure TOpenAIClient.onReceiveDataCallBackHandler(const Sender: TObject; AContentLength: Int64; AReadCount: Int64; var AAbort: Boolean);
var
  initPos: Integer;
  readDelta: Integer;
  I: Integer;
  respData: string;
  substrs: TArray<string>;
  chunks: array of TChatCompletionChunk;
begin

  if AReadCount = 0 then
    exit;

  initPos := chunkedResponseStream.Position;
  readDelta := AReadCount - lastResponseStreamPosition;
  chunkedResponseStream.Position := chunkedResponseStream.Position - readDelta;

  respData := chunkedResponseStream.ReadString(readDelta);

  substrs := respData.Split([#$A, #$A], TStringSplitOptions.ExcludeEmpty);
  SetLength(chunks, Length(substrs));
  try
    for I := 0 to Length(substrs) - 1 do
    begin
      chunks[I] := TJson.JsonToObject<TChatCompletionChunk>(substrs[I].Substring(5));
    end;

    lastResponseStreamPosition := initPos;
    for I := 0 to Length(chunks) - 1 do
    begin
      if Assigned(FOnChunkReceived) and (chunks[I] <> nil) then
      begin
        chunkedResponseBuilder.Append(chunks[I].Choices[0].Delta.Content);
        FOnChunkReceived(chunks[I]);
      end;
    end;
  except
    on e: EConversionError do
    begin

    end;
  end;

  chunkedResponseStream.Position := initPos;

end;

procedure TOpenAIClient.SendMessage(const msg: string; stream: Boolean);
var
  chatReq: TChatRequest;
  chatMsg: TChatMessage;
  reqJson: string;
  reqStream: TStringStream;

  httpResponse: IHTTPResponse;
  asyncRequest: IAsyncResult;

  resp: TChatCompletion;
  chunkedMsg: TChatMessage;
  I: Integer;
begin

  chatReq := TChatRequest.Create;
  chatReq.Model := FSettings.EngineModel;
  chatReq.Top_P := FSettings.TopPValue;
  chatReq.Temperature := FSettings.TemperatureValue;
  chatReq.stream := stream;

  chatMsg := TChatMessage.Create;
  chatMsg.Content := msg;
  chatMsg.Role := 'user';

  FMessages.Add(chatMsg);

  if Assigned(FSystemMessage) then
  begin
    chatReq.SetMessagesLength(FMessages.Count + 1);
    chatReq.messages[0] := FSystemMessage;
    for I := 1 to FMessages.Count do
    begin
      chatReq.messages[I] := FMessages[I - 1];
    end;
  end
  else
  begin
    chatReq.SetMessagesLength(FMessages.Count);
    for I := 0 to FMessages.Count - 1 do
    begin
      chatReq.messages[I] := FMessages[I];
    end;
  end;

  reqJson := TJson.ObjectToJsonString(chatReq, [TJsonOption.joIgnoreEmptyStrings, TJsonOption.joIgnoreEmptyArrays, TJsonOption.joIndentCaseLower]);
  reqStream := TStringStream.Create(reqJson);
  chunkedResponseStream := TStringStream.Create('', TEncoding.UTF8);

  if stream then
  begin
    chunkedResponseBuilder := TStringBuilder.Create;
    lastResponseStreamPosition := 0;

    FWebClient.ReceiveDataCallBack := onReceiveDataCallBackHandler;
    asyncRequest := FWebClient.BeginExecute('POST', 'https://api.openai.com/v1/chat/completions', reqStream, chunkedResponseStream);
    httpResponse := FWebClient.EndAsyncHTTP(asyncRequest);

    if Assigned(FOnChatCompletionStreamComplete) then
    begin
      FOnChatCompletionStreamComplete;
    end;

    if httpResponse.StatusCode > 300 then
    begin
      FreeAndNil(chunkedResponseBuilder);
      raise Exception.CreateFmt('Bad status code: %d %s%s%s', [httpResponse.StatusCode, httpResponse.StatusText, #$A#$A, chunkedResponseStream.DataString]);
    end;

    chunkedMsg := TChatMessage.Create;
    chunkedMsg.Role := 'assistant';
    chunkedMsg.Content := chunkedResponseBuilder.ToString;
    FMessages.Add(chunkedMsg);

    FreeAndNil(chunkedResponseBuilder);
  end
  else
  begin
    FWebClient.Post('https://api.openai.com/v1/chat/completions', reqStream, chunkedResponseStream);

    resp := TJson.JsonToObject<TChatCompletion>(chunkedResponseStream.DataString);
    FMessages.Add(resp.Choices[0].Message);
    if Assigned(FOnCompletionReceived) then
    begin
      FOnCompletionReceived(resp);
    end;
  end;

  FreeAndNil(reqStream);
  FreeAndNil(chunkedResponseStream);

end;

end.
