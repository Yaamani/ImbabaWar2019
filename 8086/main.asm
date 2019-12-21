include mymacros.inc
.model compact
.386
.stack 64
.data
intromessage db 10,13,10,13,10,13,10,13,10,13,9,'     EMBABA WAR  ','$' ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
mes db 10,13,10,13,9,9,'main menu','$'
;infomessage1 db 10,13,9,9,'Info menu',10,13,'Player1: UP:W',9,'Down:S',9,'Right:D',9,'fire:f','$'
;infomessage2 db 'Player2: UP:uparrow',9,'Down:downarrow',9,'Right:rightarrow',9,'Left:leftarrow',9,'fire:l','$'
fitmess db 10,13,10,13,10,13,9,'   start play press ','$'
secmess db 10,13,10,13,10,13,10,13,9,'   start chat press ','$'
;guidemess db 10,13,10,13,10,13,10,13,9,'   Game INFO press ','$'

player1 dw 70 , 100
player2 dw 250 , 100
               
playerstep equ 4
playerheight equ 15
playerwidth equ 20
playercolor equ 5h

bulletHitAmountHealthbar equ 1
laserHitAmountHealthbar equ 1
laserHitDecreaseHealthDelay equ 15

laser1HitDecreaseHealthCounter db 0
laser2HitDecreaseHealthCounter db 0

clip_laser1 db 0 ; Intended to be a boolean val
clip_laser2 db 0 ; Intended to be a boolean val


player1bullets dw 0
player1bulletx dw 200 dup(0)
player1bullety dw 200 dup(0)

player2bullets dw 0
player2bulletx dw 200 dup(0)
player2bullety dw 200 dup(0)


laser_bar_recover_delay equ 33
barrier_bar_recover_delay equ 33

laser_on_delay equ 255
barrier_on_delay equ 255

laserthickness equ 3
laserlength equ 140

barrierwidth equ 4
barrierheight equ 25

laserprogbarthreshold equ 4 ; if laser's progbar is below this val, don't draw the laser
barrierprogbarthreshold equ 4 

firsthealthbar  dw 10 , 10 , 35
secondhealthbar dw 170 , 10 , 35
;**********************

firstlaserrecoverdelay db laser_bar_recover_delay
firstlaser_on_delay   db 1
firstlaserbar   dw 70 , 13 , 20
firstlaser_cleared db 1 ;Intended to be a boolean val

secondlaserrecoverdelay db laser_bar_recover_delay
secondlaser_on_delay   db 1
secondlaserbar   dw 230 , 13 , 20
secondlaser_cleared db 1 ;Intended to be a boolean val

;**********************

firstbarrierrecoverdelay db barrier_bar_recover_delay
firstbarrier_on_delay   db 1 
firstbarrierbar  dw 115 , 13 , 35
firstbarrier_cleared db 1 ;Intended to be a boolean val

secondbarrierrecoverdelay db barrier_bar_recover_delay
secondbarrier_on_delay  db  1
secondbarrierbar dw 275 , 13 , 35
secondbarrier_cleared db 1 ;Intended to be a boolean val

;**********************

;---width and len
widthG equ  playerheight
lenG   equ  playerwidth
widthB equ  2
lenB   equ  5 

;-----temp memory
yGamerTop dw 0
yGamerBottom dw 0

yBulletTop dw 0
yBulletBottom dw 0
yLaserTop dw 0
yLaserBottom dw 0
lenBetweenGB dw 0 
lenBetweenGL dw 0 


temp1 dw ?
temp2 dw ?
temp3 dw ?
temp4 dw ?


.code         
main proc far            
mov ax,@data
mov ds,ax

;********video mode********
mov ax,13h
int 10h
;*********intro message****************;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;intromenu intromessage				   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;MOV     CX, 1fH						   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;MOV     DX, 8253H					   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;MOV     AH, 86H						   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;INT     15H							   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;********clear screen******************;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    mov ax,0600h					   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    mov bh,0						   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    mov cx,0						   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    mov dx,184fh					   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    int 10h 						   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

