; StatusMon Setup Script for InnoSetup
; by Daniel Marschall

; http://www.daniel-marschall.de/

; ToDo:
; - For all users or only for me

[Setup]
AppName=StatusMon
AppVerName=StatusMon 3.0
AppVersion=3.0
AppCopyright=© Copyright 2010 ViaThinkSoft.
AppPublisher=ViaThinkSoft
AppPublisherURL=http://www.viathinksoft.de/
AppSupportURL=http://www.daniel-marschall.de/
AppUpdatesURL=http://www.viathinksoft.de/
DefaultDirName={pf}\ViaThinkSoft Status Monitor
DefaultGroupName=Status Monitor
VersionInfoCompany=ViaThinkSoft
VersionInfoCopyright=© Copyright 2010 ViaThinkSoft.
VersionInfoDescription=ViaThinkSoft Status Monitor Setup
VersionInfoTextVersion=1.0.0.0
VersionInfoVersion=3.0
Compression=zip/9

[Languages]
Name: de; MessagesFile: "compiler:Languages\German.isl"

[LangOptions]
LanguageName=Deutsch
LanguageID=$0407

[Tasks]
Name: "autostart"; Description: "Starte automatisch mit &Windows"; GroupDescription: "Programmverknüpfungen:"

[Files]
Source: "StatusMon.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "examples\*.*"; DestDir: "{app}\examples"
Source: "examples\joomla_version\*.*"; DestDir: "{app}\examples\joomla_version"
Source: "examples\phpbb3_version\*.*"; DestDir: "{app}\examples\phpbb3_version"
Source: "examples\verteiler\*.*"; DestDir: "{app}\examples\verteiler"
Source: "examples\positive_responder\*.*"; DestDir: "{app}\examples\positive_responder"

[Icons]
Name: "{group}\Webseiten\ViaThinkSoft"; Filename: "http://www.viathinksoft.de/"
Name: "{group}\Status Monitor"; Filename: "{app}\StatusMon.exe"
Name: "{group}\Status Monitor deinstallieren"; Filename: "{uninstallexe}"
Name: "{userstartup}\ViaThinkSoft Status Monitor"; Filename: "{app}\StatusMon.exe"; Tasks: autostart

[Run]
Filename: "{app}\StatusMon.exe"; Description: "Status Monitor starten"; Flags: nowait postinstall skipifsilent

[Code]
Const WM_QUIT = $0012;

function InitializeSetup(): Boolean;
var
  WinID: HWND;
begin
  // Doppelte Setup-Instant verhindern
  if CheckForMutexes('StatusMonSetup') then
  begin
    Result := False;
    Exit;
  end;
  Result := True;
  CreateMutex('StatusMonSetup');

  // Laufendes Programm beenden
  WinID := FindWindowByWindowName('ViaThinkSoft Status Monitor');
  if (WinID <> 0) then
  begin
    // Wir benötigen WM_QUIT, da WM_CLOSE in diesem Fall nur zum minimieren führt
    SendMessage(WinID, WM_QUIT, 0, 0);
  end
end;

