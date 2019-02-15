unit ZeiterfassungMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, ADODB, Grids, Wwdbigrd, Wwdbgrid, ExtCtrls, DBCtrls, StdCtrls;

type
  TForm1 = class(TForm)
    ADOConnection1: TADOConnection;
    wwDBGrid1: TwwDBGrid;
    ADOTable1: TADOTable;
    DataSource1: TDataSource;
    ADOTable1TAG: TWideStringField;
    ADOTable1KOMMEN: TWideStringField;
    ADOTable1PAUSE_START: TWideStringField;
    ADOTable1PAUSE_ENDE: TWideStringField;
    ADOTable1GEHEN: TWideStringField;
    ADOTable1SONSTIGER_ABZUG: TWideStringField;
    ADOTable1ZUHAUSE: TWideStringField;
    ADOTable1BERSTUNDEN_SALDO: TIntegerField;
    ADOTable1BERSTUNDEN: TIntegerField;
    ADOTable1FREIER_TAG: TBooleanField;
    Panel1: TPanel;
    Button1: TButton;
    DBNavigator1: TDBNavigator;
    ADOTable1WOCHENTAG: TStringField;
    ADOTable1USERNAME: TStringField;
    ComboBox1: TComboBox;
    Label1: TLabel;
    Label2: TLabel;
    procedure ADOTable1NewRecord(DataSet: TDataSet);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ADOTable1BeforePost(DataSet: TDataSet);
    procedure ADOTable1BERSTUNDEN_SALDOGetText(Sender: TField; var Text: string;
      DisplayText: Boolean);
    procedure ADOTable1BERSTUNDENGetText(Sender: TField; var Text: string;
      DisplayText: Boolean);
    procedure wwDBGrid1CalcCellColors(Sender: TObject; Field: TField;
      State: TGridDrawState; Highlight: Boolean; AFont: TFont; ABrush: TBrush);
    procedure ADOTable1AfterPost(DataSet: TDataSet);
    procedure Button1Click(Sender: TObject);
    procedure ADOTable1TAGChange(Sender: TField);
    procedure ADOTable1SONSTIGER_ABZUGSetText(Sender: TField;
      const Text: string);
    procedure ADOTable1ZUHAUSESetText(Sender: TField; const Text: string);
    procedure ADOTable1GEHENSetText(Sender: TField; const Text: string);
    procedure ADOTable1PAUSE_ENDESetText(Sender: TField; const Text: string);
    procedure ADOTable1PAUSE_STARTSetText(Sender: TField; const Text: string);
    procedure ADOTable1KOMMENSetText(Sender: TField; const Text: string);
    procedure FormShow(Sender: TObject);
    procedure ADOTable1WOCHENTAGGetText(Sender: TField; var Text: string;
      DisplayText: Boolean);
    procedure ComboBox1Change(Sender: TObject);
    procedure ADOTable1TAGSetText(Sender: TField; const Text: string);
    procedure ADOTable1AfterDelete(DataSet: TDataSet);
    procedure ADOTable1TAGGetText(Sender: TField; var Text: string;
      DisplayText: Boolean);
    procedure ADOTable1KOMMENGetText(Sender: TField; var Text: string;
      DisplayText: Boolean);
    procedure ADOTable1PAUSE_STARTGetText(Sender: TField; var Text: string;
      DisplayText: Boolean);
    procedure ADOTable1PAUSE_ENDEGetText(Sender: TField; var Text: string;
      DisplayText: Boolean);
    procedure ADOTable1GEHENGetText(Sender: TField; var Text: string;
      DisplayText: Boolean);
    procedure ADOTable1SONSTIGER_ABZUGGetText(Sender: TField; var Text: string;
      DisplayText: Boolean);
    procedure ADOTable1ZUHAUSEGetText(Sender: TField; var Text: string;
      DisplayText: Boolean);
  private
    function GueltigeZeile: boolean;
  protected
    procedure ReorgDataSet;
    procedure ReorgAll;
    function RegelArbeitszeit: integer;
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

// TODO: Trennstriche zwischen Wochen oder zwischen Urlauben
// TODO: Anmerkungen