lbl:
;push bx
;push ax
mov bx,offset firsthealthbar
add bx,4
mov ax,35
mov [bx],ax

mov bx,offset secondhealthbar
add bx,4
mov ax,35
mov [bx],ax

mov bx,0
mov [player1bullets],bx ;model small problem
mov [player2bullets],bx


;player1 dw 70 , 100
;player2 dw 250 , 100
;pop ax
;pop bx

;********main menu mode********
mainmenu mes,fitmess,secmess

;-------key pressed---------
onlyp:
mov ah,0
int 16h   ;get key pressed (wait for a key-ah:scancode,al:ascii)  
cmp al , 'p'
jne onlyP
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
;drawrect 159 , 0 , 1 , 200 , 06h ;pitch division



;call firebullet1


;call firebullet2


mov dx,0  ;i am using DX , BX for the delay in fire rate so DON'T CHANGE THEM IN YOUR CODE
mov bx,0  ;

mov cx,0

yamany:

mov bx,offset firsthealthbar
call salq2
jb lbl

mov bx,offset secondhealthbar
call salq2
jb lbl


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

call drawfirstbarrier
call drawsecondbarrier


call a3del_elgamer

mov di , offset player1
drawrect [di] , [di+2] , playerwidth , playerheight , playercolor ;1st player
;
;movplayer1
;drawrect 159 , 0 , 1 , 200 , 06h

mov di , offset player2
drawrect [di], [di+2] , playerwidth , playerheight , playercolor ;2nd player

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
    
    call Collision
    ;skip2:
    ;    inc cx
    
    ;pushall
    ;DEBUG
    ;mov ah, 2
    ;mov dl, 'A'
    ;int 21
    ;popall

    ;showmessage intromessage

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

    ;--------------------------check barrier------------------------

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

mov si, offset secondlaserbar
mov ax, [si]+4
cmp ax, laserprogbarthreshold 
ja activatelaser1
mov secondlaser_on_delay, 1
ret

activatelaser1:
mov si , offset secondlaserbar
decprogbar 8

mov secondlaser_on_delay, laser_on_delay
ret
laser1 endp

;***************************
laser2 proc 

mov si, offset firstlaserbar
mov ax, [si]+4
cmp ax, laserprogbarthreshold 
ja activatelaser2
mov firstlaser_on_delay, 1
ret

activatelaser2:
mov si , offset firstlaserbar
decprogbar 8

mov firstlaser_on_delay, laser_on_delay
ret
laser2 endp

;***************************
barrier1 proc 

mov si, offset secondbarrierbar
mov ax, [si]+4
cmp ax, barrierprogbarthreshold 
ja activatebarrier1
mov secondbarrier_on_delay, 1
ret

activatebarrier1:
mov si , offset secondbarrierbar
decprogbar 8

mov secondbarrier_on_delay, barrier_on_delay
ret
barrier1 endp

;***************************
barrier2 proc

mov si, offset firstbarrierbar
mov ax, [si]+4
cmp ax, barrierprogbarthreshold 
ja activatebarrier2
mov firstbarrier_on_delay, 1
ret

activatebarrier2:
mov si , offset firstbarrierbar
decprogbar 8

mov firstbarrier_on_delay, barrier_on_delay
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

;push ax
mov si, offset firstlaserbar
mov ax, [si]+4
cmp ax, laserprogbarthreshold 
;pop ax
ja drawinglaser1isalowed
mov firstlaser_on_delay, 1
jmp dont_drawlaser1


drawinglaser1isalowed:
push ax
mov al, 1
sub firstlaser_on_delay, al
cmp firstlaser_on_delay, al
pop ax
ja drawlaser1
jmp dont_drawlaser1

drawlaser1:
prepareplayer1laserCoordinates
drawsolidrect temp1, temp2, temp3, temp4, 04h

