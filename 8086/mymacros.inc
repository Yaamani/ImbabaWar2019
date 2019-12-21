;-----------------macros------
showmessage macro mymessage
            mov ah,9h
            mov dx,offset mymessage
            int 21h
endm showmessage              
;------------draw rect-----------
drawrect macro x,y,l,w,c		;drawRect ax , cx , bx , 20 , 02h ;1st prog bar health green
    local l1,l2
    push ax
    push bx
    push dx
    


    mov bx , x
    add bx , l
    mov al , c
    mov cx , x
    mov dx , y
    mov ah , 0ch
    
    l1: int 10h
        add dx , w
        int 10h
        sub dx , w
        inc cx
        cmp cx , bx
        jnz l1
    
    mov bx , y
    add bx , w
    
    l2: int 10h
        sub cx , l
        int 10h
        add cx , l
        inc dx
        cmp dx , bx
        jbe l2
	
	
        pop dx
        pop bx
        pop ax
endm    drawrect
;------------draw solid rect-----------
drawsolidrect macro x,y,l,w,c
    local l1,l2
    push ax
    push bx
    push dx
    push di	
    mov dx , y
    mov cx , x
    mov al , c
    mov bx , x
    add bx , l
    mov di , y
    add di , w
    l2: mov ah,0ch
	int 10h
        inc cx
        cmp cx , bx
        jbe l2
    l1: inc dx
        mov cx , x
        cmp dx , di
        jbe l2
    pop di
    pop dx
    pop bx
    pop ax
endm    drawsolidrect
;----------Intro menu--------------
intromenu macro mymessage
showmessage mymessage
mov ah,9          ;display
mov bh,0          ;page 0
mov al,32h        ;letter 2
mov cx,1h         ;1 times
mov bl,028h        ;green048 (9) on white(f) background
int 10h
MOV     CX, 1AH						   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
MOV     DX, 8253H					   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
MOV     AH, 86H						   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
INT     15H	 
mov ah,9          ;display
mov bh,0          ;page 0
mov al,30h        ;letter 0
mov cx,1h         ;1 times
mov bl,028h        ;red (0) on white(f) background
int 10h
MOV     CX, 1AH						   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
MOV     DX, 8253H					   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
MOV     AH, 86H						   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
INT     15H	
mov ah,9          ;display
mov bh,0          ;page 0
mov al,31h        ;letter p
mov cx,1h         ;1 times
mov bl,028h        ;green048 (9) on white(f) background
int 10h
MOV     CX, 1AH						   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
MOV     DX, 8253H					   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
MOV     AH, 86H						   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
INT     15H	 
mov ah,9          ;display
mov bh,0          ;page 0
mov al,39h        ;letter c
mov cx,1h         ;1 times
mov bl,028h        ;red (c) on white(f) background
int 10h
endm    intromenu               
;----------main menu--------------
mainmenu macro mymessage,fitmess,secmess

showmessage mymessage
showmessage fitmess
mov ah,9          ;display
mov bh,0          ;page 0
mov al,50h        ;letter p
mov cx,1h         ;1 times
mov bl,048h        ;green (p) on white(f) background
int 10h 
showmessage secmess
mov ah,9          ;display
mov bh,0          ;page 0
mov al,43h        ;letter c
mov cx,1h         ;1 times
mov bl,028h        ;red (c) on white(f) background
int 10h

endm    mainmenu
;---------draw prog bar----------
drawprogbar macro height, fg_c, bg_c
mov cx , 35
sub cx , [si+4]
mov ax , [si]
add ax , [si+4]
mov temp1 , ax
mov temp2 , cx
drawsolidrect [si] , [si+2] , [si+4] , height , fg_c
drawsolidrect temp1 , [si+2] , temp2 , height , bg_c
endm
;---------inc prog bar----------
incprogbar macro amount
local toend , tofull
push ax
push cx
mov cx , 35
mov ax , amount
add [si+4] , ax
cmp [si+4] , cx
jae tofull

