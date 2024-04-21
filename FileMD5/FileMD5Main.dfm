object Form1: TForm1
  Left = 192
  Top = 113
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Quick MD5 Calc'
  ClientHeight = 105
  ClientWidth = 289
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 32
    Height = 13
    Caption = 'Label1'
  end
  object Label2: TLabel
    Left = 8
    Top = 56
    Width = 76
    Height = 13
    Caption = 'MD5 Checksum'
  end
  object Edit1: TEdit
    Left = 8
    Top = 72
    Width = 273
    Height = 21
    Color = clBtnFace
    ReadOnly = True
    TabOrder = 0
  end
  object Edit2: TEdit
    Left = 8
    Top = 24
    Width = 273
    Height = 21
    Color = clBtnFace
    ReadOnly = True
    TabOrder = 1
  end
end
