unit AsciiTable;

// Download:
// https://github.com/danielmarschall/delphiutils/blob/master/Units/AsciiTable.pas

(*
 * ASCII Table and CSV Generator Delphi Unit
 * Revision 2023-12-08
 *
 * (C) 2022 Daniel Marschall, HickelSOFT, ViaThinkSoft
 * Licensed under the terms of Apache 2.0
 *)

{

Example usage:

uses
  AsciiTable, ContNrs;

procedure TForm1.Button1Click(Sender: TObject);
var
  VirtTable: TVtsAsciiTable;
  objLine: TVtsAsciiTableLine;
begin
  VirtTable := TVtsAsciiTable.Create(true);
  try
    VirtTable.Clear;

    // Create Test data
    objLine := TVtsAsciiTableLine.Create;
    objLine.SetVal(0, 'Fruit', taCenter);
    objLine.SetVal(1, 'Amount', taCenter);
    VirtTable.Add(objLine);

    VirtTable.AddSeparator;

    objLine := TVtsAsciiTableLine.Create;
    objLine.SetVal(0, 'Apple', taLeftJustify);
    objLine.SetVal(1, '123', taRightJustify);
    VirtTable.Add(objLine);

    objLine := TVtsAsciiTableLine.Create;
    objLine.SetVal(0, 'Kiwi', taLeftJustify);
    objLine.SetVal(1, '1', taRightJustify);
    VirtTable.Add(objLine);

    objLine := TVtsAsciiTableLine.Create;
    objLine.SetVal(0, 'Asparagus (green)', taLeftJustify);
    objLine.SetVal(1, '9999', taRightJustify);
    VirtTable.Add(objLine);

    objLine := TVtsAsciiTableLine.Create;
    objLine.SetVal(0, 'Asparagus (white)', taLeftJustify);
    objLine.SetVal(1, '999', taRightJustify);
    VirtTable.Add(objLine);

    VirtTable.AddSeparator;
    VirtTable.AddSumLine;

    // Create ASCII table
    Memo1.Clear;
    VirtTable.GetASCIITable(Memo1.Lines);

    // Save ASCII table
    VirtTable.SaveASCIITable('Order.txt');

    // Create CSV
    Memo2.Clear;
    VirtTable.GetCSV(Memo2.Lines);

    // Save CSV
    VirtTable.SaveCSV('Order.csv');
  finally
    FreeAndNil(VirtTable);
  end;
end;

}

interface

uses
  ContNrs, Classes, SysUtils;

const
  VTS_ASCII_TABLE_COLS = 10;

type
  TVtsAsciiTableLine = class(TObject)
  private
    IsSumLine: boolean;
    //IsSeparator: boolean;
  public
    Cont: array[0..VTS_ASCII_TABLE_COLS-1] of string;
    Align: array[0..VTS_ASCII_TABLE_COLS-1] of TAlignment;
    PadChar: array[0..VTS_ASCII_TABLE_COLS-1] of char;
    DoSum: array[0..VTS_ASCII_TABLE_COLS-1] of boolean;
    procedure Clear;
    procedure SetVal(index: integer; ACont: string; AAlign: TAlignment=taLeftJustify;
      APadChar: char=' '; ADoSum: boolean=false);
  end;

  TVtsAsciiTableAnalysis = record
    MaxLen: array[0..VTS_ASCII_TABLE_COLS-1] of integer;
    Used: array[0..VTS_ASCII_TABLE_COLS-1] of boolean;
    Sum: array[0..VTS_ASCII_TABLE_COLS-1] of extended;
  end;

  TVtsAsciiTable = class(TObjectList{<TVtsAsciiTableLine>})
  private
    function GetItem(Index: Integer): TVtsAsciiTableLine;
    procedure SetItem(Index: Integer; const Value: TVtsAsciiTableLine);
  public
    function GetAnalysis: TVtsAsciiTableAnalysis;
    procedure GetASCIITable(sl: TStrings; spaceBetween: integer=3); overload;
    function GetASCIITable(spaceBetween: integer=3): string; overload;
    procedure SaveASCIITable(filename: string; spaceBetween: integer=3);
    procedure GetCSV(sl: TStrings);
    procedure SaveCSV(filename: string);

    procedure AddSeparator;
    procedure AddSumLine;

    // Just a little bit type-safe... The rest stays TObject for now
    function Add(AObject: TVtsAsciiTableLine): Integer; reintroduce;
    property Items[Index: Integer]: TVtsAsciiTableLine read GetItem write SetItem;
    procedure Insert(Index: Integer; AObject: TVtsAsciiTableLine); reintroduce;
  end;

