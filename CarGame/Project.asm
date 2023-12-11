; THIS NEEDS A PICTURE AND TO ADD ANOTHER CAR
.386
DATA SEGMENT USE16
startchat DB 'To start chatting press F1$'
startgame DB 'To start the game press F2$'
ExitProgram DB 'To End the program press ESC$'
user1mess DB 'Please Enter user1 name: $'
user2mess DB 'Please Enter user2 name: $'
username1 db 15,?,15 DUP('$')
username2 db 15,?,15 DUP('$')
CUR_X DW  ?  ; ACTIVE VARIABLES TO BE USED IN FUNCTIONS
CUR_Y DW  ?
FIRST_RECTANGLE_X DW 60  ;initial positions of the FIRST CAR
FIRST_RECTANGLE_Y DW  50
SECOND_RECTANGLE_X DW  60   ;INITIAL POSITION OF TH ESECOND CAR
SECOND_RECTANGLE_Y DW  100
MAX_SPEED EQU 30     ;maximum speed of the rectangle
BUTTONS DB 8 DUP(0) 
SPEEDS DW 16 DUP(0)   ;array of booleans to check which buttons are pressed in each frame 
; UP:0   LEFT:1   RIGHT:2   DOWN:3  w:4   a:5   d:6   s:7
RECTANGLE_WIDTH EQU 30
RECTANGLE_HEIGHT EQU 30
IMG_SIZE EQU 30*30
FILE_NAME1 DB "car.bin",0
FILE_NAME2 DB "car1.bin",0
FILE_NAME3 DB "sec.bin",0
FILE_NAME4 DB "sec1.bin",0
IMG1 DB 2*IMG_SIZE DUP(?)
IMG2 DB 2*IMG_SIZE DUP(?)

CODE SEGMENT USE16
ASSUME CS:CODE,DS:DATA
INCLUDE macros.asm
MAIN PROC FAR

;DEFINING MEMORY

MOV AX,DATA
MOV DS,AX
MOV ES,AX
;text mode
mov ax,03h
int 10h
;take usernames
;user1
movecursor 0B19h
printmessege user1mess
readmessege username1
;clear screen
mov ax,03h
int 10h
;user2
movecursor 0B19h
printmessege user2mess
readmessege username2
;clear screen
mov ax,03h
int 10h
;main screen
mainscreentxt:


;print masseges
;move cursor to the middle
movecursor 0519h
printmessege startchat
movecursor 0819h
printmessege startgame
movecursor 0B19h
printmessege ExitProgram
mainscreen:
; Wait for key press
  mov ah, 0
  int 16h
    
; Check the pressed key
  cmp ah, 3Bh    ; F1 key
  je chatmode
  cmp ah, 3Ch    ; F2 key
  je gamemode    ;note we may want to handle this as (gamemode) will be too far
  cmp al, 1Bh    ; Esc key
  je ExtPrgrm    
  
jmp mainscreen

ExtPrgrm:
movecursor 0E19h
mov ah,4ch
int 21h

chatmode:
;chatting code
; ............

