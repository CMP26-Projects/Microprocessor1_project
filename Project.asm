;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;; MACROS ;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;MACRO TO DRAW AN IMAGE GIVEN THESE PARAMS

DRAW MACRO IMG, WID, HEI, STARX, STARY
MOV AX, OFFSET IMG
MOV IMGTODRAW, AX
MOV AX, WID
MOV WIDTODRAW, AX
MOV AX, HEI
MOV HEITODRAW, AX
MOV AX, STARX
MOV STARXTODRAW, AX
MOV AX, STARY
MOV STARYTODRAW, AX
CALL DRAWIMAGE
MOV LASTDI, DI
ENDM

;THIS MACRO CHECKS ONLY THE BYTES AT THE WIDTH AND HEIGHT FOR SIMPLICITY AND FAST RUN
; CHECKCANDRAW MACRO WID, HEI, STARX, STARY, DIRECTION
;     LOCAL HOR, VER, FINISH, HANDLECANTDRAW, CONTINUEUP, CONTINUERIGHT, CONTINUEDOWN, CONTINUELEFT
;     ;VIDEO MEMORY
;     MOV AX, 0A000H
;     MOV ES, AX

;     MOV DI, STARY
;     MOV AX, SCREENWIDTH
;     MUL DI
;     MOV DI, AX
;     ADD DI, STARX
    
;     MOV AX, WID
;     PUSH DI
;     MOV INCOUNTER, AX
;     HOR:
;         CMP BYTE PTR ES:[DI], 20
;         JE HANDLECANTDRAW
;         CMP BYTE PTR ES:[DI], 31
;         JE HANDLECANTDRAW
;         INC DI
;         DEC INCOUNTER
;     JNZ HOR
;     POP DI

;     MOV AX, HEI
;     MOV OUTCOUNTER, AX
;     VER:
;         CMP BYTE PTR ES:[DI], 20
;         JE HANDLECANTDRAW
;         CMP BYTE PTR ES:[DI], 31
;         JE HANDLECANTDRAW
;         ADD DI, SCREENWIDTH
;         DEC OUTCOUNTER
;     JNZ VER
;     JMP FINISH

;     HANDLECANTDRAW:
;     CMP DIRECTION, 0
;     JNE CONTINUEUP
;     MOV CANTUP, 1
;     CONTINUEUP:
    
;     CMP DIRECTION, 1
;     JNE CONTINUERIGHT
;     MOV CANTRIGHT, 1
;     CONTINUERIGHT:
    
;     CMP DIRECTION, 2
;     JNE CONTINUEDOWN
;     MOV CANTDOWN, 1
;     CONTINUEDOWN:

;     CMP DIRECTION, 3
;     JNE CONTINUELEFT
;     MOV CANTLEFT, 1
;     CONTINUELEFT:

;     JMP RANDOMIZEPART
;     FINISH:
; ENDM



;THIS MACRO CHECKS THE WHOLE AREA TO BE DRAWN

CHECKCANDRAW MACRO WID, HEI, STARX, STARY, DIRECTION
    LOCAL ROWS, COLS, FINISH, HANDLECANTDRAW, CONTINUEUP, CONTINUERIGHT, CONTINUEDOWN, CONTINUELEFT
    ;VIDEO MEMORY
    MOV AX, 0A000H
    MOV ES, AX 
    MOV DI, STARY
    MOV AX, SCREENWIDTH
    MUL DI
    MOV DI, AX
    ADD DI, STARX
    MOV AX, HEI
    MOV OUTCOUNTER, AX

    ROWS:
        MOV FIRSTBYTEINROW, DI
        MOV AX, WID
        MOV INCOUNTER, AX
        COLS:
            CMP BYTE PTR ES:[DI], 20
            JE HANDLECANTDRAW
            CMP BYTE PTR ES:[DI], 31
            JE HANDLECANTDRAW
            INC DI
            DEC INCOUNTER
        JNZ COLS
        MOV DI, FIRSTBYTEINROW
        ADD DI, SCREENWIDTH
    DEC OUTCOUNTER
    JNZ ROWS
    JMP FINISH

    HANDLECANTDRAW:
    CMP DIRECTION, 0
    JNE CONTINUEUP
    MOV CANTUP, 1
    CONTINUEUP:
    
    CMP DIRECTION, 1
    JNE CONTINUERIGHT
    MOV CANTRIGHT, 1
    CONTINUERIGHT:
    
    CMP DIRECTION, 2
    JNE CONTINUEDOWN
    MOV CANTDOWN, 1
    CONTINUEDOWN:

    CMP DIRECTION, 3
    JNE CONTINUELEFT
    MOV CANTLEFT, 1
    CONTINUELEFT:

    JMP RANDOMIZEPART
    FINISH:
