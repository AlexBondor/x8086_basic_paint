PUBLIC mouseLi

GLOBAL PencilBTN:FAR
GLOBAL RectBTN:FAR
GLOBAL ClearBTN:FAR
GLOBAL DisCol:FAR

GLOBAL drawFrame:FAR
GLOBAL fillFrame:FAR
GLOBAL fixCoordinates:FAR

DATA SEGMENT PARA PUBLIC 'DATA'

colour DW 0 ;set starting colour to black

drawStartX DW 0 ;X coordinate of start point
drawStartY DW 0 ;Y coordinate of start point
drawEndX   DW 0 ;X coordinate of end point
drawEndY   DW 0 ;Y coordinate of end point

penButtSel  DB 0 ;flag for pencil button selected
rectButtSel DB 0 ;flag for rectangle button selected
clsButtSel  DB 0 ;flag for clear button selected
exitButtSel DB 0 ;flag for exit button selected

DATA ENDS

CODE_F SEGMENT PARA PUBLIC 'CODE' 
ASSUME CS:CODE_F, DS:DATA
mouseLi PROC FAR 

MOV AX, DATA
MOV DS, AX

MOV AX, 0001h ;show mouse cursor
INT 33h

mouseLoop:
	MOV AX, ES:[0004] ;restore colour value
	MOV colour, AX
	
	MOV AX, 3h 	  ;3 in AX tells int 33 to get the mouse button position and status
	INT 33h   	  ;get mouse info
	XCHG CX, DX   ;exchange vertical position with horizontal position
	SHR DX, 1     ;/2
	CMP BX, 1     ;if left mouse button is pressed
	JE leftButtonPressed
	JMP leftButtonReleased
	JMP mouseLoop

;CX now is mouse horizontal position. 0 - 319
;DX now is mouse   vertical position. 0 - 199


leftButtonPressed:
	CMP CX, 170 
	JL drawingBoardFocused ;mouse pressed in drawing area
	JMP pencilButtonPressed

drawingBoardFocused:
	CMP drawStartX, 0 ;if starting point not initialized yet
	JE initStart
	JMP mouseLoop
	
initStart: ;initialize starting point
	MOV drawStartX, CX 
	MOV drawStartY, DX
	CMP penButtSel, 1   ;if pen button not selected jmp to mouseLoop
	JNE mouseLoop 	    ;else put pixel on screen
	MOV AX, drawStartX  ;initialize pixel coordinates
	MOV BX, drawStartY
	MOV CX, drawStartX
	MOV DX, drawStartY
	CALL fixCoordinates ;if coordinates out of bounds then fix them
	CALL drawFrame      ;use drawFrame function to put pixel on screen
	MOV drawStartX, 0   ;if drawStartX == 0 then left click not pressed yet
	MOV drawStartY, 0
	JMP mouseLoop
	
leftButtonReleased:
	CMP drawStartX, 0 ;if mouse not pressed yet
	JE mouseLoop
	; board bounds
	;  
	; top - 3, 3
	; bottom - 166, 316
	MOV AX, drawStartX
	MOV BX, drawStartY
	; to see if rectangle coordinates are out of drawing bounds
	; and fix them if so
	CALL fixCoordinates
	CMP rectButtSel, 1
	JE drawRectangle
	JMP cont0
	drawRectangle: CALL drawFrame			

cont0:	
	MOV drawStartX, 0
	MOV drawStartY, 0
	JMP mouseLoop

pencilButtonPressed: ;check if pencil button is pressed
					 ;and set button selection flags specifically
					 
	; Pencil Button coordinates
	;
	; startX : 170
	; staryY : 0
	;   endX : 199
	;   endY : 50
	CMP CX, 170
	JL ml_0
	CMP CX, 199
	JG ml_0
	CMP DX, 0
	JL ml_0
	CMP DX, 50
	JG rectangleButtonPressed 

	;update button selection flags
	MOV penButtSel, 1
	MOV rectButtSel, 0
	MOV clsButtSel, 0
	MOV exitButtSel, 0
	JMP interpret


rectangleButtonPressed: ;check if rectangle button is pressed
						;and set button selection flags specifically

	; Rectangle Button coordinates
	;
	; startX : 170
	; staryY : 51
	;   endX : 199
	;   endY : 101
	CMP CX, 170
	JL ml_0
	CMP CX, 199
	JG ml_0
	CMP DX, 51
	JL ml_0
	CMP DX, 101
	JG clearButtonPressed

	;update button selection flags		
	MOV penButtSel, 0
	MOV rectButtSel, 1
	MOV clsButtSel, 0
	MOV exitButtSel, 0
	JMP interpret


