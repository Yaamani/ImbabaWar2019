include mymacros.inc
.model small
.stack 64
.data
mes db 10,13,10,13,9,9,'main menu','$' 
fitmess db 10,13,10,13,10,13,9,'   start play press ','$'
secmess db 10,13,10,13,10,13,10,13,9,'   start chat press ','$'

player1 dw 70 , 100
player2 dw 250 , 100
                         
player1bullets dw 0
player1bulletx dw 200 dup(0)
player1bullety dw 200 dup(0)

player2bullets dw 0
player2bulletx dw 200 dup(0)
player2bullety dw 200 dup(0)

firsthealthbar  dw 10 , 15 , 35
secondhealthbar dw 165 , 15 , 35
;**********************
firstlaserbar   dw 55 , 15 , 20
;**********************
secondlaserbar   dw 210 , 15 , 20
firstbarrierbar  dw 100 , 15 , 35
secondbarrierbar dw 255 , 15 , 35
temp1 dw ?
temp2 dw ?
.code         
main proc far            
mov ax,@data
mov ds,ax 

;********video mode********
mov ax,13h
int 10h

;********main menu mode********
mainmenu mes,fitmess,secmess

;-------key pressed---------
mov ah,0
int 16h   ;get key pressed (wait for a key-ah:scancode,al:ascii)  
cmp al , 50h

;********clear screen******************
    mov ax,0600h
    mov bh,0
    mov cx,0
    mov dx,184fh
    int 10h 

;*******************
;mov ax , 8h
;mov bx , 5010h              ;i forgot but one of this trio is v.v.i
;mov dx , 03h

;*******************
drawrect 159 , 0 , 1 , 200 , 06h ;pitch division



;call firebullet1


;call firebullet2


mov dx,0  ;i am using DX , BX for the delay in fire rate so DON'T CHANGE THEM IN YOUR CODE
mov bx,0  ;

mov cx,0

yamany:

;cmp cx,0ff0h 
;jb skip

mov di , offset player1
drawrect [di] , [di+2] , 20 , 15 , 05h ;1st player
;
;movplayer1
;drawrect 159 , 0 , 1 , 200 , 06h

mov di , offset player2
drawrect [di], [di+2] , 20 , 15 , 05h ;2nd player

;mov ah,1
;int 16h
;jz ending

;MOV     CX, 0H
;MOV     DX, 6000H
;MOV     AH, 86H
;INT     15H

 movplayer2


;ending:


;drawrect 70 , 100 , 20 , 15 , 05h ;1st player

; call movplayer1

;drawrect 250, 100 , 20 , 15 , 05h ;2nd player   

     push ax
    push cx
    push dx
    
    push bx
    
    
    ;-----------------------delay-----------------
    mov cx,0fffh
    l99:
    
    loop l99
    ;-----------------------delay-----------------
    
    ; ----------------------- clear screen -------------------------
    mov ax,0600h  
    mov bh,0
    mov cx,0
    mov dx,184fh
    int 10h 
    ;-----------------------------------------------------------------
    
    pop bx
    pop dx
    pop cx
    pop ax
    
    
    push ax
drawsolidrect 159 , 0 , 1 , 200 , 06h ;pitch division
pop ax
    
    
    call drawbullets
    call player2bullets_problem
    
    
    ;mov ah,1
    ;int 16h
    ;
    ;jz nothing_pressed
    ;    
    ;mov ah,07
    ;int 21h
    ;
    ;cmp al,'f'
    ;jne dontfire1
    ;
    ;cmp dx,10          ;fire rate delay 
    ;jb nothing_pressed  ;
    ;
    ;call firebullet1
    ;;skip:
    ;;cmp cx,0fff0h
    ;;jb skip2
    ;dontfire1:
    ;cmp al,'l'
    ;jne dontfire2
    ;
    ;cmp bx,10          ;fire rate 
    ;jb nothing_pressed  ;
    ;    
    ;call firebullet2
;
    ;
    ;dontfire2:
    ;
    ;
    ;nothing_pressed:
   
    
    call key_listner

    mov cx,0
    
    inc dx
    inc bx
    
    ;skip2:
    ;    inc cx
jmp yamany

hlt
main    endp

;*****************************
;Movplayer1	proc

;CHECK:  mov ah,1
;        int 16h
;        jz CHECK
;		mov si , offset player1
;		cmp ah , 48
;		jz UP
;		cmp ah , 50
;		jz down
;		cmp ah , 4d
;		jz right
;		left:mov bx , 1
;		sub [si + 2] , bx
;		drawsolidrect  [si] , [si+2] , 20 , 15 , 05h
;		jmp toend
;		UP:mov bx , 1
;		add [si + 2] , bx
;		drawsolidrect  [si] , [si+2] , 20 , 15 , 05h
;		jmp toend
;		down:mov bx , 1
;		sub [si + 2] , bx
;		drawsolidrect  [si] , [si+2] , 20 , 15 , 05h
;		jmp toend
;		right:mov bx , 1
;		add [si] , bx
;		drawsolidrect  [si] , [si+2] , 20 , 15 , 05h
;		toend:
;ret
;Movplayer1 endp
;*****************************
firebullet1 proc
            ;add x position
            push bx 
            push ax
            push si 
            
            mov bx,offset player1
            mov ax,[bx] ;x position for player 1
            
            mov bx,offset player1bulletx
            mov si,player1bullets
            
            mov [bx+si],ax
                              
            
            
            
            ;add y position
            mov bx,offset player1
            add bx,2
            mov ax,[bx] ;y position for player 1
            
            mov bx,offset player1bullety
            
            
            mov [bx+si],ax
                               ;inc number of bullets
            add si,2
            mov bx,offset player1bullets
            mov [bx],si 
    
            pop si
            pop ax
            pop bx
    
            mov dx , 0 
            
            ret