gamemode:
    ; STARTING GAME MODE
    MOV    AX, 4F02H
    MOV    BX, 101H
    INT    10H


    ; Set Cursor Position
    MOV    AH, 2H
    MOV    BH, 0 
    MOV    DH, 1Ah 
    MOV    DL, 2h
    INT    10H

    ; Write string at the specified position
    MOV    AH, 9H
    LEA    DX, username1+2 ; Load the offset of the string
    INT    21H

    ; Set Cursor Position
    MOV    AH, 2H
    MOV    BH, 0 
    MOV    DH, 1Ch 
    MOV    DL, 2h
    INT    10H

    MOV    AH, 9H
    LEA    DX, username2+2 ; Load the offset of the string
    INT    21H

    ;draw line for the status bar
    mov cx,0
    mov dx,405 ;y-axis
    mov al,0fh
    mov ah,0CH
    back:int 10h
    inc cx
    cmp cx,640 ;x-axis
    jnz back
    ;Above status bar
    mov ah, 03Dh
    mov al, 0 ; open attribute: 0 - read-only, 1 - write-only, 2 -read&write
    mov dx, offset FILE_NAME1 ; ASCIIZ filename to open
    int 21h
    mov bx, AX
    mov ah, 03Fh
    mov cx, IMG_SIZE; number of bytes to read
    mov dx, offset IMG1 ; wHere to put read data
    int 21h
    mov ah, 3Eh         ; DOS function: close file
    INT 21H


    mov ah, 03Dh
    mov al, 0 ; open attribute: 0 - read-only, 1 - write-only, 2 -read&write
    mov dx, offset FILE_NAME2 ; ASCIIZ filename to open
    int 21h
    mov bx, AX
    mov ah, 03Fh
    mov cx, IMG_SIZE; number of bytes to read
    mov dx, offset IMG1 +IMG_SIZE; wHere to put read data
    int 21h
    mov ah, 3Eh         ; DOS function: close file
    INT 21H

    mov ah, 03Dh
    mov al, 0 ; open attribute: 0 - read-only, 1 - write-only, 2 -read&write
    mov dx, offset FILE_NAME3 ; ASCIIZ filename to open
    int 21h
    mov bx, AX
    mov ah, 03Fh
    mov cx, IMG_SIZE; number of bytes to read
    mov dx, offset IMG2 ; wHere to put read data
    int 21h
    mov ah, 3Eh         ; DOS function: close file
    INT 21H


     mov ah, 03Dh
    mov al, 0 ; open attribute: 0 - read-only, 1 - write-only, 2 -read&write
    mov dx, offset FILE_NAME4 ; ASCIIZ filename to open
    int 21h
    mov bx, AX
    mov ah, 03Fh
    mov cx, IMG_SIZE; number of bytes to read
    mov dx, offset IMG2 +IMG_SIZE; wHere to put read data
    int 21h
    mov ah, 3Eh         ; DOS function: close file
    INT 21H
GAME:
; reading keys
MOV CX ,09FFFH ; BUFFER FOR READING KEYS THE LESS THIS NUMBER IS THE FASTER THE GAME
BUFFER:
IN AL ,60H

;marking pressed
CMP AL,48H
JNE MARK_LEFT
MOV BUTTONS,1

MARK_LEFT:
CMP AL,4BH
JNE MARK_RIGHT
MOV BUTTONS+1,1

MARK_RIGHT:
CMP AL,4DH
JNE MARK_DOWN
MOV BUTTONS+2,1

MARK_DOWN:
CMP AL,50H
JNE MARK_W
MOV BUTTONS+3,1

MARK_W:
CMP AL,11H
JNE MARK_A
MOV BUTTONS+4,1

MARK_A:
CMP AL,1EH
JNE MARK_D
MOV BUTTONS+5,1

MARK_D:
CMP AL,20H
JNE MARK_S
MOV BUTTONS+6,1

MARK_S:
CMP AL,1FH
JNE DEMARK_UP
MOV BUTTONS+7,1



;demarking released

DEMARK_UP:
CMP AL ,48H+80H
JNE DEMARK_LEFT
MOV BUTTONS,0

DEMARK_LEFT:
CMP AL,4BH+80H
JNE DEMARK_RIGHT
MOV BUTTONS+1,0

DEMARK_RIGHT:
CMP AL,4DH+80H
JNE DEMARK_DOWN
MOV BUTTONS+2,0

DEMARK_DOWN:
CMP AL,50h+80H
JNE DEMARK_W
MOV BUTTONS+3,0

DEMARK_W:
CMP AL ,11H+80H
JNE DEMARK_A
MOV BUTTONS+4,0

DEMARK_A:
CMP AL,1EH+80H
JNE DEMARK_D
MOV BUTTONS+5,0

DEMARK_D:
CMP AL,20H+80H
JNE DEMARK_S
MOV BUTTONS+6,0

DEMARK_S:
CMP AL,1Fh+80H
JNE FIN_DEMARK
MOV BUTTONS+7,0

FIN_DEMARK:
DEC CX
CMP CX,0
JNE BUFFER




