unit wSysMessage;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtDlgs, Vcl.StdCtrls;

type
  TfrmSysMessage = class(TForm)
    txtSystemMessage: TMemo;
    btnLoadPrompt: TButton;
    btnSavePrompt: TButton;
    dlgLoadPromptFile: TOpenTextFileDialog;
    dlgSavePromptFile: TSaveTextFileDialog;
    btnSetMsg: TButton;
    btnCancel: TButton;
    btnClearMsg: TButton;

    constructor Create(AOwner: TComponent);
    procedure btnLoadPromptClick(Sender: TObject);
    procedure btnSetMsgClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnClearMsgClick(Sender: TObject);
    procedure btnSavePromptClick(Sender: TObject);
  private
    { Private declarations }
    FSystemMessage: string;
  public
    { Public declarations }
    property SystemMessage: string read FSystemMessage;

  end;

var
  frmSysMessage: TfrmSysMessage;

implementation

{$R *.dfm}

uses IOUtils;

constructor TfrmSysMessage.Create(AOwner: TComponent);
begin
  inherited;
  ModalResult := 0;
end;

procedure TfrmSysMessage.btnSetMsgClick(Sender: TObject);
begin
  FSystemMessage := txtSystemMessage.Text;
  ModalResult := 1;
end;

procedure TfrmSysMessage.btnCancelClick(Sender: TObject);
begin
  ModalResult := 0;
  Self.CloseModal;
end;

procedure TfrmSysMessage.btnClearMsgClick(Sender: TObject);
begin
  FSystemMessage := '';
  ModalResult := 1;
end;

procedure TfrmSysMessage.btnSavePromptClick(Sender: TObject);
var
  initDir: string;
begin
  initDir := TPath.Combine(TPath.Combine(TPath.GetHomePath, '.chat-window'), 'system-messages');
  if not TDirectory.Exists(initDir) then
  begin
    TDirectory.CreateDirectory(initDir);
  end;

  dlgSavePromptFile.InitialDir := initDir;
  if dlgSavePromptFile.Execute then
  begin
    TFile.WriteAllText(dlgSavePromptFile.FileName, txtSystemMessage.Text, TEncoding.UTF8);
  end;
end;

procedure TfrmSysMessage.btnLoadPromptClick(Sender: TObject);
var
  initDir: string;
begin
  initDir := TPath.Combine(TPath.Combine(TPath.GetHomePath, '.chat-window'), 'system-messages');
  if not TDirectory.Exists(initDir) then
  begin
    TDirectory.CreateDirectory(initDir);
  end;

  dlgLoadPromptFile.InitialDir := initDir;
  if dlgLoadPromptFile.Execute then
  begin
    txtSystemMessage.Text := TFile.ReadAllText(dlgLoadPromptFile.FileName, TEncoding.UTF8);
  end;

end;

end.
