;;DIRECCIONES DE RAM PENDIENTES DE DETERMINAR Y QUE SE ENVíAN POR EL PUERTO 007F
;;0x87BB = ?? Esta dirección es importante, es la primera que se consulta en cada interrupción!
;;0x8739 = ??
;;0x874A = ??
;;0x8749 = ??
;;0x8746 = ??
;;0x874E = ??
;;0x874F = ??
;;0x874D = ??
;;0x8745 = ??
;;255h = rutina del teclado
;;0x21E0 = la de carga de cabecera
;;0x2237 = carga del programa
;;0x253F = rutina de salvado de la cabecera
;;0x219B = salvado de los datos
;;0x87b7 = keybuffer
;;8008h  scr_buf      730h = (1840d) = 40d(columnas?) * 23d(filas?) * 02d(attr+char)
;;87cah  current attr
;;87cbh  current char
;;874eh  current pos (Y,X)
;;8750h  ???????  direccion del primer caracter de la fila
;;87b0h  sonido?
;;87b7h  buffer teclado
;;bffeh  stack
;;
;;
;;1ff0h  get location (Y,X) address routine
;;2004h  print char routine
;;212dh  sync routine
;;
;;; ofsset row n screen bytes
;;3158h  db 8008h      row 00
;;315ah  db 8058h      row 01
;;315ch  db 80a8h      row 02
;;315eh  db 80f8h      row 03
;;3160h  db 8148h      row 04
;;3162h  db 8198h      row 05
;;3164h  db 81e8h      row 06
;;3166h  db 8238h      row 07
;;3168h  db 8288h      row 08
;;316ah  db 82d8h      row 09
;;316ch  db 8328h      row 10
;;316eh  db 8378h      row 11
;;3170h  db 83c8h      row 12
;;3172h  db 8418h      row 13
;;3174h  db 8468h      row 14
;;3176h  db 84b8h      row 15
;;3178h  db 8508h      row 16
;;317ah  db 8558h      row 17
;;317ch  db 85a8h      row 18
;;317eh  db 85f8h      row 19
;;3180h  db 8648h      row 20
;;3182h  db 8698h      row 21
;;3184h  db 86e8h      row 22
;;3186h  db 8738h      row 23


        ORG     0000h

        ; Entry Point
        ; --- START PROC L0000 ---
L0000:  JP      Inicializacion

L0003:  DB      37h             ; '7'
        DB      15h
        DB      0E4h
        DB      19h
        DB      00h
        DB      7Eh             ; '~'
        DB      0E3h
        DB      0BEh
        DB      23h             ; '#'
        DB      0E3h
        DB      0C2h
        DB      5Ah             ; 'Z'
        DB      12h
        DB      23h             ; '#'
        DB      7Eh             ; '~'
        DB      0FEh
        DB      3Ah             ; ':'
        DB      0D0h
        DB      0C3h
        DB      24h             ; '$'
        DB      15h
        DB      0C3h
        DB      09h
        DB      0Fh
        DB      00h
        DB      00h
        DB      00h
        DB      00h
        DB      00h
        DB      7Ch             ; '|'
        DB      92h
        DB      0C0h
        DB      7Dh             ; '}'
        DB      93h
        DB      0C9h
        DB      00h
        DB      00h

        ; --- START PROC L0028 ---
L0028:  LD      A,(88AEh)
        OR      A
        JP      NZ,L053F
        RET

L0030:  DB      0C3h
        DB      0A5h
        DB      1Dh
        DB      00h
        DB      00h
        DB      00h
        DB      00h
        DB      00h

        ; Entry Point
        ; --- START PROC Vector_Interrupcion ---
Vector_Interrupcion:
		EX      AF,AF'			; Intercambio con los registros alternativos
        EXX
        LD      A,(87BBh)		; Carga en A la dirección RAM 87BB
        OUT     (7Fh),A         ; Y lo envía al puerto 7F
        AND     A		
        JP      Z,Fin_Interrupcion			; Si A es cero salta a Fin_Interrupcion
        LD      C,7Fh           ; Si no, carga C con 7F
        CP      0C0h			;
        JP      Z,L011C			; Si A es 0C salta a L011C
        BIT     1,A				; En caso contrario empieza a comparar A a nivel de bits
        JP      NZ,L0226		; Si el bit 1 está encendido, salta a L0226
        BIT     2,A
        JP      NZ,L0078		; Si el bit 2 está encendido, salta a L0078
        BIT     3,A
        JP      NZ,L01EF		; Si el bit 3 está encendido, salta a L01EF
        BIT     4,A
        JP      NZ,L0078		; Si el bit 4 está encendido, salta a L0078
        BIT     5,A
        JP      NZ,L00C5		; Si el bit 5 está encendido, salta a L00C5
        BIT     6,A
        JP      Z,Bit6_OFF		; Si el bit 6 está apagado, salta a Bit6_OFF
        BIT     7,A
        JP      Z,L00D8			; Si el bit 7 está apagado, salta a L00D8
        JP      L011C			; En caso contrario, salta a L011C

Bit6_OFF:
		BIT     7,A
        JP      NZ,Bit7ON_Bit6OFF; Si el bit 7 está encendido y 6 está apagado salta a Bit7ON_Bit6OFF
        JP      L024D			; Si ambos bits 6 y 7 están apagados salta a L024D

L0078:  LD      HL,(873Fh)		; Carga en HL el valor de 16 bits apuntado en RAM 873F
Primer_Loop:
		LD      B,(HL)			; Carga en B el valor que apunta HL
L007C:  IN      A,(0BFh)		; Este bucle se repite mientras no se reciba por...
        RRCA					; ...el puerto 00BF un valor con...
        JP      NC,L007C		; ...el bit 0 encendido.
        OUTI					; Se copia de la dirección apuntada por HL al puerto BC e incrementa HL
        INC     B				; OUTI disminuye B, pero esta instrucción lo deja como está
        JP      Z,L024D			; Si B es cero salta a L024D
L0088:  IN      A,(0BFh)		; Este bucle se repite mientras no se reciba por...
        RRCA					; ...el puerto 00BF un valor con...
        JP      NC,L0088		; ...el bit 0 encendido.
        OUTI					; Se copia de la dirección apuntada por HL al puerto BC e incrementa HL
        INC     B				; OUTI disminuye B, pero esta instrucción lo deja como está
L0091:  IN      A,(0BFh)		; Este bucle se repite mientras no se reciba por...
        RRCA					; ...el puerto 00BF un valor con...
        JP      NC,L0091		; ...el bit 0 encendido.
        LD      A,40h           ; 
        OUT     (7Fh),A         ; Se envía el valor 0x40 al puerto 007F
L009B:  IN      A,(0BFh)		; Este bucle se repite mientras no se reciba por...
        RRCA					; ...el puerto 00BF un valor con...
        JP      NC,L009B		; ...el bit 0 encendido.
        OUTI					; Se copia de la dirección apuntada por HL al puerto BC e incrementa HL
        INC     B				; OUTI disminuye B, pero esta instrucción lo deja como está
L00A4:  IN      A,(0BFh)		; Otro bucle de espera del puerto
        RRCA
        JP      NC,L00A4
        LD      A,20h           ; ' '
        OUT     (7Fh),A         ; Se envía al puerto 007F el valor 0x20 (Puede ser Espacio en blanco???)
Ultimo_Loop:
		IN      A,(0BFh)		; Otro bucle de espera del puerto
        RRCA
        JP      NC,Ultimo_Loop
        OUTI					; Se copia de la dirección apuntada por HL al puerto BC e incrementa HL
        INC     B				; OUTI disminuye B, pero esta instrucción lo deja como está
L00B7:  IN      A,(0BFh)		; Otro bucle de espera del puerto
        RRCA
        JP      NC,L00B7
        OUTI					; Se copia de la dirección apuntada por HL al puerto BC e incrementa HL
        JP      NZ,Ultimo_Loop	; Si después de la rotación, A sigue sin ser 0 se repite el último loop
        JP      Primer_Loop		; Si A es 0 se repite todo el ciclo

L00C5:  LD      B,0EAh			; Se carga B con 0xEA, C viene de arriba con el valor 7F
        LD      HL,(8739h)		; Carga en HL el valor de 16 bits almacenado en RAM 8739
Loop_Corto:
		IN      A,(0BFh)		; Otro bucle de espera del puerto
        RRCA
        JP      NC,Loop_Corto
        OUTI					; Se copia de la dirección apuntada por HL al puerto BC (EA7F) e incrementa HL
        JP      NZ,Loop_Corto	; Mientras A no valga 0 se repite este bucle
        JP      L024D

L00D8:  LD      HL,(873Dh)		; Carga en HL el valor de 16 bits almacenado en RAM 873D
L00DB:  IN      A,(0BFh)		; Otro bucle de espera del puerto
        RRCA
        JP      NC,L00DB
        LD      A,(874Ah)
        OUT     (7Fh),A         ; Se envía al puerto 007F el valor almacenado en RAM 874A
L00E6:  IN      A,(0BFh)		; Otro bucle de espera del puerto 0BFh
        RRCA
        JP      NC,L00E6
        LD      A,(8749h)
        OUT     (7Fh),A         ; Envía al puerto 007F el valor almacenado en RAM 8749
        LD      D,A				; Se copia dicho valor de RAM en D (para usarlo como contador)
Loop_D_veces:
		LD      B,50h           ; Carga B con el valor 0x50
L00F4:  IN      A,(0BFh)		; Otro bucle de espera del puerto
        RRCA
        JP      NC,L00F4
        OUTI					; Copia de la dirección apuntada por HL al puerto BC (507F) e incrementa HL
        JP      NZ,L00F4		; Este bucle se repite mientras B no valga 0
        DEC     D				; Se disminuye D...
        JP      NZ,Loop_D_veces	; ... y mientras D no valga 0 se repite todo el bucle
L0103:  IN      A,(0BFh)		; Otro bucle de espera del puerto 0BFh
        RRCA
        JP      NC,L0103		
        LD      A,(8746h)		; Envía al puerto 007F el valor almacenado en RAM 8746
        OUT     (7Fh),A         
L010E:  IN      A,(0BFh)		; Otro bucle de espera del puerto
        RRCA
        JP      NC,L010E
        LD      A,(8748h)		; Envía al puerto 007F el valor almacenado en RAM 8748
        OUT     (7Fh),A         ; ''
        JP      L024D

L011C:  LD      HL,(8750h)		; Carga HL con el valor de 16 bits almacenado en RAM 8750...
        JP      Loop_Largo			; ...y se salta las siguientes 5 instrucciones

L0122:  IN      A,(0BFh)		; Otro bucle de espera del puerto 0BFh
        RRCA
        JP      NC,L0122
        INC     HL				; Incrementa HL
        OUTI					; Copia de la dirección apuntada por HL al puerto BC e incrementa HL
Loop_Largo:
		IN      A,(0BFh)		; Otro bucle de espera del puerto 0BFh
        RRCA
        JP      NC,Loop_Largo
        LD      A,(HL)			; Carga en A el contenido de RAM apuntado por HL
        OUT     (C),A			; Lo manda al puerto 7F
        BIT     7,A				; Si el bit 7 de A es cero
        JP      Z,L0122			; repite el bucle anterior
        AND     60h             ; En caso contrario comprueba los bits 6 y 5
        JP      NZ,L0122		; Si está encendido alguno de ellos, repite también el bucle anterior
        LD      A,18h			; En caso contrario comprueba los bits 4 y 3
        AND     (HL)
        JP      Z,L0122			; Si ninguno está encendido, repite también el bucle anterior
        BIT     3,(HL)
        JP      Z,L024D			; Continúa comprobando por separado el bit 3 y salta a L024D si es cero
        BIT     4,(HL)
        JP      Z,L0162			; En caso contrario, salta a L0162 si el bit 4 es cero
L014E:  IN      A,(0BFh)		; Otro bucle de espera del puerto 0BFh
        RRCA
        JP      NC,L014E
        INC     HL				; Incrementa HL
        OUTI					; Copia de la dirección apuntada por HL al puerto BC e incrementa HL
L0157:  IN      A,(0BFh)		; Otro bucle de espera del puerto 0BFh
        RRCA
        JP      NC,L0157
        OUTI					; Copia de la dirección apuntada por HL al puerto BC e incrementa HL
        JP      Loop_Largo		; Repite el bucle

L0162:  BIT     0,(HL)			; Si el bit 4 es cero, continúa por aquí
        JP      NZ,L0186		; Comprueba el bit 0 y salta a L0186 si está activado
        BIT     2,(HL)
        JP      NZ,L0195		; En caso contrario, salta a L0195 si el bit 2 está activado
L016C:  IN      A,(0BFh)		; Otro bucle de espera del puerto 0BFh
        RRCA
        JP      NC,L016C
        LD      A,(874Eh)		; Carga en A el valor de la RAM 874E
        OUT     (C),A			; Lo envía al puerto 7F
L0177:  IN      A,(0BFh)		; Otro bucle de espera del puerto 0BFh
        RRCA
        JP      NC,L0177
        LD      A,(874Fh)		; Envía al puerto 7F el contenido de RAM 874F
        OUT     (C),A
        INC     HL				; Incrementa HL
		JP      Loop_Largo		; Repite todo el bucle

L0186:  IN      A,(0BFh)		; Si el bit 0 está activado, continúa por aquí
        RRCA					; Otro bucle de espera del puerto 0BFh
        JP      NC,L0186
        LD      A,(874Dh)		; Envía al puerto 7F el contenido de RAM 874D
        OUT     (C),A
        INC     HL				; Incrementa HL
		JP      Loop_Largo		; Repite todo el bucle

L0195:  IN      A,(0BFh)		; Si el bit 2 está activado, continúa por aquí
        RRCA					; Otro bucle de espera del puerto 0BFh
        JP      NC,L0195
        LD      A,(8746h)
        OUT     (7Fh),A         ; Envía al puerto 7F el contenido de RAM 8746
L01A0:  IN      A,(0BFh)		; Otro bucle de espera del puerto 0BFh
        RRCA
        JP      NC,L01A0
        LD      A,(8748h)		; Envía al puerto 7F el contenido de RAM 8748
        OUT     (7Fh),A         
        INC     HL				; Incrementa HL
        JP      Loop_Largo		; Repite todo el bucle

Bit7ON_Bit6OFF:
		IN      A,(0BFh)		; Otro bucle de espera del puerto 0BFh
        RRCA
        JP      NC,Bit7ON_Bit6OFF
        LD      A,(8745h)		; Copia en A el contenido de RAM 8745
        OUT     (7Fh),A         ; Envía al puerto 7F dicho contenido
        LD      D,A				; Y lo copia en D
        AND     D
        JP      Z,L01C5			; 
        LD      HL,(8741h)		; Si no es 0, copia 10xD bytes desde RAM 8741 al puerto 7F
        CALL    Out_10xD_veces
L01C5:  IN      A,(0BFh)		; Otro bucle de espera del puerto 0BFh
        RRCA
        JP      NC,L01C5
        LD      A,(8747h)		; Si el contenido de 8745 contenido es 0...
        OUT     (7Fh),A         ; envía el contenido de RAM 8747 al puerto 7F
        LD      D,A
        AND     D
        JP      Z,L024D			; Si el contenido de RAM 8747 es 0, salta a L024D
        LD      HL,(8743h)		; En caso contrario, copia 10xD bytes desde RAM 8743 al puerto 7F
        CALL    Out_10xD_veces
        JP      L024D			; y salta a L204D

        ; --- START PROC Out_10xD_veces ---
Out_10xD_veces:
		LD      B,0Ah			; Carga B como contador con valor 10
L01E0:  IN      A,(0BFh)		; Otro bucle de espera del puerto 0BFh
        RRCA
        JP      NC,L01E0
        OUTI					; Copia de la dirección apuntada por HL al puerto BC (7F) e incrementa HL
        JP      NZ,L01E0		; Si B es cero, repite el bucle
        DEC     D				; Disminuye D
        JR      NZ,Out_10xD_veces; Si D es no cero, repite toda la subrutina
        RET

        ; --- START PROC L01EF ---
L01EF:  LD      HL,(874Bh)
L01F2:  IN      A,(0BFh)
        RRCA
        JP      NC,L01F2
        LD      A,(HL)
        OUT     (7Fh),A         ; ''
        LD      D,A
        AND     D
        JP      Z,L024D
        INC     HL
L0201:  IN      A,(0BFh)
        RRCA
        JP      NC,L0201
        OUTI
L0209:  IN      A,(0BFh)
        RRCA
        JP      NC,L0209
        OUTI
L0211:  LD      E,0Ah
L0213:  IN      A,(0BFh)
        RRCA
        JP      NC,L0213
        OUTI
        DEC     E
        JP      NZ,L0213
        DEC     D
        JP      NZ,L0211
        JP      L01F2

        ; --- START PROC L0226 ---
L0226:  LD      HL,(873Bh)
L0229:  LD      B,(HL)
L022A:  IN      A,(0BFh)
        RRCA
        JP      NC,L022A
        OUTI
        INC     B
        JP      Z,L024D
L0236:  IN      A,(0BFh)
        RRCA
        JP      NC,L0236
        OUTI
        INC     B
L023F:  IN      A,(0BFh)
        RRCA
        JP      NC,L023F
        OUTI
        JP      NZ,L023F
        JP      L0229

        ; --- START PROC L024D ---
L024D:  LD      A,(87BBh)
        BIT     0,A
        JP      Z,Fin_Interrupcion
        LD      HL,87B1h
        LD      B,0Ah
L025A:  IN      A,(0BFh)
        RRCA
        JP      NC,L025A
        LD      A,(87B0h)
        OUT     (7Fh),A         ; ''
L0265:  IN      A,(0BFh)
        RRCA
        JP      NC,L0265
L026B:  OUT     (7Fh),A         ; ''
L026D:  IN      A,(0BFh)
        RRCA
        JP      NC,L026D
        INI
        JP      NZ,L026B
        LD      HL,87B0h
        RES     7,(HL)
        ; --- START PROC Fin_Interrupcion ---
Fin_Interrupcion:
		IN      A,(0BFh)
        RRCA
        JP      NC,Fin_Interrupcion
        XOR     A
        OUT     (7Fh),A         ; ''
        LD      HL,87BDh
        INC     (HL)
        EXX
        EX      AF,AF'
        EI
        CALL    87DDh
        RET

        ; --- START PROC L0291 ---
L0291:  PUSH    AF
        LD      A,0FFh
        OUT     (7Fh),A         ; ''
L0296:  SLA     A
        JP      NZ,L0296
        POP     AF
        RET

        ; --- START PROC L029D ---
L029D:  PUSH    AF
        LD      A,00h
        OUT     (7Fh),A         ; ''
        POP     AF
        RET

        ; --- START PROC L02A4 ---
L02A4:  LD      HL,07ABh
        CALL    L0585
        JR      L02B5

L02AC:  DB      0CDh
        DB      85h
        DB      05h
        DB      21h             ; '!'
        DB      0C1h
        DB      0D1h
        DB      0CDh
        DB      5Fh             ; '_'
        DB      05h

        ; --- START PROC L02B5 ---
L02B5:  LD      A,B
        OR      A
        RET     Z
        LD      A,(88AEh)
        OR      A
        JP      Z,L0577
        SUB     B
        JR      NC,L02CE
        CPL
        INC     A
        EX      DE,HL
        CALL    L0567
        EX      DE,HL
        CALL    L0577
        POP     BC
        POP     DE
L02CE:  CP      19h
        RET     NC
        PUSH    AF
        CALL    L059A
        LD      H,A
        POP     AF
        CALL    L0384
        LD      A,H
        OR      A
        LD      HL,88ABh
        JP      P,L02F3
        CALL    L0364
        JR      NC,L0345
        INC     HL
        INC     (HL)
        JP      Z,L1269
        LD      L,01h
        CALL    L03A6
        JR      L0345

L02F3:  XOR     A
        SUB     B
        LD      B,A
        LD      A,(HL)
        SBC     A,E
        LD      E,A
        INC     HL
        LD      A,(HL)
        SBC     A,D
        LD      D,A
        INC     HL
        LD      A,(HL)
        SBC     A,C
        LD      C,A
        ; --- START PROC L0301 ---
L0301:  CALL    C,L0370
        LD      L,B
        LD      H,E
        XOR     A
L0307:  LD      B,A
        LD      A,C
        OR      A
        JR      NZ,L0333
        LD      C,D
        LD      D,H
        LD      H,L
        LD      L,A
        LD      A,B
        SUB     08h
        CP      0E0h
        JR      NZ,L0307
        ; --- START PROC L0317 ---
L0317:  XOR     A
        LD      (88AEh),A
        RET

        ; --- START PROC L031C ---
L031C:  LD      A,H
        OR      L
        OR      D
        JR      NZ,L032B
        LD      A,C
L0322:  DEC     B
        RLA
        JR      NC,L0322
        INC     B
        RRA
        LD      C,A
        JR      L0336

L032B:  DEC     B
        ADD     HL,HL
        LD      A,D
        RLA
        LD      D,A
        LD      A,C
        ADC     A,A
        LD      C,A
        ; --- START PROC L0333 ---
L0333:  JP      P,L031C
        ; --- START PROC L0336 ---
L0336:  LD      A,B
        LD      E,H
        LD      B,L
        OR      A
        JR      Z,L0345
        LD      HL,88AEh
        ADD     A,(HL)
        LD      (HL),A
        JR      NC,L0317
        JR      Z,L0317
        ; --- START PROC L0345 ---
L0345:  LD      A,B
        ; --- START PROC L0346 ---
L0346:  LD      HL,88AEh
        OR      A
        CALL    M,L0357
        LD      B,(HL)
        INC     HL
        LD      A,(HL)
        AND     80h
        XOR     C
        LD      C,A
        JP      L0577

        ; --- START PROC L0357 ---
L0357:  INC     E
        RET     NZ
        INC     D
        RET     NZ
        INC     C
        RET     NZ
        LD      C,80h
        INC     (HL)
        RET     NZ
        JP      L1269

        ; --- START PROC L0364 ---
L0364:  LD      A,(HL)
        ADD     A,E
        LD      E,A
        INC     HL
        LD      A,(HL)
        ADC     A,D
        LD      D,A
        INC     HL
        LD      A,(HL)
        ADC     A,C
        LD      C,A
        RET

        ; --- START PROC L0370 ---
L0370:  LD      HL,88AFh
        LD      A,(HL)
        CPL
        LD      (HL),A
        XOR     A
        LD      L,A
        SUB     B
        LD      B,A
        LD      A,L
        SBC     A,E
        LD      E,A
        LD      A,L
        SBC     A,D
        LD      D,A
        LD      A,L
        SBC     A,C
        LD      C,A
        RET

        ; --- START PROC L0384 ---
L0384:  LD      B,00h
L0386:  SUB     08h
        JR      C,L0391
        LD      B,E
        LD      E,D
        LD      D,C
        LD      C,00h
        JR      L0386

L0391:  ADD     A,09h
        LD      L,A
        LD      A,D
        OR      E
        OR      B
        JR      NZ,L03A2
        LD      A,C
L039A:  DEC     L
        RET     Z
        RRA
        LD      C,A
        JR      NC,L039A
        JR      L03A8

        ; --- START PROC L03A2 ---
L03A2:  XOR     A
        DEC     L
        RET     Z
        LD      A,C
        ; --- START PROC L03A6 ---
L03A6:  RRA
        LD      C,A
        ; --- START PROC L03A8 ---
L03A8:  LD      A,D
        RRA
        LD      D,A
        LD      A,E
        RRA
        LD      E,A
        LD      A,B
        RRA
        LD      B,A
        JR      L03A2

L03B3:  DB      00h
        DB      00h
        DB      00h
        DB      81h
        DB      04h
        DB      9Ah
        DB      0F7h
        DB      19h
        DB      83h
        DB      24h             ; '$'
        DB      63h             ; 'c'
        DB      43h             ; 'C'
        DB      83h
        DB      75h             ; 'u'
        DB      0CDh
        DB      8Dh
        DB      84h
        DB      0A9h
        DB      7Fh
        DB      83h
        DB      82h
        DB      04h
        DB      00h
        DB      00h
        DB      00h
        DB      81h
        DB      0E2h
        DB      0B0h
        DB      4Dh             ; 'M'
        DB      83h
        DB      0Ah
        DB      72h             ; 'r'
        DB      11h
        DB      83h
        DB      0F4h
        DB      04h
        DB      35h             ; '5'
        DB      7Fh
        DB      0EFh
        DB      0B7h
        DB      0EAh
        DB      4Ch             ; 'L'
        DB      15h
        DB      0CDh
        DB      0E9h
        DB      03h
        DB      01h
        DB      31h             ; '1'
        DB      80h
        DB      11h
        DB      18h
        DB      72h             ; 'r'
        DB      18h
        DB      36h             ; '6'
        DB      0CDh
        DB      82h
        DB      05h
        DB      3Eh             ; '>'
        DB      80h
        DB      32h             ; '2'
        DB      0AEh
        DB      88h
        DB      0A8h
        DB      0F5h
        DB      0CDh
        DB      67h             ; 'g'
        DB      05h
        DB      21h             ; '!'
        DB      0B7h
        DB      03h
        DB      0CDh
        DB      9Ah
        DB      08h
        DB      0C1h
        DB      0E1h
        DB      0CDh
        DB      67h             ; 'g'
        DB      05h
        DB      0EBh
        DB      0CDh
        DB      77h             ; 'w'
        DB      05h
        DB      21h             ; '!'
        DB      0C8h
        DB      03h
        DB      0CDh
        DB      9Ah
        DB      08h
        DB      0C1h
        DB      0D1h
        DB      0CDh
        DB      83h
        DB      04h
        DB      0F1h
        DB      0CDh
        DB      67h             ; 'g'
        DB      05h
        DB      0CDh
        DB      4Ah             ; 'J'
        DB      05h
        DB      0C1h
        DB      0D1h
        DB      0C3h
        DB      0B5h
        DB      02h
        DB      21h             ; '!'
        DB      0C1h
        DB      0D1h
        DB      0EFh
        DB      0C8h
        DB      2Eh             ; '.'
        DB      00h
        DB      0CDh
        DB      00h
        DB      05h
        DB      79h             ; 'y'
        DB      32h             ; '2'
        DB      0BDh
        DB      88h
        DB      0EBh
        DB      22h             ; '"'
        DB      0BEh
        DB      88h
        DB      01h
        DB      00h
        DB      00h
        DB      50h             ; 'P'
        DB      58h             ; 'X'
        DB      21h             ; '!'
        DB      04h
        DB      03h
        DB      0E5h
        DB      21h             ; '!'
        DB      3Fh             ; '?'
        DB      04h
        DB      0E5h
        DB      0E5h
        DB      21h             ; '!'
        DB      0ABh
        DB      88h
        DB      7Eh             ; '~'
        DB      23h             ; '#'
        DB      0B7h
        DB      28h             ; '('
        DB      2Ch             ; ','
        DB      0E5h
        DB      2Eh             ; '.'
        DB      08h
        DB      1Fh
        DB      67h             ; 'g'
        DB      79h             ; 'y'
        DB      30h             ; '0'
        DB      0Bh
        DB      0E5h
        DB      2Ah             ; '*'
        DB      0BEh
        DB      88h
        DB      19h
        DB      0EBh
        DB      0E1h
        DB      3Ah             ; ':'
        DB      0BDh
        DB      88h
        DB      89h
        DB      1Fh
        DB      4Fh             ; 'O'
        DB      7Ah             ; 'z'
        DB      1Fh
        DB      57h             ; 'W'
        DB      7Bh             ; '{'
        DB      1Fh
        DB      5Fh             ; '_'
        DB      78h             ; 'x'
        DB      1Fh
        DB      47h             ; 'G'
        DB      0E6h
        DB      10h
        DB      28h             ; '('
        DB      04h
        DB      78h             ; 'x'
        DB      0F6h
        DB      " G-| "
        DB      0D9h

        ; --- START PROC L046E ---
L046E:  POP     HL
        RET

L0470:  DB      43h             ; 'C'
        DB      5Ah             ; 'Z'
        DB      51h             ; 'Q'
        DB      4Fh             ; 'O'
        DB      0C9h

        ; --- START PROC L0475 ---
L0475:  CALL    L0567
        LD      BC,8420h
        LD      DE,0000h
        CALL    L0577
        POP     BC
        POP     DE
        RST     0x28
        JP      Z,L125D
        LD      L,0FFh
        CALL    L0500
        INC     (HL)
        JP      Z,L1269
        INC     (HL)
        JP      Z,L1269
        DEC     HL
        LD      A,(HL)
        LD      (87E9h),A
        DEC     HL
        LD      A,(HL)
        LD      (87E5h),A
        DEC     HL
        LD      A,(HL)
        LD      (87E1h),A
        LD      B,C
        EX      DE,HL
        XOR     A
        LD      C,A
        LD      D,A
        LD      E,A
        LD      (87ECh),A
L04AC:  PUSH    HL
        PUSH    BC
        LD      A,L
        CALL    87E0h
        SBC     A,00h
        CCF
        JR      NC,L04BE
        LD      (87ECh),A
        POP     AF
        POP     AF
        SCF
        JP      NC,0E1C1h
L04BE:  POP     BC
        POP     HL
        LD      A,C
        INC     A
        DEC     A
        RRA
        JP      P,L04DB
        RLA
        LD      A,(87ECh)
        RRA
        AND     0C0h
        PUSH    AF
        LD      A,B
        OR      H
        OR      L
        JR      Z,L04D6
        LD      A,20h           ; ' '
L04D6:  POP     HL
        OR      H
        JP      L0346

L04DB:  RLA
        LD      A,E
        RLA
        LD      E,A
        LD      A,D
        RLA
        LD      D,A
        LD      A,C
        RLA
        LD      C,A
        ADD     HL,HL
        LD      A,B
        RLA
        LD      B,A
        LD      A,(87ECh)
        RLA
        LD      (87ECh),A
        LD      A,C
        OR      D
        OR      E
        JR      NZ,L04AC
        PUSH    HL
        LD      HL,88AEh
        DEC     (HL)
        POP     HL
        JR      NZ,L04AC
        JP      L0317

        ; --- START PROC L0500 ---
L0500:  LD      A,B
        OR      A
        JR      Z,L0521
        LD      A,L
        LD      HL,88AEh
        XOR     (HL)
        ADD     A,B
        LD      B,A
        RRA
        XOR     B
        LD      A,B
        JP      P,L0520
        ADD     A,80h
        LD      (HL),A
        JP      Z,L046E
        CALL    L059A
        LD      (HL),A
        DEC     HL
        RET

