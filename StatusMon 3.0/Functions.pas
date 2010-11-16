unit Functions;

interface

uses
  SysUtils, Windows, Messages, idHTTP, ShellAPI;

function GetDomainNameByURL(URL: string): string;
function ForceForegroundWindow(hwnd: THandle): Boolean;

procedure VTSUpdateCheck(abbreviation, thisversion: string;
  showNoNewUpdatesMsg, showErrorMsg: boolean);

implementation

function GetDomainNameByURL(URL: string): string;
var
  i: integer;
  j: integer;
  c: String;
const
  Delim = '/';
begin
  j := 0;
  for i := 1 to Length(URL) do
  begin
    c := Copy(URL, i, 1);

    if (j = 2) and (c <> Delim) then
    begin
      result := result + c;
    end
    else if j > 2 then break;

    if c = Delim then
    begin
      inc(j);
    end;
  end;
end;

// Ref: http://www.swissdelphicenter.ch/de/showcode.php?id=261

function ForceForegroundWindow(hwnd: THandle): Boolean;
const
  SPI_GETFOREGROUNDLOCKTIMEOUT = $2000;
  SPI_SETFOREGROUNDLOCKTIMEOUT = $2001;
var
  ForegroundThreadID: DWORD;
  ThisThreadID: DWORD;
  timeout: DWORD;
begin
  if IsIconic(hwnd) then ShowWindow(hwnd, SW_RESTORE);

  if GetForegroundWindow = hwnd then Result := True
  else
  begin
    // Windows 98/2000 doesn't want to foreground a window when some other
    // window has keyboard focus

    if ((Win32Platform = VER_PLATFORM_WIN32_NT) and (Win32MajorVersion > 4)) or
      ((Win32Platform = VER_PLATFORM_WIN32_WINDOWS) and
      ((Win32MajorVersion > 4) or ((Win32MajorVersion = 4) and
      (Win32MinorVersion > 0)))) then
    begin
      // Code from Karl E. Peterson, www.mvps.org/vb/sample.htm
      // Converted to Delphi by Ray Lischner
      // Published in The Delphi Magazine 55, page 16

      Result := False;
      ForegroundThreadID := GetWindowThreadProcessID(GetForegroundWindow, nil);
      ThisThreadID := GetWindowThreadPRocessId(hwnd, nil);
      if AttachThreadInput(ThisThreadID, ForegroundThreadID, True) then
      begin
        BringWindowToTop(hwnd); // IE 5.5 related hack
        SetForegroundWindow(hwnd);
        AttachThreadInput(ThisThreadID, ForegroundThreadID, False);
        Result := (GetForegroundWindow = hwnd);
      end;
      if not Result then
      begin
        // Code by Daniel P. Stasinski
        SystemParametersInfo(SPI_GETFOREGROUNDLOCKTIMEOUT, 0, @timeout, 0);
        SystemParametersInfo(SPI_SETFOREGROUNDLOCKTIMEOUT, 0, TObject(0),
          SPIF_SENDCHANGE);
        BringWindowToTop(hwnd); // IE 5.5 related hack
        SetForegroundWindow(hWnd);
        SystemParametersInfo(SPI_SETFOREGROUNDLOCKTIMEOUT, 0, TObject(timeout), SPIF_SENDCHANGE);
      end;
    end
    else
    begin
      BringWindowToTop(hwnd); // IE 5.5 related hack
      SetForegroundWindow(hwnd);
    end;

    Result := (GetForegroundWindow = hwnd);
  end;
end;

const
  Handle = 0; // Da wir außerhalb eines Forms sind...

procedure VTSUpdateCheck(abbreviation, thisversion: string;
  showNoNewUpdatesMsg, showErrorMsg: boolean);
resourcestring
  lng_no_new_version = 'Es ist keine neue Programmversion vorhanden.';
  lng_update_error = 'Ein Fehler ist aufgetreten. Wahrscheinlich ist keine Internetverbindung aufgebaut, oder der der ViaThinkSoft-Server temporär offline.';
  lng_caption_error = 'Fehler';
  lng_caption_information = 'Information';
  lng_update_new_version = 'Eine neue Programmversion (%s) ist vorhanden. Möchten Sie diese jetzt herunterladen?';
const
  url_comparison = 'http://www.viathinksoft.de/update/?id=%s&expect_version=%s';
  url_version = 'http://www.viathinksoft.de/update/?id=%s';
  url_download = 'http://www.viathinksoft.de/update/?id=@%s';
  res_nothing = 'NO_UPDATES';
  res_updates = 'UPDATE_AVAILABLE';
var
  temp: string;
  http: TIdHTTP;
begin
  temp := '';
  http := TIdHTTP.Create;
  try
    temp := http.Get(Format(url_comparison, [abbreviation, thisversion]));
  finally
    http.Free;
  end;

  if temp = res_nothing then
  begin
    if showNoNewUpdatesMsg then
    begin
      MessageBox(Handle, PChar(lng_no_new_version), PChar(lng_caption_information), MB_OK + MB_ICONASTERISK);
    end;
  end
  else if temp = res_updates then
  begin
    temp := '';
    http := TIdHTTP.Create;
    try
      temp := http.Get(Format(url_version, [abbreviation]));
    finally
      http.Free;
    end;

    if MessageBox(Handle, PChar(Format(lng_update_new_version, [temp])), PChar(lng_caption_information), MB_YESNO + MB_ICONASTERISK) = ID_YES then
    begin
      ShellExecute(Handle, 'open', pchar(Format(url_download, [abbreviation])), '', '', sw_normal);
    end;
  end
  else
  begin
    if showErrorMsg then
    begin
      MessageBox(Handle, PChar(lng_update_error), PChar(lng_caption_error), MB_OK + MB_ICONERROR)
    end;
  end;
end;

end.
