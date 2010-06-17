unit PosEx;

// © 1997-2005 by FNS Enterprize's™
//   2003-2005 by himitsu @ Delphi-PRAXiS

// http://www.delphipraxis.net/topic61002,0,asc,0.html

interface

Function _Pos       (Const SubStr, S: AnsiString): LongInt; overload;
Function _Pos       (Const SubStr, S: WideString): LongInt; overload;
Function _PosEx     (Const SubStr, S: AnsiString; Offset: LongInt = 1): LongInt; overload;
Function _PosEx     (Const SubStr, S: WideString; Offset: LongInt = 1): LongInt; overload;
Function CountString(Const SubStr, S: AnsiString): Word; overload;
Function CountString(Const SubStr, S: WideString): Word; overload;

implementation

Function _Pos(Const SubStr, S: AnsiString): LongInt;
  ASM 
    PUSH    ESI 
    PUSH    EDI 
    PUSH    EBX 
    TEST    &SubStr, &SubStr 
    JE      @Exit 
    TEST    &S, &S 
    JE      @Exit0 
    MOV     ESI, &SubStr
    MOV     EDI, &S 
    PUSH    EDI 
    MOV     ECX, [EDI - 4] 
    MOV     EDX, [ESI - 4] 
    DEC     EDX 
    JS      @Fail 
    MOV     AL, [ESI] 
    INC     ESI 
    SUB     ECX, EDX 
    JLE     @Fail 

    @Loop: 
    REPNE   SCASB 
    JNE     @Fail 
    MOV     EBX, ECX 
    PUSH    ESI 
    PUSH    EDI 
    MOV     ECX, EDX 
    REPE    CMPSB 
    POP     EDI 
    POP     ESI 
    JE      @Found 
    MOV     ECX, EBX 
    JMP     @Loop 

    @Fail: 
    POP     EDX

    @Exit0: 
    XOR     EAX, EAX 
    JMP     @Exit 

    @Found: 
    POP     EDX 
    MOV     EAX, EDI 
    SUB     EAX, EDX 

    @Exit: 
    POP     EBX 
    POP     EDI 
    POP     ESI 
  End; 

Function _Pos(Const SubStr, S: WideString): LongInt; 
  ASM 
    PUSH    ESI 
    PUSH    EDI 
    PUSH    EBX 
    TEST    &SubStr, &SubStr 
    JE      @Exit 
    TEST    &S, &S 
    JE      @Exit0 
    MOV     ESI, &SubStr 
    MOV     EDI, &S
    PUSH    EDI 
    MOV     ECX, [EDI - 4] 
    SAL     EAX, 1 
    MOV     EDX, [ESI - 4] 
    SAL     EDX, 1 
    DEC     EDX 
    JS      @Fail 
    MOV     AX, [ESI] 
    ADD     ESI, 2 
    SUB     ECX, EDX 
    JLE     @Fail 

    @Loop: 
    REPNE   SCASW 
    JNE     @Fail 
    MOV     EBX, ECX 
    PUSH    ESI 
    PUSH    EDI 
    MOV     ECX, EDX 
    REPE    CMPSW 
    POP     EDI 
    POP     ESI 
    JE      @Found 
    MOV     ECX, EBX 
    JMP     @Loop 

    @Fail:
    POP     EDX 

    @Exit0: 
    XOR     EAX, EAX 
    JMP     @Exit 

    @Found: 
    POP     EDX 
    MOV     EAX, EDI 
    SUB     EAX, EDX 
    SHR     EAX, 1 

    @Exit: 
    POP     EBX 
    POP     EDI 
    POP     ESI 
  End; 

Function _PosEx(Const SubStr, S: AnsiString; Offset: LongInt = 1): LongInt; 
  ASM 
    PUSH    ESI 
    PUSH    EDI 
    PUSH    EBX 
    TEST    &SubStr, &SubStr 
    JE      @Exit 
    TEST    &S, &S 
    JE      @Exit0
    TEST    &Offset, &Offset 
    JG      @POff 
    MOV     &Offset, 1 
    @POff: 
    MOV     ESI, &SubStr 
    MOV     EDI, &S 
    PUSH    EDI 
    MOV     EAX, &Offset 
    DEC     EAX 
    MOV     ECX, [EDI - 4] 
    MOV     EDX, [ESI - 4] 
    DEC     EDX 
    JS      @Fail 
    SUB     ECX, EAX 
    ADD     EDI, EAX 
    MOV     AL, [ESI] 
    INC     ESI 
    SUB     ECX, EDX 
    JLE     @Fail 

    @Loop: 
    REPNE   SCASB 
    JNE     @Fail 
    MOV     EBX, ECX 
    PUSH    ESI 
    PUSH    EDI 
    MOV     ECX, EDX
    REPE    CMPSB 
    POP     EDI 
    POP     ESI 
    JE      @Found 
    MOV     ECX, EBX 
    JMP     @Loop 

    @Fail: 
    POP     EDX 

    @Exit0: 
    XOR     EAX, EAX 
    JMP     @Exit 

    @Found: 
    POP     EDX 
    MOV     EAX, EDI 
    SUB     EAX, EDX 

    @Exit: 
    POP     EBX 
    POP     EDI 
    POP     ESI 
  End; 

