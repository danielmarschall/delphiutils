object MainForm: TMainForm
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'ViaThinkSoft Base-Converter'
  ClientHeight = 384
  ClientWidth = 492
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 24
    Width = 96
    Height = 13
    Caption = 'Numbers of base 10'
  end
  object Label2: TLabel
    Left = 248
    Top = 24
    Width = 81
    Height = 13
    Caption = 'Numbers of base'
  end
  object Memo1: TMemo
    Left = 8
    Top = 72
    Width = 233
    Height = 297
    ScrollBars = ssVertical
    TabOrder = 0
  end
  object Memo2: TMemo
    Left = 248
    Top = 72
    Width = 233
    Height = 297
    Color = clBtnFace
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 1
  end
  object Edit1: TEdit
    Left = 344
    Top = 16
    Width = 41
    Height = 21
    TabOrder = 2
    Text = '16'
  end
  object Button1: TButton
    Left = 136
    Top = 24
    Width = 91
    Height = 25
    Caption = 'Convert -->'
    TabOrder = 3
    OnClick = Button1Click
  end
  object CheckBox1: TCheckBox
    Left = 248
    Top = 48
    Width = 113
    Height = 17
    Caption = 'Use 0..Z for 0..36'
    Checked = True
    State = cbChecked
    TabOrder = 4
  end
end
