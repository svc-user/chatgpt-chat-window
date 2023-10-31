unit wSettings;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, ChatSettings, IOUtils,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ButtonGroup,
  Vcl.ExtCtrls, Vcl.Mask, Vcl.ComCtrls;

type
  TSaveEvent = procedure(S: TChatSettings) of object;

type
  TfrmSettings = class(TForm)
    btnSave: TButton;
    btnClose: TButton;
    radGrpEngine: TRadioGroup;
    txtApiKey: TMaskEdit;
    Label1: TLabel;
    lblTemp: TLabel;
    trackBarTemp: TTrackBar;
    trackBarTopP: TTrackBar;
    lblTopP: TLabel;
    chkStreamResponse: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure trackBarTopPChange(Sender: TObject);
    procedure trackBarTempChange(Sender: TObject);
    procedure txtApiKeyChange(Sender: TObject);
    procedure radGrpEngineClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure chkStreamResponseClick(Sender: TObject);
  private
    FOnSave: TSaveEvent;
    FSettings: TChatSettings;

  public
    { Public declarations }

    property OnSave: TSaveEvent write FOnSave;

  end;

var
  frmSettings: TfrmSettings;

implementation

uses FileCtrl;

{$R *.dfm}

procedure TfrmSettings.FormCreate(Sender: TObject);
begin

  { Set default values for settings }

  FSettings := TChatSettings.Create;
  FSettings.LoadSettingsFile;

  radGrpEngine.ItemIndex := radGrpEngine.Items.IndexOf(FSettings.EngineModel);
  trackBarTopP.Position := Trunc(FSettings.TopPValue * trackBarTopP.Max);
  trackBarTemp.Position := Trunc(FSettings.TemperatureValue * (trackBarTemp.Max div 2));
  txtApiKey.Text := FSettings.ApiKey;
  chkStreamResponse.Checked := FSettings.StreamResponse;
end;

procedure TfrmSettings.btnCloseClick(Sender: TObject);
begin
  Self.Close;
end;

procedure TfrmSettings.btnSaveClick(Sender: TObject);
begin

  if Assigned(FOnSave) then
  begin
    FSettings.WriteSettingsFile;
    FOnSave(FSettings);
  end;
  Self.Close;

end;

procedure TfrmSettings.chkStreamResponseClick(Sender: TObject);
begin
  FSettings.StreamResponse := chkStreamResponse.Checked;
end;

procedure TfrmSettings.radGrpEngineClick(Sender: TObject);
begin
  FSettings.EngineModel := radGrpEngine.Items[radGrpEngine.ItemIndex];
end;

procedure TfrmSettings.trackBarTempChange(Sender: TObject);
begin
  FSettings.TemperatureValue := trackBarTemp.Position / (trackBarTemp.Max div 2);
  lblTemp.Caption := 'Temperature (' + FloatToStrF(FSettings.TemperatureValue, TFloatFormat.ffFixed, 2, 1) + ')';
end;

procedure TfrmSettings.trackBarTopPChange(Sender: TObject);
begin
  FSettings.TopPValue := trackBarTopP.Position / trackBarTopP.Max;
  lblTopP.Caption := 'Top_P (' + FloatToStrF(FSettings.TopPValue, TFloatFormat.ffFixed, 2, 1) + ')';
end;

procedure TfrmSettings.txtApiKeyChange(Sender: TObject);
begin
  FSettings.ApiKey := txtApiKey.Text
end;

end.
