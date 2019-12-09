include mymacros.inc
.model small
.stack 64
.data
mes db 10,13,10,13,9,9,'main menu','$' 
fitmess db 10,13,10,13,10,13,9,'   start play press ','$'
secmess db 10,13,10,13,10,13,10,13,9,'   start chat press ','$'

player1 dw 70 , 100
player2 dw 250 , 100
               
playerstep equ 4
playerheight equ 15

bulletHitAmountHealthbar equ 1

player1bullets dw 0
player1bulletx dw 200 dup(0)
player1bullety dw 200 dup(0)

player2bullets dw 0
player2bulletx dw 200 dup(0)
player2bullety dw 200 dup(0)


laser_bar_recover_delay equ 33
barrier_bar_recover_delay equ 33

laser_on_delay equ 255

laserthickness equ 3
laserlength equ 150

firsthealthbar  dw 10 , 10 , 35
secondhealthbar dw 170 , 10 , 35
;**********************
firstlaserrecoverdelay db laser_bar_recover_delay
firstlaser_on_delay   db 1
firstlaserbar   dw 70 , 13 , 20
secondlaserrecoverdelay db laser_bar_recover_delay
secondlaser_on_delay   db 1
secondlaserbar   dw 230 , 13 , 20
;**********************
firstbarrierrecoverdelay db barrier_bar_recover_delay
firstbarrierbar  dw 115 , 13 , 35
secondbarrierrecoverdelay db barrier_bar_recover_delay
secondbarrierbar dw 275 , 13 , 35

;---width and len
widthG equ  15
lenG   equ  20
widthB equ  2
lenB   equ  5 

;-----temp memory
yGamerTop dw 0
yGamerBottom dw 0

yBulletTop dw 0
yBulletBottom dw 0
lenBetweenGB dw 0 


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


;drawsolidrect

;mov si , offset firstlaserbar
;incprogbar
;mov si , offset secondlaserbar
;incprogbar
;mov si , offset firstlaserbar
;decprogbar
mov si , offset firsthealthbar
drawprogbar 10, 02h, 04h
mov si , offset secondhealthbar
drawprogbar 10, 02h, 04h

mov si , offset firstlaserbar
drawprogbar 5, 1110b, 04h
mov si , offset secondlaserbar
drawprogbar 5, 1110b, 04h

mov si , offset firstbarrierbar
drawprogbar 5, 1000b, 04h
mov si , offset secondbarrierbar
drawprogbar 5, 1000b, 04h

call firstlaserrecoverdelay_proc

call secondlaserrecoverdelay_proc

call firstbarrierrecoverdelay_proc

call secondbarrierrecoverdelay_proc



call drawfirstlaser
call drawsecondlaser

mov di , offset player1
drawrect [di] , [di+2] , 20 , playerheight , 05h ;1st player
;
;movplayer1
;drawrect 159 , 0 , 1 , 200 , 06h

mov di , offset player2
drawrect [di], [di+2] , 20 , playerheight , 05h ;2nd player

;mov ah,1
;int 16h
;jz ending

;MOV     CX, 0H
;MOV     DX, 6000H
;MOV     AH, 86H
;INT     15H

;movplayer2


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
    ;MOV     CX, 0H
    ;MOV     DX, 6000H
    ;MOV     AH, 86H
    ;INT     15H
    ; ----------------------- clear screen -------------------------
    ;mov ax,0600h  
    ;mov bh,0
    ;mov cx,0
    ;mov dx,184fh
    ;int 10h 
    ;-----------------------------------------------------------------
    ;drawsolidrect 0 , 0 , 320 , 200 , 0h ;pitch division
    
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
   
    
    call key_listener

    mov cx,0
    
    inc dx
    inc bx
    
    call Collesion
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
            call drawBulletFrame
            cmp dx,310
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

            call drawBulletFrame
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
drawBulletFrame proc
drawrect dx,si,5,2,03h
        sub dx, 2
        sub si, 2
drawrect dx, si, 9, 7, 0h
        add dx,2
        add si,2
ret
drawBulletFrame endp

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
   
