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
name_request_message db 10,13,10,13,10,13,9,'   please enter your name ',10,9,9,'$'

play_req_mes db ' ,you recived playing request press y to accept $'
chat_req_mes db ' ,you recived chat request press y to accept $'

connection_waiting_mes db ' waiting for the other player to connect $'

play_req_mes_wait db  ' ,waiting for other player answer $'

chat_req_mes_wait db  ' ,waiting for other player answer $'

player1 dw 70 , 100
player2 dw 250 , 100

my_score db 0
other_score db 0

my_score_mes db 10,13 , 'your score :$'
other_score_mes db  10 ,10 , 'other score :$'

player_name db  26        ;MAX NUMBER OF CHARACTERS ALLOWED (25).
player_name_length db  ?         ;NUMBER OF CHARACTERS ENTERED BY USER.
my_name     db  26 dup('$') ;CHARACTERS ENTERED BY USER.

other_name_length db  ? 
other_player_name db  26 dup('$') ;CHARACTERS ENTERED BY USER.

left_player_fire_limit db  0 
right_player_fire_limit db  0


               
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

connection_set db 0 
leftPlayer db 0  ; for multible devices

right_player_action db '-'
left_player_action db '-'

received_VALUE db 0 
send_VALUE db 0 

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
;---------------------------------chat variables---------------------------------
RECIEVE_char       db  ?
send_char          db  ?

CURSOR_UPPER        dw  0
CURSOR_UPPER_NAME   dw  0

CURSOR_LOWER        dw  0d00h
CURSOR_LOWER_NAME   dw  0d00h

upper_limit db 11 
lower_limit db 24
separation_pos dw 0c00h

kill_me_upper db 0 
kill_me_lower db 13
 
;SEPARATION_LINE     db  '________________________________________$'
SEPARATION_LINE     db  '========================================$'

open_parenthesis db '($'
close_parenthesis db '):$'

;---------------------------------chat variables---------------------------------

;---width and len
widthG equ  playerheight
lenG   equ  playerwidth
widthB equ  2
lenB   equ  5 


fire_rate_delay equ 10
;-----temp memory
yGamerTop dw 0
yGamerBottom dw 0

yBulletTop dw 0
yBulletBottom dw 0
yLaserTop dw 0
yLaserBottom dw 0
lenBetweenGB dw 0 
lenBetweenGL dw 0 

end_game db 0


temp1 dw ?
temp2 dw ?
temp3 dw ?
temp4 dw ?


.code         
main proc far  


mov ax,@data
mov ds,ax


;--------------------------- set up serial stuff-------------------------
;Set Divisor Latch Access Bit
mov dx,3fbh 			; Line Control Register
mov al,10000000b		;Set Divisor Latch Access Bit
out dx,al				;Out it
;Set LSB byte of the Baud Rate Divisor Latch register.
mov dx,3f8h			
mov al,0ch			
out dx,al
;Set MSB byte of the Baud Rate Divisor Latch register.
mov dx,3f9h
mov al,00h
out dx,al
;Set port configuration
mov dx,3fbh
mov al,00011011b
out dx,al
;------------------------------------------------------------------------





;********video mode********
mov ax,13h
int 10h

;jmp far ptr game_loop

;*********intro message****************;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;intromenu intromessage				   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;MOV     CX, 1fH						   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;MOV     DX, 8253H					   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;MOV     AH, 86H						   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;INT     15H							   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;********clear screen******************;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   clear_screen





reset_cursor

;-------- get name -------------
    showmessage name_request_message
    mov ah, 0Ah ;SERVICE TO CAPTURE STRING FROM KEYBOARD.
    mov dx, offset player_name
    int 21h 

;---------------------------------
clear_screen
;----------- establish connection----------
mov al, '*' ;any body there signal
mov send_VALUE,al
call send_data_proc

showmessage connection_waiting_mes

no_signal_yet:



call receive_data_proc
mov al,'-' ; empty sign
cmp received_VALUE,al
jne data_received 
jmp no_signal_yet

data_received:
mov al, '*' 
cmp received_VALUE,al
jne not_any_body_mes
mov al, '&' 
mov send_VALUE,al 
call send_data_proc
call send_name

mov al, '-' 
mov send_VALUE,al
jmp connection_established

