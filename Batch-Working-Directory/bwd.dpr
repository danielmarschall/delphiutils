program bwd;

{

Batch-Working-Directory
Executes a batch script and set the working directory to
the batch script's directory.

}

uses
  ShellAPI, SysUtils, Windows;

{$R *.res}

var
  i: integer;
  params: string;

begin
  if ParamCount() < 1 then
  begin
    WriteLn('Batch-Working-Directory');
    WriteLn('Executes a file and set the working directory to the file''s directory');
    WriteLn('');
    WriteLn('Syntax: bwd.exe application [params]');
  end
  else
  begin
    params := '';
    for i := 2 to ParamCount() - 1 do
    begin
      params := ParamStr(i);
    end;

    // ToDo: In Konsole einbetten?
    ShellExecute(0, 'open', PChar(ParamStr(1)), PChar(params), PChar(ExtractFilePath(ParamStr(1))), SW_NORMAL);
  end;
end.
