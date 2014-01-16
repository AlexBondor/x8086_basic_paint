PUBLIC fixCoordinates

CODE SEGMENT PARA PUBLIC 'CODE'
ASSUME CS:CODE

fixCoordinates PROC FAR

sXb:CMP AX, 3  
	JL sXbelow  ;if X coordinate of start point below 3
sXa:CMP AX, 166
	JA sXabove  ;if X coordinate of start point above 166
sYb:CMP BX, 3  
	JL sYbelow  ;if Y coordinate of start point below 3
sYa:CMP BX, 316 
	JA sYabove  ;if Y coordinate of start point above 316
eXb:CMP CX, 3   
	JL eXbelow  ;if X coordinate of end point below 3
eXa:CMP CX, 166
	JA eXabove  ;if X coordinate of end point above 166
eYb:CMP DX, 3  
	JL eYbelow  ;if X coordinate of end point below 3
eYa:CMP DX, 316 
	JA eYabove  ;if X coordinate of end point above 336
	
JMP exit

; then initialize coordinates with maximum/minimum allowed
sXbelow: MOV AX, 3
		 JMP sXa
sXabove: MOV AX, 166
		 JMP sYb
sYbelow: MOV BX, 3
		 JMP sYa
sYabove: MOV BX, 316
		 JMP eXb
eXbelow: MOV CX, 3
		 JMP eXa
eXabove: MOV CX, 166
		 JMP eYb
eYbelow: MOV DX, 3
		 JMP eYa
eYabove: MOV DX, 316

exit:

RET
fixCoordinates ENDP


mainf PROC FAR

RET
mainf ENDP
CODE ENDS
END mainf