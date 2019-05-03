object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'File readability checker'
  ClientHeight = 472
  ClientWidth = 756
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  DesignSize = (
    756
    472)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 16
    Top = 45
    Width = 66
    Height = 13
    Caption = 'Found errors:'
  end
  object Label2: TLabel
    Left = 201
    Top = 446
    Width = 537
    Height = 13
    Anchors = [akLeft, akRight, akBottom]
    AutoSize = False
    Caption = 'Ready.'
    ExplicitTop = 445
    ExplicitWidth = 497
  end
  object Button1: TButton
    Left = 16
    Top = 423
    Width = 169
    Height = 33
    Anchors = [akLeft, akBottom]
    Caption = 'Start'
    Default = True
    TabOrder = 0
    OnClick = Button1Click
    ExplicitTop = 422
  end
  object Edit1: TEdit
    Left = 16
    Top = 16
    Width = 722
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 1
    Text = 'C:\'
    ExplicitWidth = 682
  end
  object Memo1: TMemo
    Left = 16
    Top = 64
    Width = 722
    Height = 353
    Anchors = [akLeft, akTop, akRight, akBottom]
    ReadOnly = True
    ScrollBars = ssBoth
    TabOrder = 2
    ExplicitWidth = 682
    ExplicitHeight = 352
  end
  object ProgressBar1: TProgressBar
    Left = 201
    Top = 423
    Width = 537
    Height = 17
    Anchors = [akLeft, akRight, akBottom]
    TabOrder = 3
    ExplicitTop = 422
    ExplicitWidth = 497
  end
end
