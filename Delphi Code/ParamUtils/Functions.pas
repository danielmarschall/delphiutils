unit Functions;

interface

uses
  Windows, SysUtils;

type
  TDynStringArray = array of String;

procedure AppendStringToArray(var x: TDynStringArray; const s: string);

function ExtendFilename(s: string; AllowDirs: boolean): TDynStringArray;

implementation

procedure AppendStringToArray(var x: TDynStringArray; const s: string);
begin
  SetLength(x, Length(x)+1);
  x[Length(x)-1] := s;
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
      AppendStringToArray(result, s);

      IsFound := FindNext(SR) = 0;
    end;
  finally
    FindClose(SR);
  end;
end;

end.
