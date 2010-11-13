object EditForm: TEditForm
  Left = 347
  Top = 240
  BorderStyle = bsDialog
  ClientHeight = 161
  ClientWidth = 342
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 16
    Top = 16
    Width = 98
    Height = 13
    Caption = 'Statusmonitor-Name:'
  end
  object Label2: TLabel
    Left = 16
    Top = 64
    Width = 92
    Height = 13
    Caption = 'Statusmonitor-URL:'
  end
  object Edit1: TEdit
    Left = 16
    Top = 32
    Width = 305
    Height = 21
    TabOrder = 0
  end
  object Edit2: TEdit
    Left = 16
    Top = 80
    Width = 305
    Height = 21
    TabOrder = 1
  end
  object Button1: TButton
    Left = 216
    Top = 120
    Width = 105
    Height = 25
    Caption = 'OK'
    Default = True
    TabOrder = 2
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 16
    Top = 120
    Width = 105
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    TabOrder = 3
    OnClick = Button2Click
  end
end