;sub cx , [si+4]
;mov ax , [si]
;add ax , [si+4]
;mov temp1 , ax
;mov temp2 , cx

;pop cx
;pop ax
;drawsolidrect [si] , [si+2] , [si+4] , 20 , 02h
;drawsolidrect temp1 , [si+2] , temp2 , 20 , 04h
jmp toend
tofull:
;pop cx
;pop ax
mov [si+4] , cx
;drawsolidrect [si] , [si+2] , [si+4] , 20 , 02h 





toend:

pop cx
pop ax
endm    IncProgbar
;---------dec prog bar----------
decProgbar macro amount
local toend , dead
push ax
push cx
mov cx , 250
mov ax , amount
sub [si+4] , ax
cmp [si+4] , cx
jae dead

;mov cx, 35
;sub cx , [si+4]
;mov ax , [si]
;add ax , [si+4]
;mov temp1 , ax
;mov temp2 , cx

;drawsolidrect [si] , [si+2] , [si+4] , 20 , 02h
;drawsolidrect temp1 , [si+2] , temp2 , 20 , 04h
jmp toend
dead:
mov cx, 1
mov [si+4], cx
;drawsolidrect [si] , [si+2] , 35 , 20 , 04h 



toend:
pop cx
pop ax															
endm    decProgbar


;------------------------------


drawbullets2 MACRO
	    local loopbullets1,loopbullets2,empty,empty2,didnt_go_out
            ;--------- draw player 1 bullets -------------
            push ax
            push bx
            push dx
            push di
            push cx

            mov di,0 ;counter for loop
            
            mov bx,offset player1bullets
            mov ax,[bx]                   ;number of bullets
	    

	    cmp ax,0
	    je empty

	    mov bx,offset player1bulletx
loopbullets1:            
            mov bx,offset player1bulletx
	    ;move player 1 bullets by one            
	    mov dx,[bx+di]
	    add dx,1
	    mov [bx+di],dx

            mov bx,offset player1bullety
           
            mov si,[bx+di]
	    drawrect dx,si,5,2,03h
            cmp dx,150
            jb didnt_go_out
	     
	    deletebullet1 di		

	    didnt_go_out:
            add di,2
            cmp di,ax
            jne loopbullets1
            
            empty:
	    cmp ax,0
            je empty2
            ;--------- draw player 2 bullets -------------
            
            mov di,0 ;counter for loop
            
            mov bx,offset player2bullets
            mov ax,player2bullets                       ;number of bullets
	    mov bx,offset player2bulletx
	    
            cmp ax,0
	    je empty2
loopbullets2:            
            mov bx,offset player2bulletx
            mov dx,[bx+di]
		
	    ;move player 2 bullets by one            
	    mov dx,[bx+di]
	    sub dx,1
	    mov [bx+di] , dx            
		
            mov bx,offset player2bullety	    
	    mov si,[bx+di]

            drawrect dx,si,5,2,03h
            
            add di,2
            cmp di,ax
            jne loopbullets2 
            
	    empty2: 
          
            pop cx
            pop di
            pop dx
            pop bx
            pop ax
            

       endm


deletebullet1 MACRO 
push ax
push bx
push si 
;-------------------------swap x position----------------------
mov bx,offset player1bulletx

mov si,player1bullets
mov dx,[bx+si-2] ;get last bullet in the array
mov [bx+di],dx ;put the last bullet instead of the deleted one
;-------------------------swap y position----------------------
mov bx,offset player1bullety
mov dx,[bx+si-2] ;get last bullet in the array
mov [bx+di],dx ;put the last bullet instead of the deleted one
;-------------------------decrement bullet count-------------------------


mov si,player1bullets
sub si,2
mov bx,offset player1bullets
mov [bx],si


pop si
pop bx
pop ax

