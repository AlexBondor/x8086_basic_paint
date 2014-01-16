PUBLIC ExitBTN

GLOBAL drawFrame:FAR
GLOBAL fillFrame:FAR

CODE_F SEGMENT PARA PUBLIC 'CODE' 
ASSUME CS:CODE_F
ExitBTN PROC FAR 

MOV AX, 0002h ;hide mouse cursor
INT 33h

;;;;;;;;;;;;;;;;;;;;;;;;;;;
;DRAW FRAME OF EXIT BUTTON;
;;;;;;;;;;;;;;;;;;;;;;;;;;;
MOV AX, 184     ;colour no.
               ; drawFrame will load the colour no.
               ; from ES:[0000]
MOV ES:[0000], AX 
MOV AX, 170    ;x coordinate of start point
MOV BX, 279    ;y coordinate of start point
MOV CX, 199    ;x coordinate of end point
MOV DX, 319    ;y coordinate of end point
CALL drawFrame ;prints board frame

MOV AX, 112     ;colour no.
               ; drawFrame will load the colour no.
               ; from ES:[0000]
MOV ES:[0000], AX 
MOV AX, 171    ;x coordinate of start point
MOV BX, 280    ;y coordinate of start point
MOV CX, 198    ;x coordinate of end point
MOV DX, 318    ;y coordinate of end point
CALL drawFrame ;prints board frame

MOV AX, 40     ;colour no.
               ; drawFrame will load the colour no.
               ; from ES:[0000]
MOV ES:[0000], AX 
MOV AX, 172    ;x coordinate of start point
MOV BX, 281    ;y coordinate of start point
MOV CX, 197    ;x coordinate of end point
MOV DX, 317    ;y coordinate of end point
CALL drawFrame ;prints board frame


;;;;;;;;;;;;;;;;;;;;;;;;;;;
;FILL FRAME OF EXIT BUTTON;
;;;;;;;;;;;;;;;;;;;;;;;;;;;
MOV AX, 40     ;colour no.
               ; drawFrame will load the colour no.
               ; from ES:[0000]
MOV ES:[0000], AX 
MOV AX, 173    ;x coordinate of start point
MOV BX, 282    ;y coordinate of start point
MOV CX, 196    ;x coordinate of end point
MOV DX, 316    ;y coordinate of end point
CALL fillFrame ;prints board frame

MOV AX, 0001h ;show mouse cursor
INT 33h
	
RET
ExitBTN ENDP 

mainf PROC FAR	;Also added a public function.
RET
mainf ENDP

CODE_F ENDS 
END mainf