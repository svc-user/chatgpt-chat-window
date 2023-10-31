unit wMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, ChatSettings, Generics.Collections,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Menus, Vcl.StdCtrls, Vcl.ComCtrls,
  Vcl.ExtCtrls, OpenAI.Classes, OpenAI.Client, Vcl.WinXCtrls, Vcl.ExtDlgs;

type
  TSendMessageThread = class(TThread)
  private
    FRequestText: string;
    FStreaming: Boolean;
  public
    constructor Create(const ARequestText: string; streaming: Boolean);
    procedure Execute; override;
  end;

type
  TfrmMain = class(TForm)
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    fileBtnSettings: TMenuItem;
    Exit1: TMenuItem;
    txtResponse: TRichEdit;
    Splitter1: TSplitter;
    Panel1: TPanel;
    txtRequest: TRichEdit;
    btnSendMessage: TButton;
    Conversation1: TMenuItem;
    Setsystemprompt1: TMenuItem;
    menuResetConv: TMenuItem;
    menuSaveConv: TMenuItem;
    menuLoadConv: TMenuItem;
    dlgSaveConversation: TSaveTextFileDialog;
    dlgOpenConversation: TOpenTextFileDialog;
    procedure fileBtnSettingsClick(Sender: TObject);
    procedure onSettingsSaved(S: TChatSettings);
    procedure Exit1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnSendMessageClick(Sender: TObject);

    procedure onChunkReceived(C: TChatCompletionChunk);
    procedure onChunkedResponseComplete;

    procedure onCompletionReceived(C: TChatCompletion);
    procedure FormShow(Sender: TObject);
    procedure onSendMessageTerminateHandler(Sender: TObject);
    procedure menuResetConvClick(Sender: TObject);
    procedure SetFormCaption;
    procedure Setsystemprompt1Click(Sender: TObject);
    procedure menuSaveConvClick(Sender: TObject);
    procedure menuLoadConvClick(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure saveConversation;
    procedure loadConversation;
    procedure setSystemPromptForm;

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}

uses wSettings, wSysMessage, System.UITypes, IOUtils, REST.Json;

var
  ChatSettings: TChatSettings;
  apiClient: TOpenAIClient;

  { TfrmMain implementations }
procedure TfrmMain.btnSendMessageClick(Sender: TObject);
var
  sendMessageThread: TSendMessageThread;
begin

  txtRequest.Enabled := False;
  btnSendMessage.Enabled := False;
  txtResponse.SelAttributes.BackColor := $FFFFFF;
  txtResponse.Lines.Add(txtRequest.Text);
  txtResponse.Lines.Add('-------------------');
  SendMessage(txtResponse.handle, WM_VSCROLL, SB_BOTTOM, 0);

  sendMessageThread := TSendMessageThread.Create(txtRequest.Text, ChatSettings.StreamResponse);
  sendMessageThread.FreeOnTerminate := True;
  sendMessageThread.OnTerminate := onSendMessageTerminateHandler;
  sendMessageThread.Start;

end;

procedure TfrmMain.onSendMessageTerminateHandler(Sender: TObject);
begin
  txtRequest.Text := '';
  txtRequest.Enabled := True;
  btnSendMessage.Enabled := True;
  txtRequest.SetFocus;
end;

procedure TfrmMain.Exit1Click(Sender: TObject);
begin
  Self.Close;
end;

procedure TfrmMain.fileBtnSettingsClick(Sender: TObject);
var
  frmSettings: TfrmSettings;
begin
  frmSettings := TfrmSettings.Create(Self);
  frmSettings.OnSave := onSettingsSaved;
  frmSettings.ShowModal;

  FreeAndNil(frmSettings);
end;

procedure TfrmMain.menuSaveConvClick(Sender: TObject);
begin
  saveConversation;
end;

procedure TfrmMain.saveConversation;
var
  initDir, fileJson: string;
begin
  initDir := TPath.Combine(TPath.Combine(TPath.GetHomePath, '.chat-window'), 'conversations');
  dlgSaveConversation.InitialDir := initDir;
  if dlgSaveConversation.Execute then
  begin
    TFile.WriteAllText(dlgSaveConversation.FileName, apiClient.ExportMessagesAsJson, TEncoding.UTF8);

  end;
end;

procedure TfrmMain.menuLoadConvClick(Sender: TObject);
begin
  loadConversation;
end;

procedure TfrmMain.loadConversation;
var
  initDir: string;
  fileJson: string;
  Messages: TObjectList<TChatMessage>;
  I: Integer;
begin
  initDir := TPath.Combine(TPath.Combine(TPath.GetHomePath, '.chat-window'), 'conversations');
  dlgOpenConversation.InitialDir := initDir;
  if dlgOpenConversation.Execute then
  begin
    apiClient.Reset;
    txtResponse.Text := '';

    fileJson := TFile.ReadAllText(dlgOpenConversation.FileName, TEncoding.UTF8);
    apiClient.ImportMessageFromJson(fileJson);

    Messages := TJson.JsonToObject < TObjectList < TChatMessage >> (fileJson, [TJsonOption.joIgnoreEmptyStrings, TJsonOption.joIgnoreEmptyArrays,
      TJsonOption.joIndentCaseLower]);

    for I := 0 to Messages.Count - 1 do
    begin
      if Messages[I].Role = 'system' then
      begin
        apiClient.SetSystemMessage(Messages[I].Content);
        continue;
      end;

      txtResponse.Lines.Add(Messages[I].Content);
      txtResponse.Lines.Add('-------------------');
    end;
    SendMessage(txtResponse.handle, WM_VSCROLL, SB_BOTTOM, 0);
  end;
