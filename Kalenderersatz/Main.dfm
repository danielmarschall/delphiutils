object MainForm: TMainForm
  Left = 194
  Top = 148
  BorderIcons = [biSystemMenu, biMinimize]
  Caption = 'Kalender'
  ClientHeight = 392
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
  PixelsPerInch = 96
  TextHeight = 13
  object PopupMenu1: TPopupMenu
    Left = 8
    Top = 8
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
end