implementation

uses
  Math;

{ TVtsAsciiTable }

function TVtsAsciiTable.Add(AObject: TVtsAsciiTableLine): Integer;
begin
  result := Inherited Add(AObject);
end;

procedure TVtsAsciiTable.AddSeparator;
begin
  Inherited Add(nil);
end;

procedure TVtsAsciiTable.AddSumLine;
var
  objLine: TVtsAsciiTableLine;
  j: Integer;
  analysis: TVtsAsciiTableAnalysis;
  found: boolean;
begin
  objLine := TVtsAsciiTableLine.Create;
  objLine.IsSumLine := true;
  analysis := GetAnalysis;
  found := false;
  for j := 0 to VTS_ASCII_TABLE_COLS-1 do
  begin
    if analysis.Sum[j] <> 0 then
    begin
      objLine.SetVal(j, FloatToStr(RoundTo(analysis.Sum[j],2)), taRightJustify, ' ');
      found := true;
    end;
  end;
  if found then
    Inherited Add(objLine)
  else
    FreeAndNil(objLine);
end;

function TVtsAsciiTable.GetAnalysis: TVtsAsciiTableAnalysis;
var
  j: Integer;
  i: Integer;
  objLine: TVtsAsciiTableLine;
  len: Integer;
  itmp: extended;
begin
  for j := 0 to VTS_ASCII_TABLE_COLS-1 do
  begin
    result.MaxLen[j] := 0;
    result.Used[j] := false;
    result.Sum[j] := 0;
  end;
  for i := 0 to Self.Count-1 do
  begin
    objLine := Self.items[i] as TVtsAsciiTableLine;
    if objLine <> nil then
    begin
      for j := 0 to VTS_ASCII_TABLE_COLS-1 do
      begin
        len := Length(objLine.Cont[j]);
        if TryStrToFloat(RoundTo(objLine.Cont[j],2), itmp) and objLine.DoSum[j] then
          result.Sum[j] := result.Sum[j] + itmp;
        if len > result.MaxLen[j] then
          result.MaxLen[j] := len;
        if len > 0 then
          result.Used[j] := true;
      end;
    end;
  end;
end;

function TVtsAsciiTable.GetASCIITable(spaceBetween: integer): string;
var
  sl: TStringList;
begin
  sl := TStringList.Create;
  try
    GetASCIITable(sl, spaceBetween);
    result := sl.Text;
  finally
    FreeAndNil(sl);
  end;
end;

procedure TVtsAsciiTable.GetASCIITable(sl: TStrings; spaceBetween: integer=3);
var
  analysis: TVtsAsciiTableAnalysis;
  objLine: TVtsAsciiTableLine;
  i: Integer;
  sLine: string;
  j: Integer;
  itmp: Integer;
  padchar: Char;
  firstcol: boolean;
  width: Integer;
begin
  analysis := GetAnalysis;
  //sl.Clear;
  for i := 0 to Self.Count-1 do
  begin
    objLine := Self.items[i] as TVtsAsciiTableLine;
    sLine := '';
    if objLine <> nil then
    begin
      firstcol := true;
      for j := 0 to VTS_ASCII_TABLE_COLS-1 do
      begin
        if not analysis.Used[j] then continue;

        padchar := objLine.PadChar[j];
        if padchar = #0 then padchar := ' ';

        if firstcol then
          firstcol := false
        else
          sLine := sLine + StringOfChar(' ', spaceBetween);

        if objLine.Align[j] = taRightJustify then
        begin
          sLine := sLine + StringOfChar(padchar, analysis.MaxLen[j]-Length(objLine.Cont[j]));
          sLine := sLine + objLine.Cont[j];
        end
        else if objLine.Align[j] = taLeftJustify then
        begin
          sLine := sLine + objLine.Cont[j];
          sLine := sLine + StringOfChar(padchar, analysis.MaxLen[j]-Length(objLine.Cont[j]));
        end
        else if objLine.Align[j] = taCenter then
        begin
          if Odd(analysis.MaxLen[j]-Length(objLine.Cont[j])) then itmp := 1 else itmp := 0;
          sLine := sLine + StringOfChar(padchar, (analysis.MaxLen[j]-Length(objLine.Cont[j])) div 2);
          sLine := sLine + objLine.Cont[j];
          sLine := sLine + StringOfChar(padchar, (analysis.MaxLen[j]-Length(objLine.Cont[j])) div 2 + itmp);
        end
        else
          Assert(false);
      end;
    end
    else
    begin
      firstcol := true;
      width := 0;
      for j := 0 to VTS_ASCII_TABLE_COLS-1 do
      begin
        if not analysis.Used[j] then continue;
        if firstcol then
          firstcol := false
        else
          width := width + spaceBetween;
        width := width + analysis.MaxLen[j];
      end;

      sLine := sLine + StringOfChar('-', Width);
    end;
    sl.Add(sLine);
  end;