L051D:  DB      0EFh
        DB      2Fh             ; '/'
        DB      0E1h

L0520:  OR      A
L0521:  POP     HL
        JP      P,L0317
        JP      L1269

        ; --- START PROC L0528 ---
L0528:  CALL    L0582
        LD      A,B
        OR      A
        RET     Z
        ADD     A,02h
        JP      C,L1269
        LD      B,A
        CALL    L02B5
        LD      HL,88AEh
        INC     (HL)
        RET     NZ
        JP      L1269

        ; --- START PROC L053F ---
L053F:  LD      A,(88ADh)
        CP      2Fh             ; '/'
        RLA
        SBC     A,A
        RET     NZ
        INC     A
        RET

L0549:  DB      0EFh

        ; --- START PROC L054A ---
L054A:  LD      B,88h
        LD      DE,0000h
        ; --- START PROC L054F ---
L054F:  LD      HL,88AEh
        LD      C,A
        LD      (HL),B
        LD      B,00h
        INC     HL
        LD      (HL),80h
        RLA
        JP      L0301

L055D:  DB      0EFh
        DB      0F0h

        ; --- START PROC L055F ---
L055F:  LD      HL,88ADh
        LD      A,(HL)
        XOR     80h
        LD      (HL),A
        RET

        ; --- START PROC L0567 ---
L0567:  EX      DE,HL
        LD      HL,(88ABh)
        EX      (SP),HL
        PUSH    HL
        LD      HL,(88ADh)
        EX      (SP),HL
        PUSH    HL
        EX      DE,HL
        RET

        ; --- START PROC L0574 ---
L0574:  CALL    L0585
        ; --- START PROC L0577 ---
L0577:  EX      DE,HL
        LD      (88ABh),HL
        LD      H,B
        LD      L,C
        LD      (88ADh),HL
        EX      DE,HL
        RET

        ; --- START PROC L0582 ---
L0582:  LD      HL,88ABh
        ; --- START PROC L0585 ---
L0585:  LD      E,(HL)
        INC     HL
        LD      D,(HL)
        INC     HL
        LD      C,(HL)
        INC     HL
        LD      B,(HL)
        ; --- START PROC L058C ---
L058C:  INC     HL
        RET

        ; --- START PROC L058E ---
L058E:  LD      DE,88ABh
        ; --- START PROC L0591 ---
L0591:  LD      B,04h
L0593:  LD      A,(DE)
        LD      (HL),A
        INC     DE
        INC     HL
        DJNZ    L0593
        RET

        ; --- START PROC L059A ---
L059A:  LD      HL,88ADh
        LD      A,(HL)
        RLCA
        SCF
        RRA
        LD      (HL),A
        CCF
        RRA
        INC     HL
        INC     HL
        LD      (HL),A
        LD      A,C
        RLCA
        SCF
        RRA
        LD      C,A
        RRA
        XOR     (HL)
        RET

        ; --- START PROC L05AF ---
L05AF:  LD      A,B
        OR      A
        JP      Z,L0028
        LD      HL,0543h
        PUSH    HL
        RST     0x28
        LD      A,C
        RET     Z
        LD      HL,88ADh
        XOR     (HL)
        LD      A,C
        RET     M
        CALL    L05C7
        RRA
        XOR     C
        RET

        ; --- START PROC L05C7 ---
L05C7:  INC     HL
        LD      A,B
        CP      (HL)
        RET     NZ
        DEC     HL
        LD      A,C
        CP      (HL)
        RET     NZ
        DEC     HL
        LD      A,D
        CP      (HL)
        RET     NZ
        DEC     HL
        LD      A,E
        SUB     (HL)
        RET     NZ
        POP     HL
        POP     HL
        RET

        ; --- START PROC L05DA ---
L05DA:  LD      B,A
        LD      C,A
        LD      D,A
        LD      E,A
        OR      A
        RET     Z
        PUSH    HL
        CALL    L0582
        CALL    L059A
        XOR     (HL)
        LD      H,A
        CALL    M,L05FE
        LD      A,98h
        SUB     B
        CALL    L0384
        LD      A,H
        RLA
        CALL    C,L0357
        LD      B,00h
        CALL    C,L0370
        POP     HL
        RET

        ; --- START PROC L05FE ---
L05FE:  DEC     DE
        LD      A,D
        AND     E
        INC     A
        RET     NZ
        DEC     BC
        RET

L0605:  DB      21h             ; '!'
        DB      0AEh
        DB      88h
        DB      7Eh             ; '~'
        DB      0FEh
        DB      98h
        DB      3Ah             ; ':'
        DB      0ABh
        DB      88h
        DB      0D0h
        DB      7Eh             ; '~'
        DB      0CDh
        DB      0DAh
        DB      05h
        DB      36h             ; '6'
        DB      98h
        DB      7Bh             ; '{'
        DB      0F5h
        DB      79h             ; 'y'
        DB      17h
        DB      0CDh
        DB      01h
        DB      03h
        DB      0F1h
        DB      0C9h

        ; --- START PROC L061E ---
L061E:  LD      HL,0000h
        LD      A,B
        OR      C
        RET     Z
        LD      A,10h
L0626:  ADD     HL,HL
        JP      C,L2DFD
        EX      DE,HL
        ADD     HL,HL
        EX      DE,HL
        JP      NC,L0634
        ADD     HL,BC
        JP      C,L2DFD
L0634:  DEC     A
        JP      NZ,L0626
        RET

        ; --- START PROC L0639 ---
L0639:  CP      2Dh             ; '-'
        PUSH    AF
        JR      Z,L0643
        CP      2Bh             ; '+'
        JR      Z,L0643
        DEC     HL
L0643:  CALL    L0317
        LD      B,A
        LD      D,A
        LD      E,A
        CPL
        LD      C,A
        ; --- START PROC L064B ---
L064B:  RST     0x10
        JP      C,L0693
        CP      2Eh             ; '.'
        JP      Z,L066E
        CP      65h             ; 'e'
        JP      Z,L065E
        CP      45h             ; 'E'
        JP      NZ,L0672
L065E:  RST     0x10
        CALL    L195A
        ; --- START PROC L0662 ---
L0662:  RST     0x10
        JP      C,L06B5
        INC     D
        JP      NZ,L0672
        XOR     A
        SUB     E
        LD      E,A
        INC     C
        ; --- START PROC L066E ---
L066E:  INC     C
        JP      Z,L064B
        ; --- START PROC L0672 ---
L0672:  PUSH    HL
        LD      A,E
        SUB     B
L0675:  CALL    P,L068B
        JP      P,L0681
        PUSH    AF
        CALL    L0475
        POP     AF
        INC     A
L0681:  JP      NZ,L0675
        POP     DE
        POP     AF
        CALL    Z,L055F
        EX      DE,HL
        RET

        ; --- START PROC L068B ---
L068B:  RET     Z
        ; --- START PROC L068C ---
L068C:  PUSH    AF
        CALL    L0528
        POP     AF
        DEC     A
        RET

        ; --- START PROC L0693 ---
L0693:  PUSH    DE
        LD      D,A
        LD      A,B
        ADC     A,C
        LD      B,A
        PUSH    BC
        PUSH    HL
        PUSH    DE
        CALL    L0528
        POP     AF
        SUB     30h             ; '0'
        CALL    L06AA
        POP     HL
        POP     BC
        POP     DE
        JP      L064B

        ; --- START PROC L06AA ---
L06AA:  CALL    L0567
        CALL    L054A
        POP     BC
        POP     DE
        JP      L02B5

        ; --- START PROC L06B5 ---
L06B5:  LD      A,E
        RLCA
        RLCA
        ADD     A,E
        RLCA
        ADD     A,(HL)
        SUB     30h             ; '0'
        LD      E,A
        JP      L0662

        ; --- START PROC L06C1 ---
L06C1:  PUSH    HL
        LD      HL,1202h
        CALL    L2838
        POP     HL
        ; --- START PROC L06C9 ---
L06C9:  LD      DE,2837h
        PUSH    DE
        EX      DE,HL
        XOR     A
        LD      B,98h
        CALL    L054F
        LD      HL,88B0h
        PUSH    HL
        RST     0x28
        LD      (HL),20h        ; ' '
        JP      P,L06E0
        LD      (HL),2Dh        ; '-'
L06E0:  INC     HL
        LD      (HL),30h        ; '0'
        JP      Z,L0796
        PUSH    HL
        CALL    M,L055F
        XOR     A
        PUSH    AF
        CALL    L079C
L06EF:  LD      BC,9143h
        LD      DE,4FF8h
        CALL    L05AF
        OR      A
        JP      PO,L070D
        POP     AF
        CALL    L068C
        PUSH    AF
        JP      L06EF

        ; --- START PROC L0704 ---
L0704:  CALL    L0475
        POP     AF
        INC     A
        PUSH    AF
        CALL    L079C
        ; --- START PROC L070D ---
L070D:  CALL    L02A4
        INC     A
        CALL    L05DA
        CALL    L0577
        LD      BC,0306h
        POP     AF
        ADD     A,C
        INC     A
        JP      M,L0729
        CP      08h
        JP      NC,L0729
        INC     A
        LD      B,A
        LD      A,02h
L0729:  DEC     A
        DEC     A
        POP     HL
        PUSH    AF
        LD      DE,07B2h
        DEC     B
        JP      NZ,L073A
        LD      (HL),2Eh        ; '.'
        INC     HL
        LD      (HL),30h        ; '0'
        INC     HL
L073A:  DEC     B
        LD      (HL),2Eh        ; '.'
        CALL    Z,L058C
        PUSH    BC
        PUSH    HL
        PUSH    DE
        CALL    L0582
        POP     HL
        LD      B,2Fh           ; '/'
L0749:  INC     B
        LD      A,E
        SUB     (HL)
        LD      E,A
        INC     HL
        LD      A,D
        SBC     A,(HL)
        LD      D,A
        INC     HL
        LD      A,C
        SBC     A,(HL)
        LD      C,A
        DEC     HL
        DEC     HL
        JP      NC,L0749
        CALL    L0364
        INC     HL
        CALL    L0577
        EX      DE,HL
        POP     HL
        LD      (HL),B
        INC     HL
        POP     BC
        DEC     C
        JP      NZ,L073A
        DEC     B
        JP      Z,L077A
L076E:  DEC     HL
        LD      A,(HL)
        CP      30h             ; '0'
        JP      Z,L076E
        CP      2Eh             ; '.'
        CALL    NZ,L058C
L077A:  POP     AF
        JP      Z,L0799
        LD      (HL),45h        ; 'E'
        INC     HL
        LD      (HL),2Bh        ; '+'
        JP      P,L078A
        LD      (HL),2Dh        ; '-'
        CPL
        INC     A
L078A:  LD      B,2Fh           ; '/'
L078C:  INC     B
        SUB     0Ah
        JP      NC,L078C
        ADD     A,3Ah           ; ':'
        INC     HL
        LD      (HL),B
        ; --- START PROC L0796 ---
L0796:  INC     HL
        LD      (HL),A
        INC     HL
        ; --- START PROC L0799 ---
L0799:  LD      (HL),C
        POP     HL
        RET

        ; --- START PROC L079C ---
L079C:  LD      BC,9474h
        LD      DE,23F7h
        CALL    L05AF
        OR      A
        POP     HL
        JP      PO,L0704
        JP      (HL)

L07AB:  DB      00h
        DB      00h
        DB      00h
        DB      80h
        DB      40h             ; '@'
        DB      42h             ; 'B'
        DB      0Fh
        DB      0A0h
        DB      86h
        DB      01h
        DB      10h
        DB      27h             ; '''
        DB      00h
        DB      0E8h
        DB      03h
        DB      00h
        DB      64h             ; 'd'
        DB      00h
        DB      00h
        DB      0Ah
        DB      00h
        DB      00h
        DB      01h
        DB      00h
        DB      00h
        DB      21h             ; '!'
        DB      5Fh             ; '_'
        DB      05h
        DB      0E3h
        DB      0E9h
        DB      0CDh
        DB      67h             ; 'g'
        DB      05h
        DB      21h             ; '!'
        DB      0ABh
        DB      07h
        DB      0CDh
        DB      74h             ; 't'
        DB      05h
        DB      0C1h
        DB      0D1h
        DB      0EFh
        DB      78h             ; 'x'
        DB      0CAh
        DB      21h             ; '!'
        DB      08h
        DB      0F2h
        DB      0E0h
        DB      07h
        DB      0B7h
        DB      0CAh
        DB      5Dh             ; ']'
        DB      12h
        DB      0B7h
        DB      0CAh
        DB      18h
        DB      03h
        DB      0D5h
        DB      0C5h
        DB      79h             ; 'y'
        DB      0F6h
        DB      7Fh
        DB      0CDh
        DB      82h
        DB      05h
        DB      0F2h
        DB      09h
        DB      08h
        DB      0F5h
        DB      3Ah             ; ':'
        DB      0AEh
        DB      88h
        DB      0FEh
        DB      99h
        DB      38h             ; '8'
        DB      03h
        DB      0F1h
        DB      18h
        DB      0Fh
        DB      0F1h
        DB      0D5h
        DB      0C5h
        DB      0CDh
        DB      05h
        DB      06h
        DB      0C1h
        DB      0D1h
        DB      0F5h
        DB      0CDh
        DB      0AFh
        DB      05h
        DB      0E1h
        DB      7Ch             ; '|'
        DB      1Fh
        DB      0E1h
        DB      22h             ; '"'
        DB      0ADh
        DB      88h
        DB      0E1h
        DB      22h             ; '"'
        DB      0ABh
        DB      88h
        DB      0DCh
        DB      0C4h
        DB      07h
        DB      0CCh
        DB      5Fh             ; '_'
        DB      05h
        DB      0D5h
        DB      0C5h
        DB      0CDh
        DB      0D9h
        DB      03h
        DB      0C1h
        DB      0D1h
        DB      0CDh
        DB      1Fh
        DB      04h
        DB      01h
        DB      38h             ; '8'
        DB      81h
        DB      11h
        DB      3Bh             ; ';'
        DB      0AAh
        DB      0CDh
        DB      1Fh
        DB      04h
        DB      3Ah             ; ':'
        DB      0AEh
        DB      88h
        DB      0FEh
        DB      88h
        DB      30h             ; '0'
        DB      22h             ; '"'
        DB      0FEh
        DB      68h             ; 'h'
        DB      38h             ; '8'
        DB      30h             ; '0'
        DB      0CDh
        DB      67h             ; 'g'
        DB      05h
        DB      0CDh
        DB      05h
        DB      06h
        DB      0C6h
        DB      81h
        DB      0C1h
        DB      0D1h
        DB      28h             ; '('
        DB      15h
        DB      0F5h
        DB      0CDh
        DB      0B2h
        DB      02h
        DB      21h             ; '!'
        DB      6Eh             ; 'n'
        DB      08h
        DB      0CDh
        DB      9Ah
        DB      08h
        DB      0C1h
        DB      11h
        DB      00h
        DB      00h
        DB      4Ah             ; 'J'
        DB      0C3h
        DB      1Fh
        DB      04h
        DB      0CDh
        DB      67h             ; 'g'
        DB      05h
        DB      3Ah             ; ':'
        DB      0ADh
        DB      88h
        DB      0B7h
        DB      0F2h
        DB      62h             ; 'b'
        DB      08h
        DB      0F1h
        DB      0F1h
        DB      0C3h
        DB      17h
        DB      03h
        DB      0C3h
        DB      69h             ; 'i'
        DB      12h
        DB      01h
        DB      00h
        DB      81h
        DB      11h
        DB      00h
        DB      00h
        DB      0C3h
        DB      77h             ; 'w'
        DB      05h
        DB      07h
        DB      7Ch             ; '|'
        DB      88h
        DB      59h             ; 'Y'
        DB      74h             ; 't'
        DB      0E0h
        DB      97h
        DB      26h             ; '&'
        DB      77h             ; 'w'
        DB      0C4h
        DB      1Dh
        DB      1Eh
        DB      "z^Pc|"
        DB      1Ah
        DB      0FEh
        DB      75h             ; 'u'
        DB      7Eh             ; '~'
        DB      18h
        DB      72h             ; 'r'
        DB      31h             ; '1'
        DB      80h
        DB      00h
        DB      00h
        DB      00h
        DB      81h
        DB      0CDh
        DB      67h             ; 'g'
        DB      05h
        DB      11h
        DB      1Dh
        DB      04h
        DB      0D5h
        DB      0E5h
        DB      0CDh
        DB      82h
        DB      05h
        DB      0CDh
        DB      1Fh
        DB      04h
        DB      0E1h
        DB      0CDh
        DB      67h             ; 'g'
        DB      05h
        DB      7Eh             ; '~'
        DB      23h             ; '#'
        DB      0CDh
        DB      74h             ; 't'
        DB      05h
        DB      06h
        DB      0F1h
        DB      0C1h
        DB      0D1h
        DB      3Dh             ; '='
        DB      0C8h
        DB      0D5h
        DB      0C5h
        DB      0F5h
        DB      0E5h
        DB      0CDh
        DB      1Fh
        DB      04h
        DB      0E1h
        DB      0CDh
        DB      85h
        DB      05h
        DB      0E5h
        DB      0CDh
        DB      0B5h
        DB      02h
        DB      0E1h
        DB      18h
        DB      0E9h
        DB      0EFh
        DB      21h             ; '!'
        DB      0F0h
        DB      87h
        DB      0FAh
        DB      18h
        DB      09h
        DB      21h             ; '!'
        DB      11h
        DB      88h
        DB      0CDh
        DB      74h             ; 't'
        DB      05h
        DB      21h             ; '!'
        DB      0F0h
        DB      87h
        DB      0C8h
        DB      86h
        DB      0E6h
        DB      07h
        DB      06h
        DB      00h
        DB      77h             ; 'w'
        DB      23h             ; '#'
        DB      87h
        DB      87h
        DB      4Fh             ; 'O'
        DB      09h
        DB      0CDh
        DB      85h
        DB      05h
        DB      0CDh
        DB      1Fh
        DB      04h
        DB      3Ah             ; ':'
        DB      0EFh
        DB      87h
        DB      3Ch             ; '<'
        DB      0E6h
        DB      03h
        DB      06h
        DB      00h
        DB      0FEh
        DB      01h
        DB      88h
        DB      32h             ; '2'
        DB      0EFh
        DB      87h
        DB      21h             ; '!'
        DB      1Bh
        DB      09h
        DB      87h
        DB      87h
        DB      4Fh             ; 'O'
        DB      09h
        DB      0CDh
        DB      0A7h
        DB      02h
        DB      0CDh
        DB      82h
        DB      05h
        DB      7Bh             ; '{'
        DB      59h             ; 'Y'
        DB      0EEh
        DB      4Fh             ; 'O'
        DB      4Fh             ; 'O'
        DB      36h             ; '6'
        DB      80h
        DB      2Bh             ; '+'
        DB      46h             ; 'F'
        DB      36h             ; '6'
        DB      80h
        DB      21h             ; '!'
        DB      0EEh
        DB      87h
        DB      34h             ; '4'
        DB      7Eh             ; '~'
        DB      0D6h
        DB      0ABh
        DB      20h             ; ' '
        DB      04h
        DB      77h             ; 'w'
        DB      0Ch
        DB      15h
        DB      1Ch
        DB      0CDh
        DB      04h
        DB      03h
        DB      21h             ; '!'
        DB      11h
        DB      88h
        DB      0C3h
        DB      8Eh
        DB      05h
        DB      "w+w+w"
        DB      18h
        DB      0D5h
        DB      68h             ; 'h'
        DB      0B1h
        DB      46h             ; 'F'
        DB      68h             ; 'h'
        DB      99h
        DB      0E9h
        DB      92h
        DB      69h             ; 'i'
        DB      10h
        DB      0D1h
        DB      75h             ; 'u'
        DB      68h             ; 'h'
        DB      21h             ; '!'
        DB      0A7h
        DB      09h
        DB      0CDh
        DB      0A7h
        DB      02h
        DB      3Ah             ; ':'
        DB      0AEh
        DB      88h
        DB      0FEh
        DB      77h             ; 'w'
        DB      0D8h
        DB      3Ah             ; ':'
        DB      0ADh
        DB      88h
        DB      0B7h
        DB      0F2h
        DB      47h             ; 'G'
        DB      09h
        DB      0E6h
        DB      7Fh
        DB      32h             ; '2'
        DB      0ADh
        DB      88h
        DB      11h
        DB      5Fh             ; '_'
        DB      05h
        DB      0D5h
        DB      01h
        DB      22h             ; '"'
        DB      7Eh             ; '~'
        DB      11h
        DB      83h
        DB      0F9h
        DB      0CDh
        DB      1Fh
        DB      04h
        DB      0CDh
        DB      67h             ; 'g'
        DB      05h
        DB      0CDh
        DB      05h
        DB      06h
        DB      0C1h
        DB      0D1h
        DB      0CDh
        DB      0B2h
        DB      02h
        DB      01h
        DB      00h
        DB      7Fh
        DB      11h
        DB      00h
        DB      00h
        DB      0CDh
        DB      0AFh
        DB      05h
        DB      0FAh
        DB      89h
        DB      09h
        DB      01h
        DB      80h
        DB      7Fh
        DB      11h
        DB      00h
        DB      00h
        DB      0CDh
        DB      0B5h
        DB      02h
        DB      01h
        DB      80h
        DB      80h
        DB      11h
        DB      00h
        DB      00h
        DB      0CDh
        DB      0B5h
        DB      02h
        DB      0EFh
        DB      0F4h
        DB      5Fh             ; '_'
        DB      05h
        DB      01h
        DB      00h
        DB      7Fh
        DB      11h
        DB      00h
        DB      00h
        DB      0CDh
        DB      0B5h
        DB      02h
        DB      0CDh
        DB      5Fh             ; '_'
        DB      05h
        DB      3Ah             ; ':'
        DB      0ADh
        DB      88h
        DB      0B7h
        DB      0F5h
        DB      0F2h
        DB      96h
        DB      09h
        DB      0EEh
        DB      80h
        DB      32h             ; '2'
        DB      0ADh
        DB      88h
        DB      21h             ; '!'
        DB      0AFh
        DB      09h
        DB      0CDh
        DB      8Bh
        DB      08h
        DB      0F1h
        DB      0F0h
        DB      3Ah             ; ':'
        DB      0ADh
        DB      88h
        DB      0EEh
        DB      80h
        DB      32h             ; '2'
        DB      0ADh
        DB      88h
        DB      0C9h
        DB      0DBh
        DB      0Fh
        DB      49h             ; 'I'
        DB      81h
        DB      00h
        DB      00h
        DB      00h
        DB      7Fh
        DB      05h
        DB      0FBh
        DB      0D7h
        DB      1Eh
        DB      86h
        DB      65h             ; 'e'
        DB      26h             ; '&'
        DB      99h
        DB      87h
        DB      58h             ; 'X'
        DB      34h             ; '4'
        DB      23h             ; '#'
        DB      87h
        DB      0E1h
        DB      5Dh             ; ']'
        DB      0A5h
        DB      86h
        DB      0DBh
        DB      0Fh
        DB      49h             ; 'I'
        DB      83h
        DB      0CDh
        DB      67h             ; 'g'
        DB      05h
        DB      0CDh
        DB      31h             ; '1'
        DB      09h
        DB      0C1h
        DB      0E1h
        DB      0CDh
        DB      67h             ; 'g'
        DB      05h
        DB      0EBh
        DB      0CDh
        DB      77h             ; 'w'
        DB      05h
        DB      0CDh
        DB      2Bh             ; '+'
        DB      09h
        DB      0C3h
        DB      81h
        DB      04h
        DB      0EFh
        DB      0FCh
        DB      0C4h
        DB      07h
        DB      0FCh
        DB      5Fh             ; '_'
        DB      05h
        DB      3Ah             ; ':'
        DB      0AEh
        DB      88h
        DB      0FEh
        DB      81h
        DB      38h             ; '8'
        DB      0Ch
        DB      01h
        DB      00h
        DB      81h
        DB      51h             ; 'Q'
        DB      59h             ; 'Y'
        DB      0CDh
        DB      83h
        DB      04h
        DB      21h             ; '!'
        DB      0ACh
        DB      02h
        DB      0E5h
        DB      21h             ; '!'
        DB      0FDh
        DB      09h
        DB      0CDh
        DB      8Bh
        DB      08h
        DB      21h             ; '!'
        DB      0A7h
        DB      09h
        DB      0C9h
        DB      09h
        DB      4Ah             ; 'J'
        DB      0D7h
        DB      3Bh             ; ';'
        DB      78h             ; 'x'
        DB      02h
        DB      6Eh             ; 'n'
        DB      84h
        DB      7Bh             ; '{'
        DB      0FEh
        DB      0C1h
        DB      2Fh             ; '/'
        DB      7Ch             ; '|'
        DB      74h             ; 't'
        DB      31h             ; '1'
        DB      9Ah
        DB      7Dh             ; '}'
        DB      84h
        DB      3Dh             ; '='
        DB      5Ah             ; 'Z'
        DB      7Dh             ; '}'
        DB      0C8h
        DB      7Fh
        DB      91h
        DB      7Eh             ; '~'
        DB      0E4h
        DB      0BBh
        DB      4Ch             ; 'L'
        DB      7Eh             ; '~'
        DB      6Ch             ; 'l'
        DB      0AAh
        DB      0AAh
        DB      7Fh
        DB      00h
        DB      00h
        DB      00h
        DB      81h

        ; --- START PROC L0A22 ---
L0A22:  PUSH    BC
        PUSH    DE
        PUSH    HL
        LD      A,(87C6h)
        AND     A
        JP      NZ,L0B43
        CALL    L1BDF
        OR      A
        JP      Z,L0A96
        CP      0Fh
        JP      Z,L0A95
        CP      0Eh
        JP      Z,L0A95
        PUSH    AF
        LD      A,85h
        LD      (87B0h),A
        CALL    L213A
        LD      A,00h
        LD      (87B0h),A
        POP     AF
        BIT     7,A
        JP      NZ,L0AAB
        CP      5Eh             ; '^'
        JP      Z,L0CB1
        CP      7Eh             ; '~'
        JP      Z,L0CB6
        CP      20h             ; ' '
        JP      NC,L0A94
        CP      04h
        JP      Z,L0A94
        CP      03h
        JP      Z,L0A94
        CP      06h
        JP      Z,L0A94
        CP      07h
        JP      Z,L0A9F
        CP      15h
        JP      Z,L0AA5
        SET     7,A
L0A7B:  CP      85h
        JP      Z,L0BE8
        CP      8Dh
        JP      Z,L0BCE
        CP      88h
        JP      Z,L0BF9
        CP      8Ah
        JP      Z,L0C33
        CP      8Ch
        JP      Z,L0C6B
        ; --- START PROC L0A94 ---
L0A94:  RST     0x30
        ; --- START PROC L0A95 ---
L0A95:  XOR     A
        ; --- START PROC L0A96 ---
L0A96:  POP     HL
        POP     DE
        POP     BC
        RET

L0A9A:  DB      3Eh             ; '>'
        DB      0FFh
        DB      0C3h
        DB      96h
        DB      0Ah

L0A9F:  LD      A,(87BFh)
        JP      L0A7B

L0AA5:  LD      A,(87C0h)
        JP      L0A7B

L0AAB:  CP      82h
        JP      Z,L0CAC
        SUB     0B0h
        JP      C,L0A95
        CP      0Ah
        JP      C,L0B1D
        SUB     31h             ; '1'
        JP      C,L0A95
        CP      1Ah
        JP      NC,L0A95
        LD      D,00h
        LD      E,A
        ADD     A,A
        ADD     A,E
        LD      E,A
        LD      HL,0ACFh
        ADD     HL,DE
        JP      (HL)

L0ACF:  DB      0C3h
        DB      0CAh
        DB      0Dh
        DB      0C3h
        DB      0D6h
        DB      0Dh
        DB      0C3h
        DB      0E2h
        DB      0Dh
        DB      0C3h
        DB      0A7h
        DB      0Ch
        DB      0C3h
        DB      0EEh
        DB      0Dh
        DB      0C3h
        DB      0FAh
        DB      0Dh
        DB      0C3h
        DB      0Ch
        DB      0Eh
        DB      0C3h
        DB      18h
        DB      0Eh
        DB      0C3h
        DB      0A2h
        DB      0Ch
        DB      0C3h
        DB      25h             ; '%'
        DB      0Eh
        DB      0C3h
        DB      32h             ; '2'
        DB      0Eh
        DB      0C3h
        DB      3Dh             ; '='
        DB      0Eh
        DB      0C3h
        DB      49h             ; 'I'
        DB      0Eh
        DB      0C3h
        DB      56h             ; 'V'
        DB      0Eh
        DB      0C3h
        DB      63h             ; 'c'
        DB      0Eh
        DB      0C3h
        DB      6Fh             ; 'o'
        DB      0Eh
        DB      0C3h
        DB      7Bh             ; '{'
        DB      0Eh
        DB      0C3h
        DB      89h
        DB      0Eh
        DB      0C3h
        DB      93h
        DB      0Eh
        DB      0C3h
        DB      0A0h
        DB      0Eh
        DB      0C3h
        DB      0ACh
        DB      0Eh
        DB      0C3h
        DB      0B9h
        DB      0Eh
        DB      0C3h
        DB      0C7h
        DB      0Eh
        DB      0C3h
        DB      0D3h
        DB      0Eh
        DB      0C3h
        DB      0E2h
        DB      0Eh
        DB      0C3h
        DB      0F1h
        DB      0Eh

L0B1D:  PUSH    AF
        LD      HL,0000h
        LD      A,(87C1h)
        OR      A
        JR      Z,L0B2A
        LD      HL,(87C2h)
L0B2A:  ADD     HL,HL
        LD      E,L
        LD      D,H
        ADD     HL,HL
        ADD     HL,HL
        ADD     HL,DE
        LD      D,00h
        POP     AF
        LD      E,A
        ADD     HL,DE
        LD      (87C2h),HL
        LD      A,01h
        LD      (87C1h),A
        CALL    L0D77
        JP      L0A95

L0B43:  LD      A,(87CEh)
        OR      A
        CALL    NZ,L0BB0
        LD      HL,(87C4h)
        LD      A,L
        CP      28h             ; '('
        JP      NC,L0B76
        PUSH    HL
        CALL    L1FF0
        POP     DE
        LD      A,(HL)
        CP      20h             ; ' '
        JP      NZ,L0B6F
L0B5E:  INC     E
        LD      A,E
        CP      28h             ; '('
        JP      NC,L0B76
        INC     HL
        INC     HL
        LD      A,(HL)
        CP      20h             ; ' '
        JP      Z,L0B5E
        LD      A,20h           ; ' '
L0B6F:  LD      HL,87C4h
        INC     (HL)
        JP      L0BAD

L0B76:  XOR     A
        LD      (87C6h),A
        LD      A,(87C7h)
        BIT     7,A
        JP      NZ,L0BAB
        CP      20h             ; ' '
        JP      Z,L0B91
        CP      30h             ; '0'
        JP      C,L0BA5
        CP      3Ah             ; ':'
        JP      NC,L0BA5
L0B91:  LD      A,(874Eh)
        CP      01h
        JP      Z,L0B9F
        LD      A,83h
        RST     0x30
        JP      L0BAB

L0B9F:  LD      A,9Ah
        RST     0x30
        JP      L0BAB

L0BA5:  LD      A,83h
        RST     0x30
        LD      A,9Eh
        RST     0x30
L0BAB:  LD      A,0Dh
        ; --- START PROC L0BAD ---
L0BAD:  JP      L0A96

        ; --- START PROC L0BB0 ---
L0BB0:  LD      HL,(87C4h)
        PUSH    HL
        CALL    L1FF0
        POP     DE
L0BB8:  LD      A,E
        CP      28h             ; '('
        JR      NC,L0BC9
        INC     E
        LD      A,(HL)
        INC     HL
        INC     HL
        CP      3Fh             ; '?'
        JR      NZ,L0BB8
        LD      (87C4h),DE
L0BC9:  XOR     A
        LD      (87CEh),A
        RET

        ; --- START PROC L0BCE ---
L0BCE:  LD      A,(874Fh)
        LD      H,A
        LD      L,01h
        LD      (87C4h),HL
        CALL    L1FF0
        LD      A,(HL)
        RES     7,A
        ; --- START PROC L0BDD ---
L0BDD:  LD      (87C7h),A
        LD      A,01h
        LD      (87C6h),A
        JP      L0A95

        ; --- START PROC L0BE8 ---
L0BE8:  LD      A,(874Fh)
        LD      H,A
        LD      L,01h
        LD      (87C4h),HL
        CALL    L1FF0
        LD      A,80h
        JP      L0BDD

        ; --- START PROC L0BF9 ---
L0BF9:  LD      A,(874Fh)
        CP      03h
        JP      NC,L0C2D
        LD      A,9Ch
        RST     0x30
        LD      DE,(8752h)
        CALL    L1339
        LD      BC,(8754h)
        LD      A,B
        OR      C
        JP      Z,L0C25
        CALL    L0D20
        LD      A,00h
        CALL    L203B
        CALL    L0D11
L0C1F:  CALL    L20F4
        JP      L0A95

L0C25:  LD      A,00h
        CALL    L1BAC
        JP      L0C1F

L0C2D:  LD      A,88h
        RST     0x30
        JP      L0A95

        ; --- START PROC L0C33 ---
L0C33:  LD      A,(874Fh)
        CP      14h
        JP      C,L0C65
        LD      A,9Bh
        RST     0x30
        LD      DE,(8752h)
        INC     DE
        CALL    L1339
        JP      C,L0C4C
        JP      Z,L0C5D
L0C4C:  CALL    L0D20
        LD      A,16h
        CALL    L203B
        CALL    L0D11
L0C57:  CALL    L20F4
        JP      L0A95

L0C5D:  LD      A,16h
        CALL    L1BAC
        JP      L0C57

L0C65:  LD      A,8Ah
        RST     0x30
        JP      L0A95

        ; --- START PROC L0C6B ---
L0C6B:  RST     0x30
        XOR     A
        LD      (87C1h),A
        CALL    L1BAC
        LD      A,01h
        CALL    L1BAC
        LD      DE,(87C2h)
        CALL    L1339
        LD      A,02h
L0C81:  PUSH    AF
        CALL    L0D20
        CALL    C,L0C9F
        POP     AF
        PUSH    AF
        PUSH    HL
        CALL    L203B
        CALL    L0D11
        POP     BC
        POP     AF
        INC     A
        CP      17h
        JP      C,L0C81
        CALL    L20F4
        JP      L0A95

        ; --- START PROC L0C9F ---
L0C9F:  DEC     HL
        DEC     HL
        RET

L0CA2:  DB      3Eh             ; '>'
        DB      90h
        DB      0C3h
        DB      94h
        DB      0Ah
        DB      3Eh             ; '>'
        DB      84h
        DB      0C3h
        DB      94h
        DB      0Ah

        ; --- START PROC L0CAC ---
L0CAC:  LD      A,9Fh
        JP      L0A94

        ; --- START PROC L0CB1 ---
L0CB1:  LD      A,0FFh
        JP      L0A94

        ; --- START PROC L0CB6 ---
L0CB6:  LD      A,0FEh
        JP      L0A94

        ; --- START PROC L0CBB ---
L0CBB:  PUSH    DE
        PUSH    HL
        LD      (8752h),HL
        ; --- START PROC L0CC0 ---
L0CC0:  LD      DE,2710h
        CALL    L0CE1
        LD      DE,03E8h
        CALL    L0CE1
        LD      DE,0064h
        CALL    L0CE1
        LD      DE,000Ah
        CALL    L0CE1
        LD      A,30h           ; '0'
        ADD     A,L
        CALL    L0CF1
        POP     HL
        POP     DE
        RET

        ; --- START PROC L0CE1 ---
L0CE1:  LD      A,0FFh
L0CE3:  INC     A
        OR      A
        SBC     HL,DE
        JP      NC,L0CE3
        ADD     HL,DE
        ADD     A,30h           ; '0'
        CALL    L0CF1
        RET

        ; --- START PROC L0CF1 ---
L0CF1:  PUSH    BC
        PUSH    DE
        PUSH    HL
        CP      83h
        JP      Z,L0D01
        LD      (IX+00h),A
        INC     IX
        JP      L0D0D

L0D01:  LD      A,(874Fh)
        CALL    L203B
        CALL    L1F75
        CALL    L0D11
L0D0D:  POP     HL
        POP     DE
        POP     BC
        RET

        ; --- START PROC L0D11 ---
L0D11:  LD      IX,87AFh
        LD      B,27h           ; '''
