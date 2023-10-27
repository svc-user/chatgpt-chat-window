object frmSettings: TfrmSettings
  Left = 0
  Top = 0
  Caption = 'Settings'
  ClientHeight = 441
  ClientWidth = 619
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnCreate = FormCreate
  DesignSize = (
    619
    441)
  TextHeight = 15
  object Label1: TLabel
    Left = 8
    Top = 113
    Width = 85
    Height = 15
    Caption = 'OpenAI API-Key'
  end
  object lblTemp: TLabel
    Left = -2
    Top = 155
    Width = 92
    Height = 15
    Caption = 'Temperature (1.0)'
  end
  object lblTopP: TLabel
    Left = 33
    Top = 203
    Width = 57
    Height = 15
    Caption = 'Top_P (1.0)'
  end
  object btnSave: TButton
    Left = 434
    Top = 408
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Save'
    TabOrder = 0
    OnClick = btnSaveClick
  end
  object btnClose: TButton
    Left = 515
    Top = 408
    Width = 96
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Close'
    TabOrder = 1
    OnClick = btnCloseClick
  end
  object radGrpEngine: TRadioGroup
    Left = 99
    Top = 8
    Width = 145
    Height = 73
    Caption = 'Chat Engine'
    Items.Strings = (
      'gpt-3.5-turbo'
      'gpt-4')
    TabOrder = 2
    OnClick = radGrpEngineClick
  end
  object txtApiKey: TMaskEdit
    Left = 99
    Top = 110
    Width = 282
    Height = 23
    Anchors = [akLeft, akTop, akRight]
    PasswordChar = '*'
    TabOrder = 3
    Text = ''
    OnChange = txtApiKeyChange
  end
  object trackBarTemp: TTrackBar
    Left = 99
    Top = 139
    Width = 282
    Height = 45
    Anchors = [akLeft, akTop, akRight]
    Max = 20
    Position = 10
    TabOrder = 4
    TickMarks = tmBoth
    OnChange = trackBarTempChange
  end
  object trackBarTopP: TTrackBar
    Left = 99
    Top = 190
    Width = 282
    Height = 45
    Anchors = [akLeft, akTop, akRight]
    Position = 10
    TabOrder = 5
    TickMarks = tmBoth
    OnChange = trackBarTopPChange
  end
  object chkEnableLogging: TCheckBox
    Left = 23
    Top = 244
    Width = 70
    Height = 17
    Caption = 'Logging?'
    TabOrder = 6
    OnClick = chkEnableLoggingClick
  end
  object btnSetLogPath: TButton
    Left = 387
    Top = 241
    Width = 28
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = '...'
    TabOrder = 7
    OnClick = btnSetLogPathClick
  end
  object txtLogPath: TEdit
    Left = 99
    Top = 241
    Width = 282
    Height = 23
    TabOrder = 8
  end
  object chkStreamResponse: TCheckBox
    Left = 99
    Top = 87
    Width = 111
    Height = 17
    Caption = 'Stream response?'
    TabOrder = 9
    OnClick = chkStreamResponseClick
  end
end