push ax
mov al, 0
mov firstlaser_cleared, al
pop ax

ret

dont_drawlaser1:
mov firstlaser_on_delay, 1

;claer the laser
push ax
mov al, 1
cmp firstlaser_cleared, al
je dontclear1

prepareplayer1laserCoordinates
drawsolidrect temp1, temp2, temp3, temp4, 0h

mov firstlaser_cleared, al

dontclear1:
pop ax

ret
drawfirstlaser endp

;***************************
drawsecondlaser proc

push ax
mov si, offset secondlaserbar
mov ax, [si]+4
cmp ax, laserprogbarthreshold 
pop ax
ja drawinglaser2isalowed
mov secondlaser_on_delay, 1
jmp dont_drawlaser2

drawinglaser2isalowed:
push ax
mov al, 1
sub secondlaser_on_delay, al
cmp secondlaser_on_delay, al
pop ax
ja drawlaser2
jmp dont_drawlaser2

drawlaser2:
prepareplayer2laserCoordinates
drawsolidrect temp1, temp2, temp3, temp4, 04h

push ax
mov al, 0
mov secondlaser_cleared, al
pop ax

ret

dont_drawlaser2:
mov secondlaser_on_delay, 2



;claer the laser
push ax
mov al, 1
cmp secondlaser_cleared, al
je dontclear2

prepareplayer2laserCoordinates
drawsolidrect temp1, temp2, temp3, temp4, 0h
mov secondlaser_cleared, al

dontclear2:
pop ax
ret
drawsecondlaser endp

;***************************
drawfirstbarrier proc

push ax
mov si, offset firstbarrierbar
mov ax, [si]+4
cmp ax, barrierprogbarthreshold 
pop ax
ja drawingbarrier1isalowed
mov firstbarrier_on_delay, 1
jmp dont_drawbarrier1

drawingbarrier1isalowed:
push ax
mov al, 1
sub firstbarrier_on_delay, al
cmp firstbarrier_on_delay, al
pop ax
ja drawbarrier1
jmp dont_drawbarrier1

drawbarrier1:

prepareplayer1barrierCoordinates
drawsolidrect temp1, temp2, barrierwidth, barrierheight, 08h
;popall


push ax
mov al, 0
mov firstbarrier_cleared, al
pop ax

ret

dont_drawbarrier1:
mov firstbarrier_on_delay, 1
mov si, offset player1

;claer the barrier
push ax
mov al, 1
cmp firstbarrier_cleared, al
je dontclearbarrier1

clearplayer1barrier

mov al, 1
mov firstbarrier_cleared, al

dontclearbarrier1:
pop ax

ret
drawfirstbarrier endp

;***************************
drawsecondbarrier proc

push ax
mov si, offset secondbarrierbar
mov ax, [si]+4
cmp ax, barrierprogbarthreshold 
pop ax
ja drawingbarrier2isalowed
mov secondbarrier_on_delay, 1
jmp dont_drawbarrier2

drawingbarrier2isalowed:
push ax
mov al, 1
sub secondbarrier_on_delay, al
cmp secondbarrier_on_delay, al
pop ax
ja drawbarrier2
jmp dont_drawbarrier2

drawbarrier2:
prepareplayer2barrierCoordinates
drawsolidrect temp1, temp2, barrierwidth, barrierheight, 08h
;popall


push ax
mov al, 0
mov secondbarrier_cleared, al
pop ax

ret

dont_drawbarrier2:
mov secondbarrier_on_delay, 1
mov si, offset player2

;claer the barrier
push ax
mov al, 1
cmp secondbarrier_cleared, al
je dontclearbarrier2

clearplayer2barrier

mov al, 1
mov secondbarrier_cleared, al

dontclearbarrier2:
pop ax

ret
drawsecondbarrier endp