ENDM


CHECKPOSSIBILITIES MACRO
    CMP CANTUP, 0
    JE START
    CMP CANTRIGHT, 0
    JE START
    CMP CANTDOWN, 0
    JE START
    CMP CANTLEFT, 0
    JE START
    JMP LAST
ENDM


.MODEL MEDIUM
.STACK 64
.DATA
;BACKGROUND
BACKGROUNDIMAGEPARTH    EQU     16
BACKGROUNDIMAGEPARTW    EQU     16
BACKGROUNDIMAGEPART     DB      142, 193, 142, 142, 71, 142, 193, 142, 143, 193, 142, 142, 142, 71, 142, 142, 71, 142, 193, 142, 71, 142, 193, 142, 142, 142, 142, 142, 142, 142, 142, 142, 142, 142, 193, 142, 142, 142, 142, 142
 DB 71, 142, 142, 142, 193, 142, 142, 71, 142, 142, 142, 142, 143, 142, 142, 142, 142, 71, 142, 193, 142, 142, 143, 71, 142, 143, 142, 142, 142, 142, 142, 142, 142, 71, 142, 193, 142, 142, 142, 71
 DB 142, 142, 142, 71, 142, 142, 142, 142, 142, 142, 142, 142, 142, 193, 142, 142, 142, 142, 142, 142, 71, 142, 193, 142, 142, 143, 142, 142, 142, 193, 142, 142, 142, 193, 142, 142, 71, 142, 142, 193
 DB 142, 142, 142, 142, 142, 142, 142, 193, 142, 142, 193, 142, 71, 142, 142, 193, 142, 142, 142, 71, 142, 142, 193, 142, 142, 142, 193, 142, 142, 142, 142, 142, 142, 142, 71, 142, 142, 193, 142, 143
 DB 142, 142, 142, 142, 142, 142, 142, 142, 142, 142, 71, 142, 142, 193, 142, 142, 143, 142, 142, 142, 193, 142, 142, 71, 142, 142, 142, 142, 142, 142, 142, 142, 71, 142, 142, 193, 142, 142, 71, 142
 DB 143, 142, 142, 142, 143, 142, 142, 142, 142, 71, 142, 193, 142, 142, 71, 142, 142, 142, 193, 142, 142, 142, 71, 142, 142, 71, 142, 142, 142, 142, 71, 142, 142, 193, 142, 142, 142, 71, 142, 142
 DB 142, 143, 142, 71, 142, 193, 142, 142, 142, 193, 142, 143, 142, 71, 142, 142
SCREENWIDTH             EQU     320
SCREENHEIGHT            EQU     200
SCREENSIZE              EQU     32*32


;CAR
CARIMG                  DB      142, 142, 0, 0, 142, 142, 142, 46, 46, 46, 46, 142, 0, 46, 16, 112, 46, 0, 0, 46, 112, 16, 46, 0, 142, 46, 46, 46, 46, 142, 142, 142, 0, 0, 142, 142

;START FLAG
STARTFLAGIMGW           EQU     4
STARTFLAGIMGH           EQU     20
STARTFLAGIMG            DB      16, 16, 29, 29, 16, 16, 29, 29, 29, 29, 16, 16, 29, 29, 16, 16, 16, 16, 29, 29, 16, 16, 29, 29, 29, 29, 16, 16, 29, 29, 16, 16, 16, 16, 29, 29, 16, 16, 29, 29
 DB 29, 29, 16, 16, 29, 29, 16, 16, 16, 16, 29, 29, 16, 16, 29, 29, 29, 29, 16, 16, 29, 29, 16, 16, 16, 16, 29, 29, 16, 16, 29, 29, 29, 29, 16, 16, 29, 29, 16, 16