endm
;------------------------------------ delete bullet 2 ------------------------------------

deletebullet2 MACRO 
push ax
push bx
push si 
;-------------------------swap x position----------------------
mov bx,offset player2bulletx

mov si,player2bullets
mov dx,[bx+si-2] ;get last bullet in the array
mov [bx+di],dx ;put the last bullet instead of the deleted one
;-------------------------swap y position----------------------
mov bx,offset player2bullety
mov dx,[bx+si-2] ;get last bullet in the array
mov [bx+di],dx ;put the last bullet instead of the deleted one
;-------------------------decrement bullet count-------------------------


mov si,player2bullets
sub si,2
mov bx,offset player2bullets
mov [bx],si

pop si
pop bx
pop ax

endm

;---------------------------------------------

pushall macro

push ax
push bx
push cx
push dx
push di
push si


endm


popall macro

pop si
pop di
pop dx
pop cx
pop bx
pop ax

endm
;*****************************
Movplayer1	Macro
local toend , bridgetoend , bridgetoright , right , bridgetodown , down , UP , left , check
mov si , offset player2
        drawrect  [si] , [si+2] , 20 , playerheight , 0h
        push ax
        
        
        mov al, 2
        cmp secondlaser_on_delay, al
        jbe dontclear1laser_m

        prepareplayer2laserCoordinates
        drawsolidrect temp1, temp2, laserlength, laserthickness, 0h ;claer laser upon mvement
        ;drawsolidrect  [si] , [si+2] , laserlength , playerheight , 0h
		;mov ah,0
        ;int 16h

        dontclear1laser_m:
        pop ax

        push ax
        mov al, 2
        cmp secondbarrier_on_delay, al
        jbe dontclear1barrier_m

;pushall
clearplayer2barrier
;popall

dontclear1barrier_m:
        pop ax


		cmp ah , 48h
		jz UP
		cmp ah , 50h
		jz bridgetodown
		cmp ah , 4dh
		jz bridgetoright
		cmp ah , 4bh
		jnz bridgetoend
		left:mov bx , playerstep
		sub [si] , bx
		drawrect  [si] , [si+2] , 20 , playerheight , 05h
		jmp toend
		bridgetoend: jmp toend
		bridgetoright: jmp right
		bridgetodown: jmp down
		UP:mov bx , playerstep
        sub [si + 2] , bx
		drawrect  [si] , [si+2] , 20 , playerheight , 05h
		jmp toend
		down:mov bx , playerstep
		add [si + 2] , bx
		drawrect  [si] , [si+2] , 20 , playerheight , 05h
		jmp toend
		right:mov bx , playerstep
		add [si] , bx
		drawrect  [si] , [si+2] , 20 , playerheight , 05h
		toend:

endm Movplayer1
;-------------------------------------------------------------------
Movplayer2	Macro
local toend , bridgetoend , bridgetoright , right , bridgetodown , down , UP , left , check
mov si , offset player1
drawrect  [si] , [si+2] , 20 , playerheight , 0h ;clear player upon movement

        push ax
        mov al, 2
        cmp firstlaser_on_delay, al
        jbe dontclear2laser_m

        prepareplayer1laserCoordinates
        drawsolidrect  temp1, temp2, laserlength , laserthickness , 0h ;clear laser upon movement

dontclear2laser_m:
        pop ax

        push ax
        mov al, 2
        cmp firstbarrier_on_delay, al
        jbe dontclear2barrier_m

;pushall
clearplayer1barrier
;popall