;***************************
Collision proc 
    
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
        
        call CheckOfCollision1
         
        add di,2
        add si,2
        sub cx,2
        cmp cx,0
    ja LForRightSide 
    
    
    quit1:
    
    prepareplayer1laserCoordinates
    mov di,offset temp1 ; laser's x coordinate
    mov si,offset temp2 ; laser's y coordinate
    mov bx,offset player2

    call CheckLaserCollision1

    mov cx,player2bullets
    cmp cx,0
    jne notempty2
    jmp quit2


    notempty2:
    mov di,offset player2bulletx
    mov si,offset player2bullety
    mov bx,offset player1 
    
     
     
    ; loop for all bullets out of gamer2
    LForLeftSide:
           
        call CheckOfCollision2 
        
        add di,2
        add si,2
        sub cx,2
        cmp cx,0
    ja LForLeftSide
    
    quit2:

    prepareplayer2laserCoordinates
    mov di,offset temp1 ; laser's x coordinate
    mov si,offset temp2 ; laser's y coordinate
    mov bx,offset player1

    call CheckLaserCollision2

    popall
    ret
Collision endp
;--------------------------
CheckOfCollision1 proc

   pushall 
   mov ax,[bx+2]
   mov yGamerTop,ax
   add ax,widthG  
   mov yGamerBottom,ax 
   
   mov ax,[si]
   mov yBulletTop,ax
   add ax,widthB
   mov yBulletBottom,ax

    mov al, 2
    cmp secondbarrier_on_delay, al
    jbe barrier1_isnt_active 

;barrier1_is_active
    mov ax, [bx] ; player's x coordinate 
    sub ax, barrierwidth
    mov dx, [di] ; bullet's x coordinate
    cmp ax, dx
    jae abslutelen
    sub dx, ax
    xchg dx, ax
    jmp continue
   

barrier1_isnt_active:
   mov ax,[bx] ; player's x coordinate 
   mov dx,[di] ; bullet's x coordinate
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

    mov bx,offset player1bulletx
    sub di,bx
    deletebullet1 

    mov al, 2
    cmp secondbarrier_on_delay, al
    jae outt ;barrier1_is_active
    
    mov si , offset secondhealthbar
    decprogbar bulletHitAmountHealthbar
    
    
 
  ;debug
  ;mov cx,1
  ;mov bh,0
  ;mov ah,9
  ;mov al,44h
  ;mov bl,4
  ;int 10h

  
    
    
outt:
   
   popall
   ret
CheckOfCollision1 endp


;--------------------------
CheckLaserCollision1 proc 
   pushall 

   	mov clip_laser1, 0

    mov al, 2
    cmp firstlaser_on_delay, al
    jbe outtlaser ; if opponent's laser isn't working


   mov ax,[bx+2]
   mov yGamerTop,ax
   add ax,widthG  
   mov yGamerBottom,ax 
   
   mov ax, [si] ; laser's y coordinate
   mov yLaserTop, ax
   add ax, laserthickness 
   mov yLaserBottom, ax

    mov al, 2
    cmp secondbarrier_on_delay, al
    jbe barrier1_isnt_active_laser

;barrier1_is_active_laser:
    mov ax, [bx] ; player's x coordinate 
    sub ax, barrierwidth
    mov dx, [di] ; laser's x coordinate
    cmp ax, dx
    jae abslutelenlaser
    sub dx, ax
    xchg dx, ax
    jmp continuelaser
   


barrier1_isnt_active_laser:
   mov ax,[bx] ; player's x coordinate 
   mov dx,[di] ; laser's x coordinate
   cmp ax,dx
   jae abslutelenlaser
   sub dx,ax
   xchg dx,ax

continuelaser:
    mov lenBetweenGL, ax
    mov ax, laserlength
	;drawsolidrect 150, 150, lenBetweenGL, laserthickness, 02h
    cmp lenBetweenGL, ax
    jbe continueComapringLaser1
    
    jmp outtlaser

abslutelenlaser:  ; abslute length
   sub ax,dx
   jmp continuelaser    