;END FLAG
HORENDFLAGIMGW          EQU     20
HORENDFLAGIMGH          EQU     6
HORENDFLAGIMG           DB      31, 31, 40, 40, 31, 31, 40, 40, 31, 31, 40, 40, 31, 31, 40, 40, 31, 31, 40, 40, 31, 31, 40, 40, 31, 31, 40, 40, 31, 31, 40, 40, 31, 31, 40, 40, 31, 31, 40, 40
 DB 31, 31, 40, 40, 31, 31, 40, 40, 31, 31, 40, 40, 31, 31, 40, 40, 31, 31, 40, 40, 40, 40, 31, 31, 40, 40, 31, 31, 40, 40, 31, 31, 40, 40, 31, 31, 40, 40, 31, 31
 DB 40, 40, 31, 31, 40, 40, 31, 31, 40, 40, 31, 31, 40, 40, 31, 31, 40, 40, 31, 31, 40, 40, 31, 31, 40, 40, 31, 31, 40, 40, 31, 31, 40, 40, 31, 31, 40, 40, 31, 31
VERENDFLAGIMGW          EQU     6
VERENDFLAGIMGH          EQU     20
VERENDFLAGIMG           DB      40, 40, 40, 31, 31, 31, 40, 40, 40, 31, 31, 31, 31, 31, 31, 40, 40, 40, 31, 31, 31, 40, 40, 40, 40, 40, 40, 31, 31, 31, 40, 40, 40, 31, 31, 31, 31, 31, 31, 40 
 DB 40, 40, 31, 31, 31, 40, 40, 40, 40, 40, 40, 31, 31, 31, 40, 40, 40, 31, 31, 31, 31, 31, 31, 40, 40, 40, 31, 31, 31, 40, 40, 40, 40, 40, 40, 31, 31, 31, 40, 40 
 DB 40, 31, 31, 31, 31, 31, 31, 40, 40, 40, 31, 31, 31, 40, 40, 40, 40, 40, 40, 31, 31, 31, 40, 40, 40, 31, 31, 31, 31, 31, 31, 40, 40, 40, 31, 31, 31, 40, 40, 40

;TEMPORARY X AND Y
TEMPX                   DW      ?
TEMPY                   DW      ?

;WE SAVE LAST DIRECTION TO PRINT THE END RACE LINE 
LASTDIR                 DW      ?
LASTDI                  DW      ?

;TEMPORARY VARIABLE
TMP                     DW      ?
TMP1                    DW      ?
TMP2                    DW      ?
TMP3                    DW      ?
TMP4                    DW      ?

;INFINITELOOP RANDOMIZATIONS STORAGE
CANTUP                  DW      0
CANTRIGHT               DW      0
CANTDOWN                DW      0
CANTLEFT                DW      0

;COUNTERS FOR CHECKDRAW
OUTCOUNTER              DW      ?
INCOUNTER               DW      ?
FIRSTBYTEINROW          DW      ?

;STARTdd
STARTROADX              EQU     0
STARTROADY              EQU     50

;VARIABLES FOR DRAWIMAGE PROCEDURE
IMGTODRAW               DW      ?
WIDTODRAW               DW      ?
HEITODRAW               DW      ?
STARXTODRAW             DW      ?
STARYTODRAW             DW      ?

;CONSTRAINTS          ;;;; 10 GAB IS LET
XNOLEFT                 EQU     22
XNORIGHT                EQU     248
YNOUP                   EQU     22
YNODOWN                 EQU     128

;DIRECTIONS
UPDIR                   DW      ?
RIGHTDIR                DW      ?
DOWNDIR                 DW      ?
LEFTDIR                 DW      ?