key_listener proc
    mov ah,1
    int 16h
    
    jnz exist
    ret
    exist:
    mov ah,0
    int 16h
    ;-----------------------check player 2 movement--------------------
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
    ;-----------------------check player 1 movement--------------------
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
    ;--------------------------check Bullets------------------------    
    cmp al,'f'
    jne dontfire1
    
    cmp dx,10          ;fire rate delay 
    jb dontfire1  ;
    
    call firebullet1
    ;skip:
    ;cmp cx,0fff0h
    ;jb skip2
    dontfire1:
    cmp al,'l'
    jne dontfire2
    
    cmp bx,10          ;fire rate 
    jb dontfire2  ;
        
    call firebullet2

    
    dontfire2:
    ;--------------------------check Laser------------------------

    cmp al, ';'
    jne dontlaser1
    
    
    call laser1

    dontlaser1:
    cmp al, 'e'
    jne dontlaser2

    call laser2
    dontlaser2:

    ;--------------------------check Barrier------------------------

    cmp al, 'k'
    jne dontbarrier1
    
    
    call barrier1

    dontbarrier1:
    cmp al, 'q'
    jne dontbarrier2

    call barrier2
    dontbarrier2:
    
    ;nothing_pressed:

    mov al,0
ret
key_listener endp
;***************************
laser1 proc 
mov si , offset secondlaserbar
decprogbar 8

mov secondlaser_on_delay, laser_on_delay
ret
laser1 endp

;***************************
laser2 proc 
mov si , offset firstlaserbar
decprogbar 8

mov firstlaser_on_delay, laser_on_delay
ret
laser2 endp

;***************************
barrier1 proc 
mov si , offset secondbarrierbar
decprogbar 8
ret
barrier1 endp

;***************************
barrier2 proc 
mov si , offset firstbarrierbar
decprogbar 8
ret
barrier2 endp

;***************************
firstlaserrecoverdelay_proc proc
push ax
mov al, 1
sub firstlaserrecoverdelay, al
cmp firstlaserrecoverdelay, al
pop ax
jbe inclaser1
jmp dont_inc_laserbar1

inclaser1: mov si , offset firstlaserbar
incprogbar 1
mov firstlaserrecoverdelay, laser_bar_recover_delay

dont_inc_laserbar1:
ret
firstlaserrecoverdelay_proc endp

;***************************
secondlaserrecoverdelay_proc proc
push ax
mov al, 1
sub secondlaserrecoverdelay, al
cmp secondlaserrecoverdelay, al
pop ax
jbe inclaser2
jmp dont_inc_laserbar2

inclaser2: mov si , offset secondlaserbar
incprogbar 1
mov secondlaserrecoverdelay, laser_bar_recover_delay

dont_inc_laserbar2:
ret
secondlaserrecoverdelay_proc endp

;***************************
firstbarrierrecoverdelay_proc proc
push ax
mov al, 1
sub firstbarrierrecoverdelay, al
cmp firstbarrierrecoverdelay, al
pop ax
jbe incbarrier1
jmp dont_inc_barrierbar1

incbarrier1: mov si , offset firstbarrierbar
incprogbar 1
mov firstbarrierrecoverdelay, barrier_bar_recover_delay

dont_inc_barrierbar1:
ret
firstbarrierrecoverdelay_proc endp

;***************************
secondbarrierrecoverdelay_proc proc
push ax
mov al, 1
sub secondbarrierrecoverdelay, al
cmp secondbarrierrecoverdelay, al
pop ax
jbe incbarrier2
jmp dont_inc_barrierbar2

incbarrier2: mov si , offset secondbarrierbar
incprogbar 1
mov secondbarrierrecoverdelay, barrier_bar_recover_delay

dont_inc_barrierbar2:
ret
secondbarrierrecoverdelay_proc endp

;***************************
drawfirstlaser proc
push ax
mov al, 1
sub firstlaser_on_delay, al
cmp firstlaser_on_delay, al
pop ax
ja drawlaser1
jmp dont_drawlaser1

drawlaser1:
mov si, offset player1
drawsolidrect [si], [si+2], laserlength, laserthickness, 04h
ret

dont_drawlaser1:
mov firstlaser_on_delay, 1
mov si, offset player1
drawsolidrect [si], [si+2], laserlength, laserthickness, 0h

ret
drawfirstlaser endp

;***************************
drawsecondlaser proc
push ax
mov al, 1
sub secondlaser_on_delay, al
cmp secondlaser_on_delay, al
pop ax
ja drawlaser2
jmp dont_drawlaser2

drawlaser2:
mov si, offset player2
push ax
mov ax, [si]
sub ax, 130
mov temp1, ax
pop ax
drawsolidrect temp1, [si+2], laserlength, laserthickness, 04h

ret

dont_drawlaser2:
mov secondlaser_on_delay, 2