dontclear2barrier_m:
        pop ax
		cmp al , 77h
		jz UP
		cmp al , 73h
		jz bridgetodown
		cmp al , 64h
		jz bridgetoright
		cmp al , 61h
		jnz bridgetoend
		left:mov bx , playerstep
		sub [si] , bx
		drawrect  [si] , [si+2] , 20 , playerheight , 05h
		jmp toend
		bridgetoend: jmp toend
		bridgetoright: jmp right
		bridgetodown: jmp down
		UP:mov bx , playerstep
		sub [si + 2] , bx
		drawrect  [si] , [si+2] , 20 , playerheight , 05h
		jmp toend
		down:mov bx , playerstep
		add [si + 2] , bx
		drawrect  [si] , [si+2] , 20 , playerheight , 05h
		jmp toend
		right:mov bx , playerstep
		add [si] , bx
		drawrect  [si] , [si+2] , 20 , playerheight , 05h
		toend:

endm Movplayer2

;*************************
clearplayer1barrier macro
    prepareplayer1barrierCoordinates
    drawsolidrect temp1, temp2, barrierwidth, barrierheight, 0h
endm clearplayer1barrier


;*************************
clearplayer2barrier macro
    prepareplayer2barrierCoordinates
    drawsolidrect temp1, temp2, barrierwidth, barrierheight, 0h
endm clearplayer1barrier


;*************************
deleteBulletsShoubra Macro Xbullet,Ybullet

	pushall
        mov bx,player2bullets
	mov di,offset player2bulletx
	
	mov ax , bx
	add ax,di
        mov di,Xbullet
	lllk:

		
	mov cx,[di+2]
	mov [di],cx
	add di,2
	cmp di,ax
	jnz lllk
	
mov bx,player2bullets
	mov di,offset player2bullety
	mov ax , bx
	add ax,di
	mov di,Ybullet	
	lllk2:

	
	mov cx,[di+2]
	mov [di],cx
	add di,2
	cmp di,ax
	jnz lllk2


;-------------------------decrement bullet count-------------------------


mov ax,player2bullets
sub ax,2
mov bx,offset player2bullets
mov [bx],ax
		
	popall
ENDM   deleteBulletsShoubra

;************************
prepareplayer1laserCoordinates macro
    mov si, offset player1
    push ax
    mov ax, [si]
    add ax, playerwidth
    mov temp1, ax
    ;laserYcoordinate = playerY + playerheight/2 - laserheight/2 = (playerheight-laserheight)/2 + playerY
    mov ax, playerheight
    sub ax, laserthickness
    mov bl, 2
    idiv bl
    mov ah, 0
    add al, [si+2] ;player y coordinate
    mov temp2, ax
    pop ax
ENDM

;************************
prepareplayer2laserCoordinates macro
    mov si, offset player2
    push ax
    mov ax, [si]
    sub ax, laserlength
    mov temp1, ax
    ;laserYcoordinate = playerY + playerheight/2 - laserheight/2 = (playerheight-laserheight)/2 + playerY
    mov ax, playerheight
    sub ax, laserthickness
    mov bl, 2
    idiv bl
    mov ah, 0
    add al, [si+2] ;player y coordinate
    mov temp2, ax
    pop ax
ENDM

;************************
prepareplayer1barrierCoordinates macro
        mov si, offset player1
        mov ax, [si] ;player x coordinate
        add ax, playerwidth
        mov temp1, ax
        ;barrierYcoordinate = playerY + playerheight/2 - barrierheight/2 = (playerheight-barrierheight)/2 + playerY
        mov ax, 0
        mov ax, playerheight
        sub ax, barrierheight
        mov bl, 2
        idiv bl
        mov ah, 0
        add al, [si+2] ;player y coordinate
        mov temp2, ax
ENDM

;************************
prepareplayer2barrierCoordinates macro
        mov si, offset player2
        mov ax, [si] ;player x coordinate
        sub ax, barrierwidth
        mov temp1, ax
        ;barrierYcoordinate = playerY + playerheight/2 - barrierheight/2 = (playerheight-barrierheight)/2 + playerY
        mov ax, 0
        mov ax, playerheight
        sub ax, barrierheight
        mov bl, 2
        idiv bl
        mov ah, 0
        add al, [si+2] ;player y coordinate
        mov temp2, ax
ENDM