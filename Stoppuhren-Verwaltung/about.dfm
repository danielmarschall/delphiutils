object AboutBox: TAboutBox
  Left = 445
  Top = 127
  ActiveControl = OKButton
  BorderStyle = bsDialog
  Caption = 'Info '#252'ber Stoppuhren-Verwaltung'
  ClientHeight = 216
  ClientWidth = 335
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clBlack
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  DesignSize = (
    335
    216)
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 8
    Top = 8
    Width = 319
    Height = 153
    Anchors = [akLeft, akTop, akRight]
    BevelOuter = bvLowered
    TabOrder = 0
    object ProgramIcon: TImage
      Left = 8
      Top = 8
      Width = 65
      Height = 57
      IsControl = True
    end
    object ProductName: TLabel
      Left = 88
      Top = 16
      Width = 111
      Height = 13
      Caption = 'Stoppuhren-Verwaltung'
      IsControl = True
    end
    object Version: TLabel
      Left = 88
      Top = 40
      Width = 99
      Height = 13
      Caption = 'Revision 2018-11*28'
      IsControl = True
    end
    object Copyright: TLabel
      Left = 8
      Top = 80
      Width = 188
      Height = 13
      Caption = '(C) 2018 ViaThinkSoft, Daniel Marschall'
      IsControl = True
    end
    object Comments: TLabel
      Left = 8
      Top = 104
      Width = 267
      Height = 13
      Caption = 'Lizenziert unter den Bedingungen der Apache 2.0 Lizenz'
      IsControl = True
    end
    object Label1: TLabel
      Left = 8
      Top = 123
      Width = 96
      Height = 13
      Cursor = crHandPoint
      Caption = 'www.viathinksoft.de'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsUnderline]
      ParentFont = False
      WordWrap = True
      OnClick = Label1Click
      IsControl = True
    end
  end
  object OKButton: TButton
    Left = 118
    Top = 175
    Width = 105
    Height = 33
    Anchors = [akLeft, akTop, akRight, akBottom]
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 1
    IsControl = True
  end
end