not_any_body_mes:
call receive_name
call send_name

jmp endisa

connection_established:
call receive_name

endisa:

clear_screen
;----------- establish connection----------
game_over:
call reset_game ; reset health bar & bullets 
clear_screen

;********main menu mode********
;clear_screen

;mainmenu mes,fitmess,secmess

mainmenu_loop :
;clear_screen

reset_cursor
;-------key pressed--------

mainmenu mes,fitmess,secmess

    mov ah,1
    int 16h
    
    jnz exist1
    jmp far ptr receive
    exist1:
    mov ah,0
    int 16h
    mov send_VALUE,al
    call send_data_proc 

    cmp al , 'p'
    je a_play_request
    cmp al , 'c'
    je a_chat_request

    jmp far ptr receive
    a_play_request:
 ;   call request_sent_proc
    req_sent_mac
    jmp Receive

    a_chat_request:
    chat_req_sent 
    


receive:

call receive_data_proc

mov al,received_VALUE
cmp al , '-'
jne not_empty1
jmp far ptr mainmenu_loop

not_empty1:
cmp al , 'p'
jne not_a_play_request1

req_rec_mac

not_a_play_request1:

cmp al , 'c'
jne not_a_chat_request1

chat_req_rec ;--------------------   TODO

not_a_chat_request1:



jmp mainmenu_loop


jmp mainmenu_loop

;********clear screen******************

clear_screen

;*******************

;*******************
;mov ax , 8h
;mov bx , 5010h              ;i forgot but one of this trio is v.v.i
;mov dx , 03h

;*******************

;drawrect 159 , 0 , 1 , 200 , 06h ;pitch division

push dx
mov dl,0  
mov left_player_fire_limit , dl
mov right_player_fire_limit , dl
pop dx 

mov cx,0

game_loop: ; yamany

drawsolidrect 0 , 0 , 158 , 3 , 0h ; don't touch
drawsolidrect 161 , 0 , 158 , 3 , 0h ; don't touch

check_for_win


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


;call a3del_elgamer

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
    
   
   
    
    call key_listener

    mov cx,0
    push dx 

    mov dl , left_player_fire_limit 
    inc dl
    mov left_player_fire_limit ,dl

    mov dl , right_player_fire_limit 
    inc dl
    mov right_player_fire_limit ,dl
    pop dx 

    call Collision
    ;skip2:
    ;    inc cx
    mov cl , 1
    cmp end_game , cl
    jne dont_end_game

    jmp far ptr game_over

    dont_end_game:

jmp game_loop

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
    
            push dx
            mov dl , 0 
            mov left_player_fire_limit,dl ; reset fire limit
            pop dx 

            pop si
            pop ax
            pop bx
    
            
            
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
    
    
            
            push bx 
            mov bl,0
            mov right_player_fire_limit,bl ; reset fire limit
            pop dx 
            
            pop di
            pop ax
            pop bx

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
	    jne eee
      jmp far ptr empty
      eee:
	    ;mov bx,offset player1bulletx
loopbullets1:            
        mov bx,offset player1bulletx
	    ;move player 1 bullets by one            
	    mov dx,[bx+di]
	    call drawBulletFrame_black1

      add dx,1
	    mov [bx+di],dx

            mov bx,offset player1bullety
           
            mov si,[bx+di]
            call drawBulletFrame
            cmp dx,310
            jb didnt_go_out
            
	     
          call drawBulletFrame_black1
	        deletebullet1 		
            sub di,2
	        didnt_go_out:       
	        
	        add di,2                    
            
            
            mov ax,player1bullets
            
            cmp di,ax
            jae eee2
            jmp far ptr loopbullets1
            eee2:
            
            empty:
            ;--------- draw player 2 bullets -------------
            
            mov di,0 ;counter for loop
            
            mov bx,offset player2bullets
            mov ax,player2bullets                       ;number of bullets
	    ;mov bx,offset player2bulletx
	    
            cmp ax,0
	    jne eee3 
      jmp far ptr empty2
      eee3:
	        mov di,0
