unit ParamUtils;

// ParamUtils.pas
// Copyright (C) 2010 ViaThinkSoft. All rights reserved.

interface

uses
  Windows, SysUtils, Classes, Functions;

type
  TParamInfo = packed record
    ParamName: String; // in actual case, if found
    Found: boolean;
    Position: integer; // only if found, otherwise 0
    Values: TDynStringArray;
  end;

function CheckParam(AParamStr: String; ACaseSensitive: boolean): TParamInfo;
// function DecodeFilename(): TDynStringArray;
// function GetFilenames(AOffset: integer): TDynStringArray;
// function GetFilenames(): TDynStringArray;

implementation

function _NewParamInfo: TParamInfo;
begin
  result.ParamName := '';
  result.Found := false;
  result.Position := 0;
  SetLength(result.Values, 0);
end;

function _IsFlag(AParam: string): boolean;
var
  c: string;
begin
  c := Copy(AParam, 1, 1);

  result := (c = '/') or (c = '-');
end;

function CheckParam(AParamStr: String; ACaseSensitive: boolean): TParamInfo;
var
  i: integer;
  s: String;
begin
  result := _NewParamInfo;
  result.ParamName := AParamStr;

  // Search
  for i := 1 to ParamCount do
  begin
    s := ParamStr(i);

    if s = '--' then break;

    if ACaseSensitive then
    begin
      result.Found := AnsiUpperCase(AParamStr) = AnsiUpperCase(s);
    end
    else
    begin
      result.Found := AParamStr = s;
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

      if not _IsFlag(s) then
      begin
        AppendStringToArray(result.Values, s);
      end;
    end;
  end;
end;



end.