L0D17:  DEC     IX
        LD      (IX+00h),20h    ; ' '
        DJNZ    L0D17
        RET

        ; --- START PROC L0D20 ---
L0D20:  LD      A,08h
        LD      (87CAh),A
        XOR     A
        LD      (87C8h),A
        PUSH    BC
        POP     HL
        LD      C,(HL)
        INC     HL
        LD      B,(HL)
        INC     HL
        LD      A,B
        OR      C
        JP      Z,L0D75
        LD      E,(HL)
        INC     HL
        LD      D,(HL)
        INC     HL
        EX      DE,HL
        CALL    L0CBB
        EX      DE,HL
        LD      A,20h           ; ' '
L0D3F:  CALL    L0CF1
L0D42:  LD      A,(HL)
        INC     HL
        OR      A
        JP      Z,L0D76
        JP      P,L0D3F
        LD      (87C8h),A
        SUB     7Fh             ; ''
        LD      C,A
        CP      0Fh
        JR      NZ,L0D5A
        LD      A,0Fh
        LD      (87CAh),A
L0D5A:  LD      DE,1094h
L0D5D:  LD      A,(DE)
        INC     DE
        OR      A
        JP      P,L0D5D
        DEC     C
        JP      NZ,L0D5D
L0D67:  AND     7Fh             ; ''
        CALL    L0CF1
        LD      A,(DE)
        INC     DE
        OR      A
        JP      P,L0D67
        JP      L0D42

L0D75:  SCF
        ; --- START PROC L0D76 ---
L0D76:  RET

        ; --- START PROC L0D77 ---
L0D77:  LD      HL,(874Eh)
        PUSH    HL
        LD      HL,1F01h
        LD      (874Eh),HL
        LD      HL,0D91h
        PUSH    HL
        LD      HL,(87C2h)
        PUSH    DE
        PUSH    HL
        LD      IX,8788h
        JP      L0CC0

L0D91:  DB      11h
        DB      56h             ; 'V'
        DB      87h
        DB      3Eh             ; '>'
        DB      98h
        DB      12h
        DB      13h
        DB      3Eh             ; '>'
        DB      0A0h
        DB      12h
        DB      13h
        DB      3Eh             ; '>'
        DB      0CDh
        DB      12h
        DB      13h
        DB      3Eh             ; '>'
        DB      8Ah
        DB      12h
        DB      13h
        DB      21h             ; '!'
        DB      88h
        DB      87h
        DB      01h
        DB      05h
        DB      00h
        DB      0EDh
        DB      0A0h
        DB      3Eh             ; '>'
        DB      0Fh
        DB      12h
        DB      13h
        DB      0EAh
        DB      0AAh
        DB      0Dh
        DB      3Eh             ; '>'
        DB      90h
        DB      12h
        DB      21h             ; '!'
        DB      56h             ; 'V'
        DB      87h
        DB      22h             ; '"'
        DB      50h             ; 'P'
        DB      87h
        DB      0CDh
        DB      2Dh             ; '-'
        DB      21h             ; '!'
        DB      0CDh
        DB      11h
        DB      0Dh
        DB      0E1h
        DB      22h             ; '"'
        DB      4Eh             ; 'N'
        DB      87h
        DB      0CDh
        DB      99h
        DB      1Fh
        DB      0C9h
        DB      21h             ; '!'
        DB      0D0h
        DB      0Dh
        DB      0C3h
        DB      0FEh
        DB      0Eh
        DB      "CLOAD"
        DB      00h
        DB      21h             ; '!'
        DB      0DCh
        DB      0Dh
        DB      0C3h
        DB      0FEh
        DB      0Eh
        DB      "CSAVE"
        DB      00h
        DB      21h             ; '!'
        DB      0E8h
        DB      0Dh
        DB      0C3h
        DB      0FEh
        DB      0Eh
        DB      "CLEAR"
        DB      00h
        DB      21h             ; '!'
        DB      0F4h
        DB      0Dh
        DB      0C3h
        DB      0FEh
        DB      0Eh
        DB      "INIT "
        DB      00h
        DB      21h             ; '!'
        DB      00h
        DB      0Eh
        DB      0C3h
        DB      0FEh
        DB      0Eh
        DB      "FOR I=1 TO "
        DB      00h
        DB      21h             ; '!'
        DB      12h
        DB      0Eh
        DB      0C3h
        DB      0FEh
        DB      0Eh
        DB      "GOTO "
        DB      00h
        DB      21h             ; '!'
        DB      1Eh
        DB      0Eh
        DB      0C3h
        DB      0FEh
        DB      0Eh
        DB      "GOSUB "
        DB      00h
        DB      21h             ; '!'
        DB      2Bh             ; '+'
        DB      0Eh
        DB      0C3h
        DB      0FEh
        DB      0Eh
        DB      "RETURN"
        DB      00h
        DB      21h             ; '!'
        DB      38h             ; '8'
        DB      0Eh
        DB      0C3h
        DB      0FEh
        DB      0Eh
        DB      44h             ; 'D'
        DB      49h             ; 'I'
        DB      4Dh             ; 'M'
        DB      20h             ; ' '
        DB      00h
        DB      21h             ; '!'
        DB      43h             ; 'C'
        DB      0Eh
        DB      0C3h
        DB      0FEh
        DB      0Eh
        DB      "LINE "
        DB      00h
        DB      21h             ; '!'
        DB      4Fh             ; 'O'
        DB      0Eh
        DB      0C3h
        DB      0FEh
        DB      0Eh
        DB      "INPUT "
        DB      00h
        DB      21h             ; '!'
        DB      5Ch             ; '\'
        DB      0Eh
        DB      0C3h
        DB      0FEh
        DB      0Eh
        DB      "NEXT I"
        DB      00h
        DB      21h             ; '!'
        DB      69h             ; 'i'
        DB      0Eh
        DB      0C3h
        DB      0FEh
        DB      0Eh
        DB      "DATA "
        DB      00h
        DB      21h             ; '!'
        DB      75h             ; 'u'
        DB      0Eh
        DB      0C3h
        DB      0FEh
        DB      0Eh
        DB      "POKE "
        DB      00h
        DB      21h             ; '!'
        DB      81h
        DB      0Eh
        DB      0C3h
        DB      0FEh
        DB      0Eh
        DB      "RESTORE"
        DB      00h
        DB      21h             ; '!'
        DB      8Fh
        DB      0Eh
        DB      0C3h
        DB      0FEh
        DB      0Eh
        DB      52h             ; 'R'
        DB      55h             ; 'U'
        DB      4Eh             ; 'N'
        DB      00h
        DB      21h             ; '!'
        DB      99h
        DB      0Eh
        DB      0C3h
        DB      0FEh
        DB      0Eh
        DB      "SOUND "
        DB      00h
        DB      21h             ; '!'
        DB      0A6h
        DB      0Eh
        DB      0C3h
        DB      0FEh
        DB      0Eh
        DB      43h             ; 'C'
        DB      48h             ; 'H'
        DB      52h             ; 'R'
        DB      04h
        DB      28h             ; '('
        DB      00h
        DB      21h             ; '!'
        DB      0B2h
        DB      0Eh
        DB      0C3h
        DB      0FEh
        DB      0Eh
        DB      4Ch             ; 'L'
        DB      45h             ; 'E'
        DB      46h             ; 'F'
        DB      54h             ; 'T'
        DB      04h
        DB      28h             ; '('
        DB      00h
        DB      21h             ; '!'
        DB      0BFh
        DB      0Eh
        DB      0C3h
        DB      0FEh
        DB      0Eh
        DB      "RIGHT"
        DB      04h
        DB      28h             ; '('
        DB      00h
        DB      21h             ; '!'
        DB      0CDh
        DB      0Eh
        DB      0C3h
        DB      0FEh
        DB      0Eh
        DB      4Dh             ; 'M'
        DB      49h             ; 'I'
        DB      44h             ; 'D'
        DB      04h
        DB      28h             ; '('
        DB      00h
        DB      21h             ; '!'
        DB      0D9h
        DB      0Eh
        DB      0C3h
        DB      0FEh
        DB      0Eh
        DB      "CURSORX "
        DB      00h
        DB      21h             ; '!'
        DB      0E8h
        DB      0Eh
        DB      0C3h
        DB      0FEh
        DB      0Eh
        DB      "CURSORY "
        DB      00h
        DB      21h             ; '!'
        DB      0F7h
        DB      0Eh
        DB      0C3h
        DB      0FEh
        DB      0Eh
        DB      "SCREEN"
        DB      00h
        DB      7Eh             ; '~'
        DB      0A7h
        DB      0CAh
        DB      95h
        DB      0Ah
        DB      0F7h
        DB      23h             ; '#'
        DB      0C3h
        DB      0FEh
        DB      0Eh
        DB      90h
        DB      0F5h
        DB      3Ah             ; ':'
        DB      1Bh
        DB      88h
        DB      0B7h
        DB      0CAh
        DB      57h             ; 'W'
        DB      0Fh
        DB      0F1h
        DB      0F5h
        DB      0FEh
        DB      09h
        DB      0C2h
        DB      25h             ; '%'
        DB      0Fh
        DB      3Eh             ; '>'
        DB      20h             ; ' '
        DB      0DFh
        DB      3Ah             ; ':'
        DB      1Ah
        DB      88h
        DB      0E6h
        DB      07h
        DB      0C2h
        DB      18h
        DB      0Fh
        DB      0F1h
        DB      0C9h
        DB      0F1h
        DB      0F5h
        DB      0D6h
        DB      0Dh
        DB      0CAh
        DB      38h             ; '8'
        DB      0Fh
        DB      0DAh
        DB      3Bh             ; ';'
        DB      0Fh
        DB      3Ah             ; ':'
        DB      1Ah
        DB      88h
        DB      3Ch             ; '<'
        DB      0FEh
        DB      84h
        DB      0CCh
        DB      48h             ; 'H'
        DB      0Fh
        DB      32h             ; '2'
        DB      1Ah
        DB      88h
        DB      0F1h

        ; --- START PROC L0F3C ---
L0F3C:  JP      L0FDB

        ; --- START PROC L0F3F ---
L0F3F:  XOR     A
        LD      (881Bh),A
        LD      A,(881Ah)
        OR      A
        RET     Z
        LD      A,0Dh
        CALL    L0F3C
        LD      A,0Ah
        CALL    L0F3C
        XOR     A
        LD      (881Ah),A
        RET

L0F57:  DB      0F1h
        DB      0C5h
        DB      0F5h
        DB      0FEh
        DB      20h             ; ' '
        DB      0DAh
        DB      76h             ; 'v'
        DB      0Fh
        DB      3Ah             ; ':'
        DB      1Ch
        DB      88h
        DB      47h             ; 'G'
        DB      3Ah             ; ':'
        DB      25h             ; '%'
        DB      88h
        DB      04h
        DB      0CAh
        DB      72h             ; 'r'
        DB      0Fh
        DB      05h
        DB      0B8h
        DB      0CCh
        DB      95h
        DB      0Fh
        DB      0CAh
        DB      76h             ; 'v'
        DB      0Fh
        DB      3Ch             ; '<'
        DB      32h             ; '2'
        DB      25h             ; '%'
        DB      88h
        DB      0F1h
        DB      0C1h
        DB      0F5h
        DB      0F1h
        DB      0F7h
        DB      0C9h
        DB      0CDh
        DB      22h             ; '"'
        DB      0Ah
        DB      0E6h
        DB      7Fh
        DB      0C9h

        ; --- START PROC L0F82 ---
L0F82:  LD      A,(8825h)
        OR      A
        RET     Z
        JP      L0F92

        ; --- START PROC L0F8A ---
L0F8A:  LD      (HL),00h
        LD      HL,8826h
        JP      L0F95

        ; --- START PROC L0F92 ---
L0F92:  LD      A,83h
        RST     0x18
        ; --- START PROC L0F95 ---
L0F95:  LD      A,(881Bh)
        OR      A
        JP      Z,L0FA1
        XOR     A
        LD      (881Ah),A
        RET

L0FA1:  XOR     A
        LD      (8825h),A
        RET

L0FA6:  DB      32h             ; '2'
        DB      56h             ; 'V'
        DB      87h
        DB      0DBh
        DB      7Fh
        DB      0E6h
        DB      7Fh
        DB      0FEh
        DB      18h
        DB      0CAh
        DB      0B7h
        DB      0Fh
        DB      0AFh
        DB      3Ah             ; ':'
        DB      56h             ; 'V'
        DB      87h
        DB      0C9h
        DB      0DBh
        DB      7Fh
        DB      0E6h
        DB      7Fh
        DB      32h             ; '2'
        DB      18h
        DB      88h
        DB      0FEh
        DB      18h
        DB      20h             ; ' '
        DB      0Ah
        DB      0CDh
        DB      3Ah             ; ':'
        DB      21h             ; '!'
        DB      3Ah             ; ':'
        DB      0B7h
        DB      87h
        DB      0E6h
        DB      7Fh
        DB      0FEh
        DB      18h
        DB      0C3h
        DB      0Bh
        DB      2Fh             ; '/'
        DB      3Ah             ; ':'
        DB      18h
        DB      88h
        DB      0B7h
        DB      0C8h
        DB      0F5h
        DB      0AFh
        DB      32h             ; '2'
        DB      18h
        DB      88h
        DB      0F1h
        DB      0C9h

        ; --- START PROC L0FDB ---
L0FDB:  RET

L0FDC:  DB      3Eh             ; '>'
        DB      3Fh             ; '?'
        DB      0F7h
        DB      3Eh             ; '>'
        DB      20h             ; ' '
        DB      0F7h

        ; --- START PROC L0FE2 ---
L0FE2:  LD      HL,8827h
L0FE5:  CALL    L0A22
        OR      A
        JR      Z,L0FE5
        CP      0Dh
        JP      Z,L0F8A
        RES     7,A
        LD      (HL),A
        LD      (8893h),A
        INC     HL
        JP      L0FE5

