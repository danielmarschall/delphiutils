unit Functions;

interface

uses
  Windows, SysUtils;

type
  TDynStringArray = array of String;

procedure AppendStringToArray(const s: string; var x: TDynStringArray);
function NewStringArray: TDynStringArray;
function BuildStringArray(s: String): TDynStringArray;

function ExtendFilename(s: string; AllowDirs: boolean): TDynStringArray;

implementation

procedure AppendStringToArray(const s: string; var x: TDynStringArray);
var
  i: integer;
begin
  i := Length(x);
  SetLength(x, i+1);
  x[i] := s;
end;

function NewStringArray: TDynStringArray;
begin
  SetLength(result, 0);
end;

function BuildStringArray(s: String): TDynStringArray;
begin
  result := NewStringArray;
  AppendStringToArray(s, result);
end;

// Src: http://www.swissdelphicenter.ch/torry/showcode.php?id=1140
function _ExpandEnvironment(const strValue: string): string;
var
  chrResult: array[0..1023] of Char;
  wrdReturn: DWORD;
begin
  wrdReturn := ExpandEnvironmentStrings(PChar(strValue), chrResult, 1024);
  if wrdReturn = 0 then
    Result := strValue
  else
  begin
    Result := Trim(chrResult);
  end;
end;

function ExtendFilename(s: string; AllowDirs: boolean): TDynStringArray;
var
  SR: TSearchRec;
  IsFound: boolean;
begin
  // 1. Expand environment variables
  s := _ExpandEnvironment(s);

  // 2. Expand wildcards (and ensure that file/directory actually exists!)
  if AllowDirs then
    IsFound := FindFirst(s, faAnyFile, SR) = 0
  else
    IsFound := FindFirst(s, faAnyFile-faDirectory, SR) = 0;

  try
    while IsFound do
    begin
      // 3. Make UNC
      s := ExpandUNCFileName(SR.Name);
      AppendStringToArray(s, result);

      IsFound := FindNext(SR) = 0;
    end;
  finally
    FindClose(SR);
  end;
end;

end.