;ROAD IMAGES
VERROADIMGW             EQU     20
VERROADIMGH             EQU     50
VERROADIMG              DB      20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20
 DB 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20
 DB 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20
 DB 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20
 DB 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20
 DB 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20
 DB 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20
 DB 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 31, 31, 20, 20, 20, 20, 20, 20, 20, 20, 20
 DB 20, 20, 20, 20, 20, 20, 20, 20, 20, 31, 31, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 31, 31, 20, 20, 20, 20, 20, 20, 20, 20, 20
 DB 20, 20, 20, 20, 20, 20, 20, 20, 20, 31, 31, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 31, 31, 20, 20, 20, 20, 20, 20, 20, 20, 20
 DB 20, 20, 20, 20, 20, 20, 20, 20, 20, 31, 31, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20
 DB 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 31, 31, 20, 20, 20, 20, 20, 20, 20, 20, 20
 DB 20, 20, 20, 20, 20, 20, 20, 20, 20, 31, 31, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 31, 31, 20, 20, 20, 20, 20, 20, 20, 20, 20
 DB 20, 20, 20, 20, 20, 20, 20, 20, 20, 31, 31, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 31, 31, 20, 20, 20, 20, 20, 20, 20, 20, 20
 DB 20, 20, 20, 20, 20, 20, 20, 20, 20, 31, 31, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20
 DB 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 31, 31, 20, 20, 20, 20, 20, 20, 20, 20, 20
 DB 20, 20, 20, 20, 20, 20, 20, 20, 20, 31, 31, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 31, 31, 20, 20, 20, 20, 20, 20, 20, 20, 20
 DB 20, 20, 20, 20, 20, 20, 20, 20, 20, 31, 31, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 31, 31, 20, 20, 20, 20, 20, 20, 20, 20, 20
 DB 20, 20, 20, 20, 20, 20, 20, 20, 20, 31, 31, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20
 DB 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20
 DB 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20
 DB 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20
 DB 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20
 DB 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20
 DB 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20

HORROADIMGW             EQU     50
HORROADIMGH             EQU     20
HORROADIMG              DB      20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20
 DB 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20
 DB 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20
 DB 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20
 DB 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20
 DB 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20
 DB 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20
 DB 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20
 DB 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20
 DB 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20
 DB 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20
 DB 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 31, 31, 31, 31, 31, 31, 20, 20, 31, 31, 31, 31, 31, 31, 20
 DB 20, 31, 31, 31, 31, 31, 31, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 31, 31, 31, 31, 31
 DB 31, 20, 20, 31, 31, 31, 31, 31, 31, 20, 20, 31, 31, 31, 31, 31, 31, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20
 DB 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20
 DB 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20
 DB 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20
 DB 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20
 DB 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20
 DB 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20
 DB 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20
 DB 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20
 DB 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20
 DB 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20
 DB 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20

.CODE

DRAWBCKGROUND PROC
    MOV CX, 12
    MOV TEMPX, 0
    MOV TEMPY, 0
    OUTERLOOP:
    PUSH CX
    MOV CX, 20
    INNERLOOP:
        DRAW BACKGROUNDIMAGEPART , BACKGROUNDIMAGEPARTW, BACKGROUNDIMAGEPARTH, TEMPX, TEMPY
        ADD TEMPX, BACKGROUNDIMAGEPARTW
    LOOP INNERLOOP
    MOV TEMPX, 0
    ADD TEMPY, BACKGROUNDIMAGEPARTH
    POP CX
    LOOP OUTERLOOP
    RET
DRAWBCKGROUND ENDP

;PROC TO DRAW AN IMAGE
DRAWIMAGE PROC FAR 
    PUSH CX
    ;VIDEO MEMORY
    MOV AX, 0A000H
    MOV ES, AX

    MOV DI, STARYTODRAW
    MOV AX, SCREENWIDTH
    MUL DI
    MOV DI, AX
    ADD DI, STARXTODRAW
    
    MOV CX, HEITODRAW
    MOV SI, IMGTODRAW

    ROWS:
        PUSH CX
        PUSH DI
        MOV CX, WIDTODRAW
        COLS:
            MOV DL, BYTE PTR [SI]
            MOV ES:[DI], DL
            INC SI
            INC DI
        LOOP COLS
        POP DI
        POP CX
        ADD DI, SCREENWIDTH
    LOOP ROWS
    MOV DI, STARYTODRAW
    MOV AX, SCREENWIDTH
    MUL DI
    MOV DI, AX
    ADD DI, STARXTODRAW
    ADD DI, WIDTODRAW
    POP CX
    RET
DRAWIMAGE ENDP





;PROC TO RANDOMIZE
GetSystemTime PROC
    MOV AH, 2Ch  ; INTERRUPT to get system time
    INT 21h
    RET
GetSystemTime ENDP



