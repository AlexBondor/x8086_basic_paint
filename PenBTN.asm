PUBLIC pencilBTN

GLOBAL drawFrame:FAR
GLOBAL fillFrame:FAR

DATA SEGMENT PARA PUBLIC 'DATA'
pen DB "PEN$" ;button label
DATA ENDS

CODE_F SEGMENT PARA PUBLIC 'CODE' 
ASSUME CS:CODE_F, DS:DATA
PencilBTN PROC FAR 

MOV AX, DATA
MOV DS, AX

MOV AX, 0002h ;hide mouse cursor
INT 33h

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;DRAW FRAME OF PENCIL BUTTON;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
MOV AX, ES:[0004] ;get colour from ES:[0004] - colour values only 25 or 27 here
CMP AX, 25		  ;if colour == 25 (button pressed)
JE add2			  ;then add 2 => colour = 27
SUB AX, 2		  ;else sub 2 => colour = 25
JMP cont
add2: ADD AX, 2
cont:
MOV ES:[0000], AX

MOV AX, 170    ;x coordinate of start point
MOV BX, 0      ;y coordinate of start point
MOV CX, 199    ;x coordinate of end point
MOV DX, 50     ;y coordinate of end point
CALL drawFrame ;prints board frame


MOV AX, 26     ;colour no.
               ; drawFrame will load the colour no.
               ; from ES:[0000]
MOV ES:[0000], AX 
MOV AX, 171    ;x coordinate of start point
MOV BX, 1      ;y coordinate of start point
MOV CX, 198    ;x coordinate of end point
MOV DX, 49     ;y coordinate of end point
CALL drawFrame ;prints board frame


MOV AX, ES:[0004]
MOV ES:[0000], AX 
MOV AX, 172    ;x coordinate of start point
MOV BX, 2      ;y coordinate of start point
MOV CX, 197    ;x coordinate of end point
MOV DX, 48     ;y coordinate of end point
CALL drawFrame ;prints board frame

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;FILL FRAME OF PENCIL BUTTON;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
MOV AX, ES:[0004]
MOV ES:[0000], AX 
MOV AX, 173    ;x coordinate of start point
MOV BX, 3      ;y coordinate of start point
MOV CX, 196    ;x coordinate of end point
MOV DX, 47     ;y coordinate of end point
CALL fillFrame ;prints board frame


MOV AH, 02h ;set cursor position
MOV DH, 23  ;row
MOV DL, 2   ;col
INT 10h

MOV AH, 09h ;display string on screen
LEA DX, pen ;text to print
INT 21h

MOV AX, 0001h ;show mouse cursor
INT 33h
	
RET
PencilBTN ENDP 

mainf PROC FAR	;Also added a public function.
RET
mainf ENDP

CODE_F ENDS 
END mainf