program ChatWindow;

uses
  Vcl.Forms,
  wMain in 'wMain.pas' {frmMain},
  wSettings in 'wSettings.pas' {frmSettings},
  ChatSettings in 'ChatSettings.pas',
  OpenAI.Classes in 'OpenAI\OpenAI.Classes.pas',
  OpenAI.Client in 'OpenAI\OpenAI.Client.pas',
  wSysMessage in 'wSysMessage.pas' {frmSysMessage};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TfrmSettings, frmSettings);
  Application.CreateForm(TfrmSysMessage, frmSysMessage);
  Application.Run;
end.