L0FFA:  DB      0FFh
        DB      0FFh
        DB      0FFh
        DB      0FFh
        DB      0FFh
        DB      0FFh
        DB      0Dh
        DB      2Fh             ; '/'
        DB      6Eh             ; 'n'
        DB      14h
        DB      0AFh
        DB      2Fh             ; '/'
        DB      0D3h
        DB      15h
        DB      54h             ; 'T'
        DB      17h
        DB      0FCh
        DB      2Ch             ; ','
        DB      83h
        DB      17h
        DB      0EAh
        DB      15h
        DB      92h
        DB      15h
        DB      75h             ; 'u'
        DB      15h
        DB      58h             ; 'X'
        DB      16h
        DB      0F1h
        DB      2Eh             ; '.'
        DB      81h
        DB      15h
        DB      0AEh
        DB      15h
        DB      0D5h
        DB      15h
        DB      0Bh
        DB      2Fh             ; '/'
        DB      3Ch             ; '<'
        DB      16h
        DB      72h             ; 'r'
        DB      16h
        DB      0FEh
        DB      19h
        DB      0CBh
        DB      1Ah
        DB      79h             ; 'y'
        DB      16h
        DB      37h             ; '7'
        DB      2Fh             ; '/'
        DB      1Eh
        DB      14h
        DB      19h
        DB      14h
        DB      68h             ; 'h'
        DB      2Fh             ; '/'
        DB      0A6h
        DB      "!s!c*"
        DB      94h
        DB      2Ah             ; '*'
        DB      0B0h
        DB      2Ah             ; '*'
        DB      0B6h
        DB      2Ah             ; '*'
        DB      0Eh
        DB      2Bh             ; '+'
        DB      14h
        DB      2Bh             ; '+'
        DB      1Ah
        DB      "+++8+E+J+P+n+"
        DB      14h
        DB      2Ch             ; ','
        DB      51h             ; 'Q'
        DB      2Ch             ; ','
        DB      0F0h
        DB      2Ch             ; ','
        DB      9Eh
        DB      2Ah             ; '*'
        DB      0A8h
        DB      2Ah             ; '*'
        DB      0ABh
        DB      2Eh             ; '.'
        DB      49h             ; 'I'
        DB      05h
        DB      05h
        DB      06h
        DB      5Dh             ; ']'
        DB      05h
        DB      0DAh
        DB      87h
        DB      44h             ; 'D'
        DB      2Ah             ; '*'
        DB      0F0h
        DB      19h
        DB      0F6h
        DB      19h
        DB      0C9h
        DB      07h
        DB      0BAh
        DB      08h
        DB      0D9h
        DB      03h
        DB      21h             ; '!'
        DB      08h
        DB      2Bh             ; '+'
        DB      09h
        DB      31h             ; '1'
        DB      09h
        DB      0C4h
        DB      09h
        DB      0D9h
        DB      09h
        DB      0C4h
        DB      1Ah
        DB      8Eh
        DB      29h             ; ')'
        DB      0C4h
        DB      27h             ; '''
        DB      20h             ; ' '
        DB      2Ah             ; '*'
        DB      9Dh
        DB      29h             ; ')'
        DB      7Dh             ; '}'
        DB      2Bh             ; '+'
        DB      93h
        DB      2Bh             ; '+'
        DB      0A9h
        DB      2Bh             ; '+'
        DB      02h
        DB      2Ch             ; ','
        DB      0AEh
        DB      29h             ; ')'
        DB      0BCh
        DB      29h             ; ')'
        DB      0EBh
        DB      29h             ; ')'
        DB      0F4h
        DB      29h             ; ')'
        DB      0C5h
        DB      4Eh             ; 'N'
        DB      44h             ; 'D'
        DB      0C6h
        DB      4Fh             ; 'O'
        DB      52h             ; 'R'
        DB      0CEh
        DB      45h             ; 'E'
        DB      58h             ; 'X'
        DB      54h             ; 'T'
        DB      0C4h
        DB      41h             ; 'A'
        DB      54h             ; 'T'
        DB      41h             ; 'A'
        DB      0C9h
        DB      4Eh             ; 'N'
        DB      50h             ; 'P'
        DB      55h             ; 'U'
        DB      54h             ; 'T'
        DB      0C4h
        DB      49h             ; 'I'
        DB      4Dh             ; 'M'
        DB      0D2h
        DB      45h             ; 'E'
        DB      41h             ; 'A'
        DB      44h             ; 'D'
        DB      0CCh
        DB      45h             ; 'E'
        DB      54h             ; 'T'
        DB      0C7h
        DB      4Fh             ; 'O'
        DB      54h             ; 'T'
        DB      4Fh             ; 'O'
        DB      0D2h
        DB      55h             ; 'U'
        DB      4Eh             ; 'N'
        DB      0C9h
        DB      46h             ; 'F'
        DB      0D2h
        DB      "ESTORE"
        DB      0C7h
        DB      4Fh             ; 'O'
        DB      53h             ; 'S'
        DB      55h             ; 'U'
        DB      42h             ; 'B'
        DB      0D2h
        DB      "ETURN"
        DB      0D2h
        DB      45h             ; 'E'
        DB      4Dh             ; 'M'
        DB      0D3h
        DB      54h             ; 'T'
        DB      4Fh             ; 'O'
        DB      50h             ; 'P'
        DB      0CFh
        DB      4Eh             ; 'N'
        DB      0CCh
        DB      "PRINT"
        DB      0C4h
        DB      45h             ; 'E'
        DB      46h             ; 'F'
        DB      0D0h
        DB      4Fh             ; 'O'
        DB      4Bh             ; 'K'
        DB      45h             ; 'E'
        DB      0D0h
        DB      52h             ; 'R'
        DB      49h             ; 'I'
        DB      4Eh             ; 'N'
        DB      54h             ; 'T'
        DB      0C3h
        DB      4Fh             ; 'O'
        DB      4Eh             ; 'N'
        DB      54h             ; 'T'
        DB      0CCh
        DB      49h             ; 'I'
        DB      53h             ; 'S'
        DB      54h             ; 'T'
        DB      0CCh
        DB      4Ch             ; 'L'
        DB      49h             ; 'I'
        DB      53h             ; 'S'
        DB      54h             ; 'T'
        DB      0C3h
        DB      4Ch             ; 'L'
        DB      45h             ; 'E'
        DB      41h             ; 'A'
        DB      52h             ; 'R'
        DB      0C3h
        DB      4Ch             ; 'L'
        DB      4Fh             ; 'O'
        DB      41h             ; 'A'
        DB      44h             ; 'D'
        DB      0C3h
        DB      53h             ; 'S'
        DB      41h             ; 'A'
        DB      56h             ; 'V'
        DB      45h             ; 'E'
        DB      0D4h
        DB      58h             ; 'X'
        DB      0C7h
        DB      52h             ; 'R'
        DB      0D3h
        DB      "CREEN"
        DB      0CCh
        DB      49h             ; 'I'
        DB      4Eh             ; 'N'
        DB      45h             ; 'E'
        DB      0C4h
        DB      "ISPLAY"
        DB      0D3h
        DB      54h             ; 'T'
        DB      4Fh             ; 'O'
        DB      52h             ; 'R'
        DB      45h             ; 'E'
        DB      0C9h
        DB      4Eh             ; 'N'
        DB      49h             ; 'I'
        DB      54h             ; 'T'
        DB      0C3h
        DB      "URSORX"
        DB      0C3h
        DB      "URSORY"
        DB      0D3h
        DB      "CROLL"
        DB      0D0h
        DB      41h             ; 'A'
        DB      47h             ; 'G'
        DB      45h             ; 'E'
        DB      0C2h
        DB      "RIGHT"
        DB      0D3h
        DB      4Fh             ; 'O'
        DB      55h             ; 'U'
        DB      4Eh             ; 'N'
        DB      44h             ; 'D'
        DB      0C4h
        DB      45h             ; 'E'
        DB      4Ch             ; 'L'
        DB      49h             ; 'I'
        DB      4Dh             ; 'M'
        DB      0D3h
        DB      45h             ; 'E'
        DB      54h             ; 'T'
        DB      45h             ; 'E'
        DB      54h             ; 'T'
        DB      0D3h
        DB      45h             ; 'E'
        DB      54h             ; 'T'
        DB      45h             ; 'E'
        DB      47h             ; 'G'
        DB      0C5h
        DB      54h             ; 'T'
        DB      0C5h
        DB      47h             ; 'G'
        DB      0CEh
        DB      45h             ; 'E'
        DB      57h             ; 'W'
        DB      0D4h
        DB      41h             ; 'A'
        DB      42h             ; 'B'
        DB      28h             ; '('
        DB      0D4h
        DB      4Fh             ; 'O'
        DB      0C6h
        DB      4Eh             ; 'N'
        DB      0D3h
        DB      50h             ; 'P'
        DB      43h             ; 'C'
        DB      28h             ; '('
        DB      0D4h
        DB      48h             ; 'H'
        DB      45h             ; 'E'
        DB      4Eh             ; 'N'
        DB      0CEh
        DB      4Fh             ; 'O'
        DB      54h             ; 'T'
        DB      0D3h
        DB      54h             ; 'T'
        DB      45h             ; 'E'
        DB      50h             ; 'P'
        DB      0ABh
        DB      0ADh
        DB      0AAh
        DB      0AFh
        DB      0FFh
        DB      0C1h
        DB      4Eh             ; 'N'
        DB      44h             ; 'D'
        DB      0CFh
        DB      52h             ; 'R'
        DB      0BEh
        DB      0BDh
        DB      0BCh
        DB      0D3h
        DB      47h             ; 'G'
        DB      4Eh             ; 'N'
        DB      0C9h
        DB      4Eh             ; 'N'
        DB      54h             ; 'T'
        DB      0C1h
        DB      42h             ; 'B'
        DB      53h             ; 'S'
        DB      0D5h
        DB      53h             ; 'S'
        DB      52h             ; 'R'
        DB      0C6h
        DB      52h             ; 'R'
        DB      45h             ; 'E'
        DB      0CCh
        DB      50h             ; 'P'
        DB      4Fh             ; 'O'
        DB      53h             ; 'S'
        DB      0D0h
        DB      4Fh             ; 'O'
        DB      53h             ; 'S'
        DB      0D3h
        DB      51h             ; 'Q'
        DB      52h             ; 'R'
        DB      0D2h
        DB      4Eh             ; 'N'
        DB      44h             ; 'D'
        DB      0CCh
        DB      4Fh             ; 'O'
        DB      47h             ; 'G'
        DB      0C5h
        DB      58h             ; 'X'
        DB      50h             ; 'P'
        DB      0C3h
        DB      4Fh             ; 'O'
        DB      53h             ; 'S'
        DB      0D3h
        DB      49h             ; 'I'
        DB      4Eh             ; 'N'
        DB      0D4h
        DB      41h             ; 'A'
        DB      4Eh             ; 'N'
        DB      0C1h
        DB      54h             ; 'T'
        DB      4Eh             ; 'N'
        DB      0D0h
        DB      45h             ; 'E'
        DB      45h             ; 'E'
        DB      4Bh             ; 'K'
        DB      0CCh
        DB      45h             ; 'E'
        DB      4Eh             ; 'N'
        DB      0D3h
        DB      54h             ; 'T'
        DB      52h             ; 'R'
        DB      04h
        DB      0D6h
        DB      41h             ; 'A'
        DB      4Ch             ; 'L'
        DB      0C1h
        DB      53h             ; 'S'
        DB      43h             ; 'C'
        DB      0D3h
        DB      "TICKX"
        DB      0D3h
        DB      "TICKY"
        DB      0C1h
        DB      "CTION"
        DB      0CBh
        DB      45h             ; 'E'
        DB      59h             ; 'Y'
        DB      0C3h
        DB      48h             ; 'H'
        DB      52h             ; 'R'
        DB      04h
        DB      0CCh
        DB      45h             ; 'E'
        DB      46h             ; 'F'
        DB      54h             ; 'T'
        DB      04h
        DB      0D2h
        DB      49h             ; 'I'
        DB      47h             ; 'G'
        DB      48h             ; 'H'
        DB      54h             ; 'T'
        DB      04h
        DB      0CDh
        DB      49h             ; 'I'
        DB      44h             ; 'D'
        DB      04h
        DB      80h
        DB      79h             ; 'y'
        DB      0B0h
        DB      06h
        DB      79h             ; 'y'
        DB      0B0h
        DB      02h
        DB      7Ch             ; '|'
        DB      1Dh
        DB      04h
        DB      7Ch             ; '|'
        DB      81h
        DB      04h
        DB      7Fh
        DB      0D2h
        DB      07h
        DB      50h             ; 'P'
        DB      6Bh             ; 'k'
        DB      19h
        DB      46h             ; 'F'
        DB      6Ah             ; 'j'
        DB      19h
        DB      " Error"
        DB      00h
        DB      20h             ; ' '
        DB      69h             ; 'i'
        DB      6Eh             ; 'n'
        DB      20h             ; ' '
        DB      00h
        DB      4Fh             ; 'O'
        DB      6Bh             ; 'k'
        DB      83h
        DB      00h
        DB      95h
        DB      "Break"
        DB      00h
        DB      "NFSNRGODFCOVOMULBSDD/0IDTMOSLSSTCNUFMOFN!"
        DB      04h
        DB      00h
        DB      39h             ; '9'
        DB      7Eh             ; '~'
        DB      23h             ; '#'
        DB      0FEh
        DB      81h
        DB      0C0h
        DB      4Eh             ; 'N'
        DB      23h             ; '#'
        DB      46h             ; 'F'
        DB      23h             ; '#'
        DB      0E5h
        DB      60h             ; '`'
        DB      69h             ; 'i'
        DB      0E7h
        DB      01h
        DB      0Dh
        DB      00h
        DB      0E1h
        DB      0C8h
        DB      09h
        DB      0C3h
        DB      3Eh             ; '>'
        DB      12h
        DB      2Ah             ; '*'
        DB      90h
        DB      88h
        DB      22h             ; '"'
        DB      21h             ; '!'
        DB      88h

        ; --- START PROC L125A ---
L125A:  LD      E,02h
        LD      BC,141Eh
        ; --- START PROC L125D ---
L125D:  LD      E,14h
        LD      BC,001Eh
        LD      BC,121Eh
        ; --- START PROC L1263 ---
L1263:  LD      E,12h
        LD      BC,221Eh
        ; --- START PROC L1266 ---
L1266:  LD      E,22h           ; '"'
        LD      BC,0A1Eh
        ; --- START PROC L1269 ---
L1269:  LD      E,0Ah
        LD      BC,241Eh
        ; --- START PROC L126C ---
L126C:  LD      E,24h           ; '$'
        LD      BC,181Eh
        ; --- START PROC L126F ---
L126F:  LD      E,18h
        ; --- START PROC L1271 ---
L1271:  CALL    L2ED1
        LD      A,83h
        RST     0x30
        LD      A,95h
        RST     0x30
        LD      HL,1212h
        LD      D,00h
        ADD     HL,DE
        LD      A,3Fh           ; '?'
        RST     0x18
        LD      A,(HL)
        RST     0x18
        RST     0x10
        RST     0x18
        LD      HL,11FBh
        CALL    L2838
        LD      HL,(8821h)
        LD      DE,0FFFEh
        RST     0x20
        JP      Z,L2FF7
        LD      A,H
        AND     L
        INC     A
        CALL    NZ,L06C1
        LD      A,0C1h
        ; --- START PROC L129E ---
L129E:  POP     BC
        ; --- START PROC L129F ---
L129F:  CALL    L0F3F
        CALL    L0F82
        LD      HL,1207h
        CALL    L2838
        ; --- START PROC L12AB ---
L12AB:  LD      HL,0FFFFh
        LD      (8821h),HL
        CALL    L0FE2
        JP      C,L12AB
        RST     0x10
        INC     A
        DEC     A
        JP      Z,L12AB
        PUSH    AF
        CALL    L1551
        PUSH    DE
        CALL    L135E
        LD      B,A
        POP     DE
        POP     AF
        JP      NC,L1501
        PUSH    DE
        PUSH    BC
        XOR     A
        LD      (8893h),A
        RST     0x10
        OR      A
        PUSH    AF
        CALL    L1339
        JP      C,L12E0
        POP     AF
        PUSH    AF
        JP      Z,L15A9
        OR      A
L12E0:  PUSH    BC
        JP      NC,L12F5
        EX      DE,HL
        LD      HL,(889Dh)
L12E8:  LD      A,(DE)
        LD      (BC),A
        INC     BC
        INC     DE
        RST     0x20
        JP      NZ,L12E8
        LD      H,B
        LD      L,C
        LD      (889Dh),HL
L12F5:  POP     DE
        POP     AF
        JP      Z,L131C
        LD      HL,(889Dh)
        EX      (SP),HL
        POP     BC
        ADD     HL,BC
        PUSH    HL
        CALL    L2E80
        POP     HL
        LD      (889Dh),HL
        EX      DE,HL
        LD      (HL),H
        POP     DE
        INC     HL
        INC     HL
        LD      (HL),E
        INC     HL
        LD      (HL),D
        INC     HL
        LD      DE,8827h
L1314:  LD      A,(DE)
        LD      (HL),A
        INC     HL
        INC     DE
        OR      A
        JP      NZ,L1314
        ; --- START PROC L131C ---
L131C:  CALL    L2EB7
        INC     HL
        EX      DE,HL
L1321:  LD      H,D
        LD      L,E
        LD      A,(HL)
        INC     HL
        OR      (HL)
        JP      Z,L12AB
        INC     HL
        INC     HL
        INC     HL
        XOR     A
L132D:  CP      (HL)
        INC     HL
        JP      NZ,L132D
        EX      DE,HL
        LD      (HL),E
        INC     HL
        LD      (HL),D
        JP      L1321

        ; --- START PROC L1339 ---
L1339:  LD      BC,0000h
        LD      HL,(8823h)
        ; --- START PROC L133F ---
L133F:  LD      (8754h),BC
        LD      B,H
        LD      C,L
        LD      A,(HL)
        INC     HL
        OR      (HL)
        DEC     HL
        RET     Z
        INC     HL
        INC     HL
        LD      A,(HL)
        INC     HL
        LD      H,(HL)
        LD      L,A
        RST     0x20
        LD      H,B
        LD      L,C
        LD      A,(HL)
        INC     HL
        LD      H,(HL)
        LD      L,A
        CCF
        RET     Z
        CCF
        RET     NC
        JP      L133F

        ; --- START PROC L135E ---
L135E:  XOR     A
        LD      (8873h),A
        LD      C,05h
        LD      DE,8827h
L1367:  LD      A,(HL)
        CP      20h             ; ' '
        JP      Z,L13E9
        LD      B,A
        CP      22h             ; '"'
        JP      Z,L1409
        OR      A
        JP      Z,L1410
        LD      A,(8873h)
        OR      A
        LD      A,(HL)
        JP      NZ,L13E9
        CP      3Fh             ; '?'
        LD      A,94h
        JP      Z,L13E9
        LD      A,(HL)
        CP      30h             ; '0'
        JP      C,L1391
        CP      3Ch             ; '<'
        JP      C,L13E9
L1391:  PUSH    DE
        LD      DE,1093h
        PUSH    BC
        LD      BC,13E5h
        PUSH    BC
        LD      B,7Fh           ; ''
        LD      A,(HL)
        CP      61h             ; 'a'
        JP      C,L13AA
        CP      7Bh             ; '{'
        JP      NC,L13AA
        AND     5Fh             ; '_'
        LD      (HL),A
L13AA:  LD      C,(HL)
        EX      DE,HL
L13AC:  INC     HL
        OR      (HL)
        JP      P,L13AC
        INC     B
        LD      A,(HL)
        AND     7Fh             ; ''
        RET     Z
        CP      C
        JP      NZ,L13AC
        EX      DE,HL
        PUSH    HL
L13BC:  INC     DE
        LD      A,(DE)
        OR      A
        JP      M,L13E1
        LD      C,A
        LD      A,B
        CP      8Ch
        JP      Z,L13CE
        CP      88h
        JP      NZ,L13D0
L13CE:  RST     0x10
        DEC     HL
L13D0:  INC     HL
        LD      A,(HL)
        CP      61h             ; 'a'
        JP      C,L13D9
        AND     5Fh             ; '_'
L13D9:  CP      C
        JP      Z,L13BC
        POP     HL
        JP      L13AA

L13E1:  LD      C,B
        POP     AF
        EX      DE,HL
        RET

L13E5:  DB      0EBh
        DB      79h             ; 'y'
        DB      0C1h
        DB      0D1h

L13E9:  INC     HL
        LD      (DE),A
        INC     DE
        INC     C
        SUB     3Ah             ; ':'
        JP      Z,L13F7
        CP      49h             ; 'I'
        JP      NZ,L13FA
L13F7:  LD      (8873h),A
L13FA:  SUB     54h             ; 'T'
        JP      NZ,L1367
        LD      B,A
L1400:  LD      A,(HL)
        OR      A
        JP      Z,L1410
        CP      B
        JP      Z,L13E9
L1409:  INC     HL
        LD      (DE),A
        INC     C
        INC     DE
        JP      L1400

L1410:  LD      HL,8826h
        LD      (DE),A
        INC     DE
        LD      (DE),A
        INC     DE
        LD      (DE),A
        RET

L1419:  DB      3Eh             ; '>'
        DB      01h
        DB      32h             ; '2'
        DB      1Bh
        DB      88h
        DB      0CDh
        DB      51h             ; 'Q'
        DB      15h
        DB      0C0h
        DB      0C1h
        DB      0CDh
        DB      39h             ; '9'
        DB      13h
        DB      0C5h
        DB      0E1h
        DB      "N#F#x"
        DB      0B1h
        DB      0CDh
        DB      47h             ; 'G'
        DB      21h             ; '!'
        DB      0CAh
        DB      9Fh
        DB      12h
        DB      0CDh
        DB      0A6h
        DB      0Fh
        DB      0C5h
        DB      5Eh             ; '^'
        DB      23h             ; '#'
        DB      56h             ; 'V'
        DB      23h             ; '#'
        DB      0E5h
        DB      0EBh
        DB      0CDh
        DB      0BBh
        DB      0Ch
        DB      3Eh             ; '>'
        DB      20h             ; ' '
        DB      0E1h
        DB      0CDh
        DB      0F1h
        DB      0Ch
        DB      7Eh             ; '~'
        DB      23h             ; '#'
        DB      0B7h
        DB      0CAh
        DB      27h             ; '''
        DB      14h
        DB      0F2h
        DB      44h             ; 'D'
        DB      14h
        DB      0D6h
        DB      7Fh
        DB      4Fh             ; 'O'
        DB      11h
        DB      94h
        DB      10h
        DB      1Ah
        DB      13h
        DB      0B7h
        DB      0F2h
        DB      56h             ; 'V'
        DB      14h
        DB      0Dh
        DB      0C2h
        DB      56h             ; 'V'
        DB      14h
        DB      0E6h
        DB      7Fh
        DB      0CDh
        DB      0F1h
        DB      0Ch
        DB      1Ah
        DB      13h
        DB      0B7h
        DB      0F2h
        DB      60h             ; '`'
        DB      14h
        DB      0C3h
        DB      47h             ; 'G'
        DB      14h
        DB      3Eh             ; '>'
        DB      64h             ; 'd'
        DB      32h             ; '2'
        DB      92h
        DB      88h
        DB      0CDh
        DB      0EAh
        DB      15h
        DB      0C1h
        DB      0E5h
        DB      0CDh
        DB      0D3h
        DB      15h
        DB      22h             ; '"'
        DB      8Eh
        DB      88h
        DB      21h             ; '!'
        DB      02h
        DB      00h
        DB      39h             ; '9'
        DB      0CDh
        DB      3Eh             ; '>'
        DB      12h
        DB      0C2h
        DB      9Dh
        DB      14h
        DB      09h
        DB      0D5h
        DB      "+V+^##"
        DB      0E5h
        DB      2Ah             ; '*'
        DB      8Eh
        DB      88h
        DB      0E7h
        DB      0E1h
        DB      0D1h
        DB      0C2h
        DB      82h
        DB      14h
        DB      0D1h
        DB      0F9h
        DB      0Ch
        DB      0D1h
        DB      0EBh
        DB      0Eh
        DB      08h
        DB      0CDh
        DB      8Eh
        DB      2Eh             ; '.'
        DB      0E5h
        DB      2Ah             ; '*'
        DB      8Eh
        DB      88h
        DB      0E3h
        DB      0E5h
        DB      2Ah             ; '*'
        DB      21h             ; '!'
        DB      88h
        DB      0E3h
        DB      0CDh
        DB      3Eh             ; '>'
        DB      18h
        DB      0CFh
        DB      0AFh
        DB      0CDh
        DB      3Bh             ; ';'
        DB      18h
        DB      0E5h
        DB      0CDh
        DB      82h
        DB      05h
        DB      0E1h
        DB      0C5h
        DB      0D5h
        DB      01h
        DB      00h
        DB      81h
        DB      51h             ; 'Q'
        DB      5Ah             ; 'Z'
        DB      7Eh             ; '~'
        DB      0FEh
        DB      0B4h
        DB      3Eh             ; '>'
        DB      01h
        DB      0C2h
        DB      0D4h
        DB      14h
        DB      0D7h
        DB      0CDh
        DB      3Bh             ; ';'
        DB      18h
        DB      0E5h
        DB      0CDh
        DB      82h
        DB      05h
        DB      0EFh
        DB      0E1h
        DB      0C5h
        DB      0D5h
        DB      0F5h
        DB      33h             ; '3'
        DB      0E5h
        DB      2Ah             ; '*'
        DB      95h
        DB      88h
        DB      0E3h
        DB      06h
        DB      81h
        DB      0C5h
        DB      33h             ; '3'
        DB      0CDh
        DB      0B7h
        DB      0Fh
        DB      22h             ; '"'
        DB      95h
        DB      88h
        DB      7Eh             ; '~'
        DB      0FEh
        DB      3Ah             ; ':'
        DB      0CAh
        DB      01h
        DB      15h
        DB      0B7h
        DB      0C2h
        DB      5Ah             ; 'Z'
        DB      12h
        DB      23h             ; '#'
        DB      7Eh             ; '~'
        DB      23h             ; '#'
        DB      0B6h
        DB      0CAh
        DB      15h
        DB      "/#^#V"
        DB      0EBh
        DB      22h             ; '"'
        DB      21h             ; '!'
        DB      88h
        DB      0EBh

        ; --- START PROC L1501 ---
L1501:  RST     0x10
        LD      DE,14E1h
        PUSH    DE
        RET     Z
        SUB     80h
        JP      C,L15EA
        CP      2Eh             ; '.'
        JP      NC,L125A
        RLCA
        LD      C,A
        LD      B,00h
        EX      DE,HL
        LD      HL,1000h
        ADD     HL,BC
        LD      C,(HL)
        INC     HL
        LD      B,(HL)
        PUSH    BC
        EX      DE,HL
        ; --- START PROC L151F ---
L151F:  INC     HL
        LD      A,(HL)
        CP      3Ah             ; ':'
        RET     NC
        CP      20h             ; ' '
        JP      Z,L151F
        CP      30h             ; '0'
        CCF
        INC     A
        DEC     A
        RET

        ; --- START PROC L152F ---
L152F:  RST     0x10
        CALL    L183B
        ; --- START PROC L1533 ---
L1533:  RST     0x28
        JP      M,L154C
        ; --- START PROC L1537 ---
L1537:  LD      A,(88AEh)
        CP      90h
        JP      C,L05DA
        LD      BC,9080h
        LD      DE,0000h
        PUSH    HL
        CALL    L05AF
        POP     HL
        LD      D,C
        RET     Z
        ; --- START PROC L154C ---
L154C:  LD      E,08h
        JP      L1271

        ; --- START PROC L1551 ---
L1551:  DEC     HL
        LD      DE,0000h
L1555:  RST     0x10
        RET     NC
        PUSH    HL
        PUSH    AF
        LD      HL,1998h
        RST     0x20
        JP      C,L1572
        LD      H,D
        LD      L,E
        ADD     HL,DE
        ADD     HL,HL
        ADD     HL,DE
        ADD     HL,HL
        POP     AF
        SUB     30h             ; '0'
        LD      E,A
        LD      D,00h
        ADD     HL,DE
        EX      DE,HL
        POP     HL
        JP      L1555

L1572:  POP     AF
        POP     HL
        RET

        ; --- START PROC L1575 ---
L1575:  JP      Z,L2EB7
        CALL    L2EBB
        LD      BC,14E1h
        JP      L1591

L1581:  DB      0Eh
        DB      03h
        DB      0CDh
        DB      8Eh
        DB      2Eh             ; '.'
        DB      0C1h
        DB      0E5h
        DB      0E5h
        DB      2Ah             ; '*'
        DB      21h             ; '!'
        DB      88h
        DB      0E3h
        DB      3Eh             ; '>'
        DB      8Ch
        DB      0F5h
        DB      33h             ; '3'

L1591:  PUSH    BC
        CALL    L1551
        CALL    L15D5
        INC     HL
        PUSH    HL
        LD      HL,(8821h)
        RST     0x20
        POP     HL
        CALL    C,L133F
        CALL    NC,L1339
        LD      H,B
        LD      L,C
        DEC     HL
        RET     C
        ; --- START PROC L15A9 ---
L15A9:  LD      E,0Eh
        JP      L1271

L15AE:  DB      0C0h
        DB      16h
        DB      0FFh
        DB      0CDh
        DB      3Ah             ; ':'
        DB      12h
        DB      0F9h
        DB      0FEh
        DB      8Ch
        DB      1Eh
        DB      04h
        DB      0C2h
        DB      71h             ; 'q'
        DB      12h
        DB      0E1h
        DB      22h             ; '"'
        DB      21h             ; '!'
        DB      88h
        DB      23h             ; '#'
        DB      7Ch             ; '|'
        DB      0B5h
        DB      0C2h
        DB      0CDh
        DB      15h
        DB      3Ah             ; ':'
        DB      93h
        DB      88h
        DB      0B7h
        DB      0C2h
        DB      9Eh
        DB      12h
        DB      21h             ; '!'
        DB      0E1h
        DB      14h
        DB      0E3h
        DB      3Eh             ; '>'
        DB      0E1h
        DB      01h
        DB      3Ah             ; ':'

        ; --- START PROC L15D5 ---
L15D5:  LD      C,00h
        LD      B,00h
L15D9:  LD      A,C
        LD      C,B
        LD      B,A
L15DC:  LD      A,(HL)
        OR      A
        RET     Z
        CP      B
        RET     Z
        INC     HL
        CP      22h             ; '"'
        JP      Z,L15D9
        JP      L15DC

        ; --- START PROC L15EA ---
L15EA:  CALL    L2D01
        RST     0x08
        CP      L
        PUSH    DE
        LD      A,(8872h)
        PUSH    AF
        CALL    L1850
        POP     AF
        EX      (SP),HL
        LD      (8895h),HL
        RRA
        CALL    L1840
        JP      Z,L1635
        PUSH    HL
        LD      HL,(88ABh)
        PUSH    HL
        INC     HL
        INC     HL
        LD      E,(HL)
        INC     HL
        LD      D,(HL)
        LD      HL,(8823h)
        RST     0x20
        JP      NC,L1624
        LD      HL,(88A1h)
        RST     0x20
        POP     DE
        JP      NC,L162C
        LD      HL,8884h
        RST     0x20
        JP      NC,L162C
        LD      A,0D1h
L1624:  POP     DE
        CALL    L297F
        EX      DE,HL
        CALL    L27D4
L162C:  CALL    L297F
        POP     HL
        CALL    L0591
        POP     HL
        RET

L1635:  PUSH    HL
        CALL    L058E
        POP     DE
        POP     HL
        RET

L163C:  DB      0CDh
        DB      91h
        DB      1Ah
        DB      7Eh             ; '~'
        DB      47h             ; 'G'
        DB      0FEh
        DB      8Ch
        DB      0CAh
        DB      49h             ; 'I'
        DB      16h
        DB      0CFh
        DB      88h
        DB      2Bh             ; '+'
        DB      4Bh             ; 'K'
        DB      0Dh
        DB      78h             ; 'x'
        DB      0CAh
        DB      07h
        DB      15h
        DB      0CDh
        DB      52h             ; 'R'
        DB      15h
        DB      0FEh
        DB      2Ch             ; ','
        DB      0C0h
        DB      0C3h
        DB      4Ah             ; 'J'
        DB      16h
        DB      0CDh
        DB      50h             ; 'P'
        DB      18h
        DB      7Eh             ; '~'
        DB      0FEh
        DB      88h
        DB      0CAh
        DB      64h             ; 'd'
        DB      16h
        DB      0CFh
        DB      0B2h
        DB      2Bh             ; '+'
        DB      0CDh
        DB      3Eh             ; '>'
        DB      18h
        DB      0EFh
        DB      0CAh
        DB      0D5h
        DB      15h
        DB      0D7h
        DB      0DAh
        DB      92h
        DB      15h
        DB      0C3h
        DB      06h
        DB      15h
        DB      3Eh             ; '>'
        DB      01h
        DB      32h             ; '2'
        DB      1Bh
        DB      88h
        DB      2Bh             ; '+'
        DB      0D7h
        DB      0CCh
        DB      92h
        DB      0Fh
        DB      0CAh
        DB      2Ch             ; ','
        DB      17h
        DB      0FEh
        DB      0AEh
        DB      0CAh
        DB      0FDh
        DB      16h
        DB      0FEh
        DB      0B1h
        DB      0CAh
        DB      0FDh
        DB      16h
        DB      0E5h
        DB      0FEh
        DB      2Ch             ; ','
        DB      0CAh
        DB      0D7h
        DB      16h
        DB      0FEh
        DB      3Bh             ; ';'
        DB      0CAh
        DB      27h             ; '''
        DB      17h
        DB      0C1h
        DB      0CDh
        DB      50h             ; 'P'
        DB      18h
        DB      0E5h
        DB      3Ah             ; ':'
        DB      72h             ; 'r'
        DB      88h
        DB      0B7h
        DB      0C2h
        DB      0D0h
        DB      16h
        DB      0CDh
        DB      0D4h
        DB      06h
        DB      0CDh
        DB      0FAh
        DB      27h             ; '''
        DB      36h             ; '6'
        DB      20h             ; ' '
        DB      2Ah             ; '*'
        DB      0ABh
        DB      88h
        DB      3Ah             ; ':'
        DB      1Bh
        DB      88h
        DB      0B7h
        DB      0CAh
        DB      0BBh
        DB      16h
        DB      3Ah             ; ':'
        DB      1Ah
        DB      88h
        DB      86h
        DB      0FEh
        DB      84h
        DB      0C3h
        DB      0C9h
        DB      16h
        DB      3Ah             ; ':'
        DB      1Ch
        DB      88h
        DB      47h             ; 'G'
        DB      3Ch             ; '<'
        DB      0CAh
        DB      0CCh
        DB      16h
        DB      3Ah             ; ':'
        DB      25h             ; '%'
        DB      88h
        DB      86h
        DB      3Dh             ; '='
        DB      0B8h
        DB      0D4h
        DB      92h
        DB      0Fh
        DB      0CDh
        DB      3Bh             ; ';'
        DB      28h             ; '('
        DB      0AFh
        DB      0C4h
        DB      3Bh             ; ';'
        DB      28h             ; '('
        DB      0E1h
        DB      0C3h
        DB      77h             ; 'w'
        DB      16h
        DB      3Ah             ; ':'
        DB      1Bh
        DB      88h
        DB      0B7h
        DB      0CAh
        DB      0E6h
        DB      16h
        DB      3Ah             ; ':'
        DB      1Ah
        DB      88h
        DB      0FEh
        DB      70h             ; 'p'
        DB      0C3h
        DB      0EEh
        DB      16h
        DB      3Ah             ; ':'
        DB      1Dh
        DB      88h
        DB      47h             ; 'G'
        DB      3Ah             ; ':'
        DB      25h             ; '%'
        DB      88h
        DB      0B8h
        DB      0D4h
        DB      92h
        DB      0Fh
        DB      0D2h
        DB      27h             ; '''
        DB      17h
        DB      0D6h
        DB      0Eh
        DB      0D2h
        DB      0F4h
        DB      16h
        DB      2Fh             ; '/'
        DB      0C3h
        DB      20h             ; ' '
        DB      17h
        DB      0F5h
        DB      0CDh
        DB      90h
        DB      1Ah
        DB      0CFh
        DB      29h             ; ')'
        DB      2Bh             ; '+'
        DB      0F1h
        DB      0D6h
        DB      0B1h
        DB      0E5h
        DB      0CAh
        DB      1Bh
        DB      17h
        DB      3Ah             ; ':'
        DB      1Bh
        DB      88h
        DB      0B7h
        DB      0CAh
        DB      18h
        DB      17h
        DB      3Ah             ; ':'
        DB      1Ah
        DB      88h
        DB      0C3h
        DB      1Bh
        DB      17h
        DB      3Ah             ; ':'
        DB      25h             ; '%'
        DB      88h
        DB      2Fh             ; '/'
        DB      83h
        DB      0D2h
        DB      27h             ; '''
        DB      17h
        DB      3Ch             ; '<'
        DB      47h             ; 'G'
        DB      3Eh             ; '>'
        DB      20h             ; ' '
        DB      0DFh
        DB      10h
        DB      0FDh
        DB      0E1h
        DB      0D7h
        DB      0C3h
        DB      7Ch             ; '|'
        DB      16h
        DB      0AFh
        DB      32h             ; '2'
        DB      1Bh
        DB      88h
        DB      0C9h
        DB      "?Redo from start"
        DB      83h
        DB      00h
        DB      3Ah             ; ':'
        DB      94h
        DB      88h
        DB      0B7h
        DB      0C2h
        DB      54h             ; 'T'
        DB      12h
        DB      0C1h
        DB      21h             ; '!'
        DB      31h             ; '1'
        DB      17h
        DB      0CDh
        DB      38h             ; '8'
        DB      28h             ; '('
        DB      0C3h
        DB      0EDh
        DB      2Eh             ; '.'
        DB      0CDh
        DB      73h             ; 's'
        DB      1Ah
        DB      7Eh             ; '~'
        DB      0FEh
        DB      22h             ; '"'
        DB      3Eh             ; '>'
        DB      00h
        DB      0C2h
        DB      69h             ; 'i'
        DB      17h
        DB      0CDh
        DB      0FBh
        DB      27h             ; '''
        DB      0CFh
        DB      3Bh             ; ';'
        DB      0E5h
        DB      0CDh
        DB      3Bh             ; ';'
        DB      28h             ; '('
        DB      3Eh             ; '>'
        DB      0E5h
        DB      3Eh             ; '>'
        DB      01h
        DB      32h             ; '2'
        DB      0CEh
        DB      87h
        DB      0CDh
        DB      0DCh
        DB      0Fh
        DB      0C1h
        DB      0DAh
        DB      12h
        DB      2Fh             ; '/'
        DB      23h             ; '#'
        DB      7Eh             ; '~'
        DB      0B7h
        DB      2Bh             ; '+'
        DB      0C5h
        DB      0CAh
        DB      0D2h
        DB      15h
        DB      36h             ; '6'
        DB      2Ch             ; ','
        DB      0C3h
        DB      88h
        DB      17h
        DB      0E5h
        DB      2Ah             ; '*'
        DB      0A3h
        DB      88h
        DB      0F6h
        DB      0AFh
        DB      32h             ; '2'
        DB      94h
        DB      88h
        DB      0E3h
        DB      01h
        DB      0CFh
        DB      2Ch             ; ','
        DB      0CDh
        DB      01h
        DB      2Dh             ; '-'
        DB      0E3h
        DB      0D5h
        DB      7Eh             ; '~'
        DB      0FEh
        DB      2Ch             ; ','
        DB      0CAh
        DB      0B6h
        DB      17h
        DB      3Ah             ; ':'
        DB      94h
        DB      88h
        DB      0B7h
        DB      0C2h
        DB      1Ah
        DB      18h
        DB      3Eh             ; '>'
        DB      3Fh             ; '?'
        DB      0DFh
        DB      0CDh
        DB      0DCh
        DB      0Fh
        DB      0D1h
        DB      0C1h
        DB      0DAh
        DB      12h
        DB      2Fh             ; '/'
        DB      23h             ; '#'
        DB      7Eh             ; '~'
        DB      2Bh             ; '+'
        DB      0B7h
        DB      0C5h
        DB      0CAh
        DB      0D2h
        DB      15h
        DB      0D5h
        DB      3Ah             ; ':'
        DB      72h             ; 'r'
        DB      88h
        DB      0B7h
        DB      0CAh
        DB      0DEh
        DB      17h
        DB      0D7h
        DB      57h             ; 'W'
        DB      47h             ; 'G'
        DB      0FEh
        DB      22h             ; '"'
        DB      0CAh
        DB      0D2h
        DB      17h
        DB      3Ah             ; ':'
        DB      94h
        DB      88h
        DB      0B7h
        DB      57h             ; 'W'
        DB      0CAh
        DB      0CFh
        DB      17h
        DB      16h
        DB      3Ah             ; ':'
        DB      06h
        DB      2Ch             ; ','
        DB      2Bh             ; '+'
        DB      0CDh
        DB      0FEh
        DB      27h             ; '''
        DB      0EBh
        DB      21h             ; '!'
        DB      0E7h
        DB      17h
        DB      0E3h
        DB      0D5h
        DB      0C3h
        DB      03h
        DB      16h
        DB      0D7h
        DB      0CDh
        DB      39h             ; '9'
        DB      06h
        DB      0E3h
        DB      0CDh
        DB      8Eh
        DB      05h
        DB      0E1h
        DB      2Bh             ; '+'
        DB      0D7h
        DB      0CAh
        DB      0F1h
        DB      17h
        DB      0FEh
        DB      2Ch             ; ','
        DB      0C2h
        DB      43h             ; 'C'
        DB      17h
        DB      0E3h
        DB      2Bh             ; '+'
        DB      0D7h
        DB      0C2h
        DB      8Eh
        DB      17h
        DB      0D1h
        DB      3Ah             ; ':'
        DB      94h
        DB      88h
        DB      0B7h
        DB      0EBh
        DB      0C2h
        DB      06h
        DB      2Fh             ; '/'
        DB      0D5h
        DB      0B6h
        DB      21h             ; '!'
        DB      0Ah
        DB      18h
        DB      0C4h
        DB      38h             ; '8'
        DB      28h             ; '('
        DB      0E1h
        DB      0C9h
        DB      "?Extra ignored"
        DB      13h
        DB      00h
        DB      0CDh
        DB      0D3h
        DB      15h
        DB      0B7h
        DB      0C2h
        DB      32h             ; '2'
        DB      18h
        DB      23h             ; '#'
        DB      7Eh             ; '~'
        DB      23h             ; '#'
        DB      0B6h
        DB      1Eh
        DB      06h
        DB      0CAh
        DB      71h             ; 'q'
        DB      12h
        DB      23h             ; '#'
        DB      5Eh             ; '^'
        DB      23h             ; '#'
        DB      56h             ; 'V'
        DB      0EDh
        DB      53h             ; 'S'
        DB      90h
        DB      88h
        DB      0D7h
        DB      0FEh
        DB      83h
        DB      0C2h
        DB      1Ah
        DB      18h
        DB      0C3h
        DB      0B6h
        DB      17h

        ; --- START PROC L183B ---
