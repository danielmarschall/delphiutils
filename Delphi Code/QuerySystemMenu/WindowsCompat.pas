unit WindowsCompat;

// Ref: http://qc.embarcadero.com/wc/qcmain.aspx?d=48771

interface

uses
  Windows;

{$IF NOT DECLARED(GWLP_WNDPROC)}
const
  GWLP_WNDPROC = -4;
{$IFEND}

{$IF NOT DECLARED(PtrInt)}
type
  {$IFDEF WIN32}
  PtrInt = Longint;
  {$ELSE}
  PtrInt = Int64;
  {$ENDIF}
{$IFEND}

{$IF NOT DECLARED(LONG_PTR)}
type
  LONG_PTR = PtrInt; // Offizielle Deklaration?
{$IFEND}

{$IF NOT DECLARED(WNDPROC)}
type
  WNDPROC = TFNWndProc; // Offizielle Deklaration?
{$IFeND}

{$IF NOT DECLARED(GetWindowLongPtr)}
  {$DEFINE Do_Implement_GetWindowLongPtr}
  function GetWindowLongPtr(hWnd: HWND; nIndex: Integer): LONG_PTR; stdcall;
{$IFEND}

{$IF NOT DECLARED(SetWindowLongPtr)}
  {$DEFINE Do_Implement_SetWindowLongPtr}
  function SetWindowLongPtr(hWnd: HWND; nIndex: Integer; dwNewLong: LONG_PTR): LONG_PTR; stdcall;
{$IFEND}

implementation

{$IFDEF Do_Implement_GetWindowLongPtr}
  {$IFNDEF _WIN64}
    {$IFDEF UNICODE}
      function GetWindowLongPtr; external user32 name 'GetWindowLongW';
    {$ELSE}
      function GetWindowLongPtr; external user32 name 'GetWindowLongA';
    {$ENDIF}
  {$ELSE}
    {$IFDEF UNICODE}
      function GetWindowLongPtr; external user32 name 'GetWindowLongPtrW';
    {$ELSE}
      function GetWindowLongPtr; external user32 name 'GetWindowLongPtrA';
    {$ENDIF}
  {$ENDIF}
{$ENDIF}

{$IFDEF Do_Implement_SetWindowLongPtr}
  {$IFNDEF _WIN64}
    {$IFDEF UNICODE}
      function SetWindowLongPtr; external user32 name 'SetWindowLongW';
    {$ELSE}
      function SetWindowLongPtr; external user32 name 'SetWindowLongA';
    {$ENDIF}
  {$ELSE}
    {$IFDEF UNICODE}
      function SetWindowLongPtr; external user32 name 'SetWindowLongPtrW';
    {$ELSE}
      function SetWindowLongPtr; external user32 name 'SetWindowLongPtrA';
    {$ENDIF}
  {$ENDIF}
{$ENDIF}

end.