;PROC TO GET THE POSIBLE POINTS AFTER DRAWING UP
POINTSAFTERUP PROC
    CALL CALCXY ; AS WE NEED IT IN THE LEFT DIR

    MOV UPDIR, DI
    CMP UPDIR, VERROADIMGH*SCREENWIDTH + VERROADIMGW  ;CHECKING FOR OVERFLOWING THE SCREEN
    JA FIRSTUP
    MOV UPDIR, 0
    JMP NOTFIRSTUP
    FIRSTUP:
    SUB UPDIR, VERROADIMGH*SCREENWIDTH + VERROADIMGW 
    NOTFIRSTUP:

    MOV RIGHTDIR, DI
    SUB RIGHTDIR, HORROADIMGH*SCREENWIDTH + VERROADIMGW 
    MOV DOWNDIR, 0
    
    CMP TEMPX, HORROADIMGW
    JA FIRSTLEFT
    MOV LEFTDIR, 0
    JMP NOTFIRSTLEFT
    FIRSTLEFT:
    MOV LEFTDIR, DI
    SUB LEFTDIR, HORROADIMGH*SCREENWIDTH + HORROADIMGW
    NOTFIRSTLEFT:
    RET
POINTSAFTERUP ENDP

;PROC TO GET THE POSIBLE POINTS AFTER DRAWING RIGHT
POINTSAFTERRIGHT PROC
    MOV UPDIR, DI
    CMP UPDIR, (VERROADIMGH-HORROADIMGH)*SCREENWIDTH
    JA SECONDUP
    MOV UPDIR, 0
    JMP NOTSECONDUP
    SECONDUP:
    SUB UPDIR, (VERROADIMGH-HORROADIMGH)*SCREENWIDTH  ;VERROADIMGH-HORROADIMGH = 30
    NOTSECONDUP:

    MOV RIGHTDIR, DI
    MOV DOWNDIR, DI
    MOV LEFTDIR, 0
    RET
POINTSAFTERRIGHT ENDP

;PROC TO GET THE POSIBLE POINTS AFTER DRAWING DOWN
POINTSAFTERDOWN PROC
    CALL CALCXY
    MOV UPDIR, 0
    MOV RIGHTDIR, DI
    SUB RIGHTDIR, VERROADIMGW
    ADD RIGHTDIR, VERROADIMGH * SCREENWIDTH
    MOV DOWNDIR, DI
    SUB DOWNDIR, VERROADIMGW
    ADD DOWNDIR, VERROADIMGH * SCREENWIDTH

    CMP TEMPX, HORROADIMGW
    JA THIRDLEFT
    MOV LEFTDIR, 0
    JMP NOTTHIRDLEFT
    THIRDLEFT:
    MOV LEFTDIR, DI
    SUB LEFTDIR, HORROADIMGW
    ADD LEFTDIR, VERROADIMGH * SCREENWIDTH
    NOTTHIRDLEFT:
    RET
POINTSAFTERDOWN ENDP

;PROC TO GET THE POSIBLE POINTS AFTER DRAWING LEFT
POINTSAFTERLEFT PROC
    CALL CALCXY
    MOV UPDIR, DI
    CMP UPDIR, HORROADIMGW + VERROADIMGW + (VERROADIMGH - HORROADIMGH) * SCREENWIDTH
    JA FOURTHUP
    MOV UPDIR, 0
    JMP NOTFOURTHUP
    FOURTHUP:
    SUB UPDIR, HORROADIMGW + VERROADIMGW + (VERROADIMGH - HORROADIMGH) * SCREENWIDTH 
    NOTFOURTHUP:
    MOV RIGHTDIR, 0
    MOV DOWNDIR, DI
    SUB DOWNDIR, HORROADIMGW + VERROADIMGW

    CMP TEMPX, 2 * HORROADIMGW
    JA FOURTHLEFT
    MOV LEFTDIR, 0
    JMP NOTFOURTHLEFT
    FOURTHLEFT:
    MOV LEFTDIR, DI
    SUB LEFTDIR, 2 * HORROADIMGW
    NOTFOURTHLEFT:
    RET
POINTSAFTERLEFT ENDP



;PROCEDURE TO CALCULATE X AND Y FROM THE LOCATION OF THE BYTE
CALCXY PROC  
    MOV AX, DI
    MOV DX, 0
    MOV BX, SCREENWIDTH
    DIV BX
    MOV TEMPX, DX
    MOV TEMPY, AX
    RET