L183B:  CALL    L1850
        ; --- START PROC L183E ---
L183E:  OR      37h             ; '7'
        ; --- START PROC L183F ---
L183F:  SCF
        ; --- START PROC L1840 ---
L1840:  LD      A,(8872h)
        ADC     A,A
        OR      A
        RET     PE
        JP      L126F

L1849:  DB      0CFh
        DB      0BDh
        DB      0C3h
        DB      50h             ; 'P'
        DB      18h

        ; --- START PROC L184E ---
L184E:  RST     0x08
        JR      Z,L187C
        ; --- START PROC L1850 ---
L1850:  DEC     HL
        LD      D,00h
        ; --- START PROC L1853 ---
L1853:  PUSH    DE
        LD      C,01h
        CALL    L2E8E
        CALL    L18CA
        LD      (8897h),HL
        ; --- START PROC L185F ---
L185F:  LD      HL,(8897h)
        POP     BC
        LD      A,B
        CP      78h             ; 'x'
        CALL    NC,L183E
        LD      A,(HL)
        LD      (888Ah),HL
        CP      0B5h
        RET     C
        CP      0BFh
        RET     NC
        CP      0BCh
        JP      NC,L18AE
        SUB     0B5h
        LD      E,A
        JP      NZ,L1886
        ; --- START PROC L187C ---
L187C:  ADD     A,(HL)
        JR      L18B9

L187E:  LD      A,(8872h)
        DEC     A
        LD      A,E
        JP      Z,L2917
L1886:  RLCA
        ADD     A,E
        LD      E,A
        LD      HL,11E6h
        LD      D,00h
        ADD     HL,DE
        LD      A,B
        LD      D,(HL)
        CP      D
        RET     NC
        INC     HL
        CALL    L183E
        ; --- START PROC L1897 ---
L1897:  PUSH    BC
        LD      BC,185Fh
        PUSH    BC
        LD      B,E
        LD      C,D
        CALL    L0567
        LD      E,B
        LD      D,C
        LD      C,(HL)
        INC     HL
        LD      B,(HL)
        INC     HL
        PUSH    BC
        LD      HL,(888Ah)
        JP      L1853

        ; --- START PROC L18AE ---
L18AE:  LD      D,00h
L18B0:  SUB     0BCh
        JP      C,L1992
        CP      03h
        JP      NC,L1992
L18B9:  ADD     HL,DE
        CP      01h
        RLA
        XOR     D
        CP      D
        LD      D,A
        JP      C,L125A
        LD      (888Ah),HL
        RST     0x10
        JP      L18B0

        ; --- START PROC L18CA ---
L18CA:  XOR     A
        LD      (8872h),A
        RST     0x10
        JP      Z,L126C
        JP      C,L0639
        CALL    L2F61
        JP      NC,L1915
        CP      0B5h
        JP      Z,L18CA
        CP      2Eh             ; '.'
        JP      Z,L0639
        CP      0B6h
        JP      Z,L1904
        CP      22h             ; '"'
        JP      Z,L27FB
        CP      0B3h
        JP      Z,L19C7
        CP      0B0h
        JP      Z,L1A2D
        SUB     0BFh
        JP      NC,L1926
        ; --- START PROC L18FE ---
L18FE:  CALL    L184E
        RST     0x08
        ADD     HL,HL
        RET

        ; --- START PROC L1904 ---
L1904:  LD      D,7Dh           ; '}'
        CALL    L1853
        LD      HL,(8897h)
        PUSH    HL
        CALL    L055F
        CALL    L183E
        POP     HL
        RET

        ; --- START PROC L1915 ---
L1915:  CALL    L2D01
        PUSH    HL
        EX      DE,HL
        LD      (88ABh),HL
        LD      A,(8872h)
        OR      A
        CALL    Z,L0574
        POP     HL
        RET

        ; --- START PROC L1926 ---
L1926:  LD      B,00h
        RLCA
        LD      C,A
        PUSH    BC
        RST     0x10
        LD      A,C
        CP      31h             ; '1'
        JP      C,L1949
        CALL    L184E
        RST     0x08
        INC     L
        CALL    L183F
        EX      DE,HL
        LD      HL,(88ABh)
        EX      (SP),HL
        PUSH    HL
        EX      DE,HL
        CALL    L1A91
        EX      DE,HL
        EX      (SP),HL
        JP      L1951

L1949:  CALL    L18FE
        EX      (SP),HL
        LD      DE,1910h
        PUSH    DE
L1951:  LD      BC,105Ch
        ADD     HL,BC
        LD      C,(HL)
        INC     HL
        LD      H,(HL)
        LD      L,C
        JP      (HL)

        ; --- START PROC L195A ---
L195A:  DEC     D
        CP      0B6h
        RET     Z
        CP      2Dh             ; '-'
        RET     Z
        INC     D
        CP      2Bh             ; '+'
        RET     Z
        CP      0B5h
        RET     Z
        DEC     HL
        RET

L196A:  DB      0F6h
        DB      0AFh
        DB      0F5h
        DB      0CDh
        DB      3Eh             ; '>'
        DB      18h
        DB      0CDh
        DB      37h             ; '7'
        DB      15h
        DB      0F1h
        DB      0EBh
        DB      0C1h
        DB      0E3h
        DB      0EBh
        DB      0CDh
        DB      77h             ; 'w'
        DB      05h
        DB      0F5h
        DB      0CDh
        DB      37h             ; '7'
        DB      15h
        DB      0F1h
        DB      0C1h
        DB      79h             ; 'y'
        DB      21h             ; '!'
        DB      0E3h
        DB      19h
        DB      0C2h
        DB      8Dh
        DB      19h
        DB      0A3h
        DB      4Fh             ; 'O'
        DB      78h             ; 'x'
        DB      0A2h
        DB      0E9h
        DB      0B3h
        DB      4Fh             ; 'O'
        DB      78h             ; 'x'
        DB      0B2h
        DB      0E9h

        ; --- START PROC L1992 ---
L1992:  LD      HL,19A4h
        LD      A,(8872h)
        RRA
        LD      A,D
        RLA
        LD      E,A
        LD      D,64h           ; 'd'
        LD      A,B
        CP      D
        RET     NC
        JP      L1897

L19A4:  DB      0A6h
        DB      19h
        DB      79h             ; 'y'
        DB      0B7h
        DB      1Fh
        DB      0C1h
        DB      0D1h
        DB      0F5h
        DB      0CDh
        DB      40h             ; '@'
        DB      18h
        DB      21h             ; '!'
        DB      0BDh
        DB      19h
        DB      0E5h
        DB      0CAh
        DB      0AFh
        DB      05h
        DB      0AFh
        DB      32h             ; '2'
        DB      72h             ; 'r'
        DB      88h
        DB      0C3h
        DB      97h
        DB      27h             ; '''
        DB      3Ch             ; '<'
        DB      8Fh
        DB      0C1h
        DB      0A0h
        DB      0C6h
        DB      0FFh
        DB      9Fh
        DB      0C3h
        DB      4Ah             ; 'J'
        DB      05h

        ; --- START PROC L19C7 ---
L19C7:  LD      D,5Ah           ; 'Z'
        CALL    L1853
        CALL    L183E
        CALL    L1537
        LD      A,E
        CPL
        LD      C,A
        LD      A,D
        CPL
        CALL    L19E3
        POP     BC
        JP      L185F

L19DE:  DB      7Dh             ; '}'
        DB      93h
        DB      4Fh             ; 'O'
        DB      7Ch             ; '|'
        DB      9Ah

        ; --- START PROC L19E3 ---
L19E3:  LD      B,C
        LD      D,B
        LD      E,00h
        LD      HL,8872h
        LD      (HL),E
        LD      B,90h
        JP      L054F

L19F0:  DB      3Ah             ; ':'
        DB      1Ah
        DB      88h
        DB      0C3h
        DB      0F9h
        DB      19h
        DB      3Ah             ; ':'
        DB      4Eh             ; 'N'
        DB      87h
        DB      47h             ; 'G'
        DB      0AFh
        DB      0C3h
        DB      0E4h
        DB      19h
        DB      0CDh
        DB      81h
        DB      1Ah
        DB      0CDh
        DB      73h             ; 's'
        DB      1Ah
        DB      01h
        DB      0D3h
        DB      15h
        DB      0C5h
        DB      0D5h
        DB      11h
        DB      00h
        DB      00h
        DB      7Eh             ; '~'
        DB      0FEh
        DB      28h             ; '('
        DB      0C2h
        DB      22h             ; '"'
        DB      1Ah
        DB      0D7h
        DB      0CDh
        DB      01h
        DB      2Dh             ; '-'
        DB      0E5h
        DB      0EBh
        DB      2Bh             ; '+'
        DB      56h             ; 'V'
        DB      2Bh             ; '+'
        DB      5Eh             ; '^'
        DB      0E1h
        DB      0CDh
        DB      3Eh             ; '>'
        DB      18h
        DB      0CFh
        DB      29h             ; ')'
        DB      0CFh
        DB      0BDh
        DB      44h             ; 'D'
        DB      4Dh             ; 'M'
        DB      0E3h
        DB      71h             ; 'q'
        DB      23h             ; '#'
        DB      70h             ; 'p'
        DB      0C3h
        DB      0F4h
        DB      27h             ; '''

        ; --- START PROC L1A2D ---
L1A2D:  CALL    L1A81
        PUSH    DE
        CALL    L18FE
        CALL    L183E
        EX      (SP),HL
        LD      E,(HL)
        INC     HL
        LD      D,(HL)
        INC     HL
        LD      A,D
        OR      E
        JP      Z,L1266
        LD      A,(HL)
        INC     HL
        LD      H,(HL)
        LD      L,A
        PUSH    HL
        LD      HL,(88A5h)
        EX      (SP),HL
        LD      (88A5h),HL
        LD      HL,(88A9h)
        PUSH    HL
        LD      HL,(88A7h)
        PUSH    HL
        LD      HL,88A7h
        PUSH    DE
        CALL    L058E
        POP     HL
        CALL    L183B
        DEC     HL
        RST     0x10
        JP      NZ,L125A
        POP     HL
        LD      (88A7h),HL
        POP     HL
        LD      (88A9h),HL
        POP     HL
        LD      (88A5h),HL
        POP     HL
        RET

L1A73:  DB      0E5h
        DB      2Ah             ; '*'
        DB      21h             ; '!'
        DB      88h
        DB      23h             ; '#'
        DB      7Ch             ; '|'
        DB      0B5h
        DB      0E1h
        DB      0C0h
        DB      1Eh
        DB      16h
        DB      0C3h
        DB      71h             ; 'q'
        DB      12h

        ; --- START PROC L1A81 ---
L1A81:  RST     0x08
        OR      B
        LD      A,80h
        LD      (8892h),A
        OR      (HL)
        LD      C,A
        CALL    L2D06
        JP      L183E

L1A90:  DB      0D7h

        ; --- START PROC L1A91 ---
L1A91:  CALL    L183B
        CALL    L1533
        LD      A,D
        OR      A
        JP      NZ,L154C
        DEC     HL
        RST     0x10
        LD      A,E
        RET

L1AA0:  DB      2Ah             ; '*'
        DB      23h             ; '#'
        DB      88h
        DB      22h             ; '"'
        DB      9Dh
        DB      88h
        DB      21h             ; '!'
        DB      00h
        DB      80h
        DB      "^#V##"
        DB      22h             ; '"'
        DB      23h             ; '#'
        DB      88h
        DB      0EBh
        DB      22h             ; '"'
        DB      1Fh
        DB      88h
        DB      0F9h
        DB      11h
        DB      00h
        DB      0FFh
        DB      19h
        DB      22h             ; '"'
        DB      74h             ; 't'
        DB      88h
        DB      01h
        DB      0E1h
        DB      14h
        DB      0C5h
        DB      0C3h
        DB      0B7h
        DB      2Eh             ; '.'
        DB      0CDh
        DB      37h             ; '7'
        DB      15h
        DB      1Ah
        DB      0C3h
        DB      0F9h
        DB      19h
        DB      0CDh
        DB      3Bh             ; ';'
        DB      18h
        DB      0CDh
        DB      37h             ; '7'
        DB      15h
        DB      0D5h
        DB      0CFh
        DB      2Ch             ; ','
        DB      0CDh
        DB      91h
        DB      1Ah
        DB      0D1h
        DB      12h
        DB      0C9h
        DB      0CDh
        DB      50h             ; 'P'
        DB      18h
        DB      0E5h
        DB      0CDh
        DB      37h             ; '7'
        DB      15h
        DB      0E1h
        DB      0C9h

        ; --- START PROC L1AE3 ---
L1AE3:  LD      A,66h           ; 'f'
        LD      (87C9h),A
        LD      A,00h
        LD      (8746h),A
        LD      A,0FFh
        LD      (8748h),A
        LD      A,08h
        LD      (87CAh),A
        LD      A,00h
        LD      (87CDh),A
        LD      (87CCh),A
        LD      (87CBh),A
        LD      (87C1h),A
        LD      (87D6h),A
        CALL    L1BAC
        LD      HL,8008h
        LD      DE,8058h
        LD      BC,06E0h
        LDIR
        CALL    L1BC9
        CALL    L20F4
        LD      A,8Ch
        LD      (87BFh),A
        LD      A,8Dh
        LD      (87C0h),A
        XOR     A
        LD      (87C6h),A
        LD      (87BCh),A
        LD      (874Eh),A
        LD      A,1Fh
        LD      (874Fh),A
        LD      HL,1B59h
        LD      (8750h),HL
        CALL    L212D
        CALL    L0D77
        LD      IX,87AFh
        LD      B,27h           ; '''
L1B47:  DEC     IX
        LD      (IX+00h),20h    ; ' '
        DJNZ    L1B47
        LD      HL,0001h
        LD      (8752h),HL
        CALL    L1BC9
        RET

L1B59:  DB      8Ch
        DB      8Ah
        DB      80h
        DB      66h             ; 'f'
        DB      20h             ; ' '
        DB      0Fh
        DB      20h             ; ' '
        DB      0Fh
        DB      20h             ; ' '
        DB      0Fh
        DB      20h             ; ' '
        DB      0Fh
        DB      20h             ; ' '
        DB      0Fh
        DB      20h             ; ' '
        DB      0Fh
        DB      20h             ; ' '
        DB      0Fh
        DB      58h             ; 'X'
        DB      0Fh
        DB      3Dh             ; '='
        DB      0Fh
        DB      20h             ; ' '
        DB      0Fh
        DB      20h             ; ' '
        DB      0Fh
        DB      20h             ; ' '
        DB      0Fh
        DB      20h             ; ' '
        DB      0Fh
        DB      20h             ; ' '
        DB      0Fh
        DB      20h             ; ' '
        DB      0Fh
        DB      20h             ; ' '
        DB      0Fh
        DB      20h             ; ' '
        DB      0Fh
        DB      20h             ; ' '
        DB      0Fh
        DB      20h             ; ' '
        DB      0Fh
        DB      20h             ; ' '
        DB      0Fh
        DB      20h             ; ' '
        DB      0Fh
        DB      20h             ; ' '
        DB      0Fh
        DB      20h             ; ' '
        DB      0Fh
        DB      20h             ; ' '
        DB      0Fh
        DB      41h             ; 'A'
        DB      0Fh
        DB      30h             ; '0'
        DB      0Fh
        DB      3Dh             ; '='
        DB      0Fh
        DB      31h             ; '1'
        DB      0Fh
        DB      34h             ; '4'
        DB      0Fh
        DB      30h             ; '0'
        DB      0Fh
        DB      20h             ; ' '
        DB      0Fh
        DB      41h             ; 'A'
        DB      0Fh
        DB      31h             ; '1'
        DB      0Fh
        DB      3Dh             ; '='
        DB      0Fh
        DB      31h             ; '1'
        DB      0Fh
        DB      34h             ; '4'
        DB      0Fh
        DB      31h             ; '1'
        DB      0Fh
        DB      20h             ; ' '
        DB      0Fh
        DB      20h             ; ' '
        DB      0Fh
        DB      90h

        ; --- START PROC L1BAC ---
L1BAC:  LD      L,00h
        LD      H,A
        CALL    L1FF0
        LD      (HL),80h
        LD      A,(87C9h)
        INC     HL
        LD      (HL),A
        LD      A,(87CAh)
        INC     HL
        LD      C,A
        LD      A,20h           ; ' '
        LD      B,27h           ; '''
L1BC2:  LD      (HL),A
        INC     HL
        LD      (HL),C
        INC     HL
        DJNZ    L1BC2
        RET

        ; --- START PROC L1BC9 ---
L1BC9:  LD      HL,0201h
        LD      (874Eh),HL
        CALL    L1F99
        CALL    L2084
        RET

L1BD6:  DB      0E5h
        DB      6Fh             ; 'o'
        DB      0DBh
        DB      7Fh
        DB      0CBh
        DB      7Fh
        DB      7Dh             ; '}'
        DB      0E1h
        DB      0C9h

        ; --- START PROC L1BDF ---
L1BDF:  PUSH    HL
        CALL    L213A
        LD      A,(87B3h)
        OR      A
        JR      Z,L1BF9
        LD      A,(87B7h)
        CP      18h
        JP      Z,L1CBD
        LD      L,15h
        LD      A,(87BDh)
        JP      L1C59

L1BF9:  LD      A,(87B6h)
        OR      A
        JR      Z,L1C0F
        LD      A,(87B7h)
        CP      18h
        JP      Z,L1CB1
        LD      L,07h
        LD      A,(87BDh)
        JP      L1C59

L1C0F:  LD      A,(87B1h)
        CP      0FFh
        JP      Z,L1C2C
        CP      01h
        JP      Z,L1C31
        LD      A,(87B2h)
        CP      0FFh
        JP      Z,L1C36
        CP      01h
        JP      Z,L1C3B
        JP      L1C40

L1C2C:  LD      A,08h
        JP      L1CAF

L1C31:  LD      A,0Ah
        JP      L1CAF

L1C36:  LD      A,09h
        JP      L1CAF

L1C3B:  LD      A,0Bh
        JP      L1CAF

L1C40:  LD      A,(87B7h)
        BIT     7,A
        JP      NZ,L1C69
        LD      L,A
        LD      A,(87BEh)
        BIT     7,A
        LD      A,(87BDh)
        JP      NZ,L1C59
        CP      32h             ; '2'
        JP      L1C5B

L1C59:  CP      08h
L1C5B:  JP      C,L1C9B
        LD      A,80h
        LD      (87BEh),A
        LD      A,L
        SET     7,A
        JP      L1C6E

L1C69:  LD      HL,87BEh
        LD      (HL),00h
L1C6E:  LD      HL,87BDh
        LD      (HL),00h
        CP      0FFh
        JP      Z,L1C9B
        RES     7,A
        LD      L,A
        LD      A,(87B8h)
        CP      00h
        JP      NZ,L1C9F
        LD      A,(87BCh)
        BIT     0,A
        LD      A,L
        JP      Z,L1C9F
        CP      61h             ; 'a'
        JP      C,L1C9F
        CP      7Bh             ; '{'
        JP      NC,L1C9F
        RES     5,A
        JP      L1C9F

L1C9B:  XOR     A
        JP      L1CAF

L1C9F:  CP      80h
        JP      NZ,L1CAC
        LD      A,(87B7h)
        SET     7,A
        JP      L1CAF

L1CAC:  CALL    L1D4F
L1CAF:  POP     HL
        RET

L1CB1:  LD      HL,(874Eh)
        PUSH    HL
        LD      DE,87BFh
        LD      A,1Ch
        JP      L1CC6

L1CBD:  LD      HL,(874Eh)
        PUSH    HL
        LD      DE,87C0h
        LD      A,23h           ; '#'
L1CC6:  LD      (874Eh),A
        LD      A,1Fh
        LD      (874Fh),A
        CALL    L1F99
        LD      IY,8756h
        LD      (8750h),IY
        LD      A,0Fh
        LD      (IY+01h),A
        LD      A,90h
        LD      (IY+02h),A
L1CE3:  CALL    L1D37
        CP      33h             ; '3'
        JP      NC,L1CE3
        LD      (IY+00h),A
        CALL    L212D
        LD      L,00h
        CP      30h             ; '0'
        JP      Z,L1D01
        LD      L,64h           ; 'd'
        CP      31h             ; '1'
        JP      Z,L1D01
        LD      L,0C8h
L1D01:  CALL    L1D37
        LD      (IY+00h),A
        AND     0Fh
        ADD     A,A
        LD      H,A
        ADD     A,A
        ADD     A,A
        ADD     A,H
        ADD     A,L
        JP      C,L1D01
        LD      L,A
        CALL    L212D
L1D16:  CALL    L1D37
        LD      (IY+00h),A
        AND     0Fh
        ADD     A,L
        JP      C,L1D16
        CALL    L212D
        LD      (DE),A
        POP     HL
        LD      (874Eh),HL
        CALL    L1F99
        XOR     A
        LD      (87BEh),A
        LD      (87BDh),A
        JP      L1CAF

        ; --- START PROC L1D37 ---
L1D37:  CALL    L213A
        LD      A,(87B7h)
        BIT     7,A
        JP      Z,L1D37
        RES     7,A
        CP      30h             ; '0'
        JP      C,L1D37
        CP      3Ah             ; ':'
        JP      NC,L1D37
        RET

        ; --- START PROC L1D4F ---
L1D4F:  PUSH    AF
        RES     7,A
        CP      01h
        JP      NZ,L1D89
        POP     AF
        LD      HL,(874Eh)
        PUSH    HL
        LD      A,13h
        LD      (874Eh),A
        LD      A,1Fh
        LD      (874Fh),A
        LD      A,(87BCh)
        INC     A
        LD      (87BCh),A
        BIT     0,A
        LD      HL,1D98h
        JP      Z,L1D78
        LD      HL,1D8Bh
L1D78:  LD      (8750h),HL
        CALL    L212D
        POP     HL
        LD      (874Eh),HL
        CALL    L1F99
        XOR     A
        JP      L1D8A

L1D89:  POP     AF
        ; --- START PROC L1D8A ---
L1D8A:  RET