loopbullets2:            
            mov bx,offset player2bulletx
            mov dx,[bx+di]

            call drawBulletFrame_black2
		
	    ;move player 2 bullets by one            
	    mov dx,[bx+di]
	    dec dx
	    mov [bx+di] , dx            
		
            mov bx,offset player2bullety	    
	    mov si,[bx+di]

            call drawBulletFrame
            cmp dx,0
            
            jbe eee4
            jmp far ptr didnt_go_out2
	          eee4:
            
            call drawBulletFrame_black2
	         ;deletebullet2 	
            add bx,di
            mov si,bx
            mov bx,offset player2bulletx
            add bx,di
            mov dx,bx
            deleteBulletsShoubra dx,si 
            ;deletebullet2
            sub di,2
            
            didnt_go_out2:       
            
            
            add di,2
            cmp di,ax
            jae eee5
            jmp far ptr loopbullets2 
            eee5:
            
	    empty2: 
          
            popall
            
            ret
drawbullets endp

;***************************
drawBulletFrame proc
drawrect dx,si,5,2,03h
        
ret
drawBulletFrame endp


drawBulletFrame_black1 proc
  push bx 
  push si
  mov bx,offset player1bullety         
  mov si,[bx+di]
  drawrect dx,si,5,2,0h
  pop si 
  pop bx
ret
drawBulletFrame_black1 endp


drawBulletFrame_black2 proc
  push bx
  push si 
  mov bx,offset player2bullety         
  mov si,[bx+di]
  drawrect dx,si,5,2,0h
  pop si
  pop bx
ret
drawBulletFrame_black2 endp

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
		      
	    mov dx,[bx+di]
	    
		
            mov bx,offset player2bullety	    
	    mov si,[bx+di]

            cmp dx,300
            jb didnt_go_out4
	          drawrect dx,si,5,2,0h
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
    
    jnz exist2
    
    jmp  receive2
    
    exist2:
    
    mov ah,0
    int 16h
    
    mov send_VALUE,ah
    call send_data_proc 
    jmp dont_reset_send
    
    receive2:
    
    mov [send_VALUE],'-'
    dont_reset_send:

    call receive_data_proc
    
    mov al,0
    cmp leftPlayer,al
    je i_am_right  ;i am the right player  
    
    mov al,send_VALUE
    mov right_player_action,al
    mov al,received_VALUE
    mov left_player_action,al
    jmp i_was_left

    i_am_right:
    mov al,received_VALUE
    mov right_player_action,al
    mov al,send_VALUE
    mov left_player_action,al

    i_was_left:

    ;-----------------------check player 2 movement--------------------
    mov al, left_player_action
    cmp al,48h
    je yes_player2
    cmp al,50h
    je yes_player2
    cmp al,4bh
    je yes_player2
    cmp al,4dh
    je yes_player2
    
    jmp no_player2
    yes_player2:
    movplayer2
    no_player2:
    ;-----------------------check player 1 movement--------------------
    mov ah, right_player_action
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
    cmp al,2Ch ;z scan code
    jne dontfire1
    
    mov dl, left_player_fire_limit
    cmp dl,fire_rate_delay          ;fire rate delay 
    jb dontfire1  ;
    
    call firebullet1
    ;skip:
    ;cmp cx,0fff0h
    ;jb skip2
    dontfire1:
    cmp ah,2Ch ;z scan code
    jne dontfire2
    
    mov bl,right_player_fire_limit
    cmp bl,fire_rate_delay          ;fire rate delay
    jb dontfire2  ;
        
    call firebullet2

    
    dontfire2:
    ;--------------------------check Laser------------------------

    cmp al, 'r'
    jne dontlaser1
    
    
    call laser1

    dontlaser1:
    cmp al, 'e'
    jne dontlaser2

    ;call laser2
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
    
     ;--------------------------ingame chat------------------------

    cmp al, 10h ; q char 
    jne dontchat
    call ingame_chat_stuff
    dontchat:

    cmp ah, 10h ; q char 
    jne dontchat1
    call ingame_chat_stuff
    dontchat1:

    ;--------------------------Exit game------------------------
    cmp al, 1h ; q char 
    jne dontexit
    call end_current_game
    dontexit:

    cmp ah, 1h ; q char 
    jne dontexit1
    call end_current_game
    dontexit1:


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
   jmp continue3    

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

    ;pushall

  mov bx,offset player1 
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
    pop si
    
    drawrect [di],[si],5,2,0h
    push ax
    mov ax ,4
    mov [di],ax
    mov ax ,4
    mov [si],ax
    pop ax 
    ;mov bx,player2bulletx
    ;sub di,bx
    ;deletebullet2
    ;call test 
    ;deleteBulletsShoubra di,si 
    ;i_hate_micro 

  ;mov cx,1
  ;mov bh,0
  ;mov ah,9
  ;mov al,44h
  ;mov bl,4
  ;int 10h
    
    
