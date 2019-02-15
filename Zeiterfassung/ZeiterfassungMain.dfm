object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Digitale Zeiterfassung'
  ClientHeight = 485
  ClientWidth = 852
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object wwDBGrid1: TwwDBGrid
    Left = 0
    Top = 50
    Width = 852
    Height = 435
    ControlType.Strings = (
      'FREIER_TAG;CheckBox;Wahr;Falsch')
    Selected.Strings = (
      'WOCHENTAG'#9'2'#9' '
      'TAG'#9'10'#9'TAG'
      'FREIER_TAG'#9'6'#9'Frei'
      'KOMMEN'#9'8'#9'Kommen'
      'PAUSE_START'#9'8'#9'Pause'
      'PAUSE_ENDE'#9'8'#9'Ende'
      'GEHEN'#9'9'#9'Gehen'
      'SONSTIGER_ABZUG'#9'10'#9'Sonst. Abzug'
      'ZUHAUSE'#9'11'#9'Arb. zuhause'
      #220'BERSTUNDEN'#9'15'#9#220'berstunden heute'
      #220'BERSTUNDEN_SALDO'#9'16'#9#220'berstunden ges.')
    IniAttributes.Delimiter = ';;'
    TitleColor = clBtnFace
    FixedCols = 0
    ShowHorzScrollBar = True
    Align = alClient
    DataSource = DataSource1
    KeyOptions = [dgEnterToTab, dgAllowDelete, dgAllowInsert]
    TabOrder = 0
    TitleAlignment = taLeftJustify
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
    TitleLines = 1
    TitleButtons = False
    OnCalcCellColors = wwDBGrid1CalcCellColors
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 852
    Height = 50
    Align = alTop
    TabOrder = 1
    ExplicitWidth = 827
    DesignSize = (
      852
      50)
    object Label1: TLabel
      Left = 208
      Top = 12
      Width = 81
      Height = 13
      Caption = 'Regelarbeitszeit:'
    end
    object Label2: TLabel
      Left = 208
      Top = 27
      Width = 12
      Height = 13
      Caption = '...'
    end
    object Button1: TButton
      Left = 610
      Top = 12
      Width = 53
      Height = 24
      Anchors = [akTop, akRight]
      Caption = 'Reorg'
      TabOrder = 0
      TabStop = False
      OnClick = Button1Click
      ExplicitLeft = 585
    end
    object DBNavigator1: TDBNavigator
      Left = 669
      Top = 12
      Width = 168
      Height = 25
      DataSource = DataSource1
      VisibleButtons = [nbFirst, nbLast, nbInsert, nbDelete, nbPost, nbCancel]
      Anchors = [akTop, akRight]
      TabOrder = 1
      ExplicitLeft = 644
    end
    object ComboBox1: TComboBox
      Left = 24
      Top = 16
      Width = 169
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 2
      OnChange = ComboBox1Change
    end
  end
  object ADOConnection1: TADOConnection
    LoginPrompt = False
    Provider = 'SQLOLEDB.1'
    Left = 280
    Top = 16
  end
  object ADOTable1: TADOTable
    Connection = ADOConnection1
    CursorType = ctStatic
    BeforePost = ADOTable1BeforePost
    AfterPost = ADOTable1AfterPost
    AfterDelete = ADOTable1AfterDelete
    OnNewRecord = ADOTable1NewRecord
    TableName = 'TAGE'
    Left = 312
    Top = 16
    object ADOTable1WOCHENTAG: TStringField
      DisplayLabel = ' '
      DisplayWidth = 2
      FieldKind = fkCalculated
      FieldName = 'WOCHENTAG'
      ReadOnly = True
      OnGetText = ADOTable1WOCHENTAGGetText
      Size = 2
      Calculated = True
    end
    object ADOTable1TAG: TWideStringField
      DisplayWidth = 10
      FieldName = 'TAG'
      OnChange = ADOTable1TAGChange
      OnGetText = ADOTable1TAGGetText
      OnSetText = ADOTable1TAGSetText
      Size = 10
    end
    object ADOTable1FREIER_TAG: TBooleanField
      DisplayLabel = 'Frei'
      DisplayWidth = 6
      FieldName = 'FREIER_TAG'
    end
    object ADOTable1KOMMEN: TWideStringField
      DisplayLabel = 'Kommen'
      DisplayWidth = 8
      FieldName = 'KOMMEN'
      OnGetText = ADOTable1KOMMENGetText
      OnSetText = ADOTable1KOMMENSetText
      Size = 8
    end
    object ADOTable1PAUSE_START: TWideStringField
      DisplayLabel = 'Pause'
      DisplayWidth = 8
      FieldName = 'PAUSE_START'
      OnGetText = ADOTable1PAUSE_STARTGetText
      OnSetText = ADOTable1PAUSE_STARTSetText
      Size = 8
    end
    object ADOTable1PAUSE_ENDE: TWideStringField
      DisplayLabel = 'Ende'
      DisplayWidth = 8
      FieldName = 'PAUSE_ENDE'
      OnGetText = ADOTable1PAUSE_ENDEGetText
      OnSetText = ADOTable1PAUSE_ENDESetText
      Size = 8
    end
    object ADOTable1GEHEN: TWideStringField
      DisplayLabel = 'Gehen'
      DisplayWidth = 9
      FieldName = 'GEHEN'
      OnGetText = ADOTable1GEHENGetText
      OnSetText = ADOTable1GEHENSetText
      Size = 8
    end
    object ADOTable1SONSTIGER_ABZUG: TWideStringField
      DisplayLabel = 'Sonst. Abzug'
      DisplayWidth = 10
      FieldName = 'SONSTIGER_ABZUG'
      OnGetText = ADOTable1SONSTIGER_ABZUGGetText
      OnSetText = ADOTable1SONSTIGER_ABZUGSetText
      Size = 8
    end
    object ADOTable1ZUHAUSE: TWideStringField
      DisplayLabel = 'Arb. zuhause'
      DisplayWidth = 11
      FieldName = 'ZUHAUSE'
      OnGetText = ADOTable1ZUHAUSEGetText
      OnSetText = ADOTable1ZUHAUSESetText
      Size = 8
    end
    object ADOTable1BERSTUNDEN: TIntegerField
      DisplayLabel = #220'berstunden heute'
      DisplayWidth = 15
      FieldName = #220'BERSTUNDEN'
      OnGetText = ADOTable1BERSTUNDENGetText
    end
    object ADOTable1BERSTUNDEN_SALDO: TIntegerField
      DisplayLabel = #220'berstunden ges.'
      DisplayWidth = 16
      FieldName = #220'BERSTUNDEN_SALDO'
      OnGetText = ADOTable1BERSTUNDEN_SALDOGetText
    end
    object ADOTable1USERNAME: TStringField
      FieldName = 'USERNAME'
      Visible = False
      Size = 100
    end
  end
  object DataSource1: TDataSource
    DataSet = ADOTable1
    Left = 344
    Top = 16
  end
end
