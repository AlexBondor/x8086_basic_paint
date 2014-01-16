PUBLIC drawMenu ;The symbol drawMenu is defined as public so it can be seen from other sources. We can have more public symbols.

GLOBAL DrawFrame:FAR

GLOBAL PencilBTN:FAR
GLOBAL LineBTN:FAR
GLOBAL RectBTN:FAR
GLOBAL ExitBTN:FAR
GLOBAL ClearBTN:FAR

GLOBAL DisCol:FAR

CODE_F SEGMENT PARA PUBLIC 'CODE' 
ASSUME CS:CODE_F
drawMenu PROC FAR 

;;;;;;;;;;;;;;;;;;;;;;
;; DRAW BOARD FRAME ;;
;;;;;;;;;;;;;;;;;;;;;;

; board frame is composed of 3 rectangles
; of different colours

MOV AX, 25     ;colour no.
		       ;drawFrame will load the colour no.
		       ;from ES:[0000]
MOV ES:[0000], AX 
MOV AX, 0      ;x coordinate of start point
MOV BX, 0      ;y coordinate of start point
MOV CX, 169    ;x coordinate of end point
MOV DX, 319    ;y coordinate of end point
CALL drawFrame ;prints board frame

MOV AX, 26     ;colour no.
               ;drawFrame will load the colour no.
               ;from ES:[0000]
MOV ES:[0000], AX 
MOV AX, 1      ;x coordinate of start point
MOV BX, 1      ;y coordinate of start point
MOV CX, 168    ;x coordinate of end point
MOV DX, 318    ;y coordinate of end point
CALL drawFrame ;prints board frame

MOV AX, 27     ;colour no.
               ;drawFrame will load the colour no.
               ;from ES:[0000]
MOV ES:[0000], AX 
MOV AX, 2      ;x coordinate of start point
MOV BX, 2      ;y coordinate of start point
MOV CX, 167    ;x coordinate of end point
MOV DX, 317    ;y coordinate of end point
CALL drawFrame ;prints board frame

;;;;;;;;;;;;;;;;;;;;;;;;;
;; DRAW COLOUR BUTTONS ;;
;;;;;;;;;;;;;;;;;;;;;;;;;
MOV AX, 27        ;unselected button colour
MOV ES:[0004], AX ;set colour to ES segment
CALL PencilBTN    ;draw colour button

;;;;;;;;;;;;;;;;;;;;;;;
;; DRAW CLEAR BUTTON ;;
;;;;;;;;;;;;;;;;;;;;;;;
CALL ClearBTN      ;draw exit button

;;;;;;;;;;;;;;;;;;;;;;
;; DRAW EXIT BUTTON ;;
;;;;;;;;;;;;;;;;;;;;;;
CALL ExitBTN      ;draw exit button

;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; DRAW RECTANGLE BUTTON ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;
MOV AX, 27
MOV ES:[0004], AX
CALL RectBTN      ;draw rectangle button

;;;;;;;;;;;;;;;;;;;;;;;;;
;; DRAW COLOUR PALETTE ;;
;;;;;;;;;;;;;;;;;;;;;;;;;
MOV CX, 173
MOV DX, 157
MOV AX, 0
MOV ES:[0004], AX
CALL DisCol       ;draw colour palette

RET
drawMenu ENDP 

mainf PROC FAR	;Also added a public function.
	RET
mainf ENDP

CODE_F ENDS 
END mainf