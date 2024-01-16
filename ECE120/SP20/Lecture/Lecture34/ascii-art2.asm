;
; this code fills in a 'screen' of 25 rows of 39 columns each with spaces,
; then reads an array of three-tuples: X position, Y position, ASCII character,
; adding each one to the screen.  The array ends with X position -1 (other
; values are assumed valid and not checked!).  Then the code prints the
; 'screen'.
;

	.ORIG x3000

; register map
; R0 - used to store/print characters
; R1 - horizontal index
; R2 - vertical index
; R3 - screen pointer
; R4 - temporary
; R5 - array pointer
; R6 - temporary


; First, we need to fill the 'screen' with spaces

	LD R3,SCREEN
	LD R0,SPACE	; fill screen with spaces
	AND R4,R4,#0	; end each row with a NUL
	
	LD R2,HEIGHT	; loop over rows
BLANKVLOOP
	LD R1,WIDTH	; loop over columns
BLANKHLOOP
	STR R0,R3,#0	; write one space
	ADD R3,R3,#1
	ADD R1,R1,#-1
	BRp BLANKHLOOP

	; write a NUL at the end of the row
	STR R4,R3,#0
	ADD R3,R3,#1

	ADD R2,R2,#-1
	BRp BLANKVLOOP

; Next, fill in characters from the array of tuples.

	LD R5,ARRAY	; R5 points to the array
	LD R3,SCREEN	; R3 points to the base of the screen

FILL_LOOP
	LDR R1,R5,#0	; read one X position
	BRn FILLDONE	; negative X means the end of the array
	LDR R2,R5,#1	; read one Y position
	LDR R0,R5,#2	; read one ASCII character
	ADD R5,R5,#3	; advance to next 3-tuple

	AND R6,R6,#0	; multiply Y position by WIDTH + 1
	LD R4,WIDTH
MULTLOOP
	ADD R6,R6,R2
	ADD R4,R4,#-1
	BRzp MULTLOOP

	ADD R6,R6,R1	; add X offset to Y offset
	ADD R6,R6,R3	; add screen base pointer to offset for character
	STR R0,R6,#0	; write the character

	BRnzp FILL_LOOP
FILLDONE

; Now, we're ready to print the screen.
	
	; R3 already points to the screen

	; I'm going to be lazy and use PUTS...
	LD R1,WIDTH	; increment between rows
	ADD R1,R1,#1

	LD R2,HEIGHT	; loop over rows

PRINTLOOP
	ADD R0,R3,#0	; next row pointer
	PUTS
	LD R0,RETURN	; need a carriage return
	OUT

	ADD R3,R3,R1
	ADD R2,R2,#-1
	BRp PRINTLOOP

; All done!
	HALT

; data
SCREEN	.FILL x4000
WIDTH	.FILL #39
HEIGHT	.FILL #26
SPACE	.FILL x20
ARRAY	.FILL x5000
RETURN	.FILL x0A

	.END