;deleting the old rectangle
DELETE_OLD:
MOV CX,FIRST_RECTANGLE_X 
MOV DX,FIRST_RECTANGLE_Y
MOV CUR_X,CX
MOV CUR_Y,DX
CALL DEL_RECT ; to delete old place 


MOV CX,SECOND_RECTANGLE_X 
MOV DX,SECOND_RECTANGLE_Y
MOV CUR_X,CX
MOV CUR_Y,DX
CALL DEL_RECT

;checking each key

;BL IS BUTTON
;CX IS SPEED OF THIS DIMENSION


;check UP
MOV BL,BUTTONS
MOV CX,SPEEDS
CALL ACCELERATION
MOV SPEEDS,CX
SUB FIRST_RECTANGLE_Y,CX

;CHECK LEFT
MOV BL,BUTTONS+1
MOV CX,SPEEDS+2
CALL ACCELERATION
MOV SPEEDS+2,CX
SUB FIRST_RECTANGLE_X,CX



;check RIGHT
MOV BL,BUTTONS+2
MOV CX,SPEEDS+4
CALL ACCELERATION
MOV SPEEDS+4,CX
ADD FIRST_RECTANGLE_X,CX


;check DOWN
MOV BL,BUTTONS+3
MOV CX,SPEEDS+6
CALL ACCELERATION
MOV SPEEDS+6,CX
ADD FIRST_RECTANGLE_Y,CX


;check W
MOV BL,BUTTONS+4
MOV CX,SPEEDS+8
CALL ACCELERATION
MOV SPEEDS+8,CX
SUB SECOND_RECTANGLE_Y,CX


;check A
MOV BL,BUTTONS+5
MOV CX,SPEEDS+10
CALL ACCELERATION
MOV SPEEDS+10,CX
SUB SECOND_RECTANGLE_X,CX



;check D
MOV BL,BUTTONS+6
MOV CX,SPEEDS+12
CALL ACCELERATION
MOV SPEEDS+12,CX
ADD SECOND_RECTANGLE_X,CX



;check S
MOV BL,BUTTONS+7
MOV CX,SPEEDS+14
CALL ACCELERATION
MOV SPEEDS+14,CX
ADD SECOND_RECTANGLE_Y,CX





DRAW_NEW:
;drawing at the new position
MOV CX,FIRST_RECTANGLE_X 
MOV DX,FIRST_RECTANGLE_Y
MOV CUR_X,CX
MOV CUR_Y,DX
CALL DRAW_NEW_LOCATION_FIRST

MOV CX,SECOND_RECTANGLE_X 
MOV DX,SECOND_RECTANGLE_Y
MOV CUR_X,CX
MOV CUR_Y,DX
CALL DRAW_NEW_LOCATION_SECOND





JMP GAME

MAIN ENDP


;========================= PROCEDUERS=============================================
DRAW_NEW_LOCATION_FIRST PROC 
MOV AX, FIRST_RECTANGLE_X
MOV BX,FIRST_RECTANGLE_Y
MOV CUR_X,AX
MOV CUR_Y,BX
MOV AX, SPEEDS
MOV BX, SPEEDS+6
cmp AX,BX
JE DRAW_SIDE
JA DRAW_UP
MOV SI, OFFSET IMG1
CALL RECT_REVERSED
RET
DRAW_UP:
MOV SI,OFFSET IMG1
CALL RECT
RET
DRAW_SIDE:
MOV AX,SPEEDS+2
MOV BX,SPEEDS+4
cmp AX,BX
JA DRAW_RIGHT
MOV SI,OFFSET IMG1+IMG_SIZE
CALL RECT
RET
DRAW_RIGHT:
MOV SI,OFFSET IMG1+IMG_SIZE
CALL RECT_REVERSED
RET
DRAW_NEW_LOCATION_FIRST ENDP



