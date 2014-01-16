PUBLIC DisCol

GLOBAL drawFrame:FAR
GLOBAL fillFrame:FAR

DATA SEGMENT PARA PUBLIC 'DATA'

drawStartX DW ? ;X coordinate of start point
drawStartY DW ? ;Y coordinate of start point
drawEndX   DW ? ;X coordinate of end point
drawEndY   DW ? ;Y coordinate of end point

;select black as first colour
selColX DW 173
selColY DW 157

DATA ENDS

CODE_F SEGMENT PARA PUBLIC 'CODE' 
ASSUME CS:CODE_F, DS:DATA
DisCol PROC FAR 

MOV AX, DATA
MOV DS, AX

;get passed mouse coordinates
MOV selColX, CX 
MOV selColY, DX

;draw background of colour palette
MOV AX, 27 
MOV ES:[0000], AX
;set coordinates of drawing palette background
MOV AX, 170
MOV BX, 153
MOV CX, 199
MOV DX, 278
CALL fillFrame

; display colours start point
;	
; X coordinate - 172 
; Y coordinate - 153
MOV AX, 172
MOV drawStartX, AX
MOV AX, 156
MOV drawStartY, AX
MOV AX, 176
MOV drawEndX, AX
MOV AX, 160
MOV drawEndY, AX

MOV AX, 0h ;colour code held in AX register
		   ;start with 0(black)
		   
displayColours: ;displays the 120 colour palette on screen
	PUSH AX ;save colour code on stack
	MOV ES:[0000], AX ;set colour
	;set coordinates for rectangle(representing a colour) 
	;drawn in colour palette
	MOV AX, drawStartX
	MOV BX, drawStartY
	MOV CX, drawEndX
	MOV DX, drawEndY
	
	;if mouse coordinates are in the area
	;of current rectangle(representing a colour)
	;then draw a filled rectangle(meaning that current 
	;colour/rectangle is selected)
	CMP selColX, AX
	JAE xAbove
	JMP cont
	
	xAbove: CMP selColY, BX
		    JAE yAbove
		    JMP cont
	yAbove: CMP selColX, CX
	        JBE xBelow
	        JMP cont
	xBelow: CMP selColY, DX
	        JBE yBelow
	        JMP cont
	yBelow: CALL fillFrame
	
	MOV AX, ES:[0000]
	MOV ES:[0004], AX
	JMP cont1
	
	;if mouse coordinates not in the area
	;of current rectangle then draw a frame
	;(meaning that this colour/rectangle is not selected)
	cont: CALL drawFrame
	
	cont1:
	;restore colour code
	POP AX
	
	ADD drawStartY, 5 ;move to next rectangle to right
	ADD drawEndY, 5   ;move to next rectangle to right
	
	CMP drawEndY, 279 ;if we reached the end of the line
	JAE nextLine	  ;jump on next one
	JMP cont2
	nextLine: PUSH AX ;save colour code
			  ADD drawStartX, 5 ;move to next rectangle downward
			  ADD drawEndX, 5	;move to next rectangle downward
			  MOV AX, 156		;set starting point
			  MOV drawStartY, AX
			  MOV AX, 160
			  MOV drawEndY, AX
			  POP AX
	cont2:
INC AX
CMP AX, 120 ;if we didn't reach the maximum number of colours
			;to be displayed then go to next colour
JNE dispColours
JMP exit
dispColours: JMP displayColours

exit:
MOV AX, ES:[0004]
MOV ES:[0000], AX ;set current colour for the mouseLi file
	
RET
DisCol ENDP 

mainf PROC FAR	;Also added a public function.
RET
mainf ENDP

CODE_F ENDS 
END mainf