continueComapringLaser1:
   mov ax,yLaserTop
   mov dx,yLaserBottom
   
   cmp ax,yGamerTop
     ja continueComapringglaser2
     je DecreaseHealthLaser
   cmp dx,yGamerTop
     ja continueComapringglaser2       
     je DecreaseHealthLaser
     jmp outtlaser
continueComapringglaser2:

    cmp dx,yGamerBottom
     jbe  DecreaseHealthLaser
     
   cmp ax,yGamerBottom
     jbe DecreaseHealthLaser
     jmp outtlaser   

DecreaseHealthLaser:

    mov al, 2
    cmp secondbarrier_on_delay, al
    jae laser1clip ;barrier_is_active
    
    add laser1HitDecreaseHealthCounter, 1
    mov al, laserHitDecreaseHealthDelay
    cmp laser1HitDecreaseHealthCounter, al
    jb outtlaser
    
    mov laser1HitDecreaseHealthCounter, 0
    mov si, offset secondhealthbar
    decprogbar laserHitAmountHealthbar
    jmp outtlaser
    

  ;debug
  ;mov cx,1
  ;mov bh,0
  ;mov ah,9
  ;mov al,44h
  ;mov bl,4
  ;int 10h

  
laser1clip:
    mov clip_laser1, 1
    
outtlaser:
   
   popall
   ret
CheckLaserCollision1 endp

CheckOfCollision2 proc

    pushall
   mov ax,[bx+2]
   mov yGamerTop,ax
   add ax,widthG  
   mov yGamerBottom,ax 
   
   mov ax,[si]
   mov yBulletTop,ax
   add ax,widthB
   mov yBulletBottom,ax
   
    mov al, 2
    cmp firstbarrier_on_delay, al
    jbe barrier2_isnt_active 

;barrier2_is_active
    mov ax, [bx] ; player's x coordinate 
    add ax, barrierwidth
    mov dx, [di] ; bullet's x coordinate
    cmp ax, dx
    jae abslutelen
    sub dx, ax
    xchg dx, ax
    jmp continue2
   

barrier2_isnt_active:

   mov ax,[bx] ; player's x coordinate 
   mov dx,[di] ; bullet's x coordinate
   cmp ax,dx
   jae abslutelen2
   sub dx,ax
   xchg dx,ax

   continue2:
     mov lenBetweenGB,ax
     mov ax,playerwidth
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
    deleteBulletsShoubra di,si 
    
    mov al, 2
    cmp firstbarrier_on_delay, al
    jae outt2 ;barrier1_is_active

    ;push si
    mov si , offset firsthealthbar
    decprogbar bulletHitAmountHealthbar
    ;pop si

    ;mov bx,player2bullets
    ;sub di,bx
    ;deletebullet2

  ;mov cx,1
  ;mov bh,0
  ;mov ah,9
  ;mov al,44h
  ;mov bl,4
  ;int 10h
    
    
outt2:
   popall
   ret
   
CheckOfCollision2 endp

;-------------------------
CheckLaserCollision2 proc

    pushall

	mov clip_laser2, 0

    mov al, 2
    cmp secondlaser_on_delay, al
    jbe outtlaser2 ; if the oponent's laser isn't working


   mov ax,[bx+2]
   mov yGamerTop,ax
   add ax,widthG  
   mov yGamerBottom,ax 
   
   mov ax, [si] ; laser's y coordinate
   mov yLaserTop, ax
   add ax, laserthickness 
   mov yLaserBottom, ax
   
    mov al, 2
    cmp firstbarrier_on_delay, al
    jbe barrier2_isnt_active_laser

;barrier2_is_active_laser:
    ;mov ax, [bx] ; player's x coordinate 
    ;add ax, barrierwidth
    ;mov dx, [di] ; laser's x coordinate
    ;cmp ax, dx
    ;jae abslutelenlaser2
    ;sub dx, ax
    ;xchg dx, ax
    ;jmp continuelaser2
   