end;

procedure TfrmMain.SetFormCaption;
var
  strm: string;
begin
  case ChatSettings.StreamResponse of
    True:
      strm := 'Yes';
    False:
      strm := 'No';
  end;

  frmMain.Caption := 'ChatWindow - Engine: ' + ChatSettings.EngineModel + ' - Top_p: ' + FloatToStrF(ChatSettings.TopPValue, TFloatFormat.ffFixed, 2, 1) +
    ' - Temperature: ' + FloatToStrF(ChatSettings.TemperatureValue, TFloatFormat.ffFixed, 2, 1) + ' - Streaming: ' + strm;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  ChatSettings := TChatSettings.Create;
  ChatSettings.LoadSettingsFile;

  apiClient := TOpenAIClient.Create(ChatSettings);
  apiClient.onChunkReceived := onChunkReceived;
  apiClient.OnChatCompletionStreamComplete := onChunkedResponseComplete;
  apiClient.onCompletionReceived := onCompletionReceived;

  SetFormCaption;

end;

procedure TfrmMain.FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if ssCtrl in Shift then
  begin
    if Key = Ord('S') then
    begin
      saveConversation;
    end
    else if Key = Ord('O') then
    begin
      loadConversation;
    end
    else if Key = Ord('M') then
    begin
      setSystemPromptForm;
    end;
  end;
end;

procedure TfrmMain.FormShow(Sender: TObject);
begin
  txtRequest.SetFocus;
end;

procedure TfrmMain.onSettingsSaved(S: TChatSettings);
begin
  ChatSettings := S;
  SetFormCaption;
  apiClient.UpdateSettings(ChatSettings);
end;

procedure TfrmMain.Setsystemprompt1Click(Sender: TObject);
begin
  setSystemPromptForm;
end;

procedure TfrmMain.setSystemPromptForm;
var
  frmSysMessage: TfrmSysMessage;
begin
  frmSysMessage := TfrmSysMessage.Create(Self);
  if frmSysMessage.ShowModal = 1 then
  begin

    if frmSysMessage.SystemMessage = '' then
    begin
      apiClient.UnsetSystemMessage;
    end
    else
    begin
      apiClient.SetSystemMessage(frmSysMessage.SystemMessage);
    end;
  end;
end;

procedure TfrmMain.menuResetConvClick(Sender: TObject);
begin
  if (MessageDlg('Reset conversation? This will *not* unset the System message.', TMsgDlgType.mtConfirmation, mbYesNo, 0) = mrYes) then
  begin
    apiClient.Reset;
    txtResponse.Text := '';

    txtRequest.Enabled := True;
    btnSendMessage.Enabled := True;
    txtRequest.SetFocus;
  end;
end;

procedure TfrmMain.onChunkReceived(C: TChatCompletionChunk);
begin
  TThread.Synchronize(nil,
    procedure
    begin
      txtResponse.Text := txtResponse.Text + C.Choices[0].Delta.Content;
      SendMessage(txtResponse.handle, WM_VSCROLL, SB_BOTTOM, 0);
    end);
end;

procedure TfrmMain.onChunkedResponseComplete;
begin
  TThread.Synchronize(nil,
    procedure
    begin
      txtResponse.Lines.Add('-------------------' + #$A);
      SendMessage(txtResponse.handle, WM_VSCROLL, SB_BOTTOM, 0);
    end);
end;

procedure TfrmMain.onCompletionReceived(C: TChatCompletion);
var
  Text: string;
begin
  TThread.Synchronize(nil,
    procedure
    begin
      Text := C.Choices[0].Message.Content;

      txtResponse.SelAttributes.BackColor := $FCFCFC;
      txtResponse.Lines.Add(Text);

      txtResponse.SelAttributes.BackColor := $FFFFFF;
      txtResponse.Lines.Add('-------------------');
      SendMessage(txtResponse.handle, WM_VSCROLL, SB_BOTTOM, 0);
    end);
end;

{ TSendMessageThread implementations }
constructor TSendMessageThread.Create(const ARequestText: string; streaming: Boolean);
begin
  inherited Create(True); // Create suspended thread
  FRequestText := ARequestText;
  FStreaming := streaming;
end;

procedure TSendMessageThread.Execute;
begin
  try
    apiClient.SendMessage(FRequestText, FStreaming);
  except
    on e: Exception do
      MessageDlg('Error occured:' + #$A + e.Message + #$A#$A + 'Try again.', TMsgDlgType.mtError, [TMsgDlgBtn.mbOK], 0);
  end;
end;

end.
