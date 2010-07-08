object Form1: TForm1
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'ViaThinkSoft Rule of Three'
  ClientHeight = 315
  ClientWidth = 358
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 8
    Top = 8
    Width = 337
    Height = 81
    Caption = 'Source'
    TabOrder = 0
    object Label1: TLabel
      Left = 159
      Top = 27
      Width = 14
      Height = 25
      Caption = 'is'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -21
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Edit1: TEdit
      Left = 16
      Top = 24
      Width = 121
      Height = 33
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -21
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      Text = '5'
      OnChange = SourceChange
    end
    object Edit2: TEdit
      Left = 192
      Top = 24
      Width = 121
      Height = 33
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -21
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      Text = '100'
      OnChange = SourceChange
    end
  end
  object GroupBox2: TGroupBox
    Left = 8
    Top = 186
    Width = 337
    Height = 121
    Caption = 'Test calculation against source (1)'
    TabOrder = 2
    object Label3: TLabel
      Left = 159
      Top = 27
      Width = 14
      Height = 25
      Caption = 'is'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -21
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Edit3: TEdit
      Left = 16
      Top = 24
      Width = 121
      Height = 33
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -21
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      Text = '5'
      OnChange = Edit3Change
    end
    object Edit4: TEdit
      Left = 192
      Top = 24
      Width = 121
      Height = 33
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -21
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      Text = '100'
      OnChange = Edit4Change
    end
    object RadioButton1: TRadioButton
      Left = 16
      Top = 90
      Width = 129
      Height = 17
      Caption = 'Lock on source change'
      Checked = True
      TabOrder = 4
      TabStop = True
      OnClick = RadioButton1Click
    end
    object RadioButton2: TRadioButton
      Left = 192
      Top = 90
      Width = 129
      Height = 17
      Caption = 'Lock on source change'
      TabOrder = 5
      OnClick = RadioButton2Click
    end
    object Edit5: TEdit
      Left = 16
      Top = 63
      Width = 121
      Height = 21
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 2
      Text = '5'
    end
    object Edit6: TEdit
      Left = 192
      Top = 63
      Width = 121
      Height = 21
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 3
      Text = '100'
    end
  end
  object GroupBox3: TGroupBox
    Left = 8
    Top = 95
    Width = 337
    Height = 85
    Caption = 'Fracture of source'
    TabOrder = 1
    object Label2: TLabel
      Left = 23
      Top = 17
      Width = 36
      Height = 25
      Caption = 'ppp'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -21
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Label4: TLabel
      Left = 23
      Top = 48
      Width = 36
      Height = 25
      Caption = 'qqq'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -21
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Label5: TLabel
      Left = 95
      Top = 33
      Width = 15
      Height = 25
      Caption = '='
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -21
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Label6: TLabel
      Left = 135
      Top = 33
      Width = 30
      Height = 25
      Caption = 'xxx'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -21
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Panel1: TPanel
      Left = 16
      Top = 48
      Width = 57
      Height = 2
      TabOrder = 0
    end
  end
end
