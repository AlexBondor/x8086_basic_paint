PUBLIC drawFrame

DATA SEGMENT PARA PUBLIC 'DATA'

colour DB ? ;frame colour

drawStartX DW ? ;X coordinate of start point
drawStartY DW ? ;Y coordinate of start point
drawEndX   DW ? ;X coordinate of end point
drawEndX_1 DW ? ;X coordinate of end point incremented by 1
drawEndY   DW ? ;Y coordinate of end point
drawEndY_1 DW ? ;Y coordinate of end point incremented by 1

DATA ENDS

CODE_F SEGMENT PARA PUBLIC 'CODE' 
ASSUME CS:CODE_F, DS:DATA
drawFrame PROC FAR

PUSH AX ;save AX value
MOV AX, DATA
MOV DS, AX

MOV AX, 0002h ;hide mouse cursor
INT 33h

POP AX ;restore AX

; if start point is below or to the right 
; of end point then exchange the x coordinate
; of start point with the x coordinate of end point,
; or, in the other case, the y coordinate of start point
; with the y coordinate of the end point
CMP AX, CX
JA exchangeXcoord
JMP label0
exchangeXcoord:
XCHG AX, CX
label0:

CMP BX, DX
JA exchangeYcoord
JMP label1
exchangeYcoord:
XCHG BX, DX
label1:

; initialize local variables with the 
; values passed through registers
;  AX - X coordinate of start point
;  BX - Y coordinate of start point 
;  CX - X coordinate of end point
;  DX - Y coordinate of end point
MOV drawStartX, AX

MOV drawStartY, BX

MOV drawEndX, CX
INC CX
MOV drawEndX_1, CX

MOV drawEndY, DX
INC DX
MOV drawEndY_1, DX

MOV AX, ES:[0000] ;colour number located at ES:[0000]
MOV colour, AL

MOV AX, drawStartX ;row no.
MOV BX, drawStartY ;col. no.
 
 
frame: ;prints a one pixel wide frame

; print pixel only if 
; AX(row no.) = drawStartX(X coordinate of start point)
; and
; BX(col. no.) >= drawStartY(Y coordinate of start point)
line_0: CMP AX, drawStartX
		JNE col_0
		CMP BX, drawStartY
		JAE printPixel
		
; print pixel only if 
; BX(col. no.) = drawStartY(Y coordinate of start point)
; and
; AX(row. no.) >= drawStartX(X coordinate of start point)
col_0: CMP BX, drawStartY
	   JNE col_E1
	   CMP AX, drawStartX
	   JAE printPixel

; print pixel only if 
; BX(col. no.) = drawEndY(Y coordinate of end point)
; and
; AX(row. no.) >= drawStartX(X coordinate of start point)
col_E1: CMP BX, drawEndY
		JNE line_E1
		CMP AX, drawStartX
	    JAE printPixel
		
; print pixel only if 
; AX(row no.) = drawEndX(X coordinate of end point)
; and
; BX(col. no.) >= drawStartY(Y coordinate of start point)
line_E1: CMP AX, drawEndX
		 JNE cont
		 CMP BX, drawStartY
	     JAE printPixel

JMP cont

	printPixel:        ;prints coloured pixel
		CMP AX, drawEndX_1
		JE exitFrame
		MOV DX, AX     ;row no.
		MOV CX, BX     ;col. no.
		MOV AL, colour ;colour
		MOV AH, 0Ch    ;show pixel on screen
		INT 10h        ;actually display pixel
		MOV AX, DX     ;restore AX value
		JMP cont

	newLine:               ;we reached the Y coordinate of the end point
		MOV BX, drawStartY ;set col. no. to drawStartY
		INC AX             ;increment line no. 
		JMP frame
		
	cont:
		INC BX             ;increment col. no.
		CMP BX, drawEndY_1 ;if col == drawEndY_1(incremented by one)
		JE newLine
			
CMP AX, drawEndX_1 ;if row != drawEndX_1(incremented by one)
JNE frame          ;continue printing frame
exitFrame:

MOV AX, 0001h ;show mouse cursor
INT 33h

RET
drawFrame ENDP 

mainf PROC FAR	;Also added a public function.
	RET
mainf ENDP

CODE_F ENDS 
END mainf