CALCXY ENDP



;PROC TO DRAW THE END RACE LINE
DRAWENDLINE PROC
    ;THIS CAN BE EDITED INTO THE PROC CALCXY(OPTIMIZATION)
    MOV AX, LASTDI
    MOV DX, 0
    MOV BX, SCREENWIDTH
    DIV BX
    MOV TEMPX, DX
    MOV TEMPY, AX

    CMP LASTDIR, 0
    JNE NOTLASTUP
    SUB TEMPX, VERROADIMGW
    SUB TEMPY, HORENDFLAGIMGH*SCREENWIDTH
    DRAW HORENDFLAGIMG, HORENDFLAGIMGW, HORENDFLAGIMGH, TEMPX, TEMPY
    JMP FINISHDRAWENDLINE
    NOTLASTUP:

    CMP LASTDIR, 1
    JNE NOTLASTRIGHT
    DRAW VERENDFLAGIMG, VERENDFLAGIMGW, VERENDFLAGIMGH, TEMPX, TEMPY
    JMP FINISHDRAWENDLINE
    NOTLASTRIGHT:

    CMP LASTDIR, 2
    JNE NOTLASTDOWN
    SUB TEMPX, VERROADIMGW
    ADD TEMPY, VERROADIMGH
    DRAW HORENDFLAGIMG, HORENDFLAGIMGW, HORENDFLAGIMGH, TEMPX, TEMPY
    JMP FINISHDRAWENDLINE
    NOTLASTDOWN:
    
    SUB TEMPX, HORROADIMGW + VERENDFLAGIMGW
    DRAW VERENDFLAGIMG, VERENDFLAGIMGW, VERENDFLAGIMGH, TEMPX, TEMPY
    
    FINISHDRAWENDLINE:
    RET
DRAWENDLINE ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;; MAIN ;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
MAIN PROC FAR
MOV AX, @DATA
MOV DS, AX

MOV AH,0
MOV AL,13H
INT 10H

MOV AX, 0A000H
MOV ES, AX


;;;;;;;;;; DRAWING ROAD ;;;;;;;;;;;;


;DRAWING PART OF ROAD 
;DRAW BACKGROUNDIMAGE, SCREENWIDTH, SCREENHEIGHT, 0, 0
CALL DRAWBCKGROUND
DRAW HORROADIMG , HORROADIMGW, HORROADIMGH, STARTROADX, STARTROADY
CALL POINTSAFTERRIGHT
DRAW STARTFLAGIMG, STARTFLAGIMGW, STARTFLAGIMGH, STARTROADX, STARTROADY

DRAW CARIMG, 6, 6, 20, 140

;THIS IS TO RANDOMIZE NUMBER FROM 0 TO 3 TO SPECIFY THE DIRECTON
MOV CX, 20
RANDOMIZEPART:
    CHECKPOSSIBILITIES
    START:
    PUSH CX
    MOV CX, 64000
    WASTETIME:
        AND AX, AX
        ADD AX, 0
        ADD AX, 0
        ADD BX, 0
        AND BX, BX
    LOOP WASTETIME
    CALL GetSystemTime
    POP CX
    AND DL, 3
    CMP DL, 0  ;UP
    JE CHECKUP
    CMP DL, 1  ;RIGHT
    JE CHECKRIGHT
    CMP DL, 2  ;DOWN
    JE CHECKDOWN
    JMP CHECKLEFT ;left

    CHECKUP:
    CMP UPDIR, 0
    JNE CONTUP
    MOV CANTUP, 1
    JMP RANDOMIZEPART
    CONTUP:

    MOV AX, UPDIR
    MOV DX, 0
    MOV BX, SCREENWIDTH
    DIV BX
    MOV TEMPX, DX
    MOV TEMPY, AX
    CMP TEMPY, YNOUP
    JAE HANDLEUP
    MOV CANTUP, 1
    JMP RANDOMIZEPART

    CHECKRIGHT:
    CMP RIGHTDIR, 0
    JNE CONTRIGHT
    MOV CANTRIGHT, 1
    JMP RANDOMIZEPART
    CONTRIGHT:

    MOV AX, RIGHTDIR
    MOV DX, 0
    MOV BX, SCREENWIDTH
    DIV BX
    MOV TEMPX, DX
    MOV TEMPY, AX
    CMP TEMPX, XNORIGHT
    JBE HANDLERIGHT
    MOV CANTRIGHT, 1
    JMP RANDOMIZEPART 
    
    CHECKDOWN:
    CMP DOWNDIR, 0
    JNE CONTDOWN
    MOV CANTDOWN, 1
    JMP RANDOMIZEPART
    CONTDOWN:

    MOV AX, DOWNDIR
    MOV DX, 0
    MOV BX, SCREENWIDTH
    DIV BX
    MOV TEMPX, DX
    MOV TEMPY, AX
    CMP TEMPY, YNODOWN
    JBE HANDLEDOWN
    MOV CANTDOWN, 1
    JMP RANDOMIZEPART
    
    CHECKLEFT:
    CMP LEFTDIR, 0
    JNE CONTLEFT
    MOV CANTLEFT, 1
    JMP RANDOMIZEPART
    CONTLEFT:

    MOV AX, LEFTDIR
    MOV DX, 0
    MOV BX, SCREENWIDTH
    DIV BX
    MOV TEMPX, DX
    MOV TEMPY, AX
    CMP TEMPX, XNOLEFT
    JAE HANDLELEFT
    MOV CANTLEFT, 1
    JMP RANDOMIZEPART