outt2:
   ;popall
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
;call drawrect_proc
cmp cx,[bx]
jb ssps
call drawrect_proc_x

mov [bx],cx
ssps:

mov cx,130    ;x right
cmp cx,[bx]
ja ssps2
call drawrect_proc_x
mov [bx],cx
ssps2:

mov bx,offset player1
add bx,2

mov cx,20    ;y top
cmp cx,[bx]
jb ssps3
call drawrect_proc_y
mov [bx],cx
ssps3:

mov cx,180    ;y bottom
cmp cx,[bx]
ja ssps4
call drawrect_proc_y
mov [bx],cx
ssps4:


;-------------------------player2-----------------------


mov bx,offset player2
mov cx,150    ;x left
cmp cx,[bx]
jb ssps5

call drawrect_proc_x
mov [bx],cx

ssps5:

mov cx,290    ;x right
cmp cx,[bx]
ja ssps6

call drawrect_proc_x
mov [bx],cx

ssps6:

mov bx,offset player2
add bx,2

mov cx,20    ;y top
cmp cx,[bx]
jb ssps7

call drawrect_proc_y
mov [bx],cx

ssps7:

mov cx,180    ;y bottom
cmp cx,[bx]
ja ssps8

call drawrect_proc_y
mov [bx],cx

ssps8:

popall
ret
a3del_elgamer endp

drawrect_proc_x proc

pushall
drawrect  [bx] , [bx+2] , 20 , playerheight , 0h
popall
ret

drawrect_proc_x endp

;**************************************

drawrect_proc_y proc

pushall
drawrect  [bx-2] , [bx] , 20 , playerheight , 0h
popall
ret
drawrect_proc_y endp

;**************************************

send_data_proc proc 
pushall



  		mov dx , 3FDH		; Line Status Register
AGAIN:  	
      In al , dx 			;Read Line Status
  		test al , 00100000b
  		JZ AGAIN                               ;Not empty
 
;If empty put the VALUE in Transmit data register
  		mov dx , 3F8H		; Transmit data register
  		mov  al,send_VALUE
  		out dx , al

;mov ah,2
;mov dl,send_VALUE
;int 21h

popall
ret 
send_data_proc endp

;**************************************

receive_data_proc proc

;Check that Data is Ready
		mov dx , 3FDH		; Line Status Register
	  	in al , dx 
  		test al , 1
  		JZ date_ready                                    ;Not Ready
 ;If Ready read the VALUE in Receive data register
  		mov dx , 03F8H
  		in al , dx 
  		mov received_VALUE , al
      ret

      date_ready:
      mov al , '-'
      mov received_VALUE , al


      ret 
receive_data_proc endp

;**************************************
;
;request_received_proc proc far
;
;request_received_loop:
;mov ah,1
;int 16h
;
;jnz exist2
;jmp request_received_loop
;exist2:
;
;mov ah,0
;int 16h
;mov send_VALUE, al
;call send_data_proc
;
;cmp al , 'y' ; request got accepted
;jne not_accepted1
;mov al, 1
;mov leftPlayer ,al
;jmp far ptr game_loop
;
;not_accepted1:
;jmp far ptr mainmenu_loop
;
;ret
;request_received_proc endp
;
;
;;***********************************
;
;request_sent_proc proc far
;
;request_sent_loop:
;call receive_data_proc
;mov al,received_VALUE
;
;cmp al , '-' ;'-' is empty receive value char
;je request_sent_loop
;
;cmp al , 'y' ; request got accepted
;jne not_accepted
;mov al, 0
;mov leftPlayer ,al
;jmp far ptr game_loop
;
;not_accepted:
;jmp far ptr mainmenu_loop
;
;request_sent_proc endp
;
;;***************************************
;
reset_game proc
mov bx,offset firsthealthbar
add bx,4
mov ax,35
mov [bx],ax

