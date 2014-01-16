PUBLIC RectBTN

GLOBAL drawFrame:FAR
GLOBAL fillFrame:FAR

DATA SEGMENT PARA PUBLIC 'DATA'
rect DB "RECT$" ;button label
;due to some issues with DS segment
;I've chosen to display the labels
;for clear and exit button here
clear DB "CLS$" ;clear button label
exit DB "ESC$"  ;exit button label
DATA ENDS

CODE_F SEGMENT PARA PUBLIC 'CODE' 
ASSUME CS:CODE_F, DS:DATA
RectBTN PROC FAR

MOV AX, DATA
MOV DS, AX

MOV AX, 0002h  ;hide mouse cursor
INT 33h

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;DRAW FRAME OF RRECTANGLE BUTTON;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
MOV AX, ES:[0004] ;get colour from ES:[0004] - colour values only 25 or 27 here
CMP AX, 25		  ;if colour == 25 (button pressed)
JE add2			  ;then add 2 => colour = 27
SUB AX, 2		  ;else sub 2 => colour = 25
JMP cont
add2: ADD AX, 2
cont:
MOV ES:[0000], AX
MOV AX, 170    ;x coordinate of start point
MOV BX, 51     ;y coordinate of start point
MOV CX, 199    ;x coordinate of end point
MOV DX, 101    ;y coordinate of end point
CALL drawFrame ;prints board frame


MOV AX, 26     ;colour no.
               ; drawFrame will load the colour no.
               ; from ES:[0000]
MOV ES:[0000], AX 
MOV AX, 171    ;x coordinate of start point
MOV BX, 52     ;y coordinate of start point
MOV CX, 198    ;x coordinate of end point
MOV DX, 100    ;y coordinate of end point
CALL drawFrame ;prints board frame


MOV AX, ES:[0004]
MOV ES:[0000], AX 
MOV AX, 172    ;x coordinate of start point
MOV BX, 53     ;y coordinate of start point
MOV CX, 197    ;x coordinate of end point
MOV DX, 99     ;y coordinate of end point
CALL drawFrame ;prints board frame


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;FILL FRAME OF RECTANGLE BUTTON;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
MOV AX, ES:[0004]
MOV ES:[0000], AX 
MOV AX, 173    ;x coordinate of start point
MOV BX, 54     ;y coordinate of start point
MOV CX, 196    ;x coordinate of end point
MOV DX, 98     ;y coordinate of end point
CALL fillFrame ;prints board frame

;show rectangle button label
MOV AH, 02h ;set cursor position
MOV DH, 23  ;row
MOV DL, 8   ;col
INT 10h

MOV AH, 09h  ;display string on screen
LEA DX, rect ;text to print
INT 21h


;show clear screen button label
MOV AH, 02h ;set cursor position
MOV DH, 23  ;row
MOV DL, 15  ;col
INT 10h

MOV AH, 09h  ;display string on screen
LEA DX, clear ;text to print
INT 21h


;show exit button label
MOV AH, 02h ;set cursor position
MOV DH, 23  ;row
MOV DL, 36  ;col
INT 10h

MOV AH, 09h  ;display string on screen
LEA DX, exit ;text to print
INT 21h

MOV AX, 0001h ;show mouse cursor
INT 33h
	
RET
RectBTN ENDP 

mainf PROC FAR	;Also added a public function.
RET
mainf ENDP

CODE_F ENDS 
END mainf