;THIS PART OF HANDLES WAS REVISED
    ;WE CHECK AGAIN HERE FOR THE SCREEN EDGES 
    HANDLEUP:
    MOV TMP, 0
    ;THIS IS TO LEAVE SOME SPACE FOR A ORTHOGONAL PART TO BE DRAWN
    MOV TMP1, VERROADIMGH + HORROADIMGH + 2
    SUB TEMPY, HORROADIMGH + 2
    CHECKCANDRAW VERROADIMGW, TMP1, TEMPX, TEMPY, TMP
    ADD TEMPY, HORROADIMGH + 2
    DRAW VERROADIMG, VERROADIMGW, VERROADIMGH, TEMPX, TEMPY
    MOV LASTDIR, 0
    CALL POINTSAFTERUP
    JMP FINISH

    HANDLERIGHT:
    MOV TMP, 1
    MOV TMP1, HORROADIMGW + VERROADIMGW + 2  
    CHECKCANDRAW TMP1, HORROADIMGH, TEMPX, TEMPY, TMP
    DRAW HORROADIMG, HORROADIMGW, HORROADIMGH, TEMPX, TEMPY
    MOV LASTDIR, 1
    CALL POINTSAFTERRIGHT
    JMP FINISH
    
    HANDLEDOWN:
    MOV TMP, 2
    MOV TMP1, VERROADIMGH + HORROADIMGH + 2
    CHECKCANDRAW VERROADIMGW, TMP1, TEMPX, TEMPY, TMP
    DRAW VERROADIMG, VERROADIMGW, VERROADIMGH, TEMPX, TEMPY
    MOV LASTDIR, 2
    CALL POINTSAFTERDOWN
    JMP FINISH
    
    HANDLELEFT:
    MOV TMP, 3
    MOV TMP1, HORROADIMGW + VERROADIMGW + 2
    SUB TEMPX, VERROADIMGW + 2
    CHECKCANDRAW TMP1, HORROADIMGH, TEMPX, TEMPY, TMP
    ADD TEMPX, VERROADIMGW + 2
    DRAW HORROADIMG, HORROADIMGW, HORROADIMGH, TEMPX, TEMPY
    MOV LASTDIR, 3
    CALL POINTSAFTERLEFT

    FINISH:
;INITIALIZING CANT DRAW ARRAY
MOV CANTUP, 0
MOV CANTRIGHT, 0
MOV CANTDOWN, 0
MOV CANTLEFT, 0

DEC CX
JNZ GOUP
JMP LAST
GOUP:
JMP FAR PTR RANDOMIZEPART


LAST:
CALL DRAWENDLINE

MAIN ENDP


END MAIN





; MOV DI, 0

; ;BACKGROUND WITH IMAGE
; BACKGROUND:
;     MOV CX, SCREENSIZE
;     MOV Bx, offset img
; BACKGROUNDLOOP:
;     MOV DL, BYTE PTR [Bx]
;     MOV ES:[DI], DL
;     INC DI
;     INC BX
; LOOP BACKGROUNDLOOP