mov bx,offset secondhealthbar
add bx,4
mov ax,35
mov [bx],ax

mov bx,0
mov player1bullets,bx ;model small problem
mov player2bullets,bx

push bx
mov bl , 0 
mov end_game ,bl 
pop bx

ret
reset_game endp 

send_name proc
      mov bx , offset player_name_length
      keep_printing:
      mov cl, [bx]
		  mov dx , 3FDH		; Line Status Register
AGAIN2:  	In al , dx 			;Read Line Status
  		test al , 00100000b
  		JZ AGAIN2                               ;Not empty

;If empty put the VALUE in Transmit data register
  		mov dx , 3F8H		; Transmit data register
  		mov  al , cl
  		out dx , al

      mov ah,2
      mov dl,al
      int 21h
      
      cmp cl,'$'
      je done 
      
      inc bx 
      jmp keep_printing
      done :

ret
send_name endp


receive_name proc 

mov bx, offset other_name_length
keep_receiving:
call receive_data_proc
mov al ,received_VALUE
cmp al,'-'
je keep_receiving
mov [bx],al 
mov ah,2
mov dl,al
int 21h

inc bx 
cmp received_VALUE , '$'
jne keep_receiving


ret 
receive_name endp


;---------------------------------chat procedures ---------------------------

disp_separation PROC
   mov dx, separation_pos
   mov ah, 2
   int 10h
   mov ah, 9
   mov dx, offset SEPARATION_LINE
   int 21h

    ret 
disp_separation endp

send_char_proc PROC
 ;Check that Transmitter Holding Register is Empty
		            mov dx, 3FDH		;Line Status Register
CHECK_SEND:  	    In al, dx 			;Read Line Status
  		            AND al, 00100000b
  		            JZ CHECK_SEND

                  ;If empty put the send_char in Transmit data register
              		mov dx, 3F8H	;Transmit data register
              		mov al, send_char       ;send_char
              		out dx, al


ret 
send_char_proc endp 


disp_names PROC
      pushall
      ;------------------------------- first name -------------------------------
      ;set cursor
      mov dx, CURSOR_UPPER_NAME
      mov ah, 2
      int 10h
      
      mov ah,9h
      mov dx,offset open_parenthesis
      int 21h

      mov dx, CURSOR_UPPER_NAME
      add dx , 1
      mov ah, 2
      int 10h

      mov ah,9h
      mov dx,offset my_name
      int 21h

      mov dx, CURSOR_UPPER_NAME
      add dl , player_name_length
      add dx , 1
      mov ah, 2
      int 10h

      mov ah,9h
      mov dx,offset close_parenthesis
      int 21h
      ;------------------------------- second name -------------------------------
      ;set cursor
      mov dx, CURSOR_LOWER_NAME
      mov ah, 2
      int 10h
      
      mov ah,9h
      mov dx,offset open_parenthesis
      int 21h

      mov dx, CURSOR_LOWER_NAME
      add dx , 1
      mov ah, 2
      int 10h

      mov ah,9h
      mov dx,offset other_player_name
      int 21h

      
      mov dx, CURSOR_LOWER_NAME
      add dl, other_name_length
      add dx , 1
      mov ah, 2
      int 10h

      mov ah,9h
      mov dx,offset close_parenthesis
      int 21h

      popall
ret 
disp_names endp

main_chat_proc proc
                    mov ax , CURSOR_UPPER
                    add al , player_name_length
                    add al , 3
                    mov CURSOR_UPPER , ax

                    mov ax , CURSOR_LOWER
                    add al , other_name_length
                    add al ,3
                    mov CURSOR_LOWER , ax

                    ;Display SEPARATION_LINE
                    call disp_separation
                    call disp_names

