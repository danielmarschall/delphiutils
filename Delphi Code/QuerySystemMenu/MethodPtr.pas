unit MethodPtr;

// http://www.swissdelphicenter.ch/de/showcode.php?id=1671

interface

function MakeProcInstance(M: TMethod): Pointer;
procedure FreeProcInstance(ProcInstance: Pointer);

implementation

// type TMyMethod = procedure of object;

function MakeProcInstance(M: TMethod): Pointer;
begin
  // allocate memory
  GetMem(Result, 15);
  asm
    // MOV ECX,
    MOV BYTE PTR [EAX], $B9
    MOV ECX, M.Data
    MOV DWORD PTR [EAX+$1], ECX
    // POP EDX
    MOV BYTE PTR [EAX+$5], $5A
    // PUSH ECX
    MOV BYTE PTR [EAX+$6], $51
    // PUSH EDX
    MOV BYTE PTR [EAX+$7], $52
    // MOV ECX,
    MOV BYTE PTR [EAX+$8], $B9
    MOV ECX, M.Code
    MOV DWORD PTR [EAX+$9], ECX
    // JMP ECX
    MOV BYTE PTR [EAX+$D], $FF
    MOV BYTE PTR [EAX+$E], $E1
  end;
end;

procedure FreeProcInstance(ProcInstance: Pointer);
begin
  // free memory
  FreeMem(ProcInstance, 15);
end;

end.