barrier2_isnt_active_laser:

   ;mov ax,[bx] ; left player's x coordinate
   ;add ax, playerwidth
   ;;add ax, laserlength
   ;mov dx,[di] ; laser's x coordinate
   ;cmp ax,dx
   ;jae abslutelenlaser2
   ;sub dx,ax
   ;xchg dx,ax

   mov ax, player1
   add ax, playerwidth
   mov bx, player2
   sub bx, ax
   cmp bx, laserlength
   ja outtlaser2

   ;continuelaser2:
   ;  mov lenBetweenGL, ax
	; drawsolidrect 150, 150, lenBetweenGL, laserthickness, 02h
   ;  mov ax, laserlength
   ;  cmp lenBetweenGL, ax
   ;  jbe continueComapringlaser2
;
   ;  jmp outtlaser2

;abslutelenlaser2: ; absulte length 
   ;sub ax,dx
   ;jmp continuelaser2    

continueComapringlaser2:

   mov ax,yLaserTop
   mov dx,yLaserBottom
 
   cmp ax,yGamerTop
     ja continueComapringlaser22
     je DecreaseHealthLaser2
   cmp dx,yGamerTop
     ja continueComapringlaser22       
     je DecreaseHealthLaser2
     jmp outtlaser2
continueComapringlaser22:

    cmp dx,yGamerBottom
     jbe  DecreaseHealthLaser2
     
   cmp ax,yGamerBottom
     jbe DecreaseHealthLaser2
     jmp outtlaser2   

DecreaseHealthLaser2:    
    mov al, 2
    cmp firstbarrier_on_delay, al
    jae laser2clip ;barrier_is_active

    add laser2HitDecreaseHealthCounter, 1
    mov al, laserHitDecreaseHealthDelay
    cmp laser2HitDecreaseHealthCounter, al
    jb outtlaser2
    
    mov laser2HitDecreaseHealthCounter, 0
    mov si, offset firsthealthbar
    decprogbar laserHitAmountHealthbar
    jmp outtlaser2

    ;mov bx,player2bullets
    ;sub di,bx
    ;deletebullet2

  ;mov cx,1
  ;mov bh,0
  ;mov ah,9
  ;mov al,44h
  ;mov bl,4
  ;int 10h

   laser2clip:
    mov clip_laser2, 1 
    
outtlaser2:
   popall
   ret
   
CheckLaserCollision2 endp
;***************************

a3del_elgamer proc
pushall              
;-------------------------player1-----------------------
mov bx,offset player1
mov cx,4    ;x left
call salq
cmp cx,[bx]
jb ssps
call salq
mov [bx],cx
ssps:

mov cx,130    ;x right
cmp cx,[bx]
ja ssps2
;call salq
mov [bx],cx
ssps2:

mov bx,offset player1
add bx,2

mov cx,20    ;y top
cmp cx,[bx]
jb ssps3
;call salq
mov [bx],cx
ssps3:

mov cx,180    ;y bottom
cmp cx,[bx]
ja ssps4
;call salq
mov [bx],cx
ssps4:


;-------------------------player2-----------------------


mov bx,offset player2
mov cx,150    ;x left
cmp cx,[bx]
jb ssps5

mov [bx],cx
ssps5:

mov cx,290    ;x right
cmp cx,[bx]
ja ssps6
mov [bx],cx
ssps6:

mov bx,offset player2
add bx,2

mov cx,20    ;y top
cmp cx,[bx]
jb ssps7
mov [bx],cx
ssps7:

mov cx,180    ;y bottom
cmp cx,[bx]
ja ssps8
mov [bx],cx
ssps8:




popall
ret
a3del_elgamer endp

salq proc
;pushall
;drawrect  [bx] , [bx+2] , 20 , playerheight , 0h
;popall
ret
salq endp

salq2 proc
add bx,4
mov ax,[bx]
cmp ax,5

ret
salq2 endp

end main
