; sad

	.ORIG x3000

; R0 - zero
; R1 - SPACE
; R2 - row
; R3 - column
; R4 - screen pointer

; fill screen with spaces

	AND R0,R0,#0
	LD R1,SPACE
	LD R4,SCREEN
	
	LD R2,HEIGHT
ROWLOOP

	LD R3,WIDTH
COLLOOP
	STR R1,R4,#0
	ADD R4,R4,#1
	ADD R3,R3,#-1
	BRp COLLOOP

	STR R0,R4,#0
	ADD R4,R4,#1

	ADD R2,R2,#-1
	BRp ROWLOOP
		
	; parse the array and fill the screen with characters

; R0 - ASCII character
; R1 - array pointer
; R2 - row
; R3 - column
; R4 - screen pointer
; R5 - temporary
; R6 - temporary

	LD R4,SCREEN
	LD R1,ARRAY

PARSELOOP
	LDR R3,R1,#0 ; X position into R3
	BRn PARSEDONE
	LDR R2,R1,#1 ; Y position into R2
	LDR R0,R1,#2 ; ASCII character into R0
	ADD R1,R1,#3

	; multiply Y by (WIDTH + 1)
	LD R5,WIDTH
	AND R6,R6,#0
MULTLOOP
	ADD R6,R6,R2
	ADD R5,R5,#-1
	BRzp MULTLOOP

	; now we have Y * (WIDTH + 1) in R6
	ADD R6,R6,R3 ; add X offset
	ADD R6,R6,R4 ; add screen base

	STR R0,R6,#0
	BRnzp PARSELOOP
PARSEDONE

; print all of the row strings

; R3 - string pointer
; R2 - row
; R1 - WIDTH + 1

	LD R3,SCREEN
	LD R1,WIDTH
	ADD R1,R1,#1
	LD R2,HEIGHT
PRINTLOOP
	ADD R0,R3,#0
	PUTS
	LD R0,LINEFEED
	OUT

	ADD R3,R3,R1
	ADD R2,R2,#-1
	BRp PRINTLOOP
	
	HALT

WIDTH	.FILL #40
HEIGHT	.FILL #26
SCREEN	.FILL x4000
ARRAY	.FILL x5000
SPACE	.FILL x20
LINEFEED .FILL x0A

	.END
