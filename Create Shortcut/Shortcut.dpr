program Shortcut;

{$APPTYPE CONSOLE}

uses
  SysUtils, ShlObj, ActiveX, ComObj, Windows;

// http://www.delphi-library.de/viewtopic.php?t=20516
function ExpandEnvStr(const szInput: string): string;
const
  MAXSIZE = 32768; // laut PSDK sind 32k das Maximum
begin
  SetLength(Result, MAXSIZE);
  SetLength(Result, ExpandEnvironmentStrings(pchar(szInput),
    @Result[1],length(Result))-1); //-1 um abschlieﬂendes #0 zu verwerfen
end;

var
  IObject : IUnknown;
  ISLink : IShellLink;
  IPFile : IPersistFile;
  TargetName : String;
  LinkName : WideString;

// Ref: http://delphi.about.com/od/windowsshellapi/a/create_lnk.htm
begin
  If ParamCount <> 2 then
  begin
    WriteLn('Usage: SHORTCUT.EXE <source> <dest>');
    WriteLn('');
  end
  else
  begin
    CoInitialize(nil);

    TargetName := ExpandEnvStr(ParamStr(1));

    IObject := CreateComObject(CLSID_ShellLink);
    ISLink := IObject as IShellLink;
    IPFile := IObject as IPersistFile;

    with ISLink do
    begin
      SetPath(pChar(TargetName)) ;
      SetWorkingDirectory(pChar(ExtractFilePath(TargetName))) ;
    end;

    LinkName := ExpandEnvStr(ParamStr(2));
    IPFile.Save(PWChar(LinkName), false);

    CoUninitialize;
  end;
end.