DRAW_NEW_LOCATION_SECOND PROC 
MOV AX, SECOND_RECTANGLE_X
MOV BX, SECOND_RECTANGLE_Y
MOV CUR_X,AX
MOV CUR_Y,BX
MOV AX, SPEEDS+8
MOV BX, SPEEDS+14
cmp AX,BX
JE DRAW_SIDE_SECOND
JA DRAW_UP_SECOND
MOV SI, OFFSET IMG2
CALL RECT_REVERSED
RET
DRAW_UP_SECOND:
MOV SI,OFFSET IMG2
CALL RECT
RET
DRAW_SIDE_SECOND:
MOV AX,SPEEDS+10
MOV BX,SPEEDS+12
cmp AX,BX
JA DRAW_RIGHT_SECOND
MOV SI,OFFSET IMG2+IMG_SIZE
CALL RECT
RET
DRAW_RIGHT_SECOND:
MOV SI,OFFSET IMG2+IMG_SIZE
CALL RECT_REVERSED
RET
DRAW_NEW_LOCATION_SECOND ENDP







;drawing rectangle 
RECT PROC 
; COPYING OLD PLACE AND END PLACE
ADD CUR_X,RECTANGLE_WIDTH
ADD CUR_Y,RECTANGLE_HEIGHT
; MAKING PREP TO ENTER THE LOOP
ADD CX,RECTANGLE_WIDTH
SUB DX,1
MOV AH,0CH
; LOOP START
LOOP1:
INC DX
SUB CX,RECTANGLE_WIDTH
LOOP2:
LODSB
MOV AH,0CH
INT 10H
INC CX
CMP CX,CUR_X
JNE LOOP2
CMP DX,CUR_Y
JNE LOOP1
SUB CUR_X,RECTANGLE_WIDTH
SUB CUR_Y,RECTANGLE_HEIGHT
RET
RECT ENDP

;drawing reversed rectangle 
RECT_REVERSED PROC 
; COPYING OLD PLACE AND END PLACE
ADD CUR_X,RECTANGLE_WIDTH
ADD CUR_Y,RECTANGLE_HEIGHT
; MAKING PREP TO ENTER THE LOOP
ADD CX,RECTANGLE_WIDTH
SUB DX,1
MOV AH,0CH
ADD SI,IMG_SIZE
; LOOP START
LOOP1_RECT_REVERSED:
INC DX
SUB CX,RECTANGLE_WIDTH
LOOP2_RECT_REVERSED:
LODSB
SUB SI,2
MOV AH,0CH
INT 10H
INC CX
CMP CX,CUR_X
JNE LOOP2_RECT_REVERSED
CMP DX,CUR_Y
JNE LOOP1_RECT_REVERSED
SUB CUR_X,RECTANGLE_WIDTH
SUB CUR_Y,RECTANGLE_HEIGHT
RET
RECT_REVERSED ENDP





;DELETING THE OLD PIC
DEL_RECT PROC 
MOV AL ,0H
ADD CUR_X,RECTANGLE_WIDTH
ADD CUR_Y,RECTANGLE_HEIGHT
; MAKING PREP TO ENTER THE LOOP
ADD CX,RECTANGLE_WIDTH
SUB DX,1
MOV AH,0CH
; LOOP START
DEL_LOOP1:
INC DX
SUB CX,RECTANGLE_WIDTH
DEL_LOOP2:
INT 10H
INC CX
CMP CX,CUR_X
JNZ DEL_LOOP2
CMP DX,CUR_Y
JNZ DEL_LOOP1
SUB CUR_X,RECTANGLE_WIDTH
SUB CUR_Y,RECTANGLE_HEIGHT
DEL_RECT ENDP



ACCELERATION PROC
;BL IS BUTTON
;CX IS SPEED OF THIS DIMENSION
CMP BL,1 ;IF BL==1 THEN ADD ACCELERATION
JE INC_ACC
CMP CX,0  ;IN DEC ACC IF SPEED IS ZERO FINISH
JE FIN_ACC
DEC CX  ;ELSE DEC SPEED
JMP FIN_ACC
INC_ACC:
CMP CX,MAX_SPEED  ;IN INC ACC IF SPEED IS MAX FINISH
JE FIN_ACC  
INC CX ;ELSE INC SPEED
FIN_ACC:
RET
ACCELERATION ENDP

  

END MAIN