uses
  DateUtils, StrUtils, IniFiles;

{$REGION 'Hilfsfunktionen'}

function SQL_Escape(const s: string): string;
begin
  result := StringReplace(s, '''', '\''', [rfReplaceAll]);
end;

function IstLeer(f: TField): boolean;
begin
  result := f.IsNull or (f.AsString = '') or (f.AsString = '00:00:00');
end;

function Minuten(f: TField): integer;
begin
  if IstLeer(f) then
  begin
    result := 0;
  end
  else
  begin
    result := MinuteOfTheDay(f.AsDateTime);
  end;
end;

function MinutenZuHF(f: TField): string;
var
  d: integer;
begin
  if IstLeer(f) then
  begin
    result := '';
  end
  else
  begin
    d := f.AsInteger;
    if d < 0 then
    begin
      result := '-';
      d := -d;
    end
    else
    begin
      result := '';
    end;
    result := result + Format('%.2d:%.2d', [d div 60, d mod 60]);
  end;
end;

function EchtesDatum(f: TField): TDate;
begin
  if Copy(f.AsString, 5, 1) = '-' then
  begin
    result := EncodeDate(
    StrtoInt(Copy(f.AsString, 1, 4)),
    StrtoInt(Copy(f.AsString, 6, 2)),
    StrtoInt(Copy(f.AsString, 9, 2))
    );
  end
  else
    result := StrToDate(f.AsString);
end;

function WUserName: String;
var
  nSize: DWord;
begin
  nSize := 1024;
  SetLength(Result, nSize);
  if GetUserName(PChar(Result), nSize) then
    SetLength(Result, nSize-1)
  else
    RaiseLastOSError;
end;

{$ENDREGION}

function TForm1.RegelArbeitszeit: integer;
var
  test: TADOQuery;
begin
  test := TADOQuery.Create(nil);
  try
    test.Connection := ADOConnection1;
    test.Close;
    test.SQL.Text := 'select MINUTEN from REGELARBEITSZEIT where USERNAME = ''' + SQL_Escape(ComboBox1.Text) + '''';
    test.Open;
    if test.RecordCount = 0 then
    begin
      result := 8 * 60;
    end
    else
    begin
      result := test.FieldByName('MINUTEN').AsInteger;
    end;
  finally
    test.Free;
  end;
end;

procedure TForm1.ReorgAll;
var
  saldo: integer;
  baks: string;
  bakEv: TDataSetNotifyEvent;
  dead: boolean;
begin
  if ADOTable1.ReadOnly then exit;

  if ADOTable1TAG.IsNull then
  begin
    baks := '';
  end
  else
  begin
    if Copy(ADOTable1TAG.AsString, 5, 1) = '-' then
      baks := ADOTable1TAG.AsString
    else
      DateTimeToString(baks, 'YYYY-MM-DD', ADOTable1TAG.AsDateTime);
  end;
  bakEv := ADOTable1.AfterPost;
  ADOTable1.AfterPost := nil;
  ADOTable1.Requery();
  try
    ADOTable1.First;
    saldo := 0;
    dead := false;
    while not ADOTable1.Eof do
    begin
      ADOTable1.Edit;
      if not dead then ReorgDataSet;
      dead := dead or ADOTable1BERSTUNDEN.IsNull;
      if dead then
      begin
        ADOTable1BERSTUNDEN_SALDO.Clear;
      end
      else
      begin
        saldo := saldo + ADOTable1BERSTUNDEN.AsInteger;
        ADOTable1BERSTUNDEN_SALDO.AsInteger := saldo;
        saldo := ADOTable1BERSTUNDEN_SALDO.AsInteger;
      end;
      ADOTable1.Post;
      ADOTable1.Next;
    end;
  finally
    if baks <> '' then ADOTable1.Locate('USERNAME;TAG', VarArrayOf([WUserName, baks]), []);
    ADOTable1.AfterPost := bakEv;
  end;
end;

procedure TForm1.ADOTable1AfterDelete(DataSet: TDataSet);
begin
  ReorgAll;
end;

procedure TForm1.ADOTable1AfterPost(DataSet: TDataSet);
begin
  ReorgAll;
end;

function TForm1.GueltigeZeile: boolean;
begin
  result := false;

  if IstLeer(ADOTable1KOMMEN) <> IstLeer(ADOTable1GEHEN) then exit;
  if IstLeer(ADOTable1PAUSE_START) <> IstLeer(ADOTable1PAUSE_ENDE) then exit;
  if not IstLeer(ADOTable1PAUSE_START) and (ADOTable1PAUSE_START.AsDateTime < ADOTable1KOMMEN.AsDateTime) then exit;
  if not IstLeer(ADOTable1PAUSE_ENDE) and (ADOTable1PAUSE_ENDE.AsDateTime < ADOTable1PAUSE_START.AsDateTime) then exit;
  if not IstLeer(ADOTable1GEHEN) and (ADOTable1GEHEN.AsDateTime < ADOTable1KOMMEN.AsDateTime) then exit;
  if not IstLeer(ADOTable1GEHEN) and not IstLeer(ADOTable1PAUSE_START) and (ADOTable1GEHEN.AsDateTime < ADOTable1PAUSE_START.AsDateTime) then exit;
  if not IstLeer(ADOTable1GEHEN) and not IstLeer(ADOTable1PAUSE_ENDE) and (ADOTable1GEHEN.AsDateTime < ADOTable1PAUSE_ENDE.AsDateTime) then exit;

  result := true;
end;

procedure TForm1.ReorgDataSet;
var
  m: integer;
begin
  if GueltigeZeile then
  begin
    m :=   (Minuten(ADOTable1GEHEN) - Minuten(ADOTable1KOMMEN))
         - (Minuten(ADOTable1PAUSE_ENDE) - Minuten(ADOTable1PAUSE_START))
         - Minuten(ADOTable1SONSTIGER_ABZUG)
         + Minuten(ADOTable1ZUHAUSE);

    if not ADOTable1FREIER_TAG.AsBoolean then
    begin
      m := m - RegelArbeitszeit;
    end;

    ADOTable1BERSTUNDEN.AsInteger := m;
  end
  else
  begin
    ADOTable1BERSTUNDEN.Clear;
  end;
end;

procedure TForm1.ADOTable1BeforePost(DataSet: TDataSet);
begin
  if (ADOTable1.State = dsInsert) and ADOTable1TAG.IsNull then
  begin
    AdoTable1.Cancel;
    Abort;
  end;

  ReorgDataSet;
end;

procedure TForm1.ADOTable1BERSTUNDENGetText(Sender: TField; var Text: string;
  DisplayText: Boolean);
begin
  Text := MinutenZuHF(ADOTable1BERSTUNDEN);
end;

procedure TForm1.ADOTable1BERSTUNDEN_SALDOGetText(Sender: TField;
  var Text: string; DisplayText: Boolean);
begin
  Text := MinutenZuHF(ADOTable1BERSTUNDEN_SALDO);
end;

procedure TForm1.ADOTable1GEHENGetText(Sender: TField; var Text: string;
  DisplayText: Boolean);
begin
  Text := Copy(Sender.AsString, 1, 5);
end;

procedure TForm1.ADOTable1GEHENSetText(Sender: TField; const Text: string);
begin
  if Text = '' then
  begin
    ADOTable1GEHEN.Clear;
  end
  else
  begin
    ADOTable1GEHEN.AsString := Text;
  end;
end;

procedure TForm1.ADOTable1KOMMENGetText(Sender: TField; var Text: string;
  DisplayText: Boolean);
begin
  Text := Copy(Sender.AsString, 1, 5);
end;

procedure TForm1.ADOTable1KOMMENSetText(Sender: TField; const Text: string);
begin
  if Text = '' then
  begin
    ADOTable1KOMMEN.Clear;
  end
  else
  begin
    ADOTable1KOMMEN.AsString := Text;
  end;
end;

procedure TForm1.ADOTable1NewRecord(DataSet: TDataSet);
var
  test: TADOQuery;
begin
  ADOTable1FREIER_TAG.AsBoolean := false;
  ADOTable1USERNAME.AsString := WUserName;
  test := TADOQuery.Create(nil);
  try
    test.Connection := ADOConnection1;
    test.Close;
    test.SQL.Text := 'select * from TAGE where TAG = ''' + DateToStr(Date) + '''';
    test.Open;
    if test.RecordCount = 0 then
    begin
      ADOTable1TAG.AsDateTime := Date;
      ADOTable1KOMMEN.AsString := TimeToStr(Time);
      ADOTable1FREIER_TAG.AsBoolean := (DayOfWeek(Date) = 1{Sunday}) or
                                       (DayOfWeek(Date) = 7{Saturday});
    end;
  finally
    test.Free;
  end;

  wwDBGrid1.SelectedField := ADOTable1TAG;
end;

procedure TForm1.ADOTable1PAUSE_ENDEGetText(Sender: TField; var Text: string;
  DisplayText: Boolean);
begin
  Text := Copy(Sender.AsString, 1, 5);
end;

procedure TForm1.ADOTable1PAUSE_ENDESetText(Sender: TField; const Text: string);
begin
  if Text = '' then
  begin
    ADOTable1PAUSE_ENDE.Clear;
  end
  else
  begin
    ADOTable1PAUSE_ENDE.AsString := Text;
  end;
end;

procedure TForm1.ADOTable1PAUSE_STARTGetText(Sender: TField; var Text: string;
  DisplayText: Boolean);
begin
  Text := Copy(Sender.AsString, 1, 5);
end;

procedure TForm1.ADOTable1PAUSE_STARTSetText(Sender: TField;
  const Text: string);
begin
  if Text = '' then
  begin
    ADOTable1PAUSE_START.Clear;
  end
  else
  begin
    ADOTable1PAUSE_START.AsString := Text;
  end;
end;

procedure TForm1.ADOTable1SONSTIGER_ABZUGGetText(Sender: TField;
  var Text: string; DisplayText: Boolean);
begin
  Text := Copy(Sender.AsString, 1, 5);
end;

procedure TForm1.ADOTable1SONSTIGER_ABZUGSetText(Sender: TField;
  const Text: string);
begin
  if Text = '' then
  begin
    ADOTable1SONSTIGER_ABZUG.Clear;
  end
  else
  begin
    ADOTable1SONSTIGER_ABZUG.AsString := Text;
  end;
end;

procedure TForm1.ADOTable1TAGChange(Sender: TField);
begin
  ADOTable1FREIER_TAG.AsBoolean := (DayOfWeek(ADOTable1TAG.AsDateTime) = 1{Sunday}) or
                                   (DayOfWeek(ADOTable1TAG.AsDateTime) = 7{Saturday});
  // TODO: "Wochentag" Feld aktualisieren
end;

procedure TForm1.ADOTable1TAGGetText(Sender: TField; var Text: string;
  DisplayText: Boolean);
begin
  Text := DateToStr(EchtesDatum(Sender));
end;

procedure TForm1.ADOTable1TAGSetText(Sender: TField; const Text: string);
var
  i, punktCount: integer;
begin
  punktCount := 0;
  for i := 1 to Length(Text) do
  begin
    if Text[i] = '.' then inc(punktCount);
  end;

  if punktCount = 1 then
  begin
    ADOTable1TAG.AsString := Text + '.' + IntToStr(CurrentYear);
  end
  else if (PunktCount = 2) and EndsStr('.',Text) then
  begin
    ADOTable1TAG.AsString := Text + IntToStr(CurrentYear);
  end
  else
  begin
    ADOTable1TAG.AsString := Text;
  end;
end;

procedure TForm1.ADOTable1WOCHENTAGGetText(Sender: TField; var Text: string;
  DisplayText: Boolean);
begin
  try
    if ADOTable1TAG.AsString <> '' then
      Text := ShortDayNames[DayOfWeek(EchtesDatum(ADOTable1TAG))]
    else
      Text := '';
  except
    Text := '??';
  end;
end;

procedure TForm1.ADOTable1ZUHAUSEGetText(Sender: TField; var Text: string;
  DisplayText: Boolean);
begin
  Text := Copy(Sender.AsString, 1, 5);
end;

procedure TForm1.ADOTable1ZUHAUSESetText(Sender: TField; const Text: string);
begin
  if Text = '' then
  begin
    ADOTable1ZUHAUSE.Clear;
  end
  else
  begin
    ADOTable1ZUHAUSE.AsString := Text;
  end;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  ReorgAll;
end;

procedure TForm1.ComboBox1Change(Sender: TObject);
begin
  ADOTable1.Active := false;
  ADOTable1.ReadOnly := ComboBox1.Text <> WUserName;
  ADOTable1.Filter := 'USERNAME = ''' + SQL_Escape(ComboBox1.Text) + '''';
  ADOTable1.Filtered := true;
  ADOTable1.Active := true;
  ADOTable1.Last;

  Button1.Enabled := not ADOTable1.ReadOnly;

  Label2.Caption := IntToStr(RegelArbeitszeit);

  ReorgAll;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if ADOTable1.State in [dsEdit, dsInsert] then
  begin
    try
      ADOTable1.Post;
    except
      on E: EAbort do
      begin
        exit;
      end;
    end;
  end;
end;

procedure TForm1.FormShow(Sender: TObject);
var
  test: TADOQuery;
  ini: TMemIniFile;
resourcestring
  DefaultConnectionString = 'Provider=SQLOLEDB.1;Integrated Security=SSPI;Persist Security Info=False;Initial Catalog=Zeiterfassung;' +
                            'Data Source=SHS\FiVe,49007;Use Procedure for Prepare=1;Auto Translate=True;Packet Size=4096;Workstation ID=MARSCHALL;Use Encryption for Data=False;Tag with column collation when possible=False;';
begin
  ini := TMemIniFile.Create(IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0))) + ChangeFileExt(ExtractFileName(ParamStr(0)), '.ini'));
  try
    ADOConnection1.ConnectionString := ini.ReadString('Connection', 'ConnectionString', DefaultConnectionString);
  finally
    ini.Free;
  end;
  ADOConnection1.Connected := true;

  {$REGION 'Username Combobox füllen'}
  test := TADOQuery.Create(nil);
  try
    test.Connection := ADOConnection1;
    test.Close;
    test.SQL.Text := 'select distinct USERNAME from TAGE';
    test.Open;
    ComboBox1.Items.Clear;
    while not test.EOF do
    begin
      ComboBox1.Items.Add(test.FieldByName('USERNAME').AsString);
      test.Next;
    end;
  finally
    test.Free;
  end;

  if ComboBox1.Items.IndexOf(WUserName) = -1 then
    ComboBox1.Items.Add(WUserName);

  ComboBox1.Sorted := true;

  ComboBox1.ItemIndex := ComboBox1.Items.IndexOf(WUserName);

  ComboBox1Change(ComboBox1);
  {$ENDREGION}

  if wwDBGrid1.CanFocus then wwDBGrid1.SetFocus;
  wwDBGrid1.SelectedField := ADOTable1TAG;
end;

procedure TForm1.wwDBGrid1CalcCellColors(Sender: TObject; Field: TField;
  State: TGridDrawState; Highlight: Boolean; AFont: TFont; ABrush: TBrush);
begin
  if Highlight then exit;
  
  if (Field.FieldName = ADOTable1BERSTUNDEN.FieldName) or
     (Field.FieldName = ADOTable1BERSTUNDEN_SALDO.FieldName) then
  begin
    ABrush.Color := clBtnFace;
  end;

  if (Field.FieldName = ADOTable1BERSTUNDEN.FieldName) then
  begin
    if ADOTable1BERSTUNDEN.AsInteger < 0 then
    begin
      AFont.Color := clRed;
    end;
  end;

  if (Field.FieldName = ADOTable1BERSTUNDEN_SALDO.FieldName) then
  begin
    if ADOTable1BERSTUNDEN_SALDO.AsInteger < 0 then
    begin
      AFont.Color := clRed;
    end;
  end;
end;

end.