end;

function CsvQuoteStr(s: string): string;
begin
  s := StringReplace(s, #13#10, ' ', [rfReplaceAll]);
  s := StringReplace(s, #13, ' ', [rfReplaceAll]);
  s := StringReplace(s, #10, ' ', [rfReplaceAll]);
  if s = '' then
    result := ''
  else if (AnsiPos('"', s)>0) or (AnsiPos('''', s)>0) or (AnsiPos(';', s)>0) or
          (AnsiPos(#9, s)>0) or (AnsiPos(' ', s)>0) then
    result := '"' + StringReplace(s, '"', '""', [rfReplaceAll]) + '"'
  else
    result := s;
end;

procedure TVtsAsciiTable.GetCSV(sl: TStrings);
var
  analysis: TVtsAsciiTableAnalysis;
  objLine: TVtsAsciiTableLine;
  i: Integer;
  sLine: string;
  j: Integer;
  firstcol: boolean;
begin
  analysis := GetAnalysis;
  //sl.Clear;
  for i := 0 to Self.Count-1 do
  begin
    objLine := Self.items[i] as TVtsAsciiTableLine;
    if objLine = nil then continue;
    if objLine.IsSumLine then continue;
    sLine := '';
    firstcol := true;
    for j := 0 to VTS_ASCII_TABLE_COLS-1 do
    begin
      if not analysis.Used[j] then continue;
      if firstcol then
        firstcol := false
      else
        sLine := sLine + ';';
      sLine := sLine + CsvQuoteStr(objLine.Cont[j]);
    end;
    sl.Add(sLine);
  end;
end;

function TVtsAsciiTable.GetItem(Index: Integer): TVtsAsciiTableLine;
begin
  result := (Inherited Items[Index]) as TVtsAsciiTableLine;
end;

procedure TVtsAsciiTable.Insert(Index: Integer; AObject: TVtsAsciiTableLine);
begin
  Inherited Insert(Index, AObject);
end;

procedure TVtsAsciiTable.SaveASCIITable(filename: string;
  spaceBetween: integer);
var
  sl: TStringList;
begin
  sl := TStringList.Create;
  try
    GetASCIITable(sl, spaceBetween);
    sl.SaveToFile(filename);
  finally
    FreeAndNil(sl);
  end;
end;

procedure TVtsAsciiTable.SaveCSV(filename: string);
var
  sl: TStringList;
begin
  sl := TStringList.Create;
  try
    GetCSV(sl);
    sl.SaveToFile(filename);
  finally
    FreeAndNil(sl);
  end;
end;

procedure TVtsAsciiTable.SetItem(Index: Integer; const Value: TVtsAsciiTableLine);
begin
  Inherited Items[Index] := Value;
end;

{ TVtsAsciiTableLine }

procedure TVtsAsciiTableLine.Clear;
var
  i: Integer;
begin
  for i := 0 to VTS_ASCII_TABLE_COLS-1 do
  begin
    PadChar[i] := #0;
    Align[i] := taLeftJustify;
    Cont[i] := '';
  end;
end;

procedure TVtsAsciiTableLine.SetVal(index: integer; ACont: string;
  AAlign: TAlignment=taLeftJustify; APadChar: char=' '; ADoSum: boolean=false);
begin
  Self.Cont[index] := ACont;
  Self.Align[index] := AAlign;
  Self.PadChar[index] := APadChar;
  Self.DoSum[index] := ADoSum;
end;

end.