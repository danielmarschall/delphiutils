program DosLineConv;

uses
  SysUtils,
  Classes,
  Dialogs,
  Windows,
  BinarySafeReplace in 'BinarySafeReplace.pas',
  PosEx in 'PosEx.pas';

{$R *.res}

var
  f: string;

const
  target_format = #13#10;

type
  EMoveError = class(Exception);

resourcestring
  lng_file_not_found = 'The file "%s" was not found!';
  lng_is_a_dir = 'MD5 checksum can only calculated for files.';
  lng_binary_error = 'File "%s" has binary contents! You should only edit ASCII files.';
  lng_syntax = 'Syntax: %s filename';
  lng_error = 'An error occoured! Probably the file can''t be overwritten.';

procedure NormalizeLineBreaks(f, seq: string);
var
  t: string;
begin
  t := f+'~'; // Zwischenschritte schonen die Originaldatei (z.B. bei Fehlern)
  DeleteFile(PChar(t));
  BinarySafeReplaceFileContents(f, t, #13#10, #13); // Windows format
  // BinarySafeReplaceFileContents(t, t, #10#13, #13);
  BinarySafeReplaceFileContents(t, t, #10, #13); // MAC format
  BinarySafeReplaceFileContents(t, t, #13, seq); // Linux format
  DeleteFile(PChar(f));
  if not MoveFile(PChar(t), PChar(f)) then
  begin
    DeleteFile(PChar(t));
    raise EMoveError.Create(lng_error);
  end;
end;

function IsBinaryFile(f: string): boolean;
var
  Stream: TStream;
  b: Byte;
begin
  result := false;
  Stream := TFileStream.Create(f, fmOpenRead);
  try
    while Stream.Read(b, SizeOf(b)) > 0 do
    begin
      if (b <= 31) and (b <> 9) and (b <> 10) and (b <> 13) then
      begin
        result := true;
        Exit;
      end;
    end;
  finally
    Stream.Free;
  end;
end;

var
  i: integer;

begin
  if ParamCount() < 1 then
  begin
    ShowMessageFmt(lng_syntax, [ExtractFileName(ParamStr(0))]);
    Exit;
  end;

  for i := 1 to ParamCount() do
  begin
    f := ParamStr(i);

    if DirectoryExists(f) then
    begin
      ShowMessage(lng_is_a_dir);
    end
    else
    begin
      if not FileExists(f) then
      begin
        ShowMessageFmt(lng_file_not_found, [f]);
      end
      else
      begin
        if IsBinaryFile(f) then
        begin
          ShowMessageFmt(lng_binary_error, [f]);
        end
        else
        begin
          try
            NormalizeLineBreaks(f, #13#10);
          except
            ShowMessage(lng_error);
          end;
        end;
      end;
    end;
  end;
end.
