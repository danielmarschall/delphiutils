object Form1: TForm1
  Left = 192
  Top = 113
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Change FileExt'
  ClientHeight = 97
  ClientWidth = 225
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
  object Edit1: TEdit
    Left = 8
    Top = 32
    Width = 209
    Height = 21
    TabOrder = 0
  end
  object Button1: TButton
    Left = 120
    Top = 64
    Width = 99
    Height = 25
    Caption = 'OK'
    Default = True
    TabOrder = 1
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 8
    Top = 64
    Width = 97
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    TabOrder = 2
    OnClick = Button2Click
  end
end
