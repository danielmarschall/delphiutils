unit ParamUtils;

// ParamUtils.pas
// Copyright (C) 2010 ViaThinkSoft. All rights reserved.

interface

uses
  Windows, SysUtils, Classes, Functions;

type
  TParamInfo = packed record
    Found: boolean;
    ParamName: String; // ONLY if found: The actual found argument name (e.g. /a, -a OR --alpha)
    Position: integer; // Only if found, otherwise 0
    Values: TDynStringArray;
  end;

  TParamInfoArray = array of TParamInfo;

function CheckParam(AParamStr: TDynStringArray; ACaseSensitive: boolean; AMinOffset: integer): TParamInfo;
// function DecodeFilename(): TDynStringArray;
// function GetFilenames(AOffset: integer): TDynStringArray;
// function GetFilenames(): TDynStringArray;
function ListParams: TParamInfoArray;

implementation

// Private

const
  ArgDelimiter = '--';

function _NewParamInfo: TParamInfo;
begin
  result.ParamName := '';
  result.Found := false;
  result.Position := 0;
  result.Values := NewStringArray
end;

function _IsFlag(AParam: string): boolean;
var
  c: string;
begin
  c := Copy(AParam, 1, 1);

  result := (c = '/') or (c = '-');
end;

procedure _AppendParamInfoToArray(const s: TParamInfo; var x: TParamInfoArray);
var
  i: integer;
begin
  i := Length(x);
  SetLength(x, i+1);
  x[i] := s;
end;

// Public

function CheckParam(AParamStr: TDynStringArray; ACaseSensitive: boolean; AMinOffset: integer): TParamInfo;
var
  i, j: integer;
  s, t: String;
begin
  result := _NewParamInfo;

  for j := 0 to Length(AParamStr) - 1 do
  begin
    t := AParamStr[j];
    if not _IsFlag(t) then
    begin
      // TODO: Exception
      exit;
    end;
  end;

  // Search
  for i := AMinOffset to ParamCount do
  begin
    s := ParamStr(i);

    if s = ArgDelimiter then break;

    for j := 0 to Length(AParamStr) - 1 do
    begin
      t := AParamStr[j];
      if ACaseSensitive then
      begin
        result.Found := AnsiUpperCase(t) = AnsiUpperCase(s);
      end
      else
      begin
        result.Found := t = s;
      end;
    end;

    if result.Found then
    begin
      result.Position := i;
      result.ParamName := s; // Correct case
      break;
    end;
  end;

  // Determinate value
  if result.Found then
  begin
    for i := result.Position+1 to ParamCount do
    begin
      s := ParamStr(i);

      if s = ArgDelimiter then break;

      if not _IsFlag(s) then
      begin
        AppendStringToArray(s, result.Values);
      end;
    end;
  end;
end;

function ListParams: TParamInfoArray;
var
  i: integer;
  s: String;
begin
  SetLength(result, 0);

  for i := 1 to ParamCount do
  begin
    s := ParamStr(i);

    if s = ArgDelimiter then break;

    if _IsFlag(s) then
    begin
      _AppendParamInfoToArray(CheckParam(BuildStringArray(s), true, i), result);
    end;
  end;
end;

// Nicht berücksichtigt
// - Fehler bei doppelten Vorkommen

end.