chat_loop:
                    ;Check that Data Ready
                    mov dx, 3FDH		; Line Status Register
                    in al, dx 
                    AND al, 1
                    JZ KEY_INPUT

                    ;If Ready read the RECIEVE_char in Receive data register
                    mov dx, 03F8H
                    in al, dx 
                    mov RECIEVE_char, al


                    ;set cursor
                    mov dx, CURSOR_LOWER
                    mov ah, 2
                    int 10h




                    mov al , RECIEVE_char

                    cmp al, 08h
                    jne not_backspace2

                    mov ah, 2
                    mov dl, 08h 
                    int 21h

                    mov ah, 2
                    mov dl, 20h 
                    int 21h

                    ;mov ah, 2
                    ;mov dl, 08h 
                    ;int 21h

                    not_backspace2: 

                    cmp al, 27
                    jne not_escape2
                    
                    jmp exit_chat
                    not_escape2: 
                    



                    ;Display RECIEVE_char 
                    mov ah, 2
                    mov dl, RECIEVE_char 
                    int 21h

                    ;get cursor & save in memory
                    mov ah,3h 
                    mov bh,0h 
                    int 10h


                    cmp dh, lower_limit
                    jb no_scrol2
                    
                    mov ax , CURSOR_LOWER_NAME
                    
                    SCROL 0, kill_me_lower , 39, lower_limit
                    ;SCROL 0, 0dh, 39, 2
                  

                    no_scrol2:
                    mov CURSOR_LOWER, dx

KEY_INPUT:                   
                   
                    mov ah, 1 
                    int 16h
                    jz chat_loop

                    ;Consume char
                    mov ah, 0 
                    int 16h

                    cmp al, 0dh
                    jne not_enter
                    mov al, 0Ah

                    not_enter: 
                    
                    cmp al, 27
                    jne not_escape
                    mov send_char,al
                    call send_char_proc
                    jmp exit_chat
                    not_escape: 

                    cmp al, 08h
                    jne not_backspace
                    
                    mov ah, 2
                    mov dl, 08h 
                    int 21h

                    mov ah, 2
                    mov dl, 20h 
                    int 21h

                    mov ah, 2
                    mov dl, 08h 
                    int 21h

                    not_backspace: 


                    mov send_char, al
                   
                  call send_char_proc
                  ;set cursor
                    mov dx, CURSOR_UPPER
                    mov ah, 2
                    int 10h




                    ;Display send_char 
                    mov ah, 2
                    mov dl, send_char 
                    int 21h



                        


                    ;get cursor & save in memory
                    mov ah,3h 
                    mov bh,0h 
                    int 10h

                    cmp dh, upper_limit;---------------------------
                    jb no_scrol1

                    
                     
                    SCROL 0, kill_me_upper, 39, upper_limit
                    ;SCROL 0, 0, 39, 11

                    no_scrol1:
                    mov CURSOR_UPPER, dx
 
                    jmp chat_loop

                    exit_chat: 
ret
main_chat_proc endp
;---------------------------------chat procedures ---------------------------


chat_stuff proc

call set_main_chat

call main_chat_proc
clear_screen
ret
chat_stuff endp 
;--------------------------------
ingame_chat_stuff proc

pushall 

clear_screen
call set_ingame_var
reset_cursor
call main_chat_proc
clear_screen

popall
ret
ingame_chat_stuff endp 

;--------------------------------

set_ingame_var proc
pushall
mov ax , 1200h
mov CURSOR_UPPER   ,ax
mov CURSOR_UPPER_NAME,ax

mov ax, 1500h
mov CURSOR_LOWER  , ax
mov CURSOR_LOWER_NAME  , ax 

mov al , 20
mov upper_limit,al

mov al ,22
mov lower_limit ,al

mov ax , 1100h
mov separation_pos , ax

mov al , 18
mov kill_me_upper ,al 
mov al , 21
mov kill_me_lower, al 



popall
ret 
set_ingame_var endp

;---------------------

set_main_chat proc
pushall
mov ax , 0
mov CURSOR_UPPER       ,ax
mov CURSOR_UPPER_NAME  ,ax

mov ax , 0d00h
mov CURSOR_LOWER  , ax
mov CURSOR_LOWER_NAME  ,ax 

mov al , 11
mov upper_limit,al
mov al ,24
mov lower_limit ,al

mov ax , 0c00h
mov separation_pos , ax

mov al , 0 
mov kill_me_upper ,al 
mov al , 13
mov kill_me_lower, al 



popall
ret 
set_main_chat endp

;------------------------------------

end_current_game proc
push ax

mov al , 1
mov end_game,al

pop ax
ret
end_current_game endp 




end main