firebullet1 endp

;*****************************

firebullet2 proc
            ;add x position
            
            push bx 
            push ax
            push di 
            
            mov bx,offset player2
            mov ax,[bx] ;x position for player 2
            
            mov bx,offset player2bulletx
            mov di,player2bullets
            
            mov [bx+di],ax
                              
            
            
            
            ;add y position
            mov bx,offset player2
            mov ax,[bx+2] ;y position for player 2
            
            mov bx,offset player2bullety
            
            
            mov [bx+di],ax
                               ;inc number of bullets
            add di,2
            mov bx,offset player2bullets
            mov [bx],di 
    
    
            pop di
            pop ax
            pop bx
            
            mov bx , 0
            ret
firebullet2 endp 

;*****************************  



drawbullets proc
    
	   
            ;--------- draw player 1 bullets -------------
            pushall
            
            mov di,0 ;counter for loop
            
            mov bx,offset player1bullets
            mov ax,[bx]                   ;number of bullets
	    

	    cmp ax,0
	    je empty

	    ;mov bx,offset player1bulletx
loopbullets1:            
        mov bx,offset player1bulletx
	    ;move player 1 bullets by one            
	    mov dx,[bx+di]
	    add dx,1
	    mov [bx+di],dx

            mov bx,offset player1bullety
           
            mov si,[bx+di]
	    drawrect dx,si,5,2,03h
            cmp dx,290
            jb didnt_go_out
	        
	     
	         
	        deletebullet1 		
            sub di,2
	    didnt_go_out:       
	        
	        add di,2                    
            
            
            mov ax,player1bullets
            
            cmp di,ax
            jb loopbullets1
            
            empty:
            ;--------- draw player 2 bullets -------------
            
            mov di,0 ;counter for loop
            
            mov bx,offset player2bullets
            mov ax,player2bullets                       ;number of bullets
	    ;mov bx,offset player2bulletx
	    
            cmp ax,0
	    je empty2
	        mov di,0
loopbullets2:            
            mov bx,offset player2bulletx
            mov dx,[bx+di]
		
	    ;move player 2 bullets by one            
	    mov dx,[bx+di]
	    dec dx
	    mov [bx+di] , dx            
		
            mov bx,offset player2bullety	    
	    mov si,[bx+di]

            drawrect dx,si,5,2,03h
            cmp dx,0
            ja didnt_go_out2
	         
	        deletebullet2 		
            sub di,2
            didnt_go_out2:       
            
            
            add di,2
            cmp di,ax
            jb loopbullets2 
            
	    empty2: 
          
            popall
            
            ret
drawbullets endp

;***************************

player2bullets_problem proc
             pushall
             
             mov di,0 ;counter for loop
            
            mov bx,offset player2bullets
            mov ax,player2bullets                       ;number of bullets
	    ;mov bx,offset player2bulletx
	    
            cmp ax,0
	    je empty4
	        mov di,0
loopbullets4:            
            mov bx,offset player2bulletx
            mov dx,[bx+di]
		
	    ;move player 2 bullets by one            
	    mov dx,[bx+di]
	    
		
            mov bx,offset player2bullety	    
	    mov si,[bx+di]

            cmp dx,300
            jb didnt_go_out4
	         
	        deletebullet2 		
            sub di,2
            didnt_go_out4:       
            
            
            add di,2
            cmp di,ax
            jb loopbullets4 
            
	    empty4: 




            popall
            ret
player2bullets_problem endp

;***************************
   
key_listner proc
    mov ah,1
    int 16h
    
    jnz exist
    ret
    exist:
        
    mov ah,0
    int 16h
    cmp al,'a'
    je yes_player2
    cmp al,'w'
    je yes_player2
    cmp al,'s'
    je yes_player2
    cmp al,'d'
    je yes_player2
    
    jmp no_player2
    yes_player2:
    movplayer2
    no_player2:
    ;-----------------------check player 1--------------------
    cmp ah,48h
    je yes_player1
    cmp ah,50h
    je yes_player1
    cmp ah,4bh
    je yes_player1
    cmp ah,4dh
    je yes_player1
    
    jmp no_player1
    yes_player1:
    movplayer1
    no_player1:
    ;--------------------------check fire------------------------    


    cmp al,'f'
    jne dontfire1
    
    cmp dx,10          ;fire rate delay 
    jb nothing_pressed  ;
    
    call firebullet1
    ;skip:
    ;cmp cx,0fff0h
    ;jb skip2
    dontfire1:
    cmp al,'l'
    jne dontfire2
    
    cmp bx,10          ;fire rate 
    jb nothing_pressed  ;
        
    call firebullet2

    
    dontfire2:
    
    
    nothing_pressed:

    mov al,0
ret
key_listner endp
end main