L1D8B:  DB      98h
        DB      0A0h
        DB      0CDh
        DB      8Ah
        DB      43h             ; 'C'
        DB      0Fh
        DB      41h             ; 'A'
        DB      0Fh
        DB      50h             ; 'P'
        DB      0Fh
        DB      53h             ; 'S'
        DB      0Fh
        DB      90h
        DB      98h
        DB      0A0h
        DB      0CDh
        DB      8Ah
        DB      20h             ; ' '
        DB      0Fh
        DB      20h             ; ' '
        DB      0Fh
        DB      20h             ; ' '
        DB      0Fh
        DB      20h             ; ' '
        DB      0Fh
        DB      90h
        DB      0F5h
        DB      0C5h
        DB      0D5h
        DB      0E5h
        DB      0CBh
        DB      7Fh
        DB      0C2h
        DB      0B4h
        DB      1Dh
        DB      0CDh
        DB      04h
        DB      20h             ; ' '
        DB      0C3h
        DB      2Ah             ; '*'
        DB      1Eh
        DB      0FEh
        DB      0A0h
        DB      0D2h
        DB      0AEh
        DB      1Dh
        DB      0CBh
        DB      0BFh
        DB      21h             ; '!'
        DB      2Ah             ; '*'
        DB      1Eh
        DB      0E5h
        DB      16h
        DB      00h
        DB      5Fh             ; '_'
        DB      87h
        DB      83h
        DB      5Fh             ; '_'
        DB      21h             ; '!'
        DB      0CAh
        DB      1Dh
        DB      19h
        DB      0E9h
        DB      0C3h
        DB      54h             ; 'T'
        DB      21h             ; '!'
        DB      0C3h
        DB      54h             ; 'T'
        DB      21h             ; '!'
        DB      0C3h
        DB      0BFh
        DB      1Eh
        DB      0C3h
        DB      2Fh             ; '/'
        DB      1Eh
        DB      0C3h
        DB      0E5h
        DB      1Eh
        DB      0C3h
        DB      54h             ; 'T'
        DB      21h             ; '!'
        DB      0C3h
        DB      91h
        DB      02h
        DB      0C3h
        DB      9Dh
        DB      02h
        DB      0C3h
        DB      69h             ; 'i'
        DB      1Eh
        DB      0C3h
        DB      99h
        DB      1Eh
        DB      0C3h
        DB      65h             ; 'e'
        DB      1Eh
        DB      0C3h
        DB      0ACh
        DB      1Eh
        DB      0C3h
        DB      0C9h
        DB      1Bh
        DB      0C3h
        DB      2Fh             ; '/'
        DB      1Eh
        DB      0C3h
        DB      54h             ; 'T'
        DB      21h             ; '!'
        DB      0C3h
        DB      54h             ; 'T'
        DB      21h             ; '!'
        DB      0C3h
        DB      01h
        DB      1Fh
        DB      0C3h
        DB      0F4h
        DB      20h             ; ' '
        DB      0C3h
        DB      75h             ; 'u'
        DB      1Fh
        DB      0C3h
        DB      54h             ; 'T'
        DB      21h             ; '!'
        DB      0C3h
        DB      0D9h
        DB      1Fh
        DB      0C3h
        DB      55h             ; 'U'
        DB      21h             ; '!'
        DB      0C3h
        DB      0BAh
        DB      1Fh
        DB      0C3h
        DB      99h
        DB      1Fh
        DB      0C3h
        DB      0AFh
        DB      1Fh
        DB      0C3h
        DB      84h
        DB      20h             ; ' '
        DB      0C3h
        DB      27h             ; '''
        DB      1Fh
        DB      0C3h
        DB      5Dh             ; ']'
        DB      1Fh
        DB      0C3h
        DB      69h             ; 'i'
        DB      1Fh
        DB      0C3h
        DB      47h             ; 'G'
        DB      1Fh
        DB      0C3h
        DB      4Bh             ; 'K'
        DB      1Fh
        DB      0C3h
        DB      0E3h
        DB      1Ah
        DB      0E1h
        DB      0D1h
        DB      0C1h
        DB      0F1h
        DB      0C9h
        DB      3Eh             ; '>'
        DB      01h
        DB      32h             ; '2'
        DB      4Eh             ; 'N'
        DB      87h
        DB      3Ah             ; ':'
        DB      0CCh
        DB      87h
        DB      0B7h
        DB      3Ah             ; ':'
        DB      4Fh             ; 'O'
        DB      87h
        DB      0C2h
        DB      51h             ; 'Q'
        DB      1Eh
        DB      0FEh
        DB      14h
        DB      0DAh
        DB      56h             ; 'V'
        DB      1Eh
        DB      0CDh
        DB      5Dh             ; ']'
        DB      1Fh
        DB      3Eh             ; '>'
        DB      16h
        DB      0CDh
        DB      0ACh
        DB      1Bh
        DB      0CDh
        DB      0F4h
        DB      20h             ; ' '
        DB      0C3h
        DB      5Dh             ; ']'
        DB      1Eh
        DB      0FEh
        DB      16h
        DB      0D2h
        DB      5Ah             ; 'Z'
        DB      1Eh
        DB      3Ch             ; '<'
        DB      32h             ; '2'
        DB      4Fh             ; 'O'
        DB      87h
        DB      0CDh
        DB      99h
        DB      1Fh
        DB      3Ah             ; ':'
        DB      0CDh
        DB      87h
        DB      0B7h
        DB      0CCh
        DB      84h
        DB      20h             ; ' '
        DB      0C9h
        DB      0CDh
        DB      34h             ; '4'
        DB      1Eh
        DB      0C9h
        DB      3Ah             ; ':'
        DB      0CCh
        DB      87h
        DB      0B7h
        DB      3Ah             ; ':'
        DB      4Fh             ; 'O'
        DB      87h
        DB      0C2h
        DB      86h
        DB      1Eh
        DB      0FEh
        DB      03h
        DB      0D2h
        DB      8Ah
        DB      1Eh
        DB      0CDh
        DB      69h             ; 'i'
        DB      1Fh
        DB      3Eh             ; '>'
        DB      00h
        DB      0CDh
        DB      0ACh
        DB      1Bh
        DB      0CDh
        DB      0F4h
        DB      20h             ; ' '
        DB      0C3h
        DB      98h
        DB      1Eh
        DB      0B7h
        DB      0CAh
        DB      98h
        DB      1Eh
        DB      3Dh             ; '='
        DB      32h             ; '2'
        DB      4Fh             ; 'O'
        DB      87h
        DB      0CDh
        DB      99h
        DB      1Fh
        DB      3Ah             ; ':'
        DB      0CDh
        DB      87h
        DB      0B7h
        DB      0CCh
        DB      84h
        DB      20h             ; ' '
        DB      0C9h
        DB      3Ah             ; ':'
        DB      4Eh             ; 'N'
        DB      87h
        DB      0FEh
        DB      02h
        DB      0DAh
        DB      0ABh
        DB      1Eh
        DB      3Dh             ; '='
        DB      32h             ; '2'
        DB      4Eh             ; 'N'
        DB      87h
        DB      0CDh
        DB      99h
        DB      1Fh
        DB      0CDh
        DB      84h
        DB      20h             ; ' '
        DB      0C9h
        DB      3Ah             ; ':'
        DB      4Eh             ; 'N'
        DB      87h
        DB      0FEh
        DB      27h             ; '''
        DB      0D2h
        DB      0BEh
        DB      1Eh
        DB      3Ch             ; '<'
        DB      32h             ; '2'
        DB      4Eh             ; 'N'
        DB      87h
        DB      0CDh
        DB      99h
        DB      1Fh
        DB      0CDh
        DB      84h
        DB      20h             ; ' '
        DB      0C9h
        DB      2Ah             ; '*'
        DB      4Eh             ; 'N'
        DB      87h
        DB      3Eh             ; '>'
        DB      01h
        DB      0BDh
        DB      0D2h
        DB      0E4h
        DB      1Eh
        DB      0E5h
        DB      0CDh
        DB      0F0h
        DB      1Fh
        DB      0C1h
        DB      0E5h
        DB      0D1h
        DB      1Bh
        DB      1Bh
        DB      3Eh             ; '>'
        DB      28h             ; '('
        DB      91h
        DB      87h
        DB      4Fh             ; 'O'
        DB      06h
        DB      00h
        DB      0EDh
        DB      0B0h
        DB      2Bh             ; '+'
        DB      2Bh             ; '+'
        DB      36h             ; '6'
        DB      20h             ; ' '
        DB      0CDh
        DB      75h             ; 'u'
        DB      1Fh
        DB      0CDh
        DB      99h
        DB      1Eh
        DB      0C9h
        DB      2Ah             ; '*'
        DB      4Eh             ; 'N'
        DB      87h
        DB      3Eh             ; '>'
        DB      28h             ; '('
        DB      95h
        DB      0F5h
        DB      0CDh
        DB      0F0h
        DB      1Fh
        DB      0C1h
        DB      3Ah             ; ':'
        DB      0CAh
        DB      87h
        DB      "6 #w#"
        DB      10h
        DB      0F9h
        DB      0CDh
        DB      75h             ; 'u'
        DB      1Fh
        DB      0CDh
        DB      99h
        DB      1Fh
        DB      0C9h
        DB      2Ah             ; '*'
        DB      4Eh             ; 'N'
        DB      87h
        DB      3Eh             ; '>'
        DB      26h             ; '&'
        DB      0BDh
        DB      0DAh
        DB      26h             ; '&'
        DB      1Fh
        DB      0E5h
        DB      6Fh             ; 'o'
        DB      0CDh
        DB      0F0h
        DB      1Fh
        DB      0C1h
        DB      23h             ; '#'
        DB      0E5h
        DB      0D1h
        DB      13h
        DB      13h
        DB      3Eh             ; '>'
        DB      27h             ; '''
        DB      91h
        DB      87h
        DB      4Fh             ; 'O'
        DB      06h
        DB      00h
        DB      0EDh
        DB      0B8h
        DB      3Eh             ; '>'
        DB      20h             ; ' '
        DB      0CDh
        DB      04h
        DB      20h             ; ' '
        DB      0CDh
        DB      99h
        DB      1Eh
        DB      0C9h
        DB      3Ah             ; ':'
        DB      4Fh             ; 'O'
        DB      87h
        DB      67h             ; 'g'
        DB      2Eh             ; '.'
        DB      00h
        DB      0CDh
        DB      0F0h
        DB      1Fh
        DB      11h
        DB      08h
        DB      80h
        DB      0A7h
        DB      0EDh
        DB      52h             ; 'R'
        DB      0E5h
        DB      0C1h
        DB      21h             ; '!'
        DB      58h             ; 'X'
        DB      80h
        DB      0EDh
        DB      0B0h
        DB      3Ah             ; ':'
        DB      4Fh             ; 'O'
        DB      87h
        DB      0CDh
        DB      0ACh
        DB      1Bh
        DB      0CDh
        DB      0F4h
        DB      20h             ; ' '
        DB      0C9h
        DB      0AFh
        DB      0C3h
        DB      4Eh             ; 'N'
        DB      1Fh
        DB      3Ah             ; ':'
        DB      4Fh             ; 'O'
        DB      87h
        DB      0F5h
        DB      0CDh
        DB      0ACh
        DB      1Bh
        DB      0F1h
        DB      3Ch             ; '<'
        DB      0FEh
        DB      17h
        DB      0C2h
        DB      4Eh             ; 'N'
        DB      1Fh
        DB      0CDh
        DB      0F4h
        DB      20h             ; ' '
        DB      0C9h
        DB      21h             ; '!'
        DB      58h             ; 'X'
        DB      80h
        DB      11h
        DB      08h
        DB      80h
        DB      01h
        DB      0E0h
        DB      06h
        DB      0EDh
        DB      0B0h
        DB      0C9h
        DB      21h             ; '!'
        DB      0E8h
        DB      86h
        DB      11h
        DB      38h             ; '8'
        DB      87h
        DB      01h
        DB      0E0h
        DB      06h
        DB      0EDh
        DB      0B8h
        DB      0C9h

        ; --- START PROC L1F75 ---
L1F75:  LD      HL,(874Eh)
        PUSH    HL
        LD      L,00h
        LD      (874Eh),HL
        CALL    L1FF0
        PUSH    HL
        CALL    L1FAF
        POP     HL
        LD      (8750h),HL
        LD      DE,0050h
        ADD     HL,DE
        LD      A,(HL)
        LD      (HL),90h
        CALL    L212D
        LD      (HL),A
        POP     HL
        LD      (874Eh),HL
        RET

        ; --- START PROC L1F99 ---
L1F99:  LD      A,(87CDh)
        OR      A
        JP      NZ,L1FAF
        LD      HL,1FAAh
        ; --- START PROC L1FA3 ---
L1FA3:  LD      (8750h),HL
        CALL    L212D
        RET

L1FAA:  DB      8Ah
        DB      98h
        DB      0A0h
        DB      0DDh
        DB      90h

        ; --- START PROC L1FAF ---
L1FAF:  LD      HL,1FB5h
        JP      L1FA3

L1FB5:  DB      98h
        DB      0A0h
        DB      0CDh
        DB      8Ah
        DB      90h
        DB      2Ah             ; '*'
        DB      4Eh             ; 'N'
        DB      87h
        DB      0E5h
        DB      21h             ; '!'
        DB      00h
        DB      1Fh
        DB      22h             ; '"'
        DB      4Eh             ; 'N'
        DB      87h
        DB      21h             ; '!'
        DB      0D2h
        DB      1Fh
        DB      0CDh
        DB      0A3h
        DB      1Fh
        DB      0E1h
        DB      22h             ; '"'
        DB      4Eh             ; 'N'
        DB      87h
        DB      0CDh
        DB      99h
        DB      1Fh
        DB      0C9h
        DB      98h
        DB      0A0h
        DB      0CDh
        DB      8Ah
        DB      81h
        DB      00h
        DB      90h
        DB      2Ah             ; '*'
        DB      4Eh             ; 'N'
        DB      87h
        DB      0E5h
        DB      21h             ; '!'
        DB      00h
        DB      1Fh
        DB      22h             ; '"'
        DB      4Eh             ; 'N'
        DB      87h
        DB      21h             ; '!'
        DB      0E9h
        DB      1Fh
        DB      0C3h
        DB      0C7h
        DB      1Fh
        DB      98h
        DB      0A0h
        DB      0CDh
        DB      8Ah
        DB      80h
        DB      66h             ; 'f'
        DB      90h

        ; --- START PROC L1FF0 ---
L1FF0:  PUSH    HL
        POP     BC
        LD      A,H
        ADD     A,A
        LD      E,A
        LD      D,00h
        LD      HL,3158h
        ADD     HL,DE
        LD      A,(HL)
        INC     HL
        LD      H,(HL)
        LD      L,A
        LD      B,00h
        ADD     HL,BC
        ADD     HL,BC
        RET

        ; Entry Point
        ; --- START PROC L2004 ---
L2004:  LD      HL,87CBh
        OR      (HL)
        PUSH    AF
        LD      HL,(874Eh)
        CALL    L1FF0
        LD      A,(87CAh)
        POP     BC
        LD      (HL),B
        INC     HL
        LD      (HL),A
        LD      A,(87CDh)
        OR      A
        CALL    Z,L1F75
        LD      A,(874Eh)
        CP      27h             ; '''
        JP      NC,L202C
        INC     A
        LD      (874Eh),A
        JP      L2033

L202C:  LD      A,(87CDh)
        OR      A
        CALL    Z,L1F99
L2033:  LD      A,(87CDh)
        OR      A
        CALL    Z,L2084
        RET

        ; --- START PROC L203B ---
L203B:  LD      HL,(874Eh)
        LD      H,A
        LD      L,01h
        CALL    L1FF0
        LD      DE,8788h
        EX      DE,HL
        LD      BC,0027h
L204B:  LDI
        LD      A,(87CAh)
        LD      (DE),A
        INC     DE
        JP      PE,L204B
        LD      A,(87C8h)
        CP      0A9h
        JP      Z,L2068
        CP      0AAh
        JP      Z,L2068
L2062:  LD      A,08h
        LD      (87CAh),A
        RET

L2068:  LD      B,05h
        EX      DE,HL
        DEC     HL
        DEC     HL
        DEC     HL
        NOP
L206F:  DEC     HL
        DEC     HL
        LD      (HL),0Fh
        DEC     HL
        DEC     HL
        LD      (HL),0Fh
        DEC     HL
        DEC     HL
        LD      (HL),08h
        DEC     HL
        DEC     HL
        LD      (HL),08h
        DJNZ    L206F
        JP      L2062

        ; --- START PROC L2084 ---
L2084:  LD      A,(87CDh)
        OR      A
        RET     NZ
        LD      HL,(874Eh)
        LD      B,L
        LD      C,H
        PUSH    HL
        LD      A,1Fh
        LD      (874Fh),A
        LD      A,0Ah
        LD      (874Eh),A
        PUSH    BC
        LD      DE,8756h
        LD      (8750h),DE
        LD      HL,20E1h
        LD      BC,0013h
        LDIR
        POP     BC
        LD      A,B
        CALL    L211F
        LD      IY,8756h
        ADD     A,30h           ; '0'
        LD      (IY+06h),A
        LD      A,B
        CP      00h
        JP      Z,L20C2
        ADD     A,30h           ; '0'
        LD      (IY+04h),A
L20C2:  LD      A,C
        CALL    L211F
        ADD     A,30h           ; '0'
        LD      (IY+10h),A
        LD      A,B
        CP      00h
        JP      Z,L20D6
        ADD     A,30h           ; '0'
        LD      (IY+0Eh),A
L20D6:  CALL    L212D
        POP     HL
        LD      (874Eh),HL
        CALL    L1F99
        RET

L20E1:  DB      98h
        DB      0A0h
        DB      0CDh
        DB      8Ah
        DB      20h             ; ' '
        DB      0Fh
        DB      20h             ; ' '
        DB      0Fh
        DB      20h             ; ' '
        DB      0Fh
        DB      59h             ; 'Y'
        DB      0Fh
        DB      3Dh             ; '='
        DB      0Fh
        DB      20h             ; ' '
        DB      0Fh
        DB      20h             ; ' '
        DB      0Fh
        DB      90h

        ; --- START PROC L20F4 ---
L20F4:  LD      HL,(874Eh)
        PUSH    HL
        LD      HL,0000h
        LD      (874Eh),HL
        LD      HL,8004h
        LD      (8750h),HL
        LD      (HL),98h
        INC     HL
        LD      (HL),0A0h
        INC     HL
        LD      (HL),0CDh
        INC     HL
        LD      (HL),8Ah
        LD      A,90h
        LD      (8738h),A
        CALL    L212D
        POP     HL
        LD      (874Eh),HL
        CALL    L1F99
        RET

        ; --- START PROC L211F ---
L211F:  LD      B,00h
L2121:  CP      0Ah
        JP      C,L212C
        SUB     0Ah
        INC     B
        JP      L2121

        ; --- START PROC L212C ---
L212C:  RET

        ; --- START PROC L212D ---
L212D:  PUSH    AF
        LD      A,0C0h
        LD      (87BBh),A
        HALT
        XOR     A
        LD      (87BBh),A
        POP     AF
        RET

        ; --- START PROC L213A ---
L213A:  PUSH    AF
        LD      A,01h
        LD      (87BBh),A
        HALT
        XOR     A
        LD      (87BBh),A
        POP     AF
        RET

L2147:  DB      0F5h
        DB      3Eh             ; '>'
        DB      83h
        DB      0CDh
        DB      0F1h
        DB      0Ch
        DB      3Eh             ; '>'
        DB      83h
        DB      0CDh
        DB      0A5h
        DB      1Dh
        DB      0F1h
        DB      0C9h
        DB      0C9h
        DB      3Eh             ; '>'
        DB      00h
        DB      32h             ; '2'
        DB      0CDh
        DB      87h
        DB      32h             ; '2'
        DB      0CCh
        DB      87h
        DB      32h             ; '2'
        DB      0CBh
        DB      87h
        DB      32h             ; '2'
        DB      0C1h
        DB      87h
        DB      3Eh             ; '>'
        DB      0EEh
        DB      32h             ; '2'
        DB      0CAh
        DB      87h
        DB      3Eh             ; '>'
        DB      7Fh
        DB      0CDh
        DB      04h
        DB      20h             ; ' '
        DB      3Eh             ; '>'
        DB      08h
        DB      32h             ; '2'
        DB      0CAh
        DB      87h
        DB      0C9h
        DB      0FEh
        DB      4Dh             ; 'M'
        DB      28h             ; '('
        DB      13h
        DB      0FEh
        DB      53h             ; 'S'
        DB      28h             ; '('
        DB      0Fh
        DB      0FEh
        DB      0B7h
        DB      28h             ; '('
        DB      0Bh
        DB      0FEh
        DB      58h             ; 'X'
        DB      28h             ; '('
        DB      07h
        DB      0FEh
        DB      4Ch             ; 'L'
        DB      0CAh
        DB      0BBh
        DB      23h             ; '#'
        DB      18h
        DB      02h
        DB      23h             ; '#'
        DB      01h
        DB      3Eh             ; '>'
        DB      20h             ; ' '
        DB      32h             ; '2'
        DB      88h
        DB      87h
        DB      0CDh
        DB      06h
        DB      23h             ; '#'
        DB      0CDh
        DB      0C2h
        DB      23h             ; '#'
        DB      0E5h
        DB      0CDh
        DB      21h             ; '!'
        DB      25h             ; '%'

        ; Entry Point
        ; --- START PROC L219B ---
L219B:  CALL    L2564
        CALL    L26A1
        CALL    L2511
        POP     HL
        RET

L21A6:  DB      0FEh
        DB      0B7h
        DB      32h             ; '2'
        DB      8Fh
        DB      87h
        DB      20h             ; ' '
        DB      01h
        DB      23h             ; '#'
        DB      32h             ; '2'
        DB      88h
        DB      87h
        DB      0FEh
        DB      41h             ; 'A'
        DB      28h             ; '('
        DB      05h
        DB      0D6h
        DB      94h
        DB      28h             ; '('
        DB      04h
        DB      3Eh             ; '>'
        DB      23h             ; '#'
        DB      0AFh
        DB      01h
        DB      2Fh             ; '/'
        DB      23h             ; '#'
        DB      0FEh
        DB      01h
        DB      0F5h
        DB      3Ah             ; ':'
        DB      0D6h
        DB      87h
        DB      0E6h
        DB      0Fh
        DB      32h             ; '2'
        DB      0D6h
        DB      87h
        DB      0CDh
        DB      0FFh
        DB      22h             ; '"'
        DB      0CDh
        DB      48h             ; 'H'
        DB      24h             ; '$'
        DB      3Ah             ; ':'
        DB      0D6h
        DB      87h
        DB      0CBh
        DB      47h             ; 'G'
        DB      20h             ; ' '
        DB      06h
        DB      21h             ; '!'
        DB      0D6h
        DB      22h             ; '"'
        DB      0CDh
        DB      38h             ; '8'
        DB      28h             ; '('
        DB      0CDh
        DB      0ADh
        DB      26h             ; '&'

        ; Entry Point
        ; --- START PROC Carga_Cabecera ---
Carga_Cabecera:  
		CALL    L2320
        JR      NC,L21FF
        LD      HL,8791h
        CALL    L234C
        JR      Z,L2212
        LD      HL,2364h
        CALL    L236A
L21F3:  LD      B,0Ah
L21F5:  CALL    L2646
        OR      A
        JR      NZ,L21F3
        DJNZ    L21F5
        JR      Carga_Cabecera

L21FF:  CALL    L029D
        LD      A,81h
        CALL    L2391
        LD      HL,22D9h
        CALL    L2838
        CALL    L0291
        JR      Carga_Cabecera

L2212:  LD      HL,235Dh
        CALL    L236A
        LD      A,(8790h)
        CP      20h             ; ' '
        JR      NZ,L2233
        LD      A,(8788h)
        CP      41h             ; 'A'
        JR      Z,L2233
        POP     AF
        LD      (88ABh),A
        CALL    C,L2EAC
        LD      A,(88ABh)
        CP      01h
        PUSH    AF
L2233:  CALL    L2490
        POP     AF
		
        ; Entry Point
        ; --- START PROC Carga_Programa ---
Carga_Programa:
		CALL    L2583
        CALL    L26B8
        JR      NZ,L225B
        LD      A,C
        OR      A
        LD      A,(87D6h)
        JR      Z,L227A
        AND     0F0h
        JR      NZ,L2269
L224A:  CALL    L2511
        LD      A,87h
        CALL    L2391
        LD      HL,1207h
        CALL    L2838
        JP      L131C

L225B:  LD      HL,87D6h
        SET     4,(HL)
        CALL    L2511
        LD      DE,000Ch
        JP      L1271

L2269:  CALL    L2511
        LD      A,81h
        CALL    L2391
        LD      HL,22F6h
        CALL    L2838
        JP      L129E

L227A:  BIT     3,A
        JR      Z,L2282
        AND     0F0h
        JR      NZ,L2269
L2282:  LD      A,(8790h)
        CP      4Dh             ; 'M'
        JR      Z,L229F
        CP      20h             ; ' '
        JR      NZ,L22D2
        LD      A,(87D6h)
        AND     0F0h
        JR      NZ,L2269
        LD      A,87h
        CALL    L2391
        CALL    L23A3
        LD      (889Dh),HL
L229F:  LD      HL,8827h
        LD      A,(HL)
        OR      A
        JR      Z,L22AC
        CP      30h             ; '0'
        JR      Z,L22B3
        JR      L22C9

L22AC:  LD      DE,8798h
        LD      A,(DE)
        OR      A
        JR      NZ,L22BC
L22B3:  LD      A,(8790h)
        CP      4Dh             ; 'M'
        JR      Z,L22D2
        JR      L224A

L22BC:  LD      HL,8827h
        PUSH    HL
        LD      B,05h
L22C2:  LD      A,(DE)
        LD      (HL),A
        INC     DE
        INC     HL
        DJNZ    L22C2
        LD      A,0E5h
L22C9:  PUSH    HL
        CALL    L2511
        DEC     A
        POP     HL
        JP      L1575

L22D2:  CALL    L2511
        RET

L22D6:  DB      9Dh
        DB      8Ch
        DB      00h
        DB      "Bad label - reposition tape"
        DB      8Dh
        DB      00h
        DB      "Bad file"
        DB      00h
        DB      0AFh
        DB      32h             ; '2'
        DB      89h
        DB      87h
        DB      2Bh             ; '+'
        DB      0D7h
        DB      0C8h
        DB      0CDh
        DB      02h
        DB      25h             ; '%'
        DB      0E5h
        DB      41h             ; 'A'
        DB      0Eh
        DB      06h
        DB      21h             ; '!'
        DB      89h
        DB      87h
        DB      1Ah
        DB      77h             ; 'w'
        DB      23h             ; '#'
        DB      13h
        DB      0Dh
        DB      28h             ; '('
        DB      07h
        DB      10h
        DB      0F7h
        DB      41h             ; 'A'
        DB      36h             ; '6'
        DB      00h
        DB      10h
        DB      0FCh
        DB      0E1h
        DB      0C9h

        ; --- START PROC L2320 ---
L2320:  CALL    L273D
L2323:  LD      B,20h           ; ' '
L2325:  CALL    L2646
        JR      NC,L2323
        CP      0FFh
        JR      NZ,L2323
        DJNZ    L2325
        CALL    L26F4
L2333:  LD      B,0Ah
L2335:  CALL    L2646
        SUB     0D3h
        JR      NZ,L2333
        DJNZ    L2335
        LD      HL,8790h
        LD      B,16h
L2343:  CALL    L2646
        RET     NC
        LD      (HL),A
        INC     HL
        DJNZ    L2343
        RET

        ; --- START PROC L234C ---
L234C:  LD      BC,8789h
        LD      E,06h
        LD      A,(BC)
        OR      A
        RET     Z
L2354:  LD      A,(BC)
        CP      (HL)
        INC     HL
        INC     BC
        RET     NZ
        DEC     E
        JR      NZ,L2354
        RET

L235D:  DB      "Found:"
        DB      00h
        DB      "Skip:"
        DB      00h

        ; --- START PROC L236A ---
L236A:  PUSH    DE
        PUSH    AF
        CALL    L029D
        LD      A,83h
        CALL    L2391
        LD      A,(87D6h)
        BIT     0,A
        JR      NZ,L238B
        CALL    L2838
        LD      HL,8791h
        LD      B,06h
L2383:  LD      A,(HL)
        INC     HL
        RST     0x18
        DJNZ    L2383
        CALL    L0F92
L238B:  CALL    L0291
        POP     AF
        POP     DE
        RET

        ; --- START PROC L2391 ---
L2391:  PUSH    AF
        LD      A,(87D6h)
        BIT     1,A
        JR      NZ,L23A1
        POP     AF
        PUSH    AF
        LD      (87B0h),A
        CALL    L213A
L23A1:  POP     AF
        RET

        ; --- START PROC L23A3 ---
L23A3:  LD      DE,(8823h)
L23A7:  LD      H,D
        LD      L,E
        LD      A,(HL)
        INC     HL
        OR      (HL)
        INC     HL
        RET     Z
        INC     HL
        INC     HL
        XOR     A
L23B1:  CP      (HL)
        INC     HL
        JR      NZ,L23B1
        EX      DE,HL
        LD      (HL),E
        INC     HL
        LD      (HL),D
        JR      L23A7

L23BB:  DB      23h             ; '#'
        DB      06h
        DB      05h
        DB      0CDh
        DB      0BBh
        DB      26h             ; '&'
        DB      0C9h
        DB      0E5h
        DB      21h             ; '!'
        DB      8Fh
        DB      87h
        DB      0AFh
        DB      06h
        DB      09h
        DB      77h             ; 'w'
        DB      23h             ; '#'
        DB      10h
        DB      0FCh
        DB      3Ah             ; ':'
        DB      88h
        DB      87h
        DB      0FEh
        DB      20h             ; ' '
        DB      20h             ; ' '
        DB      12h
        DB      2Ah             ; '*'
        DB      23h             ; '#'
        DB      88h
        DB      22h             ; '"'
        DB      98h
        DB      87h
        DB      0EBh
        DB      2Ah             ; '*'
        DB      9Dh
        DB      88h
        DB      0B7h
        DB      0EDh
        DB      52h             ; 'R'
        DB      22h             ; '"'
        DB      9Ah
        DB      87h
        DB      18h
        DB      4Bh             ; 'K'
        DB      0FEh
        DB      4Dh             ; 'M'
        DB      20h             ; ' '
        DB      19h
        DB      0E1h
        DB      0CFh
        DB      2Ch             ; ','
        DB      0CDh
        DB      3Bh             ; ';'
        DB      18h
        DB      0CDh
        DB      37h             ; '7'
        DB      15h
        DB      0EDh
        DB      53h             ; 'S'
        DB      98h
        DB      87h
        DB      0CFh
        DB      2Ch             ; ','
        DB      0CDh
        DB      3Bh             ; ';'
        DB      18h
        DB      0CDh
        DB      37h             ; '7'
        DB      15h
        DB      0E5h
        DB      0EBh
        DB      18h
        DB      0DEh
        DB      0FEh
        DB      53h             ; 'S'
        DB      20h             ; ' '
        DB      0Eh
        DB      21h             ; '!'
        DB      08h
        DB      80h
        DB      22h             ; '"'
        DB      98h
        DB      87h
        DB      21h             ; '!'
        DB      30h             ; '0'
        DB      07h
        DB      22h             ; '"'
        DB      9Ah
        DB      87h
        DB      18h
        DB      28h             ; '('
        DB      0E1h
        DB      0FEh
        DB      0B7h
        DB      20h             ; ' '
        DB      0Bh
        DB      0CDh
        DB      0F3h
        DB      24h             ; '$'
        DB      0E5h
        DB      0EDh
        DB      43h             ; 'C'
        DB      98h
        DB      87h
        DB      0EBh
        DB      18h
        DB      0EBh
        DB      0CDh
        DB      02h
        DB      25h             ; '%'
        DB      0EDh
        DB      53h             ; 'S'
        DB      98h
        DB      87h
        DB      0EDh
        DB      43h             ; 'C'
        DB      9Ah
        DB      87h
        DB      0C9h
        DB      0E1h
        DB      2Bh             ; '+'
        DB      0D7h
        DB      0C8h
        DB      0CFh
        DB      2Ch             ; ','
        DB      11h
        DB      90h
        DB      87h
        DB      06h
        DB      05h
        DB      0E5h
        DB      0E1h
        DB      0C8h
        DB      0D2h
        DB      5Ah             ; 'Z'
        DB      12h
        DB      12h
        DB      13h
        DB      0D7h
        DB      10h
        DB      0F5h
        DB      0C9h
        DB      0AFh
        DB      4Fh             ; 'O'
        DB      2Bh             ; '+'
        DB      0D7h
        DB      11h
        DB      27h             ; '''
        DB      88h
        DB      12h
        DB      28h             ; '('
        DB      10h
        DB      0FEh
        DB      2Ch             ; ','
        DB      20h             ; ' '
        DB      14h
        DB      06h
        DB      05h
        DB      0D7h
        DB      28h             ; '('
        DB      07h
        DB      0D2h
        DB      5Ah             ; 'Z'
        DB      12h
        DB      12h
        DB      13h
        DB      10h
        DB      0F6h
        DB      22h             ; '"'
        DB      0A8h
        DB      87h
        DB      79h             ; 'y'
        DB      32h             ; '2'
        DB      8Fh
        DB      87h
        DB      0C9h
        DB      0E5h
        DB      23h             ; '#'
        DB      7Eh             ; '~'
        DB      0FEh
        DB      04h
        DB      28h             ; '('
        DB      04h
        DB      23h             ; '#'
        DB      7Eh             ; '~'
        DB      0FEh
        DB      04h
        DB      0E1h
        DB      0E5h
        DB      0C5h
        DB      20h             ; ' '
        DB      0Fh
        DB      3Ah             ; ':'
        DB      8Fh
        DB      87h
        DB      0FEh
        DB      0B7h
        DB      28h             ; '('
        DB      08h
        DB      0CDh
        DB      02h
        DB      25h             ; '%'
        DB      0C1h
        DB      0Dh
        DB      0E1h
        DB      18h
        DB      0D9h
        DB      0CDh
        DB      0F3h
        DB      24h             ; '$'
        DB      0C1h
        DB      0Ch
        DB      18h
        DB      0F6h

        ; --- START PROC L2490 ---
L2490:  LD      A,(8790h)
        CP      20h             ; ' '
        JR      NZ,L24A8
        LD      A,(8788h)
        CP      41h             ; 'A'
        JR      NZ,L24A4
        LD      HL,(889Dh)
        DEC     HL
        DEC     HL
        RET

L24A4:  LD      HL,(8823h)
        RET

L24A8:  CP      4Dh             ; 'M'
        JR      NZ,L24B0
        LD      HL,(87A0h)
        RET

L24B0:  CP      53h             ; 'S'
        JR      NZ,L24B8
        LD      HL,8008h
        RET

L24B8:  LD      HL,(87A8h)
        CP      0B7h
        JR      NZ,L24DC
        LD      A,(878Fh)
        DEC     A
        JR      NZ,L24EA
        CALL    L24F3
        PUSH    BC
L24C9:  LD      (87A8h),HL
        LD      HL,(87A2h)
        RST     0x20
        POP     HL
        RET     C
        RET     Z
        CALL    L2511
        CALL    L26B8
        JP      L1269

L24DC:  LD      A,(878Fh)
        INC     A
        JR      NZ,L24EA
        CALL    L2502
        PUSH    DE
        LD      D,B
        LD      E,C
        JR      L24C9

L24EA:  CALL    L2511
        CALL    L26B8
        JP      L126F

        ; --- START PROC L24F3 ---
L24F3:  LD      A,01h
        LD      (8892h),A
        CALL    L2D01
        JP      NZ,L154C
        LD      (8892h),A
        RET

        ; --- START PROC L2502 ---
L2502:  CALL    L1850
        PUSH    HL
        CALL    L29A1
        DEC     HL
        DEC     HL
        DEC     HL
        LD      B,00h
        LD      C,(HL)
        POP     HL
        RET

        ; --- START PROC L2511 ---
L2511:  LD      HL,(87A8h)
        PUSH    HL
        LD      HL,8788h
        LD      BC,2220h
L251B:  LD      (HL),C
        INC     HL
        DJNZ    L251B
        POP     HL
        RET

L2521:  DB      0EDh
        DB      5Bh             ; '['
        DB      98h
        DB      87h
        DB      0EDh
        DB      4Bh             ; 'K'
        DB      9Ah
        DB      87h
        DB      0AFh
        DB      67h             ; 'g'
        DB      6Fh             ; 'o'
        DB      1Ah
        DB      85h
        DB      6Fh             ; 'o'
        DB      3Eh             ; '>'
        DB      00h
        DB      8Ch
        DB      67h             ; 'g'
        DB      13h
        DB      0Bh
        DB      78h             ; 'x'
        DB      0B1h
        DB      20h             ; ' '
        DB      0F3h
        DB      22h             ; '"'
        DB      9Ch
        DB      87h
        DB      0CDh
        DB      3Dh             ; '='
        DB      27h             ; '''

        ; Entry Point
        ; --- START PROC Salva_Cabecera ---
