unit OpenAI.Classes;

interface

uses Generics.Collections, Rest.Json;

// type
// TChatFunctionCall = class
// private
// FArguments: string;
// FName: string;
// public
// property Arguments: string read FArguments write FArguments;
// property Name: string read FName write FName;
// end;

type
  TChatMessage = class
    constructor Create;

  private
    FContent: string;
    // FFunction_Call: TChatFunctionCall;
    FName: string;
    FRole: string;
  public
    property Content: string read FContent write FContent;
    // property Function_Call: TChatFunctionCall read FFunction_Call write FFunction_Call;
    property Name: string read FName write FName;
    property Role: string read FRole write FRole;
  end;

type
  TChatRequestFunction = class
  private
    FDescription: string;
    FName: string;
    FParameters: string;
  public
    property Description: string read FDescription write FDescription;
    property Name: string read FName write FName;
    property Parameters: string read FParameters write FParameters;
  end;

type
  strings = array of string;

type
  TChatRequestFunctions = array of TChatRequestFunction;

type
  TChatMessages = array of TChatMessage;

type
  TChatRequest = class
    constructor Create;

  private
    // FFrequency_Penalty: Double;
    FMessages: TChatMessages;
    FModel: string;
    // FFunction_Call: string;
    // FFunctions: TChatRequestFunctions;
    // FLogit_Bias: TDictionary<Integer, Integer>;
    // FMax_Tokens: Integer;
    FN: Integer;
    // FPresence_Penalty: Integer;
    // FStop: strings;
    FStream: Boolean;
    FTemperature: Double;
    FTop_P: Double;
    FUser: string;
  public
    // property Frequency_Penalty: Double read FFrequency_Penalty write FFrequency_Penalty;
    property Messages: TChatMessages read FMessages write FMessages;
    property Model: string read FModel write FModel;
    // property Function_Call: string read FFunction_Call write FFunction_Call;
    // property Functions: TChatRequestFunctions read FFunctions write FFunctions;
    // property Logit_Bias: TDictionary<Integer, Integer> read FLogit_Bias write FLogit_Bias;
    // property Max_Tokens: Integer read FMax_Tokens write FMax_Tokens;
    property N: Integer read FN write FN;
    // property Presence_Penalty: Integer read FPresence_Penalty write FPresence_Penalty;
    // property Stop: strings read FStop write FStop;
    property Stream: Boolean read FStream write FStream;
    property Temperature: Double read FTemperature write FTemperature;
    property Top_P: Double read FTop_P write FTop_P;
    property User: string read FUser write FUser;

    procedure SetMessagesLength(Length: Integer);
  end;

type
  TChatCompletionChunkChoice = class
  private
    FDelta: TChatMessage;
    FFinish_Reason: string;
    FIndex: Integer;
  public
    constructor Create;
    property Delta: TChatMessage read FDelta write FDelta;
    property Finish_Reason: string read FFinish_Reason write FFinish_Reason;
    property Index: Integer read FIndex write FIndex;
  end;

type
  TChatCompletionChoice = class
  private
    FMessage: TChatMessage;
    FFinish_Reason: string;
    FIndex: Integer;
  public
    property Message: TChatMessage read FMessage write FMessage;
    property Finish_Reason: string read FFinish_Reason write FFinish_Reason;
    property Index: Integer read FIndex write FIndex;
  end;

type
  TChatCompletionChoices = array of TChatCompletionChoice;

type
  TChatCompletionUsage = class
  public
    Completion_Tokens: Integer;
    Prompt_Tokens: Integer;
    Total_Toekns: Integer;
  end;

type
  TChatCompletionChunkChoices = array of TChatCompletionChunkChoice;

type
  TChatCompletionChunk = class
  private
    FId: string;
    FChoices: TChatCompletionChunkChoices;
    FCreated: LongInt;
    FModel: string;
    [JSONName('Object')]
    FObject: string;
    FUsage: TChatCompletionUsage;
  public
    constructor Create;
    property Id: string read FId write FId;
    property Choices: TChatCompletionChunkChoices read FChoices write FChoices;
    property Created: LongInt read FCreated write FCreated;
    property Model: string read FModel write FModel;
    property MObject: string read FObject write FObject;
    property Usage: TChatCompletionUsage read FUsage write FUsage;
  end;

type
  TChatCompletion = class
  private
    FId: string;
    FChoices: TChatCompletionChoices;
    FCreated: LongInt;
    FModel: string;
    [JSONName('Object')]
    FObject: string;
    FUsage: TChatCompletionUsage;
  public
    property Id: string read FId write FId;
    property Choices: TChatCompletionChoices read FChoices write FChoices;
    property Created: LongInt read FCreated write FCreated;
    property Model: string read FModel write FModel;
    property MObject: string read FObject write FObject;
    property Usage: TChatCompletionUsage read FUsage write FUsage;
  end;

implementation

{ TChatRequest }
constructor TChatRequest.Create;
begin
  // FFrequency_Penalty := 0;
  FMessages := [];
  FModel := 'gpt-3.5-turbo';
  // FFunction_Call := '';
  // FFunctions := nil;
  // FLogit_Bias := nil;
  // FMax_Tokens := 4097;
  FN := 1;
  // FPresence_Penalty := 0;
  // FStop := nil;
  FStream := False;
  FTemperature := 1;
  FTop_P := 1;
  FUser := '';
end;

constructor TChatMessage.Create;
begin
  // Self.Function_Call := TChatFunctionCall.Create;
end;

procedure TChatRequest.SetMessagesLength(Length: Integer);
begin
  SetLength(Self.FMessages, Length);
end;

constructor TChatCompletionChunkChoice.Create;
begin
  Self.Delta := TChatMessage.Create;
end;

constructor TChatCompletionChunk.Create;
begin
  Usage := TChatCompletionUsage.Create;
end;

end.
