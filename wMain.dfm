object frmMain: TfrmMain
  Left = 0
  Top = 0
  Caption = 'ChatWindow'
  ClientHeight = 532
  ClientWidth = 865
  Color = clBtnFace
  Constraints.MinHeight = 530
  Constraints.MinWidth = 800
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  KeyPreview = True
  Menu = MainMenu1
  OnCreate = FormCreate
  OnKeyUp = FormKeyUp
  OnShow = FormShow
  TextHeight = 15
  object Splitter1: TSplitter
    Left = 0
    Top = 444
    Width = 865
    Height = 3
    Cursor = crVSplit
    Align = alTop
    ExplicitTop = 403
    ExplicitWidth = 870
  end
  object txtResponse: TRichEdit
    Left = 0
    Top = 0
    Width = 865
    Height = 444
    Align = alTop
    Anchors = [akLeft, akTop, akRight, akBottom]
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 0
    ExplicitWidth = 1022
    ExplicitHeight = 567
  end
  object Panel1: TPanel
    Left = 0
    Top = 447
    Width = 865
    Height = 85
    Align = alClient
    Caption = 'Panel1'
    TabOrder = 1
    ExplicitTop = 570
    ExplicitWidth = 1022
    object txtRequest: TRichEdit
      Left = 1
      Top = 1
      Width = 780
      Height = 83
      Align = alLeft
      Anchors = [akLeft, akTop, akRight, akBottom]
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      ScrollBars = ssVertical
      TabOrder = 0
      ExplicitWidth = 937
    end
    object btnSendMessage: TButton
      AlignWithMargins = True
      Left = 787
      Top = 4
      Width = 74
      Height = 77
      Align = alRight
      Caption = 'Send'
      TabOrder = 1
      OnClick = btnSendMessageClick
      ExplicitLeft = 944
    end
  end
  object MainMenu1: TMainMenu
    Left = 112
    Top = 24
    object File1: TMenuItem
      Caption = 'File'
      object fileBtnSettings: TMenuItem
        Caption = 'Settings...'
        OnClick = fileBtnSettingsClick
      end
      object Exit1: TMenuItem
        Caption = 'Exit'
        OnClick = Exit1Click
      end
    end
    object Conversation1: TMenuItem
      Caption = 'Conversation'
      object Setsystemprompt1: TMenuItem
        Caption = 'Set system message...'
        OnClick = Setsystemprompt1Click
      end
      object menuSaveConv: TMenuItem
        Caption = 'Save...'
        OnClick = menuSaveConvClick
      end
      object menuLoadConv: TMenuItem
        Caption = 'Load...'
        OnClick = menuLoadConvClick
      end
      object menuResetConv: TMenuItem
        Caption = 'Reset'
        OnClick = menuResetConvClick
      end
    end
  end
  object dlgSaveConversation: TSaveTextFileDialog
    DefaultExt = 'json'
    Filter = 'Json Files|*.json'
    FilterIndex = 0
    Options = [ofEnableSizing, ofForceShowHidden]
    Left = 184
    Top = 24
  end
  object dlgOpenConversation: TOpenTextFileDialog
    DefaultExt = 'json'
    Filter = 'Json Files|*.json'
    FilterIndex = 0
    Left = 256
    Top = 24
  end
end