Salva_Cabecera:
		CALL    L267D
        CALL    L255A
        LD      B,0Ah
        LD      A,0D3h
L2549:  CALL    L25FC
        DJNZ    L2549
        LD      B,16h
        LD      HL,8788h
L2553:  LD      A,(HL)
        INC     HL
        CALL    L25FC
        DJNZ    L2553
        ; --- START PROC L255A ---
L255A:  LD      B,80h
        LD      A,0FFh
L255E:  CALL    L25FC
        DJNZ    L255E
        RET

        ; --- START PROC L2564 ---
L2564:  XOR     A
        CALL    L25FC
        LD      DE,(8798h)
        LD      BC,(879Ah)
L2570:  LD      A,(DE)
        INC     DE
        DEC     BC
        CALL    L25FC
        LD      A,B
        OR      C
        JR      NZ,L2570
        LD      B,0Ah
        XOR     A
L257D:  CALL    L25FC
        DJNZ    L257D
        RET

        ; --- START PROC L2583 ---
L2583:  LD      D,A
L2584:  CALL    L2646
        CP      0FFh
        JR      NZ,L2584
L258B:  CALL    L2646
        CP      0FFh
        JR      Z,L258B
        OR      A
        JR      NZ,L2584
        PUSH    HL
        LD      HL,0000h
        LD      (87A6h),HL
        POP     HL
        LD      BC,(87A2h)
L25A1:  CALL    L2646
        LD      E,A
        PUSH    HL
        JR      C,L25AD
        LD      HL,87D6h
        SET     7,(HL)
L25AD:  LD      HL,(87A6h)
        OR      A
        ADD     A,L
        LD      L,A
        LD      A,00h
        ADC     A,H
        LD      H,A
        LD      (87A6h),HL
        POP     HL
        LD      A,E
        SUB     (HL)
        AND     D
        JR      Z,L25C9
        LD      A,(87D6h)
        SET     5,A
        LD      (87D6h),A
        LD      A,73h           ; 's'
L25C9:  LD      (HL),E
        LD      A,(8790h)
        CP      20h             ; ' '
        JR      NZ,L25E3
        PUSH    HL
        LD      A,0A0h
        SUB     L
        LD      L,A
        LD      A,0FFh
        SBC     A,H
        LD      H,A
        JR      C,L25E0
        ADD     HL,SP
        POP     HL
        JR      C,L25E3
L25E0:  XOR     A
        DEC     A
        RET

L25E3:  INC     HL
        DEC     BC
        LD      A,B
        OR      C
        JR      NZ,L25A1
        LD      C,D
        PUSH    HL
        LD      HL,(87A6h)
        LD      DE,(87A4h)
        RST     0x20
        POP     HL
        RET     Z
        LD      HL,87D6h
        SET     6,(HL)
        XOR     A
        RET

        ; --- START PROC L25FC ---
L25FC:  PUSH    AF
        PUSH    BC
        CALL    L26DC
        RLA
        SET     0,A
        LD      B,0Bh
        ; --- START PROC L2606 ---
L2606:  LD      C,A
        BIT     0,C
        JR      Z,L263A
        PUSH    BC
        LD      B,04h
        ; --- START PROC L260E ---
L260E:  LD      A,83h
        OUT     (0BFh),A
        CALL    L26E1
        LD      A,(L26EB)
        CALL    L2635
        JR      L261D

L261D:  LD      A,81h
        OUT     (0BFh),A
        CALL    L26E1
        DJNZ    L2630
        POP     BC
        ; --- START PROC L2627 ---
L2627:  LD      A,C
        RES     0,A
        RRA
        DJNZ    L2606
        POP     BC
        POP     AF
        RET

        ; --- START PROC L2630 ---
L2630:  CALL    L2635
        JR      L260E

        ; --- START PROC L2635 ---
L2635:  PUSH    IX
        POP     IX
        RET

        ; --- START PROC L263A ---
L263A:  LD      A,(L26EB)
        LD      A,80h
        OUT     (0BFh),A
        CALL    L26D4
        JR      L2627

        ; --- START PROC L2646 ---
L2646:  PUSH    BC
L2647:  LD      B,14h
L2649:  IN      A,(0BFh)
        AND     80h
        JR      NZ,L2647
        DJNZ    L2649
L2651:  LD      B,28h           ; '('
L2653:  IN      A,(0BFh)
        AND     80h
        JR      Z,L2651
        DJNZ    L2653
        LD      B,09h
L265D:  RRA
        LD      C,A
        CALL    L26D4
        IN      A,(0BFh)
        AND     80h
        JR      Z,L266C
        CP      80h
        JR      Z,L2670
L266C:  XOR     A
        LD      A,00h
        LD      A,37h           ; '7'
L2670:  SCF
        JP      L2674

L2674:  LD      A,(L26EB)
        LD      A,C
        DJNZ    L265D
        CCF
        POP     BC
        RET

        ; --- START PROC L267D ---
L267D:  CALL    L0291
        LD      BC,4000h
L2683:  LD      A,03h
        OUT     (0BFh),A
        CALL    L26E1
        DEC     BC
        LD      A,01h
        OUT     (0BFh),A
        CALL    L26E1
        LD      A,B
        OR      C
        JR      NZ,L2683
        LD      A,80h
        OUT     (0BFh),A
        CALL    L255A
        NOP
        NOP
        NOP
        RET

        ; --- START PROC L26A1 ---
L26A1:  PUSH    AF
        ; --- START PROC L26A2 ---
L26A2:  CALL    L26C8
        XOR     A
        OUT     (0BFh),A
        CALL    L029D
        POP     AF
        RET

L26AD:  DB      0CDh
        DB      91h
        DB      02h
        DB      3Eh             ; '>'
        DB      80h
        DB      0D3h
        DB      0BFh
        DB      00h
        DB      00h
        DB      00h
        DB      0C9h

        ; --- START PROC L26B8 ---
L26B8:  PUSH    AF
        JR      L26A2

L26BB:  DB      3Eh             ; '>'
        DB      80h
        DB      0D3h
        DB      0BFh
        DB      0CDh
        DB      0C8h
        DB      26h             ; '&'
        DB      10h
        DB      0FBh
        DB      0AFh
        DB      0D3h
        DB      0BFh
        DB      0C9h

        ; --- START PROC L26C8 ---
L26C8:  LD      A,0CBh
L26CA:  CALL    L26EB
        CALL    L26EB
        DEC     A
        RET     Z
        JR      L26CA

        ; --- START PROC L26D4 ---
L26D4:  PUSH    BC
        LD      BC,(87D3h)
        NOP
        JR      L26F0

        ; --- START PROC L26DC ---
L26DC:  PUSH    BC
        LD      B,29h           ; ')'
        JR      L26F0

        ; --- START PROC L26E1 ---
L26E1:  PUSH    BC
        LD      BC,(87D4h)
        LD      C,00h
        NOP
        JR      L26F0

        ; --- START PROC L26EB ---
L26EB:  PUSH    BC
        LD      B,00h
        ; --- START PROC L26EE ---
L26EE:  PUSH    BC
        POP     BC
        ; --- START PROC L26F0 ---
L26F0:  DJNZ    L26EE
        POP     BC
        RET

        ; --- START PROC L26F4 ---
L26F4:  PUSH    HL
        LD      HL,0000h
        LD      B,40h           ; '@'
L26FA:  IN      A,(0BFh)
        AND     80h
        JR      Z,L26FA
L2700:  INC     HL
        IN      A,(0BFh)
        AND     80h
        JR      NZ,L2700
        DJNZ    L26FA
        LD      A,H
        LD      HL,278Ah
        LD      B,03h
        CP      (HL)
        JR      C,L2720
L2712:  INC     HL
        CP      (HL)
        INC     HL
        JR      C,L2725
        INC     HL
        INC     HL
        DJNZ    L2712
        LD      HL,277Fh
        JR      L2739

L2720:  LD      HL,2762h
        JR      L2739

L2725:  LD      A,(HL)
        INC     HL
        LD      C,(HL)
        INC     HL
        LD      B,(HL)
        OR      A
        JR      Z,L2742
        INC     A
        OR      A
        JR      Z,L2736
        LD      HL,276Dh
        JR      L2739

L2736:  LD      HL,2776h
L2739:  CALL    L2758
        POP     HL
        ; --- START PROC L273D ---
L273D:  LD      BC,(L2791)
        LD      A,0E1h
        ; --- START PROC L2742 ---
L2742:  POP     HL
        PUSH    BC
        LD      BC,(L2791)
        LD      (87D4h),BC
        POP     BC
        LD      A,(87D6h)
        BIT     2,A
        RET     Z
        LD      (87D4h),BC
        RET

        ; --- START PROC L2758 ---
L2758:  CALL    L029D
        CALL    L2838
        CALL    L0291
        RET

L2762:  DB      "Speed ++!"
        DB      8Dh
        DB      00h
        DB      "Speed +"
        DB      8Dh
        DB      00h
        DB      "Speed -"
        DB      8Dh
        DB      00h
        DB      "Speed --!"
        DB      8Dh
        DB      00h
        DB      0A8h
        DB      0B1h
        DB      01h
        DB      4Bh             ; 'K'
        DB      05h
        DB      0C2h
        DB      00h
