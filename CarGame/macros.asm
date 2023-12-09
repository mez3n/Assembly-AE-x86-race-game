printmessege macro mymess
    mov ah,9h
    mov dx,offset mymess
    int 21h
endm printmessege          

readmessege macro mymess
    mov ah,0ah
    mov dx,offset mymess
    int 21h
endm readmessege

movecursor macro coordinates
    mov ah,2
    mov dx,coordinates
    int 10h
endm movecursor