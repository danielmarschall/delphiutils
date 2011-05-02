program Example;

// Windows.pas START

type
  UINT = LongWord;
  HWND = type LongWord;

const
  MB_ICONASTERISK = $00000040;
{$IFDEF MSWINDOWS}
  user32    = 'user32.dll';
{$ENDIF}
{$IFDEF LINUX}
  user32    = 'libwine.borland.so';
{$ENDIF}

function MessageBox(hWnd: HWND; lpText, lpCaption: PChar; uType: UINT): Integer; stdcall; external user32 name 'MessageBoxA';

// Windows.pas END

begin
  MessageBox(0, 'ViaThinkSoft Example Application', 'Demo', MB_ICONASTERISK);
end.