ml_0: JMP mouseLoop
	
	
clearButtonPressed: ;check if clear button is pressed
					;and set button selection flags specifically
						
	; Clear Button coordinates
	;
	; startX : 170
	; staryY : 102
	;   endX : 199
	;   endY : 152
	CMP CX, 170
	JL ml_0
	CMP CX, 199
	JG ml_0
	CMP DX, 102
	JL ml_0
	CMP DX, 152
	JG selectColour

	;update button selection flags
	MOV penButtSel, 0
	MOV rectButtSel, 0
	MOV clsButtSel, 1
	MOV exitButtSel, 0
	JMP interpret

	selectColour:
	CMP DX, 278
	JA exitButtonPressed
	CALL disCol
	JMP ml_0
		

exitButtonPressed: ;check if exit button is pressed
				   ;and set button selection flags specifically
						
	; Exit Button coordinates
	;
	; startX : 170
	; staryY : 279
	;   endX : 199
	;   endY : 319
	CMP CX, 170
	JL ml_0
	CMP CX, 199
	JG ml_0
	CMP DX, 279
	JL ml_0
	CMP DX, 319
	JG ml_0

	;update button selection flags
	MOV penButtSel, 0
	MOV rectButtSel, 0
	MOV clsButtSel, 0
	MOV exitButtSel, 1
	JMP interpret

penButtonSelected:		;redraw buttons with specific colours
						;to simulate pressed or not state
						; 
						; 25 means     pressed
						;
						; 27 means not pressed
						
	MOV AX, 25			;pencil button on
	MOV ES:[0004], AX
	CALL PencilBTN
	
	MOV AX, 27			;clear button off
	MOV ES:[0004], AX
	CALL ClearBTN
	
	MOV AX, 27			;rectangle button off
	MOV ES:[0004], AX
	CALL RectBTN
	
	MOV AX, colour ;restore colour value
	MOV ES:[0000], AX
	MOV ES:[0004], AX
	JMP ml_0

rectButtonSelected:		;redraw buttons with specific colours
						;to simulate pressed or not state
						; 
						; 25 means     pressed
						;
						; 27 means not pressed
						
	MOV AX, 27			;pencil button off
	MOV ES:[0004], AX
	CALL PencilBTN
	
	MOV AX, 27			;clear button off
	MOV ES:[0004], AX
	CALL ClearBTN
	
	MOV AX, 25			;rectangle button on
	MOV ES:[0004], AX
	CALL RectBTN
	
	MOV AX, colour ;restore colour value
	MOV ES:[0000], AX
	MOV ES:[0004], AX
	JMP ml_0

clsButtonSelected:		;redraw buttons with specific colours
						;to simulate pressed or not state
						; 
						; 25 means     pressed
						;
						; 27 means not pressed
						
	MOV AX, 27			;pencil button off
	MOV ES:[0004], AX
	CALL PencilBTN
	
	MOV AX, 25			;clear button on
	MOV ES:[0004], AX
	CALL ClearBTN
	
	MOV AX, 27			;rectangle button off
	MOV ES:[0004], AX
	CALL RectBTN
	
				   ;clear screen
	MOV AX, 0 	   ;set colour value to black
	MOV ES:[0000], AX
	MOV AX, 3
	MOV BX, 3
	MOV CX, 166
	MOV DX, 316
	CALL fillFrame ;draw filled rectangle
	
	MOV AX, colour ;restore colour value
	MOV ES:[0000], AX
	MOV ES:[0004], AX
	JMP ml_0
	
interpret: ;check button selection flags and
		   ;do specific jumps for this
		   ;configuration of flags
		   
	;if pen button selected
	CMP penButtSel, 1
	JE penSel
	JMP cont1
	penSel: JMP penButtonSelected
	cont1:

	;if rectangle button selected
	CMP rectButtSel, 1
	JE rectSel
	JMP cont2
	rectSel: JMP rectButtonSelected
	cont2:

	;if clear screen button selected
	CMP clsButtSel, 1
	JE clsButtonSelected

	;if exit button selected
	CMP exitButtSel, 1
	JE EXIT
JMP mouseLoop

EXIT:
	
RET
mouseLi ENDP 

mainf PROC FAR	;Also added a public function.
RET
mainf ENDP

CODE_F ENDS 
END mainf