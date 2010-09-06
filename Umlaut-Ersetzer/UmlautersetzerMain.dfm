object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'HTML Umlaut-Ersetzer'
  ClientHeight = 369
  ClientWidth = 549
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Memo1: TMemo
    Left = 0
    Top = 0
    Width = 549
    Height = 344
    Align = alClient
    ScrollBars = ssBoth
    TabOrder = 0
    WordWrap = False
  end
  object Button1: TButton
    Left = 0
    Top = 344
    Width = 549
    Height = 25
    Align = alBottom
    Caption = 'Ersetze'
    TabOrder = 1
    OnClick = Button1Click
  end
end
