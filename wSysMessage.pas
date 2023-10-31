unit wSysMessage;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtDlgs, Vcl.StdCtrls, Vcl.ComCtrls, Vcl.ExtCtrls;

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
    lstPrompts: TListView;

    constructor Create(AOwner: TComponent);
    procedure btnLoadPromptClick(Sender: TObject);
    procedure btnSetMsgClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnClearMsgClick(Sender: TObject);
    procedure btnSavePromptClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure loadPromptFile(const filePath: string);
    procedure lstPromptsSelectItem(Sender: TObject; Item: TListItem; Selected: Boolean);
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

procedure TfrmSysMessage.FormCreate(Sender: TObject);
var
  initDir: string;
  files: TArray<string>;
  I: Integer;
begin
  initDir := TPath.Combine(TPath.Combine(TPath.GetHomePath, '.chat-window'), 'system-messages');
  if not TDirectory.Exists(initDir) then
  begin
    TDirectory.CreateDirectory(initDir);
  end;

  lstPrompts.Clear;
  files := TDirectory.GetFiles(initDir, '*.txt', TSearchOption.soAllDirectories);
  for I := 0 to Length(files) - 1 do
  begin
    var
      fileName: string;

    fileName := TPath.GetFileName(files[I]);
    lstPrompts.AddItem(fileName, TObject(files[I]));
  end;
  lstPrompts.Columns[0].Width := lstPrompts.ClientWidth;
end;

procedure TfrmSysMessage.lstPromptsSelectItem(Sender: TObject; Item: TListItem; Selected: Boolean);
var
  itemData: string;
begin
  if Selected and Assigned(Item) and Assigned(Item.Data) then
  begin
    itemData := string.Copy(string(Item.Data));
    loadPromptFile(itemData);
  end;

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
    TFile.WriteAllText(dlgSavePromptFile.fileName, txtSystemMessage.Text, TEncoding.UTF8);
  end;
end;

procedure TfrmSysMessage.btnLoadPromptClick(Sender: TObject);
var
  initDir: string;
var
  fileName: string;
begin
  initDir := TPath.Combine(TPath.Combine(TPath.GetHomePath, '.chat-window'), 'system-messages');
  if not TDirectory.Exists(initDir) then
  begin
    TDirectory.CreateDirectory(initDir);
  end;

  dlgLoadPromptFile.InitialDir := initDir;
  if dlgLoadPromptFile.Execute then
  begin
    fileName := dlgLoadPromptFile.fileName;
    loadPromptFile(fileName);
  end;
end;

procedure TfrmSysMessage.loadPromptFile(const filePath: string);
var
  sysMsg: string;
begin
  sysMsg := TFile.ReadAllText(filePath, TEncoding.UTF8);
  txtSystemMessage.Text := sysMsg;
end;

end.
