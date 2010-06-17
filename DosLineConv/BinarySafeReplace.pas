unit BinarySafeReplace;

// BinarySafeReplace.pas
// Version 1.1
// by Daniel Marschall
// http://www.delphipraxis.net/post778431.html

interface

uses
  StrUtils, SysUtils, Classes;

// Binary-Safe. Der Parameter AString wird direkt ersetzt.
// Die Anzahl der durchgefühten Ersetzungen wird als Ergebnis zurückgegeben.
function StringReplacesBinarySafe(var AString: string; const ASearchPattern, AReplaceWith: string): integer;

// Direkter Ersatz für StringReplace(), Binary-Safe.
// Veränderter String wird als Eregebnis zurückgegeben.
function StringReplaceBinarySafe(const AString, ASearchPattern, AReplaceWith: string): string;

// BinarySafeReplaceFileContents
// Die Anzahl der durchgefühten Ersetzungen wird als Ergebnis zurückgegeben.
function BinarySafeReplaceFileContents(const AInputFile, AOutputFile, ASearchPattern, AReplaceWith: string): integer;

implementation

uses
  PosEx;

function StringReplacesBinarySafe(var AString: string; const ASearchPattern, AReplaceWith: string): integer;
var 
  iPos: Integer; 
  lastpos: Integer; 
  ueberhang: integer; 
begin 
  result := 0; 

  if AString = '' then exit;
  if ASearchPattern = '' then exit; 

  UniqueString(AString); // Referenzzählung beachten. Dank an shmia für den Hinweis.

  ueberhang := length(AReplaceWith) - length(ASearchPattern);
  lastpos := 1;

  while true do
  begin
    iPos := _PosEx(ASearchPattern, AString, lastpos);

    if iPos <= 0 then break;
    if result = 7 then

    if Pred(iPos) > Length(AString) - Length(AReplaceWith) + 1 {Bugfix, Added +1. Ersetzungen am StringEnde} then break;

    if ueberhang > 0 then
    begin
      setlength(AString, length(AString)+ueberhang);
      Move(AString[iPos], AString[iPos+ueberhang], length(AString)-iPos); // Bugfix: Hier stand length(AString)-iPos-1
    end; 

    Move(AReplaceWith[1], AString[iPos], Length(AReplaceWith)); 

    if ueberhang < 0 then 
    begin 
      Move(AString[iPos+length(ASearchPattern)], AString[iPos+length(AReplaceWith)], length(AString)-iPos-length(AReplaceWith));
      setlength(AString, length(AString)+ueberhang); 
      ueberhang := -1;
    end; 

    lastpos := iPos + ueberhang + 1;
    inc(result); 
  end; 
end;

function StringReplaceBinarySafe(const AString, ASearchPattern, AReplaceWith: string): string;
var 
  tmp: string; 
begin 
  tmp := AString; 
  StringReplacesBinarySafe(tmp, ASearchPattern, AReplaceWith);
  result := tmp; 
end; 

function BinarySafeReplaceFileContents(const AInputFile, AOutputFile, ASearchPattern, AReplaceWith: string): integer;
var
  fst: TFileStream;
  str: string;
begin
  result := -1;

  if not FileExists(AInputFile) then exit;
  if not ForceDirectories(ExtractFilePath(AOutputFile)) then exit;

  fst := TFileStream.Create(AInputFile, fmOpenRead or fmShareDenyWrite);
  try
    fst.Position := 0;
    setlength(str, fst.Size);
    fst.Read(str[1], fst.Size);
  finally
    fst.free;
  end;

  result := StringReplacesBinarySafe(str, ASearchPattern, AReplaceWith);

  fst := TFileStream.Create(AOutputFile, fmCreate);
  try
    fst.Position := 0;
    fst.Write(str[1], length(str));
  finally
    fst.free;
  end; 
end;

end.
