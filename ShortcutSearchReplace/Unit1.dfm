object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'ViaThinkSoft Shortcut Search+Replace'
  ClientHeight = 500
  ClientWidth = 581
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  DesignSize = (
    581
    500)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 16
    Top = 16
    Width = 146
    Height = 13
    Caption = 'Search Hyperlinks in directory:'
  end
  object Label2: TLabel
    Left = 16
    Top = 112
    Width = 37
    Height = 13
    Caption = 'Search:'
  end
  object Label3: TLabel
    Left = 304
    Top = 112
    Width = 42
    Height = 13
    Caption = 'Replace:'
  end
  object Label4: TLabel
    Left = 8
    Top = 288
    Width = 55
    Height = 13
    Caption = 'Output log:'
  end
  object Button1: TButton
    Left = 8
    Top = 200
    Width = 225
    Height = 57
    Caption = 'Start'
    TabOrder = 4
    OnClick = Button1Click
  end
  object Memo1: TMemo
    Left = 8
    Top = 307
    Width = 561
    Height = 177
    Anchors = [akLeft, akTop, akRight, akBottom]
    ReadOnly = True
    TabOrder = 5
  end
  object Edit1: TEdit
    Left = 16
    Top = 35
    Width = 553
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 0
    Text = 'd:\onedrive\desktop\'
  end
  object CheckBox1: TCheckBox
    Left = 16
    Top = 64
    Width = 97
    Height = 17
    Caption = 'Rekursive'
    TabOrder = 1
  end
  object Edit2: TEdit
    Left = 16
    Top = 128
    Width = 265
    Height = 21
    TabOrder = 2
    Text = 'C:\Users\DELL User\OneDrive\'
  end
  object Edit3: TEdit
    Left = 304
    Top = 128
    Width = 265
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 3
    Text = 'D:\OneDrive\'
  end
end
