unit ChatSettings;

interface

type
  TChatSettings = class
    constructor Create;

  private

  public
    ApiKey: string;
    TopPValue: Float64;
    TemperatureValue: Float64;
    EngineModel: string;
    LoggingEnabled: Boolean;
    LogPath: string;
    StreamResponse: Boolean;

    procedure LoadSettingsFile;
    procedure WriteSettingsFile;

  end;

implementation

uses IOUtils, JSON, DBXJSON, DBXJSONReflect, Classes, SysUtils;

var
  settingsFileLocation: string;

constructor TChatSettings.Create;
begin
  settingsFileLocation := TPath.Combine(TPath.Combine(TPath.GetHomePath, '.chat-window'), 'settings.json');

  ApiKey := '';
  TopPValue := 1.0;
  TemperatureValue := 1.0;
  EngineModel := 'gpt-3.5-turbo';
  LoggingEnabled := True;
  StreamResponse := False;
  LogPath := TPath.Combine(TPath.Combine(TPath.GetHomePath, '.chat-window'), 'conversations');

end;

procedure TChatSettings.WriteSettingsFile;
var
  jsonWriter: TJSONMarshal;
  marshalledObject: string;
begin

  jsonWriter := TJSONMarshal.Create;
  marshalledObject := jsonWriter.Marshal(Self).ToString;

  TFile.WriteAllText(settingsFileLocation, marshalledObject);

  FreeAndNil(jsonWriter);
end;

procedure TChatSettings.LoadSettingsFile;
var
  jsonReader: TJSONUnMarshal;
  fileContent: string;
  unm: TChatSettings;
begin
  if not TFile.Exists(settingsFileLocation) then
    exit;

  fileContent := TFile.ReadAllText(settingsFileLocation);
  jsonReader := TJSONUnMarshal.Create;
  unm := jsonReader.Unmarshal(TJSONObject.ParseJSONValue(fileContent)) as TChatSettings;

  Self.ApiKey := unm.ApiKey;
  Self.TopPValue := unm.TopPValue;
  Self.TemperatureValue := unm.TemperatureValue;
  Self.EngineModel := unm.EngineModel;
  Self.LoggingEnabled := unm.LoggingEnabled;
  Self.LogPath := unm.LogPath;
  Self.StreamResponse := unm.StreamResponse;

  FreeAndNil(unm);
  FreeAndNil(jsonReader);
end;

end.
