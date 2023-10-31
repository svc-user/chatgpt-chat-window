object frmSysMessage: TfrmSysMessage
  Left = 0
  Top = 0
  BorderStyle = bsSizeToolWin
  Caption = 'Set System Message'
  ClientHeight = 347
  ClientWidth = 821
  Color = clBtnFace
  Constraints.MinHeight = 270
  Constraints.MinWidth = 640
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnCreate = FormCreate
  DesignSize = (
    821
    347)
  TextHeight = 15
  object txtSystemMessage: TMemo
    Left = 224
    Top = 8
    Width = 526
    Height = 331
    Anchors = [akLeft, akTop, akRight, akBottom]
    ScrollBars = ssVertical
    TabOrder = 0
  end
  object btnLoadPrompt: TButton
    Left = 756
    Top = 8
    Width = 57
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'Load...'
    TabOrder = 1
    OnClick = btnLoadPromptClick
  end
  object btnSavePrompt: TButton
    Left = 756
    Top = 39
    Width = 57
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'Save...'
    TabOrder = 2
    OnClick = btnSavePromptClick
    ExplicitLeft = 559
  end
  object btnSetMsg: TButton
    Left = 756
    Top = 252
    Width = 57
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Set'
    TabOrder = 3
    OnClick = btnSetMsgClick
  end
  object btnCancel: TButton
    Left = 756
    Top = 283
    Width = 57
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Cancel'
    TabOrder = 4
    OnClick = btnCancelClick
  end
  object btnClearMsg: TButton
    Left = 756
    Top = 314
    Width = 57
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Clear'
    TabOrder = 5
    OnClick = btnClearMsgClick
  end
  object lstPrompts: TListView
    Left = 8
    Top = 8
    Width = 210
    Height = 331
    Anchors = [akLeft, akTop, akBottom]
    Columns = <
      item
        AutoSize = True
      end>
    ColumnClick = False
    ReadOnly = True
    SortType = stText
    TabOrder = 6
    ViewStyle = vsList
    OnSelectItem = lstPromptsSelectItem
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
