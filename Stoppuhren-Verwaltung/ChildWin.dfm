object MDIChild: TMDIChild
  Left = 197
  Top = 117
  Caption = 'Stoppuhr'
  ClientHeight = 148
  ClientWidth = 295
  Color = clBtnFace
  ParentFont = True
  FormStyle = fsMDIChild
  OldCreateOrder = False
  Visible = True
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  DesignSize = (
    295
    148)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 94
    Height = 29
    Caption = '00:00:00'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -24
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object Memo1: TMemo
    Left = 8
    Top = 43
    Width = 278
    Height = 59
    Anchors = [akLeft, akTop, akRight, akBottom]
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
  end
  object Button1: TButton
    Left = 8
    Top = 108
    Width = 94
    Height = 30
    Anchors = [akLeft, akBottom]
    Caption = 'Start / Stopp'
    TabOrder = 1
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 213
    Top = 108
    Width = 73
    Height = 30
    Anchors = [akRight, akBottom]
    Caption = 'Reset'
    TabOrder = 2
    OnClick = Button2Click
  end
  object Timer1: TTimer
    Interval = 100
    OnTimer = Timer1Timer
    Left = 248
    Top = 8
  end
end
