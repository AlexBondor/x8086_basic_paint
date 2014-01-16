GLOBAL drawMenu:FAR ;here we specify that the drawMenu is global (it is defined in another source)
GLOBAL mouseLi:FAR

CODE SEGMENT PARA PUBLIC 'CODE'
ASSUME CS:CODE
START PROC FAR

MOV AX, 0013h ;change to 320x200 256-colour mode
INT 10h

;;;;;;;;;;;;;;;;;;;;
;; DRAW MENU HERE ;;
;;;;;;;;;;;;;;;;;;;;
CALL drawMenu ;call drawMenu to display menu buttons

;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; LISTEN TO MOUSE INPUT ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;
CALL mouseLi ;call mouseListener to listen to mouse input

MOV AX, 0002h ;hide mouse cursor
INT 33h

MOV AX, 0003h ;change to 80x25 alphanumeric
INT 10h

MOV AH, 4ch ;exit program
INT 21h

START ENDP
CODE ENDS
END START