mov si, offset player2
push ax
mov ax, [si]
sub ax, 130
mov temp1, ax
pop ax
drawsolidrect temp1, [si+2], laserlength, laserthickness, 0h

ret
drawsecondlaser endp

Collesion proc 
    
    pushall
    
    mov cx,player1bullets
    cmp cx,0
    jne notempty
    jmp quit1
    notempty:

      mov di,offset player1bulletx
      mov si,offset player1bullety
      mov bx,offset player2 
    
    ;loop for all bullets out of gamer1
    LForRightSide:
        
        call CheckOfCollesion1
         
        add di,2
        add si,2
        sub cx,2
        cmp cx,0
    ja LForRightSide 
    quit1:
    mov cx,player2bullets
    cmp cx,0
    jne notempty2
    jmp quit2
    notempty2:
    mov di,offset player2bulletx
    mov si,offset player2bullety
    mov bx,offset player1 
    
     
     
    ;loop for all bullets out of gamer2
    LForLeftSide:
           
        call CheckOfCollesion2 
        
        add di,2
        add si,2
        sub cx,2
        cmp cx,0
    ja LForLeftSide
    
    quit2:
    popall
    ret
Collesion endp
;--------------------------
CheckOfCollesion1 proc 
   pushall 
   mov ax,[bx+2]
   mov yGamerTop,ax
   add ax,widthG  
   mov yGamerBottom,ax 
   
   mov ax,[si]
   mov yBulletTop,ax
   add ax,widthB
   mov yBulletBottom,ax
   
   mov ax,[bx]
   mov dx,[di]
   cmp ax,dx
   jae abslutelen
   sub dx,ax
   xchg dx,ax

   continue:
     mov lenBetweenGB,ax
     mov ax,widthB
     cmp lenBetweenGB,ax
      jbe continueComapring
      
     jmp outt

abslutelen:  ; abslute length
   sub ax,dx
   jmp continue    

continueComapring:
   mov ax,yBulletTop
   mov dx,yBulletBottom
   
   cmp ax,yGamerTop
     ja continueComapringg2
     je DecreaseHealth
   cmp dx,yGamerTop
     ja continueComapringg2       
     je DecreaseHealth
     jmp outt
continueComapringg2:

    cmp dx,yGamerBottom
     jbe  DecreaseHealth
     
   cmp ax,yGamerBottom
     jbe DecreaseHealth
     jmp outt   

DecreaseHealth:
    
    mov si , offset secondhealthbar
    decprogbar bulletHitAmountHealthbar
    
    mov bx,offset player1bulletx
    sub di,bx
    deletebullet1 
 

   mov cx,1
  mov bh,0
  mov ah,9
  mov al,44h
  mov bl,4
  int 10h

  
    
    
outt:
   
   popall
   ret
CheckOfCollesion1 endp

CheckOfCollesion2 proc

    pushall
   mov ax,[bx+2]
   mov yGamerTop,ax
   add ax,widthG  
   mov yGamerBottom,ax 
   
   mov ax,[si]
   mov yBulletTop,ax
   add ax,widthB
   mov yBulletBottom,ax
   
   mov ax,[bx]
   mov dx,[di]
   cmp ax,dx
   jae abslutelen2
   sub dx,ax
   xchg dx,ax

   continue2:
     mov lenBetweenGB,ax
     mov ax,widthG
     cmp lenBetweenGB,ax
      jbe continueComapring2
     jmp outt2

abslutelen2: ;absulte length 
   sub ax,dx
   jmp continue2    

continueComapring2:

   mov ax,yBulletTop
   mov dx,yBulletBottom
 
   cmp ax,yGamerTop
     ja continueComapring22
     je DecreaseHealth2
   cmp dx,yGamerTop
     ja continueComapring22       
     je DecreaseHealth2
     jmp outt2
continueComapring22:

    cmp dx,yGamerBottom
     jbe  DecreaseHealth2
     
   cmp ax,yGamerBottom
     jbe DecreaseHealth2
     jmp outt2   

DecreaseHealth2:
    
    push si
    mov si , offset firsthealthbar
    decprogbar bulletHitAmountHealthbar
    
    ;mov bx,player2bullets
    ;sub di,bx
    ;deletebullet2
    pop si
    deleteBulletsShoubra di,si 

  ;mov cx,1
  ;mov bh,0
  ;mov ah,9
  ;mov al,44h
  ;mov bl,4
  ;int 10h
    
    
outt2:
   popall
   ret
   
CheckOfCollesion2 endp
;***************************


end main