Function _PosEx(Const SubStr, S: WideString; Offset: LongInt = 1): LongInt; 
  ASM
    PUSH    ESI 
    PUSH    EDI 
    PUSH    EBX 
    TEST    &SubStr, &SubStr 
    JE      @Exit 
    TEST    &S, &S 
    JE      @Exit0 
    TEST    &Offset, &Offset 
    JG      @POff 
    MOV     &Offset, 1 
    @POff: 
    MOV     ESI, &SubStr 
    MOV     EDI, &S 
    PUSH    EDI 
    PUSH    &Offset 
    MOV     ECX, [EDI - 4] 
    SAL     ECX, 1 
    MOV     EDX, [ESI - 4] 
    SAL     EDX, 1 
    POP     EAX 
    DEC     EAX 
    DEC     EDX 
    JS      @Fail 
    SUB     ECX, EAX 
    ADD     EDI, EAX 
    ADD     EDI, EAX 
    MOV     AX, [ESI]
    ADD     ESI, 2 
    SUB     ECX, EDX 
    JLE     @Fail 

    @Loop: 
    REPNE   SCASW 
    JNE     @Fail 
    MOV     EBX, ECX 
    PUSH    ESI 
    PUSH    EDI 
    MOV     ECX, EDX 
    REPE    CMPSW 
    POP     EDI 
    POP     ESI 
    JE      @Found 
    MOV     ECX, EBX 
    JMP     @Loop 

    @Fail: 
    POP     EDX 

    @Exit0: 
    XOR     EAX, EAX 
    JMP     @Exit 

    @Found: 
    POP     EDX
    MOV     EAX, EDI 
    SUB     EAX, EDX 
    SHR     EAX, 1 

    @Exit: 
    POP     EBX 
    POP     EDI 
    POP     ESI 
  End; 

Function CountString(Const SubStr, S: AnsiString): Word; 
  ASM 
    PUSH    ESI 
    PUSH    EDI 
    PUSH    EBX 
    TEST    &SubStr, &SubStr 
    JE      @Exit 
    TEST    &S, &S 
    JE      @Exit0 
    MOV     ESI, &SubStr 
    MOV     EDI, &S 
    PUSH    EDI 
    MOV     ECX, [EDI - 4] 
    MOV     EDX, [ESI - 4] 
    DEC     EDX 
    JS      @Fail 
    XOR     EAX, EAX
    MOV     AL, [ESI] 
    INC     ESI 
    SUB     ECX, EDX 
    JLE     @Fail 

    @Loop: 
    REPNE   SCASB 
    JNE     @Ready 
    MOV     EBX, ECX 
    PUSH    ESI 
    PUSH    EDI 
    MOV     ECX, EDX 
    REPE    CMPSB 
    POP     EDI 
    POP     ESI 
    JNE     @noInc 
    CMP     EAX, $FFFF0000 
    JAE     @Ready 
    ADD     EAX, $00010000 
    @noInc: 
    MOV     ECX, EBX 
    JMP     @Loop 

    @Fail: 
    POP     EDX 

    @Exit0:
    XOR     EAX, EAX 
    JMP     @Exit 

    @Ready: 
    POP     EDX 
    SHR     EAX, 16 

    @Exit: 
    POP     EBX 
    POP     EDI 
    POP     ESI 
  End; 

Function CountString(Const SubStr, S: WideString): Word; 
  ASM 
    PUSH    ESI 
    PUSH    EDI 
    PUSH    EBX 
    TEST    &SubStr, &SubStr 
    JE      @Exit 
    TEST    &S, &S 
    JE      @Exit0 
    MOV     ESI, &SubStr 
    MOV     EDI, &S 
    PUSH    EDI 
    MOV     ECX, [EDI - 4] 
    SAL     ECX, 1
    MOV     EDX, [ESI - 4] 
    SAL     EDX, 1 
    DEC     EDX 
    JS      @Fail 
    XOR     EAX, EAX 
    MOV     AX, [ESI] 
    ADD     ESI, 2 
    SUB     ECX, EDX 
    JLE     @Fail 

    @Loop: 
    REPNE   SCASW 
    JNE     @Ready 
    MOV     EBX, ECX 
    PUSH    ESI 
    PUSH    EDI 
    MOV     ECX, EDX 
    REPE    CMPSW 
    POP     EDI 
    POP     ESI 
    JNE     @noInc 
    CMP     EAX, $FFFF0000 
    JAE     @Ready 
    ADD     EAX, $00010000 
    @noInc: 
    MOV     ECX, EBX 
    JMP     @Loop

    @Fail: 
    POP     EDX 

    @Exit0:
    XOR     EAX, EAX 
    JMP     @Exit 

    @Ready: 
    POP     EDX 
    SHR     EAX, 16 

    @Exit: 
    POP     EBX
    POP     EDI
    POP     ESI
  End;

end.
