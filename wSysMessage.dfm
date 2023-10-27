object frmSysMessage: TfrmSysMessage
  Left = 0
  Top = 0
  BorderStyle = bsSizeToolWin
  Caption = 'Set System Message'
  ClientHeight = 227
  ClientWidth = 624
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  DesignSize = (
    624
    227)
  TextHeight = 15
  object txtSystemMessage: TMemo
    Left = 8
    Top = 8
    Width = 545
    Height = 211
    Anchors = [akLeft, akTop, akRight, akBottom]
    ScrollBars = ssVertical
    TabOrder = 0
  end
  object btnLoadPrompt: TButton
    Left = 559
    Top = 8
    Width = 57
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'Load...'
    TabOrder = 1
    OnClick = btnLoadPromptClick
  end
  object btnSavePrompt: TButton
    Left = 559
    Top = 39
    Width = 57
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'Save...'
    TabOrder = 2
    OnClick = btnSavePromptClick
  end
  object btnSetMsg: TButton
    Left = 559
    Top = 132
    Width = 57
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'Set'
    TabOrder = 3
    OnClick = btnSetMsgClick
  end
  object btnCancel: TButton
    Left = 559
    Top = 194
    Width = 57
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'Cancel'
    TabOrder = 4
    OnClick = btnCancelClick
  end
  object btnClearMsg: TButton
    Left = 559
    Top = 163
    Width = 57
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Clear'
    TabOrder = 5
    OnClick = btnClearMsgClick
  end
  object dlgLoadPromptFile: TOpenTextFileDialog
    Filter = 'Text Files|*.txt|All Files|*'
    FilterIndex = 0
    Options = [ofFileMustExist, ofEnableSizing, ofForceShowHidden]
    Encodings.Strings = (
      'UTF-8'
      'UTF-7'
      'ANSI'
      'ASCII'
      'Unicode'
      'Big Endian Unicode')
    ShowEncodingList = False
    Left = 456
    Top = 16
  end
  object dlgSavePromptFile: TSaveTextFileDialog
    DefaultExt = 'txt'
    Filter = 'Text Files|*.txt|All Files|*'
    FilterIndex = 0
    Options = [ofEnableSizing, ofForceShowHidden]
    Encodings.Strings = (
      'UTF-8'
      'UTF-7'
      'ANSI'
      'ASCII'
      'Unicode'
      'Big Endian Unicode')
    ShowEncodingList = False
    Left = 456
    Top = 72
  end
end