L2791:  DB      53h             ; 'S'
        DB      06h
        DB      0CCh
        DB      0FFh
        DB      5Bh             ; '['
        DB      07h
        DB      0D5h
        DB      0CDh
        DB      "d)~##N#F"
        DB      0D1h
        DB      0C5h
        DB      0F5h
        DB      0CDh
        DB      68h             ; 'h'
        DB      29h             ; ')'
        DB      0CDh
        DB      85h
        DB      05h
        DB      0F1h
        DB      57h             ; 'W'
        DB      0E1h
        DB      7Bh             ; '{'
        DB      0B2h
        DB      0C8h
        DB      7Ah             ; 'z'
        DB      0D6h
        DB      01h
        DB      0D8h
        DB      0AFh
        DB      0BBh
        DB      3Ch             ; '<'
        DB      0D0h
        DB      15h
        DB      1Dh
        DB      0Ah
        DB      03h
        DB      0BEh
        DB      23h             ; '#'
        DB      28h             ; '('
        DB      0EDh
        DB      3Fh             ; '?'
        DB      0C3h
        DB      45h             ; 'E'
        DB      05h
        DB      0CDh
        DB      3Eh             ; '>'
        DB      18h
        DB      0CDh
        DB      0D4h
        DB      06h
        DB      0CDh
        DB      0FAh
        DB      27h             ; '''
        DB      0CDh
        DB      64h             ; 'd'
        DB      29h             ; ')'
        DB      01h
        DB      0B8h
        DB      29h             ; ')'
        DB      0C5h

        ; --- START PROC L27D4 ---
L27D4:  LD      A,(HL)
        INC     HL
        INC     HL
        PUSH    HL
        CALL    L284E
        POP     HL
        LD      C,(HL)
        INC     HL
        LD      B,(HL)
        CALL    L27EE
        PUSH    HL
        LD      L,A
        CALL    L2958
        POP     DE
        RET

L27E9:  DB      3Eh             ; '>'
        DB      01h

        ; --- START PROC L27EB ---
L27EB:  CALL    L284E
        ; --- START PROC L27EE ---
L27EE:  LD      HL,8884h
        PUSH    HL
        LD      (HL),A
        INC     HL
        INC     HL
        LD      (HL),E
        INC     HL
        LD      (HL),D
        POP     HL
        RET

        ; --- START PROC L27FA ---
L27FA:  DEC     HL
        ; --- START PROC L27FB ---
L27FB:  LD      B,22h           ; '"'
        LD      D,B
        PUSH    HL
        LD      C,0FFh
L2801:  INC     HL
        LD      A,(HL)
        INC     C
        OR      A
        JR      Z,L280D
        CP      D
        JR      Z,L280D
        CP      B
        JR      NZ,L2801
L280D:  CP      22h             ; '"'
        CALL    Z,L151F
        EX      (SP),HL
        INC     HL
        EX      DE,HL
        LD      A,C
        CALL    L27EE
        ; --- START PROC L2819 ---
L2819:  LD      DE,8884h
        LD      HL,(8876h)
        LD      (88ABh),HL
        LD      A,01h
        LD      (8872h),A
        CALL    L0591
        RST     0x20
        LD      (8876h),HL
        POP     HL
        LD      A,(HL)
        RET     NZ
        LD      DE,001Eh
        JP      L1271

L2837:  DB      23h             ; '#'

        ; --- START PROC L2838 ---
L2838:  CALL    L27FA
        CALL    L2964
        CALL    L0585
        INC     E
L2842:  DEC     E
        RET     Z
        LD      A,(BC)
        RST     0x18
        CP      0Dh
        CALL    Z,L0F95
        INC     BC
        JR      L2842

        ; --- START PROC L284E ---
L284E:  OR      A
        LD      C,0F1h
        PUSH    AF
        LD      HL,(881Fh)
        EX      DE,HL
        LD      HL,(8888h)
        CPL
        LD      C,A
        LD      B,0FFh
        ADD     HL,BC
        INC     HL
        RST     0x20
        JR      C,L2869
        LD      (8888h),HL
        INC     HL
        EX      DE,HL
        POP     AF
        RET

L2869:  POP     AF
        LD      DE,001Ah
        JP      Z,L1271
        CP      A
        PUSH    AF
        LD      BC,2850h
        PUSH    BC
        LD      HL,(8874h)
        ; --- START PROC L2879 ---
L2879:  LD      (8888h),HL
        LD      HL,0000h
        PUSH    HL
        LD      HL,(88A1h)
        PUSH    HL
        LD      HL,8878h
        LD      DE,(8876h)
        RST     0x20
        LD      BC,2887h
        JP      NZ,L28CD
        LD      HL,(889Dh)
L2895:  LD      DE,(889Fh)
        RST     0x20
        JR      Z,L28A6
        INC     HL
        LD      A,(HL)
        INC     HL
        OR      A
        CALL    L28D0
        JR      L2895

L28A5:  POP     BC
L28A6:  LD      DE,(88A1h)
        RST     0x20
        JP      Z,L28F2
        CALL    L0585
        LD      A,D
        PUSH    HL
        ADD     HL,BC
        OR      A
        JP      P,L28A5
        LD      (888Ch),HL
        POP     HL
        LD      C,(HL)
        LD      B,00h
        ADD     HL,BC
        ADD     HL,BC
        INC     HL
        EX      DE,HL
        LD      HL,(888Ch)
        EX      DE,HL
        RST     0x20
        JR      Z,L28A6
        LD      BC,28C2h
L28CD:  PUSH    BC
        OR      80h
        ; --- START PROC L28D0 ---
L28D0:  LD      A,(HL)
        INC     HL
        INC     HL
        LD      E,(HL)
        INC     HL
        LD      D,(HL)
        INC     HL
        RET     P
        OR      A
        RET     Z
        LD      B,H
        LD      C,L
        LD      HL,(8888h)
        RST     0x20
        LD      H,B
        LD      L,C
        RET     C
        POP     HL
        EX      (SP),HL
        RST     0x20
        EX      (SP),HL
        PUSH    HL
        LD      H,B
        LD      L,C
        RET     NC
        POP     BC
        POP     AF
        POP     AF
        PUSH    HL
        PUSH    DE
        PUSH    BC
        RET

        ; --- START PROC L28F2 ---
L28F2:  POP     DE
        POP     HL
        LD      A,H
        OR      L
        RET     Z
        DEC     HL
        LD      B,(HL)
        DEC     HL
        LD      C,(HL)
        PUSH    HL
        DEC     HL
        DEC     HL
        LD      L,(HL)
        LD      H,00h
        ADD     HL,BC
        LD      D,B
        LD      E,C
        DEC     HL
        LD      B,H
        LD      C,L
        LD      HL,(8888h)
        CALL    L2E83
        POP     HL
        LD      (HL),C
        INC     HL
        LD      (HL),B
        LD      H,B
        LD      L,C
        DEC     HL
        JP      L2879

        ; --- START PROC L2917 ---
L2917:  PUSH    BC
        PUSH    HL
        LD      HL,(88ABh)
        EX      (SP),HL
        CALL    L18CA
        EX      (SP),HL
        CALL    L183F
        LD      A,(HL)
        PUSH    HL
        LD      HL,(88ABh)
        PUSH    HL
        ADD     A,(HL)
        LD      DE,001Ch
        JP      C,L1271
        CALL    L27EB
        POP     DE
        CALL    L2968
        EX      (SP),HL
        CALL    L2967
        PUSH    HL
        LD      HL,(8886h)
        EX      DE,HL
        CALL    L294F
        CALL    L294F
        LD      HL,185Ch
        EX      (SP),HL
        PUSH    HL
        JP      L2819

        ; --- START PROC L294F ---
L294F:  POP     HL
        EX      (SP),HL
        LD      A,(HL)
        INC     HL
        INC     HL
        LD      C,(HL)
        INC     HL
        LD      B,(HL)
        LD      L,A
        ; --- START PROC L2958 ---
L2958:  INC     L
L2959:  DEC     L
        RET     Z
        LD      A,(BC)
        LD      (DE),A
        INC     BC
        INC     DE
        JR      L2959

        ; --- START PROC L2961 ---
L2961:  CALL    L183F
        ; --- START PROC L2964 ---
L2964:  LD      HL,(88ABh)
        ; --- START PROC L2967 ---
L2967:  EX      DE,HL
        ; --- START PROC L2968 ---
L2968:  CALL    L297F
        EX      DE,HL
        RET     NZ
        PUSH    DE
        LD      D,B
        LD      E,C
        DEC     DE
        LD      C,(HL)
        LD      HL,(8888h)
        RST     0x20
        JR      NZ,L297D
        LD      B,A
        ADD     HL,BC
        LD      (8888h),HL
L297D:  POP     HL
        RET

        ; --- START PROC L297F ---
L297F:  LD      HL,(8876h)
        DEC     HL
        LD      B,(HL)
        DEC     HL
        LD      C,(HL)
        DEC     HL
        DEC     HL
        RST     0x20
        RET     NZ
        LD      (8876h),HL
        RET

L298E:  DB      01h
        DB      0F9h
        DB      19h
        DB      0C5h

        ; --- START PROC L2992 ---
L2992:  CALL    L2961
        XOR     A
        LD      D,A
        LD      (8872h),A
        LD      A,(HL)
        OR      A
        RET

L299D:  DB      01h
        DB      0F9h
        DB      19h
        DB      0C5h

        ; --- START PROC L29A1 ---
L29A1:  CALL    L2992
        JP      Z,L154C
        INC     HL
        INC     HL
        LD      E,(HL)
        INC     HL
        LD      D,(HL)
        LD      A,(DE)
        RET

L29AE:  DB      0CDh
        DB      0E9h
        DB      27h             ; '''
        DB      0CDh
        DB      94h
        DB      1Ah
        DB      2Ah             ; '*'
        DB      86h
        DB      88h
        DB      73h             ; 's'
        DB      0C1h
        DB      0C3h
        DB      19h
        DB      28h             ; '('
        DB      0CDh
        DB      3Ch             ; '<'
        DB      2Ah             ; '*'
        DB      0AFh
        DB      0E3h
        DB      4Fh             ; 'O'
        DB      0E5h
        DB      7Eh             ; '~'
        DB      0B8h
        DB      38h             ; '8'
        DB      02h
        DB      78h             ; 'x'
        DB      11h
        DB      0Eh
        DB      00h
        DB      0C5h
        DB      0CDh
        DB      4Eh             ; 'N'
        DB      28h             ; '('
        DB      0C1h
        DB      0E1h
        DB      0E5h
        DB      "##F#fh"
        DB      06h
        DB      00h
        DB      09h
        DB      44h             ; 'D'
        DB      4Dh             ; 'M'
        DB      0CDh
        DB      0EEh
        DB      27h             ; '''
        DB      6Fh             ; 'o'
        DB      0CDh
        DB      58h             ; 'X'
        DB      29h             ; ')'
        DB      0D1h
        DB      0CDh
        DB      68h             ; 'h'
        DB      29h             ; ')'
        DB      0C3h
        DB      19h
        DB      28h             ; '('
        DB      0CDh
        DB      3Ch             ; '<'
        DB      2Ah             ; '*'
        DB      0D1h
        DB      0D5h
        DB      1Ah
        DB      90h
        DB      18h
        DB      0CCh
        DB      0EBh
        DB      7Eh             ; '~'
        DB      0CDh
        DB      3Fh             ; '?'
        DB      2Ah             ; '*'
        DB      04h
        DB      05h
        DB      0CAh
        DB      4Ch             ; 'L'
        DB      15h
        DB      0C5h
        DB      1Eh
        DB      0FFh
        DB      0FEh
        DB      29h             ; ')'
        DB      0CAh
        DB      0Bh
        DB      2Ah             ; '*'
        DB      0CFh
        DB      2Ch             ; ','
        DB      0CDh
        DB      91h
        DB      1Ah
        DB      0CFh
        DB      29h             ; ')'
        DB      0F1h
        DB      0E3h
        DB      01h
        DB      0C2h
        DB      29h             ; ')'
        DB      0C5h
        DB      3Dh             ; '='
        DB      0BEh
        DB      06h
        DB      00h
        DB      0D0h
        DB      4Fh             ; 'O'
        DB      7Eh             ; '~'
        DB      91h
        DB      0BBh
        DB      47h             ; 'G'
        DB      0D8h
        DB      43h             ; 'C'
        DB      0C9h
        DB      0CDh
        DB      92h
        DB      29h             ; ')'
        DB      0CAh
        DB      17h
        DB      03h
        DB      "_##~#fo"
        DB      0E5h
        DB      19h
        DB      46h             ; 'F'
        DB      72h             ; 'r'
        DB      0E3h
        DB      0C5h
        DB      2Bh             ; '+'
        DB      0D7h
        DB      0CDh
        DB      39h             ; '9'
        DB      06h
        DB      0C1h
        DB      0E1h
        DB      70h             ; 'p'
        DB      0C9h
        DB      0EBh
        DB      0CFh
        DB      29h             ; ')'
        DB      0C1h
        DB      0D1h
        DB      0C5h
        DB      43h             ; 'C'
        DB      0C9h
        DB      2Ah             ; '*'
        DB      0A1h
        DB      88h
        DB      0EBh
        DB      21h             ; '!'
        DB      00h
        DB      00h
        DB      39h             ; '9'
        DB      3Ah             ; ':'
        DB      72h             ; 'r'
        DB      88h
        DB      0B7h
        DB      0CAh
        DB      0DEh
        DB      19h
        DB      0CDh
        DB      64h             ; 'd'
        DB      29h             ; ')'
        DB      0CDh
        DB      76h             ; 'v'
        DB      28h             ; '('
        DB      0EDh
        DB      5Bh             ; '['
        DB      1Fh
        DB      88h
        DB      2Ah             ; '*'
        DB      88h
        DB      88h
        DB      0C3h
        DB      0DEh
        DB      19h
        DB      3Eh             ; '>'
        DB      00h
        DB      32h             ; '2'
        DB      0CBh
        DB      87h
        DB      0F5h
        DB      0CDh
        DB      91h
        DB      1Ah
        DB      0E6h
        DB      07h
        DB      0D1h
        DB      0B2h
        DB      0F5h
        DB      0CFh
        DB      2Ch             ; ','
        DB      0CDh
        DB      91h
        DB      1Ah
        DB      0E6h
        DB      07h
        DB      87h
        DB      87h
        DB      87h
        DB      87h
        DB      0D1h
        DB      0B2h
        DB      0F5h
        DB      0CFh
        DB      2Ch             ; ','
        DB      0CDh
        DB      91h
        DB      1Ah
        DB      0D1h
        DB      0CBh
        DB      47h             ; 'G'
        DB      28h             ; '('
        DB      04h
        DB      0CBh
        DB      9Ah
        DB      18h
        DB      02h
        DB      0CBh
        DB      0DAh
        DB      7Ah             ; 'z'
        DB      32h             ; '2'
        DB      0CAh
        DB      87h
        DB      0C9h
        DB      3Eh             ; '>'
        DB      00h
        DB      32h             ; '2'
        DB      0CBh
        DB      87h
        DB      3Eh             ; '>'
        DB      80h
        DB      0C3h
        DB      68h             ; 'h'
        DB      2Ah             ; '*'
        DB      3Eh             ; '>'
        DB      80h
        DB      32h             ; '2'
        DB      0CBh
        DB      87h
        DB      3Eh             ; '>'
        DB      00h
        DB      0C3h
        DB      68h             ; 'h'
        DB      2Ah             ; '*'
        DB      3Eh             ; '>'
        DB      80h
        DB      32h             ; '2'
        DB      0CBh
        DB      87h
        DB      0C3h
        DB      68h             ; 'h'
        DB      2Ah             ; '*'
        DB      0E5h
        DB      0CDh
        DB      0F4h
        DB      20h             ; ' '
        DB      0E1h
        DB      0C9h
        DB      0EDh
        DB      5Bh             ; '['
        DB      4Eh             ; 'N'
        DB      87h
        DB      0D5h
        DB      0CDh
        DB      91h
        DB      1Ah
        DB      22h             ; '"'
        DB      56h             ; 'V'
        DB      87h
        DB      67h             ; 'g'
        DB      2Eh             ; '.'
        DB      00h
        DB      22h             ; '"'
        DB      4Eh             ; 'N'
        DB      87h
        DB      0CDh
        DB      0F0h
        DB      1Fh
        DB      2Bh             ; '+'
        DB      56h             ; 'V'
        DB      36h             ; '6'
        DB      8Ah
        DB      2Bh             ; '+'
        DB      5Eh             ; '^'
        DB      36h             ; '6'
        DB      0CDh
        DB      2Bh             ; '+'
        DB      46h             ; 'F'
        DB      36h             ; '6'
        DB      0A0h
        DB      2Bh             ; '+'
        DB      4Eh             ; 'N'
        DB      36h             ; '6'
        DB      98h
        DB      22h             ; '"'
        DB      50h             ; 'P'
        DB      87h
        DB      0D5h
        DB      0C5h
        DB      2Ah             ; '*'
        DB      56h             ; 'V'
        DB      87h
        DB      0CFh
        DB      2Ch             ; ','
        DB      0CDh
        DB      91h
        DB      1Ah
        DB      22h             ; '"'
        DB      56h             ; 'V'
        DB      87h
        DB      67h             ; 'g'
        DB      2Eh             ; '.'
        DB      27h             ; '''
        DB      0CDh
        DB      0F0h
        DB      1Fh
        DB      23h             ; '#'
        DB      23h             ; '#'
        DB      7Eh             ; '~'
        DB      36h             ; '6'
        DB      90h
        DB      0CDh
        DB      2Dh             ; '-'
        DB      21h             ; '!'
        DB      77h             ; 'w'
        DB      0C1h
        DB      0D1h
        DB      2Ah             ; '*'
        DB      50h             ; 'P'
        DB      87h
        DB      "q#p#s#r*V"
        DB      87h
        DB      0D1h
        DB      0EDh
        DB      53h             ; 'S'
        DB      4Eh             ; 'N'
        DB      87h
        DB      0C9h
        DB      3Eh             ; '>'
        DB      00h
        DB      32h             ; '2'
        DB      0CDh
        DB      87h
        DB      0C9h
        DB      3Eh             ; '>'
        DB      01h
        DB      32h             ; '2'
        DB      0CDh
        DB      87h
        DB      0C9h
        DB      0CDh
        DB      91h
        DB      1Ah
        DB      0E5h
        DB      0E6h
        DB      07h
        DB      6Fh             ; 'o'
        DB      87h
        DB      87h
        DB      87h
        DB      87h
        DB      85h
        DB      0CDh
        DB      0E5h
        DB      1Ah
        DB      0E1h
        DB      0C9h
        DB      0CDh
        DB      91h
        DB      1Ah
        DB      0FEh
        DB      28h             ; '('
        DB      38h             ; '8'
        DB      02h
        DB      3Eh             ; '>'
        DB      27h             ; '''
        DB      32h             ; '2'
        DB      4Eh             ; 'N'
        DB      87h
        DB      0C9h
        DB      0CDh
        DB      91h
        DB      1Ah
        DB      0FEh
        DB      17h
        DB      38h             ; '8'
        DB      02h
        DB      3Eh             ; '>'
        DB      16h
        DB      32h             ; '2'
        DB      4Fh             ; 'O'
        DB      87h
        DB      0C9h
        DB      0AFh
        DB      32h             ; '2'
        DB      0CCh
        DB      87h
        DB      0C9h
        DB      3Eh             ; '>'
        DB      01h
        DB      32h             ; '2'
        DB      0CCh
        DB      87h
        DB      0C9h
        DB      0CDh
        DB      91h
        DB      1Ah
        DB      0B7h
        DB      0E5h
        DB      3Eh             ; '>'
        DB      0FFh
        DB      28h             ; '('
        DB      02h
        DB      3Eh             ; '>'
        DB      00h
        DB      32h             ; '2'
        DB      48h             ; 'H'
        DB      87h
        DB      21h             ; '!'
        DB      56h             ; 'V'
        DB      87h
        DB      22h             ; '"'
        DB      50h             ; 'P'
        DB      87h
        DB      36h             ; '6'
        DB      8Ch
        DB      23h             ; '#'
        DB      36h             ; '6'
        DB      90h
        DB      0CDh
        DB      2Dh             ; '-'
        DB      21h             ; '!'
        DB      0E1h
        DB      0C9h
        DB      0CDh
        DB      91h
        DB      1Ah
        DB      0E6h
        DB      07h
        DB      3Ch             ; '<'
        DB      0CBh
        DB      0FFh
        DB      32h             ; '2'
        DB      0B0h
        DB      87h
        DB      0CDh
        DB      3Ah             ; ':'
        DB      21h             ; '!'
        DB      0C9h
        DB      0CDh
        DB      3Ah             ; ':'
        DB      21h             ; '!'
        DB      0CDh
        DB      94h
        DB      1Ah
        DB      0E6h
        DB      01h
        DB      0CAh
        DB      8Dh
        DB      2Bh             ; '+'
        DB      3Ah             ; ':'
        DB      0B2h
        DB      87h
        DB      18h
        DB      03h
        DB      3Ah             ; ':'
        DB      0B5h
        DB      87h
        DB      0C3h
        DB      0F9h
        DB      19h
        DB      0CDh
        DB      3Ah             ; ':'
        DB      21h             ; '!'
        DB      0CDh
        DB      94h
        DB      1Ah
        DB      0E6h
        DB      01h
        DB      0CAh
        DB      0A3h
        DB      2Bh             ; '+'
        DB      3Ah             ; ':'
        DB      0B1h
        DB      87h
        DB      18h
        DB      03h
        DB      3Ah             ; ':'
        DB      0B4h
        DB      87h
        DB      0C3h
        DB      0F9h
        DB      19h
        DB      0CDh
        DB      3Ah             ; ':'
        DB      21h             ; '!'
        DB      0CDh
        DB      94h
        DB      1Ah
        DB      0E6h
        DB      01h
        DB      0CAh
        DB      0DAh
        DB      2Bh             ; '+'
        DB      3Ah             ; ':'
        DB      0B3h
        DB      87h
        DB      47h             ; 'G'
        DB      3Ah             ; ':'
        DB      0B2h
        DB      87h
        DB      0B7h
        DB      28h             ; '('
        DB      0Ah
        DB      0FEh
        DB      01h
        DB      20h             ; ' '
        DB      04h
        DB      0CBh
        DB      0C8h
        DB      18h
        DB      02h
        DB      0CBh
        DB      0D0h
        DB      3Ah             ; ':'
        DB      0B1h
        DB      87h
        DB      0B7h
        DB      28h             ; '('
        DB      30h             ; '0'
        DB      0FEh
        DB      01h
        DB      20h             ; ' '
        DB      04h
        DB      0CBh
        DB      0D8h
        DB      18h
        DB      28h             ; '('
        DB      0CBh
        DB      0E0h
        DB      18h
        DB      24h             ; '$'
        DB      3Ah             ; ':'
        DB      0B6h
        DB      87h
        DB      47h             ; 'G'
        DB      3Ah             ; ':'
        DB      0B5h
        DB      87h
        DB      0B7h
        DB      28h             ; '('
        DB      0Ah
        DB      0FEh
        DB      01h
        DB      20h             ; ' '
        DB      04h
        DB      0CBh
        DB      0C8h
        DB      18h
        DB      02h
        DB      0CBh
        DB      0D0h
        DB      3Ah             ; ':'
        DB      0B4h
        DB      87h
        DB      0B7h
        DB      28h             ; '('
        DB      0Ah
        DB      0FEh
        DB      01h
        DB      20h             ; ' '
        DB      04h
        DB      0CBh
        DB      0D8h
        DB      18h
        DB      02h
        DB      0CBh
        DB      0E0h
        DB      78h             ; 'x'
        DB      0C3h
        DB      0F9h
        DB      19h
        DB      0CDh
        DB      3Ah             ; ':'
        DB      21h             ; '!'
        DB      3Ah             ; ':'
        DB      0B7h
        DB      87h
        DB      0CBh
        DB      0BFh
        DB      0FEh
        DB      7Fh
        DB      0C2h
        DB      11h
        DB      2Ch             ; ','
        DB      3Eh             ; '>'
        DB      00h
        DB      0C3h
        DB      0F9h
        DB      19h
        DB      3Ah             ; ':'
        DB      0CBh
        DB      87h
        DB      0F5h
        DB      3Eh             ; '>'
        DB      80h
        DB      32h             ; '2'
        DB      0CBh
        DB      87h
        DB      3Ah             ; ':'
        DB      0CAh
        DB      87h
        DB      0F5h
        DB      3Eh             ; '>'
        DB      00h
        DB      0F5h
        DB      0CDh
        DB      91h
        DB      1Ah
        DB      0E6h
        DB      07h
        DB      0D1h
        DB      0B2h
        DB      0F5h
        DB      0CFh
        DB      2Ch             ; ','
        DB      0CDh
        DB      91h
        DB      1Ah
        DB      0E6h
        DB      07h
        DB      87h
        DB      87h
        DB      87h
        DB      87h
        DB      0D1h
        DB      0B2h
        DB      32h             ; '2'
        DB      0CAh
        DB      87h
        DB      0CFh
        DB      2Ch             ; ','
        DB      0CDh
        DB      91h
        DB      1Ah
        DB      0E6h
        DB      07h
        DB      0E5h
        DB      0CDh
        DB      04h
        DB      20h             ; ' '
        DB      0E1h
        DB      0F1h
        DB      32h             ; '2'
        DB      0CAh
        DB      87h
        DB      0F1h
        DB      32h             ; '2'
        DB      0CBh
        DB      87h
        DB      0C9h
        DB      3Eh             ; '>'
        DB      00h
        DB      0F5h
        DB      11h
        DB      56h             ; 'V'
        DB      87h
        DB      0EDh
        DB      53h             ; 'S'
        DB      50h             ; 'P'
        DB      87h
        DB      3Eh             ; '>'
        DB      98h
        DB      12h
        DB      13h
        DB      3Eh             ; '>'
        DB      80h
        DB      12h
        DB      13h
        DB      3Eh             ; '>'
        DB      40h             ; '@'
        DB      12h
        DB      13h
        DB      0D5h
        DB      0CDh
        DB      91h
        DB      1Ah
        DB      0D1h
        DB      0FEh
        DB      20h             ; ' '
        DB      0DAh
        DB      4Ch             ; 'L'
        DB      15h
        DB      0CBh
        DB      0FFh
        DB      12h
        DB      13h
        DB      0CFh
        DB      2Ch             ; ','
        DB      0CFh
        DB      22h             ; '"'
        DB      0F1h
        DB      12h
        DB      13h
        DB      3Eh             ; '>'
        DB      98h
        DB      12h
        DB      13h
        DB      3Eh             ; '>'
        DB      80h
        DB      12h
        DB      13h
        DB      12h
        DB      06h
        DB      0Ah
        DB      13h
        DB      3Eh             ; '>'
        DB      00h
        DB      12h
        DB      13h
        DB      0CDh
        DB      0B5h
        DB      2Ch             ; ','
        DB      4Fh             ; 'O'
        DB      0CDh
        DB      0B5h
        DB      2Ch             ; ','
        DB      87h
        DB      87h
        DB      87h
        DB      87h
        DB      0B1h
        DB      12h
        DB      10h
        DB      0ECh
        DB      13h
        DB      3Eh             ; '>'
        DB      98h
        DB      12h
        DB      13h
        DB      3Eh             ; '>'
        DB      80h
        DB      12h
        DB      13h
        DB      3Eh             ; '>'
        DB      00h
        DB      12h
        DB      13h
        DB      3Eh             ; '>'
        DB      90h
        DB      12h
        DB      0CDh
        DB      2Dh             ; '-'
        DB      21h             ; '!'
        DB      7Eh             ; '~'
        DB      0FEh
        DB      22h             ; '"'
        DB      20h             ; ' '
        DB      01h
        DB      23h             ; '#'
        DB      0C9h
        DB      7Eh             ; '~'
        DB      23h             ; '#'
        DB      0FEh
        DB      30h             ; '0'
        DB      0DAh
        DB      4Ch             ; 'L'
        DB      15h
        DB      0FEh
        DB      3Ah             ; ':'
        DB      0DAh
        DB      0CFh
        DB      2Ch             ; ','
        DB      0CBh
        DB      0AFh
        DB      0FEh
        DB      41h             ; 'A'
        DB      0DAh
        DB      4Ch             ; 'L'
        DB      15h
        DB      0FEh
        DB      47h             ; 'G'
        DB      0D2h
        DB      4Ch             ; 'L'
        DB      15h
        DB      0C6h
        DB      0C9h
        DB      0E6h
        DB      0Fh
        DB      0CBh
        DB      47h             ; 'G'
        DB      28h             ; '('
        DB      02h
        DB      0CBh
        DB      0FFh
        DB      0CBh
        DB      4Fh             ; 'O'
        DB      28h             ; '('
        DB      02h
        DB      0CBh
        DB      0F7h
        DB      0CBh
        DB      57h             ; 'W'
        DB      28h             ; '('
        DB      02h
        DB      0CBh
        DB      0EFh
        DB      0CBh
        DB      5Fh             ; '_'
        DB      28h             ; '('
        DB      02h
        DB      0CBh
        DB      0E7h
        DB      1Fh
        DB      1Fh
        DB      1Fh
        DB      1Fh
        DB      0E6h
        DB      0Fh
        DB      0C9h
        DB      3Eh             ; '>'
        DB      80h
        DB      0F5h
        DB      0C3h
        DB      54h             ; 'T'
        DB      2Ch             ; ','
        DB      0C9h
        DB      2Bh             ; '+'
        DB      0D7h
        DB      0C8h
        DB      0CFh
        DB      2Ch             ; ','
        DB      01h
        DB      0F7h
        DB      2Ch             ; ','
        DB      0C5h
        DB      0F6h

        ; --- START PROC L2D01 ---
L2D01:  XOR     A
        LD      (8871h),A
        LD      C,(HL)
        ; --- START PROC L2D06 ---
L2D06:  CALL    L2F60
        JP      C,L125A
        XOR     A
        LD      B,A
        LD      (8872h),A
        RST     0x10
        JR      C,L2D19
        CALL    L2F61
        JR      C,L2D22
L2D19:  LD      B,A
L2D1A:  RST     0x10
        JR      C,L2D1A
        CALL    L2F61
        JR      NC,L2D1A
L2D22:  SUB     04h
        JR      NZ,L2D2E
        INC     A
        LD      (8872h),A
        RRCA
        ADD     A,B
        LD      B,A
        RST     0x10
L2D2E:  LD      A,(8892h)
        DEC     A
        JP      Z,L2DD0
        JP      P,L2D3E
        LD      A,(HL)
        SUB     28h             ; '('
        JP      Z,L2DAA
L2D3E:  XOR     A
        LD      (8892h),A
        PUSH    HL
        LD      D,B
        LD      E,C
        LD      HL,(88A5h)
        RST     0x20
        LD      DE,88A7h
        JP      Z,L046E
        LD      HL,(889Fh)
        EX      DE,HL
        LD      HL,(889Dh)
L2D56:  RST     0x20
        JP      Z,L2D6D
        LD      A,C
        SUB     (HL)
        INC     HL
        JP      NZ,L2D62
        LD      A,B
        SUB     (HL)
L2D62:  INC     HL
        JP      Z,L2D9C
        INC     HL
        INC     HL
        INC     HL
        INC     HL
        JP      L2D56

L2D6D:  POP     HL
        EX      (SP),HL
        PUSH    DE
        LD      DE,1918h
        RST     0x20
        POP     DE
        JP      Z,L2D9F
        EX      (SP),HL
        PUSH    HL
        PUSH    BC
        LD      BC,0006h
        LD      HL,(88A1h)
        PUSH    HL
        ADD     HL,BC
        POP     BC
        PUSH    HL
        CALL    L2E80
        POP     HL
        LD      (88A1h),HL
        LD      H,B
        LD      L,C
        LD      (889Fh),HL
L2D91:  DEC     HL
        LD      (HL),00h
        RST     0x20
        JR      NZ,L2D91
        POP     DE
        LD      (HL),E
        INC     HL
        LD      (HL),D
        INC     HL
L2D9C:  EX      DE,HL
        POP     HL
        RET

L2D9F:  LD      (88AEh),A
        LD      HL,1206h
        LD      (88ABh),HL
        POP     HL
        RET

L2DAA:  PUSH    HL
        LD      HL,(8871h)
        EX      (SP),HL
        LD      D,A
L2DB0:  PUSH    DE
        PUSH    BC
        CALL    L152F
        POP     BC
        POP     AF
        EX      DE,HL
        EX      (SP),HL
        PUSH    HL
        EX      DE,HL
        INC     A
        LD      D,A
        LD      A,(HL)
        CP      2Ch             ; ','
        JP      Z,L2DB0
        RST     0x08
        ADD     HL,HL
        LD      (8897h),HL
        POP     HL
        LD      (8871h),HL
        LD      E,00h
        PUSH    DE
        LD      DE,0F5E5h
L2DD0:  PUSH    HL
        PUSH    AF
        LD      HL,(889Fh)
        LD      A,19h
L2DD6:  ADD     HL,DE
        LD      DE,(88A1h)
        RST     0x20
        JR      Z,L2E03
        LD      A,(HL)
        INC     HL
        CP      C
        JR      NZ,L2DE5
        LD      A,(HL)
        CP      B
L2DE5:  INC     HL
        LD      E,(HL)
        INC     HL
        LD      D,(HL)
        INC     HL
        JR      NZ,L2DD6
        LD      A,(8871h)
        OR      A
        JP      NZ,L1263
        POP     AF
        LD      B,H
        LD      C,L
        JP      Z,L046E
        SUB     (HL)
        JP      Z,L2E5B
        ; --- START PROC L2DFD ---
L2DFD:  LD      DE,0010h
        JP      L1271

L2E03:  LD      DE,0004h
        POP     AF
        JP      Z,L154C
        LD      (HL),C
        INC     HL
        LD      (HL),B
        INC     HL
        LD      C,A
        CALL    L2E8E
        INC     HL
        INC     HL
        LD      (888Ah),HL
        LD      (HL),C
        INC     HL
        LD      A,(8871h)
        RLA
        LD      A,C
L2E1E:  LD      BC,000Bh
        JR      NC,L2E25
        POP     BC
        INC     BC
L2E25:  LD      (HL),C
        PUSH    AF
        INC     HL
        LD      (HL),B
        INC     HL
        PUSH    HL
        CALL    L061E
        EX      DE,HL
        POP     HL
        POP     AF
        DEC     A
        JR      NZ,L2E1E
        PUSH    AF
        LD      B,D
        LD      C,E
        EX      DE,HL
        ADD     HL,DE
        JP      C,L2EA5
        CALL    L2E97
        LD      (88A1h),HL
L2E42:  DEC     HL
        LD      (HL),00h
        RST     0x20
        JR      NZ,L2E42
        INC     BC
        LD      D,A
        LD      HL,(888Ah)
        LD      E,(HL)
        EX      DE,HL
        ADD     HL,HL
        ADD     HL,BC
        EX      DE,HL
        DEC     HL
        DEC     HL
        LD      (HL),E
        INC     HL
        LD      (HL),D
        INC     HL
        POP     AF
        JR      C,L2E7C
L2E5B:  LD      B,A
        LD      C,A
        LD      A,(HL)
        INC     HL
        LD      D,0E1h
L2E60:  POP     HL
        LD      E,(HL)
        INC     HL
        LD      D,(HL)
        INC     HL
        EX      (SP),HL
        PUSH    AF
        RST     0x20
        JP      NC,L2DFD
        PUSH    HL
        CALL    L061E
        POP     DE
        ADD     HL,DE
        POP     AF
        DEC     A
        LD      B,H
        LD      C,L
        JR      NZ,L2E60
        ADD     HL,HL
        ADD     HL,HL
        POP     BC
        ADD     HL,BC
        EX      DE,HL
L2E7C:  LD      HL,(8897h)
        RET

        ; --- START PROC L2E80 ---
L2E80:  CALL    L2E97
        ; --- START PROC L2E83 ---
L2E83:  PUSH    BC
        EX      (SP),HL
        POP     BC
L2E86:  RST     0x20
        LD      A,(HL)
        LD      (BC),A
        RET     Z
        DEC     BC
        DEC     HL
        JR      L2E86

        ; --- START PROC L2E8E ---
L2E8E:  PUSH    HL
        LD      HL,(88A1h)
        LD      B,00h
        ADD     HL,BC
        ADD     HL,BC
        LD      A,0E5h
        ; --- START PROC L2E97 ---
L2E97:  PUSH    HL
        LD      A,0A0h
        SUB     L
        LD      L,A
        LD      A,0FFh
        SBC     A,H
        LD      H,A
        JR      C,L2EA5
        ADD     HL,SP
        POP     HL
        RET     C
        ; --- START PROC L2EA5 ---
L2EA5:  LD      DE,000Ch
        JP      L1271

L2EAB:  DB      0C0h

        ; --- START PROC L2EAC ---
L2EAC:  LD      HL,(8823h)
        XOR     A
        LD      (HL),A
        INC     HL
        LD      (HL),A
        INC     HL
        LD      (889Dh),HL
        ; --- START PROC L2EB7 ---
L2EB7:  LD      HL,(8823h)
        DEC     HL
        ; --- START PROC L2EBB ---
L2EBB:  LD      (8895h),HL
        LD      HL,(8874h)
        LD      (8888h),HL
        XOR     A
        CALL    L2EF1
        LD      HL,(889Dh)
        LD      (889Fh),HL
        LD      (88A1h),HL
        ; --- START PROC L2ED1 ---
L2ED1:  POP     BC
        LD      HL,(881Fh)
        LD      SP,HL
        LD      HL,8878h
        LD      (8876h),HL
        CALL    L0F3F
        XOR     A
        LD      L,A
        LD      H,A
        LD      (889Bh),HL
        LD      (8892h),A
        LD      (88A5h),HL
        PUSH    HL
        PUSH    BC
        LD      HL,(8895h)
        RET

        ; --- START PROC L2EF1 ---
L2EF1:  EX      DE,HL
        LD      HL,(8823h)
        JR      Z,L2F05
        EX      DE,HL
        CALL    L1551
        PUSH    HL
        CALL    L1339
        LD      H,B
        LD      L,C
        POP     DE
        JP      NC,L15A9
L2F05:  DEC     HL
        LD      (88A3h),HL
        EX      DE,HL
        RET

L2F0B:  DB      0C0h
        DB      0F6h
        DB      0C0h
        DB      22h             ; '"'
        DB      95h
        DB      88h
        DB      21h             ; '!'
        DB      0F6h
        DB      0FFh
        DB      0C1h
        DB      2Ah             ; '*'
        DB      21h             ; '!'
        DB      88h
        DB      0F5h
        DB      7Dh             ; '}'
        DB      0A4h
        DB      3Ch             ; '<'
        DB      28h             ; '('
        DB      09h
        DB      22h             ; '"'
        DB      99h
        DB      88h
        DB      2Ah             ; '*'
        DB      95h
        DB      88h
        DB      22h             ; '"'
        DB      9Bh
        DB      88h
        DB      0CDh
        DB      3Fh             ; '?'
        DB      0Fh
        DB      0CDh
        DB      82h
        DB      0Fh
        DB      0F1h
        DB      21h             ; '!'
        DB      0Bh
        DB      12h
        DB      0C2h
        DB      8Ah
        DB      12h
        DB      0C3h
        DB      9Fh
        DB      12h
        DB      2Ah             ; '*'
        DB      9Bh
        DB      88h
        DB      7Ch             ; '|'
        DB      0B5h
        DB      11h
        DB      20h             ; ' '
        DB      00h
        DB      0CAh
        DB      71h             ; 'q'
        DB      12h
        DB      0EDh
        DB      5Bh             ; '['
        DB      99h
        DB      88h
        DB      0EDh
        DB      53h             ; 'S'
        DB      21h             ; '!'
        DB      88h
        DB      0C9h
        DB      0C3h
        DB      4Ch             ; 'L'
        DB      15h
        DB      3Eh             ; '>'
        DB      01h
        DB      32h             ; '2'
        DB      92h
        DB      88h
        DB      0CDh
        DB      01h
        DB      2Dh             ; '-'
        DB      0E5h
        DB      32h             ; '2'
        DB      92h
        DB      88h
        DB      60h             ; '`'
        DB      69h             ; 'i'
        DB      0Bh
        DB      0Bh
        DB      0Bh
        DB      0Bh

        ; --- START PROC L2F60 ---
L2F60:  LD      A,(HL)
        ; --- START PROC L2F61 ---
L2F61:  CP      41h             ; 'A'
        RET     C
        CP      5Bh             ; '['
        CCF
        RET

L2F68:  DB      0CAh
        DB      0BBh
        DB      2Eh             ; '.'
        DB      0CDh
        DB      30h             ; '0'
        DB      15h
        DB      2Bh             ; '+'
        DB      0D7h
        DB      0E5h
        DB      2Ah             ; '*'
        DB      74h             ; 't'
        DB      88h
        DB      28h             ; '('
        DB      11h
        DB      0E1h
        DB      0CFh
        DB      2Ch             ; ','
        DB      0D5h
        DB      0CDh
        DB      3Bh             ; ';'
        DB      18h
        DB      0CDh
        DB      37h             ; '7'
        DB      15h
        DB      2Bh             ; '+'
        DB      0D7h
        DB      0C2h
        DB      5Ah             ; 'Z'
        DB      12h
        DB      0E3h
        DB      0EBh
        DB      7Dh             ; '}'
        DB      93h
        DB      5Fh             ; '_'
        DB      7Ch             ; '|'
        DB      9Ah
        DB      57h             ; 'W'
        DB      0DAh
        DB      0A5h
        DB      2Eh             ; '.'
        DB      0E5h
        DB      2Ah             ; '*'
        DB      9Dh
        DB      88h
        DB      01h
        DB      28h             ; '('
        DB      00h
        DB      09h
        DB      0E7h
        DB      0D2h
        DB      0A5h
        DB      2Eh             ; '.'
        DB      0EBh
        DB      22h             ; '"'
        DB      1Fh
        DB      88h
        DB      0E1h
        DB      22h             ; '"'
        DB      74h             ; 't'
        DB      88h
        DB      0E1h
        DB      0C3h
        DB      0BBh
        DB      2Eh             ; '.'
        DB      7Dh             ; '}'
        DB      93h
        DB      5Fh             ; '_'
        DB      7Ch             ; '|'
        DB      9Ah
        DB      57h             ; 'W'
        DB      0C9h
        DB      11h
        DB      00h
        DB      00h
        DB      0C4h
        DB      01h
        DB      2Dh             ; '-'
        DB      22h             ; '"'
        DB      95h
        DB      88h
        DB      0CDh
        DB      3Ah             ; ':'
        DB      12h
        DB      0C2h
        DB      60h             ; '`'
        DB      12h
        DB      0F9h
        DB      0D5h
        DB      7Eh             ; '~'
        DB      0F5h
        DB      23h             ; '#'
        DB      0D5h
        DB      0CDh
        DB      74h             ; 't'
        DB      05h
        DB      0E3h
        DB      0E5h
        DB      0CDh
        DB      0A7h
        DB      02h
        DB      0E1h
        DB      0CDh
        DB      8Eh
        DB      05h
        DB      0E1h
        DB      0CDh
        DB      85h
        DB      05h
        DB      0E5h
        DB      0CDh
        DB      0AFh
        DB      05h
        DB      0E1h
        DB      0C1h
        DB      90h
        DB      0CDh
        DB      85h
        DB      05h
        DB      28h             ; '('
        DB      09h
        DB      0EBh
        DB      22h             ; '"'
        DB      21h             ; '!'
        DB      88h
        DB      69h             ; 'i'
        DB      60h             ; '`'
        DB      0C3h
        DB      0DDh
        DB      14h
        DB      0F9h
        DB      2Ah             ; '*'
        DB      95h
        DB      88h
        DB      7Eh             ; '~'
        DB      0FEh
        DB      2Ch             ; ','
        DB      0C2h
        DB      0E1h
        DB      14h
        DB      0D7h
        DB      0CDh
        DB      0B2h
        DB      2Fh             ; '/'

        ; --- START PROC L2FF7 ---
L2FF7:  LD      HL,30C9h
        LD      BC,0051h
        LD      DE,87D7h
        LDIR
        EX      DE,HL
        LD      SP,HL
        CALL    L2ED1
        CALL    L0F92
        LD      (8870h),A
        LD      (88C0h),A
        LD      DE,0C000h
        EX      DE,HL
        DEC     HL
        LD      A,0D9h
        LD      B,(HL)
        LD      (HL),A
        CP      (HL)
        LD      (HL),B
        JP      NZ,L2EA5
        DEC     HL
        LD      DE,012Ch
        RST     0x20
        JP      C,L2EA5
        LD      DE,0FFCEh
        LD      (8874h),HL
        ADD     HL,DE
        LD      (881Fh),HL
        CALL    L2EAC
        LD      HL,(881Fh)
        LD      DE,0FFEFh
        ADD     HL,DE
        LD      DE,88C0h
        LD      A,L
        SUB     E
        LD      L,A
        LD      A,H
        SBC     A,D
        LD      H,A
        PUSH    HL
L3044:  LD      DE,0027h
        LD      A,D
        OR      A
        JP      NZ,L3044
        LD      A,E
        CP      0Fh
        JP      C,L3044
        LD      (881Ch),A
L3055:  SUB     0Eh
        JP      NC,L3055
        ADD     A,1Ch
        CPL
        INC     A
        ADD     A,E
        LD      (881Dh),A
        LD      A,38h           ; '8'
        LD      (87CAh),A
        LD      A,01h
        LD      (87CDh),A
        LD      HL,30A7h
        CALL    L2838
        LD      HL,30A7h
        CALL    L2838
        LD      A,08h
        LD      (87CAh),A
        LD      A,00h
        LD      (87CDh),A
        LD      A,91h
        RST     0x30
        POP     HL
        CALL    L06C9
        LD      HL,3099h
        CALL    L2838
        LD      SP,882Ch
        ; --- START PROC L3090 ---
L3090:  INC     L
        ADC     A,B
        CALL    L2ED1
        JP      L129F

L3098:  DB      "  Bytes free"
        DB      83h
        DB      00h
        DB      "BBAASSIICC  VVIIDDEEOOPPAACC++  "
        DB      83h
        DB      00h
        DB      00h
        DB      0C3h
        DB      90h
        DB      30h             ; '0'
        DB      0C3h
        DB      4Ch             ; 'L'
        DB      15h
        DB      0C9h
        DB      00h
        DB      00h
        DB      0D6h
        DB      00h
        DB      6Fh             ; 'o'
        DB      7Ch             ; '|'
        DB      0DEh
        DB      00h
        DB      67h             ; 'g'
        DB      78h             ; 'x'
        DB      0DEh
        DB      00h
        DB      47h             ; 'G'
        DB      3Eh             ; '>'
        DB      00h
        DB      0C9h
        DB      00h
        DB      00h
        DB      00h
        DB      35h             ; '5'
        DB      4Ah             ; 'J'
        DB      0CAh
        DB      99h
        DB      39h             ; '9'
        DB      1Ch
        DB      76h             ; 'v'
        DB      98h
        DB      22h             ; '"'
        DB      95h
        DB      0B3h
        DB      98h
        DB      0Ah
        DB      0DDh
        DB      47h             ; 'G'
        DB      98h
        DB      53h             ; 'S'
        DB      0D1h
        DB      99h
        DB      99h
        DB      0Ah
        DB      1Ah
        DB      9Fh
        DB      98h
        DB      65h             ; 'e'
        DB      0BCh
        DB      0CDh
        DB      98h
        DB      0D6h
        DB      77h             ; 'w'
        DB      3Eh             ; '>'
        DB      98h
        DB      52h             ; 'R'
        DB      0C7h
        DB      4Fh             ; 'O'
        DB      80h
        DB      0DBh
        DB      00h
        DB      0C9h
        DB      00h
        DB      00h
        DB      00h
        DB      00h
        DB      20h             ; ' '
        DB      0Eh
        DB      00h
        DB      24h             ; '$'
        DB      89h
        DB      0FEh
        DB      0FFh
        DB      0C1h
        DB      88h

        ; --- START PROC Inicializacion ---
Inicializacion:
		DI						; Deshabilita interrupciones
        LD      SP,0BFFEh		; Pone el puntero de pila en BFFE
        XOR     A
        OUT     (7Fh),A         ; Envía el valor 0 al puerto 7F
        OUT     (0BFh),A		; y al puerto BF
        LD      (87BBh),A		; Pone a 0 la posición de RAM 87BB
        LD      A,0C9h
        LD      (87DDh),A		; Pone el valor C9 en la posición RAM 87DD
        IM      1				; Pone el modo 1 de interrupción (todas las interrupciones saltan a 0x0038)
        EI						; Habilita las interrupciones
        LD      HL,0001h
        LD      (87C2h),HL		; Pone en RAM 87C2 el valor de 16 bits 0001
        CALL    L1AE3
        LD      HL,0000h		; Este bucle busca en la ROM (empieza por 0)
        LD      DE,87CFh		; el valor que se encuentra en RAM 87CF
        LD      BC,0005h		; durante un máximo de 5 posiciones de ROM
L313D:  LD      A,(DE)
        CPI
        INC     DE
        JP      NZ,L314A		; Si no se encuentra el valor, salta a L314A
        JP      PE,L313D		; Repite la búsqueda 5 veces
        JP      L3090			; Salta a L3090

L314A:  LD      HL,0000h		; Copia los primeros 5 bytes de ROM...
        LD      DE,87CFh		; ...en la memoria RAM 87CF
        LD      BC,0005h
        LDIR
        JP      L2FF7

L3158:  DB      08h
        DB      80h
        DB      58h             ; 'X'
        DB      80h
        DB      0A8h
        DB      80h
        DB      0F8h
        DB      80h
        DB      48h             ; 'H'
        DB      81h
        DB      98h
        DB      81h
        DB      0E8h
        DB      81h
        DB      38h             ; '8'
        DB      82h
        DB      88h
        DB      82h
        DB      0D8h
        DB      82h
        DB      28h             ; '('
        DB      83h
        DB      78h             ; 'x'
        DB      83h
        DB      0C8h
        DB      83h
        DB      18h
        DB      84h
        DB      68h             ; 'h'
        DB      84h
        DB      0B8h
        DB      84h
        DB      08h
        DB      85h
        DB      58h             ; 'X'
        DB      85h
        DB      0A8h
        DB      85h
        DB      0F8h
        DB      85h
        DB      48h             ; 'H'
        DB      86h
        DB      98h
        DB      86h
        DB      0E8h
        DB      86h
        DB      38h             ; '8'
        DB      87h
;; Desde esta posición (0x3188) hasta el final (0x3FFF) es relleno de la ROM (0xFF)