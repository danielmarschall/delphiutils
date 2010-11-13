object MainForm: TMainForm
  Left = 219
  Top = 164
  Caption = 'ViaThinkSoft Status Monitor 3.0'
  ClientHeight = 479
  ClientWidth = 730
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object StringGrid1: TStringGrid
    Left = 0
    Top = 0
    Width = 730
    Height = 414
    Align = alClient
    ColCount = 3
    DefaultRowHeight = 18
    FixedCols = 0
    RowCount = 2
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing, goRowSelect]
    PopupMenu = PopupMenu2
    TabOrder = 0
    OnDblClick = StringGrid1DblClick
    OnMouseDown = StringGrid1MouseDown
    ColWidths = (
      214
      359
      149)
  end
  object Panel1: TPanel
    Left = 0
    Top = 414
    Width = 730
    Height = 65
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    object Panel2: TPanel
      Left = 0
      Top = 40
      Width = 730
      Height = 25
      Align = alBottom
      BevelOuter = bvNone
      Caption = 'Next check in 3, 2, 1...'
      TabOrder = 0
    end
    object Button3: TButton
      Left = 520
      Top = 8
      Width = 75
      Height = 25
      Caption = 'Config'
      TabOrder = 1
    end
    object Button5: TButton
      Left = 632
      Top = 8
      Width = 75
      Height = 25
      Caption = 'Close'
      TabOrder = 2
      OnClick = Button5Click
    end
    object Button1: TButton
      Left = 272
      Top = 16
      Width = 75
      Height = 25
      Caption = 'Check all'
      TabOrder = 3
      OnClick = Button1Click
    end
  end
  object PopupMenu1: TPopupMenu
    Left = 8
    Top = 48
    object Anzeigen1: TMenuItem
      Caption = '&Anzeigen'
      Default = True
      OnClick = Anzeigen1Click
    end
    object Beenden1: TMenuItem
      Caption = '&Beenden'
      OnClick = Beenden1Click
    end
  end
  object PopupMenu2: TPopupMenu
    Left = 40
    Top = 48
    object New1: TMenuItem
      Caption = 'New...'
      OnClick = New1Click
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object Open1: TMenuItem
      Caption = 'Open'
      Default = True
      OnClick = Open1Click
    end
    object Ping1: TMenuItem
      Caption = 'Ping'
    end
    object Checknow1: TMenuItem
      Caption = 'Check now'
      OnClick = Checknow1Click
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object Edit1: TMenuItem
      Caption = 'Edit...'
      OnClick = Edit1Click
    end
    object Delete1: TMenuItem
      Caption = '&Delete...'
      OnClick = Delete1Click
    end
  end
  object InitTimer: TTimer
    Interval = 300000
    OnTimer = InitTimerTimer
    Left = 8
    Top = 80
  end
  object LoopTimer: TTimer
    Enabled = False
    Interval = 3600000
    OnTimer = LoopTimerTimer
    Left = 40
    Top = 80
  end
end
