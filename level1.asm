.model small
.stack 100h
.data

xx1 dw 0
xx2 dw 0
yy1 dw 0
yy2 dw 0
aa db 10
counterr db 0



a dw 0
screen word 0
up dw 0 
down dw 0
color db 0


gamename db     "ALIEN SHOOTER", '$'
startMsg1 db "PRESS ENTER TO PLAY",'$'
startMsg2 db "PRESS H FOR HELP",'$'
startMsg3 db "PRESS C FOR CREDITS",'$'
msg2 db "LEVEL ONE ",'$'
monster3x word 0
monster3y word 0
left dw 0
monster3state word 0
right dw 0
x1 dw 0
x2 dw 0
y1 dw 0
y2 dw 0
x db 0
y db 0
msg8 db "ENTER YOUR NAME:",'$'
counter db 0
buffer db 360 dup ("$")
buffer2 db 230 dup ("$")
username db 30 dup("$")
level db 0
readFileIns db 'marioInstructions.txt',0
readFileCredits db 'cred.txt',0
Aliens db "ALIEN SHOOTER GAME - COAL PROJECT",'$'
instructions db "- HOW TO PLAY -",'$'
fireballx word 0
firebally word 0
fireballstate word 0
.code

main proc

mov ax , @data
mov ds, ax

mov ah,0
mov al,13h
int 10h

call InstRead
	call readCreds

	mainLoop:

		cmp screen,0
		je screen0
		cmp screen,1
		je screen1
		cmp screen,2
		je screen2
		cmp screen,3
		je screen3
	
	jmp mainLoop
	
	screen0:
		call mainMenu
		jmp mainLoop
	
	screen1:
		call takeInput
		mov level,1
                call drawLevel1
                call level1
		
		mov ah,4ch
		int 21h

	screen2:
		call howToplay
		jmp mainLoop
	
	screen3:
		call creditScreen
		jmp mainLoop
main endp



mainMenu proc 
	
	call drawStartScreen
	lMain:
		mov ah,11h
		int 16h
		jz lMain
		mov ah,10h
		int 16h

		cmp ah,1Ch  ;ENTER PRESSED
		je enterPressed
		cmp ah,23h 	;H key pressed
		je hpressed
		cmp ah,2Eh	;C key Pressed
		je cPressed
		cmp ah,1Bh
		je escPressed
		jmp lMain

	enterPressed:
		mov screen,1
		ret
	
	hpressed:
		mov screen,2
		ret

	cPressed:
		mov screen,3
		ret
	
	escPressed:
		mov ah,4ch
		int 21h
ret
mainMenu endp

drawStartScreen proc uses ax bx cx
	
	;BACKGROUND BLUE
        mov left,0
        mov right,320   
        mov down, 200
        mov up,0
        mov color,10h;37h
        call drawRectangle
	call CROSS_BOMB
        call drawaliens

       mov dl, 14;col
			mov dh, 8;row
			mov bh,0
			mov ah,02h
			int 10h

		mov si,offset gamename
		mov cx,13
		strt:
			mov al, [si]
			mov bl,5h
			mov bh, 0
			mov ah, 0eh
			int 10h

			inc si
		loop strt

	;;PRESS ENTER TO GO
			mov dl, 10;col
			mov dh, 17;row
			mov bh,0
			mov ah,02h
			int 10h

		mov si,offset startMsg1
		mov cx,19
		strt1:
			mov al, [si]
			mov bl,3H
			mov bh, 0
			mov ah, 0eh
			int 10h

			inc si
		loop strt1

		mov dl, 12;col
			mov dh, 20;row
			mov bh,0
			mov ah,02h
			int 10h

		mov si,offset startMsg2
		mov cx,16
		strt2:
			mov al, [si]
			mov bl,3H
			mov bh, 0
			mov ah, 0eh
			int 10h

			inc si
		loop strt2

			
			mov dl, 10;col
			mov dh, 23;row
			mov bh,0
			mov ah,02h
			int 10h

		mov si,offset startMsg3
		mov cx,19
		strt3:
			mov al, [si]
			mov bl,3h
			mov bh, 0
			mov ah, 0eh
			int 10h

			inc si
		loop strt3



ret
drawStartScreen endp

DrawSquareBorder proc
	push bx
	push dx
	push cx
	
	mov bx, 0
	mov cx, 42
	mov dx, 42;112
	topLine:
		mov ah, 0Ch
		mov al, 13
		push bx
		mov bh, 0
		int 10h
		pop bx
		
		inc cx
		inc bx
		cmp bx, 555
		jb topLine

	mov bx, 0
	mov cx, 42
	mov dx, 430;366
	bottomLine:
		mov ah, 0Ch
		mov al, 13
		push bx
		mov bh, 0
		int 10h
		pop bx
		
		inc cx
		inc bx
		cmp bx, 555
		jb bottomLine	
	
	mov bx, 0
	mov cx, 597
	mov dx, 42;112
	rightLine:
		mov ah, 0Ch
		mov al, 13
		push bx
		mov bh, 0
		int 10h
		pop bx
		
		inc dx
		inc bx
		cmp bx, 389;255
		jb rightLine	
		
	mov bx, 0
	mov cx, 42
	mov dx, 42;112
	leftLine:
		mov ah, 0Ch
		mov al, 13
		push bx
		mov bh, 0
		int 10h
		pop bx
		
		inc dx
		inc bx
		cmp bx, 389;255
		jb leftLine	
		
	pop cx
	pop dx
	pop bx
	ret
DrawSquareBorder endp

CROSS_BOMB proc 

mov counter, 15
add x1,7
add y1,7
mov cx, x1;197
mov dx, y1;107
line2:
	mov ah,0ch
	mov al,1100b
	mov bx,0
	inc cx
	inc dx
	int 10h
	dec counter
	cmp counter,0
	jne line2
	
mov counter, 15
add x1,2
sub y1,1
mov cx, x1;199
mov dx, y1;106
linee2:
	mov ah,0ch
	mov al,1100b
	mov bx,0
	inc cx
	inc dx
	int 10h
	dec counter
	cmp counter,0
	jne linee2

mov counter, 15
add x1,15
add y1,1
mov cx, x1;214
mov dx, y1;107
line3:
	mov ah,0ch
	mov al,1100b
	mov bx,0
	dec cx
	inc dx
	int 10h
	dec counter
	cmp counter,0
	jne line3
	
mov counter, 15
sub x1,2
sub y1,1
mov cx, x1;212
mov dx, y1;106
linee3:
	mov ah,0ch
	mov al,1100b
	mov bx,0
	dec cx
	inc dx
	int 10h
	dec counter
	cmp counter,0
	jne linee3
ret
CROSS_BOMB endp

drawRectangle proc uses cx dx  
	mov cx,down
	l1:
		mov dx,cx
		push cx
		mov cx,right
		loop2:
			mov ah,0ch
			mov AL, color
			int 10h
			cmp cx,left
			je exit
		loop loop2
		exit:
		pop cx
		cmp cx,up
		je exit2
		sub dx,1
	loop l1
	exit2:
ret 
drawRectangle endp

drawaliens proc 
	
	;DRAW OUTLINE
		mov left,91
        mov right,200
        mov down, 300
        mov up,15
        mov color,10h
        call CROSS_BOMB

		mov left,800
        mov right,600
        mov down, 2000
        mov up,17
        mov color,11h
        call CROSS_BOMB

	
ret
drawaliens endp

takeInput proc
	mov left,0
	mov right,320   
	mov down, 201
	mov up,0
	mov color,10h
	call drawRectangle

	mov dl, 11;col
	mov dh, 5;row
	mov bh,0
	mov ah,02h
	int 10h

	mov si,offset msg8
	mov cx,16
	msg2L:
		mov al, [si]
		mov bl,2h
		mov bh, 0
		mov ah, 0eh
		int 10h

		inc si
		
	loop msg2L

	mov dl, 14;col
	mov dh, 9;row
	mov bh,0
	mov ah,02h
	int 10h

	
	
	mov dx,offset username
	mov ah,0ah
	int 21h

	


ret
takeInput endp

InstRead proc uses ax bx cx dx
	mov dx, offset readFileIns
	mov al, 0
	mov ah, 3dh
	int 21h

	mov bx, ax

	mov dx, offset buffer
	mov ah, 3fh
	mov cx, 360
	int 21h

	;mov dx, offset buffer
	;mov ah, 09h
	;int 21h

	mov ah, 3eh
	int 21h

ret
InstRead endp

howToplay proc
	
	call drawInstructionScreen
	lHtp:
		mov ah,11h
		int 16h
		jz lHtp
		mov ah,10h
		int 16h

		cmp ah,1Ch  ;ENTER PRESSED
		je enterPressed2
		cmp ah,30h 	;B key pressed
		je bpressed
		cmp ah,1Bh
		je escPressed2
		jmp lHtp

	enterPressed2:
		mov screen,1
		ret
	
	bpressed:
		mov screen,0
		ret

	escPressed2:
		mov ah,4ch
		int 21h


ret
howToplay endp

creditScreen proc
	call drawCredistsScreen

	Lcs:
		mov ah,11h
		int 16h
		jz lcs
		mov ah,10h
		int 16h
		
		cmp ah,30h 	;B Key Pressed
		je bpressed2
		cmp ah,1Bh
		je escPressed3
		jmp lcs

	bpressed2:
		mov screen,0
		ret
	
	escPressed3:
		mov ah,4ch
		int 21h


ret
creditScreen endp

drawInstructionScreen proc uses ax bx cx

	mov left,0
        mov right,320   
        mov down, 201
        mov up,0
        mov color,10h
        call drawRectangle

		mov dl, 6;col
		mov dh, 1;row
		mov bh,0
		mov ah,02h
		int 10h

		mov si,offset aliens
		mov cx,26
		loopSuper:
			mov al, [si]
			mov bl,3h
			mov bh, 0
			mov ah, 0eh
			int 10h

			inc si
		loop loopSuper

		
		mov dl, 11;col
		mov dh, 4;row
		mov bh,0
		mov ah,02h
		int 10h

		mov si,offset instructions
		mov cx,15
		loopIns:
			mov al, [si]
			mov bl,4h
			mov bh, 0
			mov ah, 0eh
			int 10h

			inc si
		loop loopIns



		mov dl, 1;col
		mov dh, 9;row
		mov bh,0
		mov ah,02h
		int 10h

		mov si,offset buffer
		mov cx,360
		loopBuffer:
			mov al, [si]
			cmp al,'$'
			je endLoopB
			mov bl,1fh
			mov bh, 0
			mov ah, 0eh
			int 10h

			inc si
		loop loopBuffer
		endLoopB:
		mov dl, 0;col
		mov dh, 23;row
		mov bh,0
		mov ah,02h
		int 10h

ret
drawInstructionScreen endp

drawCredistsScreen proc uses ax bx cx
		

		mov left,0
        mov right,320   
        mov down, 201
        mov up,0
        mov color,10h
        call drawRectangle


		mov dl, 7;col
		mov dh, 1;row
		mov bh,0
		mov ah,02h
		int 10h

		mov si,offset aliens
		mov cx,26
		loopSuper2:
			mov al, [si]
			mov bl,8h
			mov bh, 0
			mov ah, 0eh
			int 10h

			inc si
		loop loopSuper2


		mov dl, 12;col
		mov dh, 7;row
		mov bh,0
		mov ah,02h
		int 10h

		mov si,offset buffer2
		mov cx,230
		loopCre:
			mov al, [si]
			cmp al,'$'
			je endloopc
			mov bl,3h
			mov bh, 0
			mov ah, 0eh
			int 10h

			inc si
		loop loopCre
	endLoopc:

ret
drawCredistsScreen endp

readCreds proc uses	ax bx cx dx

	mov dx, offset readFileCredits
	mov al, 0
	mov ah, 3dh
	int 21h

	mov bx, ax

	mov dx, offset buffer2
	mov ah, 3fh
	mov cx, 230
	int 21h

	mov ah, 3eh
	int 21h

ret
readCreds endp

drawLevel1 proc
	mov left,0
        mov right,320   
        mov down, 201
        mov up,0
        mov color,7h
        call drawRectangle

		mov dl, 12;col
		mov dh, 9;row
		mov bh,0
		mov ah,02h
		int 10h

		mov si,offset msg2 
		mov cx,10
		msg2L:
			mov al, [si]
			mov bl,04h
			mov bh, 0
			mov ah, 0eh
			int 10h

			inc si
			call delay
			call delay
			call delay
		loop msg2L

		call delay
		call delay
		call delay

ret
drawLevel1 endp

delay proc

	push ax
	push bx
	push cx
	push dx

	mov cx,100
	mydelay:
	mov bx,400      ;; increase this number if you want to add more delay, and decrease this number if you want to reduce delay.
	mydelay1:
	dec bx
	jnz mydelay1
	loop mydelay


	pop dx
	pop cx
	pop bx
	pop ax
ret

delay endp

;//////////////////////////////////////

drawSpaceship proc uses cx dx

;mov ah,00h
mov al,13
int 10h
;mov ax , 02h ;for 640 x 480 resolution
;int 10h ; interupt

mov ah,0ch ; pixel

mov dx, 185
add a,142
mov cx,a

l1:
cmp dx , 165
je exit1
mov al,0bh ; color
mov bh,0; page


int 10h
sub dx,1
add cx,1
;add a,1
loop l1

exit1:

;////////////
mov dx, 185
add a, 16       ;158
mov cx,a
l2:
cmp dx , 165
je exit2
mov al,0bh ; color
mov bh,0; page



int 10h
sub dx,1
add cx,1
;add a,1
loop l2

exit2:

mov dx,165
sub a, 16           ;142
mov cx,a

l3:
cmp dx,157
je exit3
mov al, 0bh
mov bh, 0
int 10h
add cx,2
add a,1
sub dx,1
loop l3


exit3:

mov al,0bh
mov bh,0
mov dx, 158
;mov cx,150
mov a, cx
int 10h


;////////////




;;///////////

mov dx, 159
add a,1		;150  -> 151
mov cx,a         
l4:
cmp dx, 166
je exit4
mov al,0bh
mov bh,0
int 10h
add cx,2
add a,1
inc dx
loop l4

exit4:

mov dx, 175
sub a, 16; a= 142
mov cx,a                
l5:
cmp dx, 195
je exit5
mov al, 0bh
mov bh,0
int 10h
add dx, 1
;sub cx,1
sub a,1
loop l5

exit5:

mov dx, 176
add a,36 ;a=158

mov cx,a     ; 159


l6:
cmp dx, 195
je exit6

mov al, 0bh
mov bh,0
int 10h
add dx,1
add cx,2
loop l6

exit6:

mov ah,0ch ; pixel
mov dx, 187
;a=177
sub a,13
mov cx,a

l7:
cmp dx , 191
je exit7
mov al,06h ; color
mov bh,0; page
add cx,1


int 10h
add dx,1
loop l7

exit7:

mov ah,0ch ; pixel
mov dx, 187
;a=164
add a,8
mov cx,a

l8:
cmp dx , 191
je exit8
mov al,06h ; color
mov bh,0; page
;mov cx, 154
add cx,1

int 10h
add dx,1
loop l8

exit8:

mov ah,0ch ; pixel
mov dx, 187
sub a,4
mov cx,a
l9:
cmp dx , 195
je exit9
mov al,06h ; color
mov bh,0; page
;mov cx, 150
add cx,1


int 10h
add dx,1
loop l9

exit9:



ret 
drawSpaceship endp

;/////////////////////////////////////

keypressed proc uses ax
	
	
	startt:
	mov ah, 11h
	int 16h
	
	
	cmp ah, 4dh
	je rightarrow
	cmp ah, 4bh
	je leftarrow
	cmp ah,1bh
	je esckey

	rightarrow:
			add a, 200
			jmp startt
			
	leftarrow:
			sub a,200
			jmp startt
	esckey:
			mov ah,4ch
			int 21h

ret
keypressed endp

level1 proc uses cx

mov cx , 1000
mov monster3x,60
mov monster3y,70
mov monster3state,1
mov fireballx,240		
mov firebally,170		


      call   drawScreen1
      call delay
	call drawSpaceship
             call  drawFireball 
            call movefireball 
    
        call drawmonster3 
	call movefireball
	call enemy
	call keypressed


	
	
	

	

;;;;;;;;; Keyboard



ret 
level1 endp





drawScreen1 proc uses cx dx
	

	mov left,0
        mov right,320   
        mov down, 201
        mov up,0
        mov color,7h
        call drawRectangle

	mov dl, 1;col
	mov dh, 1;row
	mov bh,0
	mov ah,02h
	int 10h

	mov si,offset msg2
	mov cx,15
	msg6L:
		mov al, [si]
		mov bl,1fh
		mov bh, 0
		mov ah, 0eh
		int 10h

		inc si
	loop msg6L

	mov dl, 11;col
	mov dh, 1;row
	mov bh,0
	mov ah,02h
	int 10h

	mov si,offset username
	add si,2
	mov cx,12
	msg6L1:
		mov al, [si]
		cmp al,'$'
		je emsg6l
		mov bl,1fh
		mov bh, 0
		mov ah, 0eh
		int 10h

		inc si
	loop msg6L1
	emsg6l:

ret
drawScreen1 endp

;////////////////////////////// moving the spaceship


drawmonster3 proc
	
	;BOWSER FEET BASE
		mov cx,monster3x
		mov left,cx
		;add left
		mov right,cx
		add right, 11
		mov cx,monster3y  
		mov down, cx
		sub down,0
		mov up,cx
		sub up,3
		mov color,42h
		call drawRectangle
	
		mov cx,monster3x
		mov left,cx
		sub left,3
		mov right,cx
		add right, 11
		mov cx,monster3y  
		mov down, cx
		sub down,3
		mov up,cx
		sub up,6
		mov color,42h
		call drawRectangle

		
	
	;BOWSER FEET BASE EXTENDED
		mov cx,monster3x
		mov left,cx
		;add left
		mov right,cx
		add right, 13
		mov cx,monster3y  
		mov down, cx
		sub down,0
		mov up,cx
		sub up,1
		mov color,42h
		call drawRectangle

	;RIGHT NAIL
		mov cx,monster3x
		mov left,cx
		add left,3
		mov right,cx
		add right, 6
		mov cx,monster3y  
		mov down, cx
		sub down,0
		mov up,cx
		sub up,1
		mov color,1Fh
		call drawRectangle

		mov cx,monster3x
		mov left,cx
		add left,4
		mov right,cx
		add right, 6
		mov cx,monster3y  
		mov down, cx
		sub down,1
		mov up,cx
		sub up,2
		mov color,1Fh
		call drawRectangle
	
	;LEFT NAIL
		mov cx,monster3x
		mov left,cx
		sub left,2
		mov right,cx
		add right, 1
		mov cx,monster3y  
		mov down, cx
		sub down,0
		mov up,cx
		sub up,1
		mov color,1Fh
		call drawRectangle

		mov cx,monster3x
		mov left,cx
		sub left,1
		mov right,cx
		add right, 1
		mov cx,monster3y  
		mov down, cx
		sub down,1
		mov up,cx
		sub up,2
		mov color,1Fh
		call drawRectangle
	
	;LEFT NAIL
		mov cx,monster3x
		mov left,cx
		sub left,6
		mov right,cx
		sub right, 3
		mov cx,monster3y  
		mov down, cx
		sub down,2
		mov up,cx
		sub up,3
		mov color,1Fh
		call drawRectangle

		mov cx,monster3x
		mov left,cx
		sub left,5
		mov right,cx
		sub right, 3
		mov cx,monster3y  
		mov down, cx
		sub down,2
		mov up,cx
		sub up,4
		mov color,1Fh
		call drawRectangle
	
	
	
	;GREEEN BASE
		mov cx,monster3x
		mov left,cx
		sub left,2
		mov right,cx
		add right, 13
		mov cx,monster3y  
		mov down, cx
		sub down,5
		mov up,cx
		sub up,13
		mov color,02h
		call drawRectangle

		mov cx,monster3x
		mov left,cx
		sub left,3
		mov right,cx
		add right, 12
		mov cx,monster3y  
		mov down, cx
		sub down,6
		mov up,cx
		sub up,19
		mov color,02h
		call drawRectangle

		mov cx,monster3x
		mov left,cx
		sub left,4
		mov right,cx
		sub right, 3
		mov cx,monster3y  
		mov down, cx
		sub down,6
		mov up,cx
		sub up,7
		mov color,02h
		call drawRectangle

		mov cx,monster3x
		mov left,cx
		sub left,5
		mov right,cx
		add right, 12
		mov cx,monster3y  
		mov down, cx
		sub down,7
		mov up,cx
		sub up,12
		mov color,02h
		call drawRectangle

		mov cx,monster3x
		mov left,cx
		sub left,5
		mov right,cx
		add right, 12
		mov cx,monster3y  
		mov down, cx
		sub down,7
		mov up,cx
		sub up,12
		mov color,02h
		call drawRectangle

		mov cx,monster3x
		mov left,cx
		sub left,6
		mov right,cx
		add right, 11
		mov cx,monster3y  
		mov down, cx
		sub down,20
		mov up,cx
		sub up,22
		mov color,02h
		call drawRectangle

		mov cx,monster3x
		mov left,cx
		sub left,9
		mov right,cx
		add right, 10
		mov cx,monster3y  
		mov down, cx
		sub down,22
		mov up,cx
		sub up,26
		mov color,02h
		call drawRectangle

		mov cx,monster3x
		mov left,cx
		sub left,12
		mov right,cx
		add right, 8
		mov cx,monster3y  
		mov down, cx
		sub down,26
		mov up,cx
		sub up,28
		mov color,02h
		call drawRectangle

		mov cx,monster3x
		mov left,cx
		sub left,13
		mov right,cx
		add right, 4
		mov cx,monster3y  
		mov down, cx
		sub down,28
		mov up,cx
		sub up,30
		mov color,02h
		call drawRectangle

		mov cx,monster3x
		mov left,cx
		sub left,16
		mov right,cx
		sub right,5
		mov cx,monster3y  
		mov down, cx
		sub down,30
		mov up,cx
		sub up,32
		mov color,02h
		call drawRectangle

		mov cx,monster3x
		mov left,cx
		sub left,10
		mov right,cx
		sub right,6
		mov cx,monster3y  
		mov down, cx
		sub down,32
		mov up,cx
		sub up,37
		mov color,02h
		call drawRectangle

		mov cx,monster3x
		mov left,cx
		sub left,11
		mov right,cx
		sub right,6
		mov cx,monster3y  
		mov down, cx
		sub down,35
		mov up,cx
		sub up,36
		mov color,02h
		call drawRectangle

		mov cx,monster3x
		mov left,cx
		sub left,13
		mov right,cx
		sub right,6
		mov cx,monster3y  
		mov down, cx
		sub down,28
		mov up,cx
		sub up,35
		mov color,02h
		call drawRectangle

		mov cx,monster3x
		mov left,cx
		sub left,7
		mov right,cx
		sub right,4
		mov cx,monster3y  
		mov down, cx
		sub down,22
		mov up,cx
		sub up,23
		mov color,42h
		call drawRectangle




	;TURTLE SHELL
		mov cx,monster3x
		mov left,cx
		add left,9
		mov right,cx
		add right, 14
		mov cx,monster3y  
		mov down, cx
		sub down,3
		mov up,cx
		sub up,5
		mov color,1fh
		call drawRectangle

		mov cx,monster3x
		mov left,cx
		add left,7
		mov right,cx
		add right, 9
		mov cx,monster3y  
		mov down, cx
		sub down,5
		mov up,cx
		sub up,7
		mov color,1fh
		call drawRectangle

		mov cx,monster3x
		mov left,cx
		add left,5
		mov right,cx
		add right, 7
		mov cx,monster3y  
		mov down, cx
		sub down,7
		mov up,cx
		sub up,9
		mov color,1fh
		call drawRectangle

		mov cx,monster3x
		mov left,cx
		add left,4
		mov right,cx
		add right, 5
		mov cx,monster3y  
		mov down, cx
		sub down,9
		mov up,cx
		sub up,11
		mov color,1fh
		call drawRectangle

		mov cx,monster3x
		mov left,cx
		add left,3
		mov right,cx
		add right, 4
		mov cx,monster3y  
		mov down, cx
		sub down,9
		mov up,cx
		sub up,11
		mov color,1fh
		call drawRectangle

		mov cx,monster3x
		mov left,cx
		add left,3
		mov right,cx
		add right, 4
		mov cx,monster3y  
		mov down, cx
		sub down,11
		mov up,cx
		sub up,16
		mov color,1fh
		call drawRectangle

		mov cx,monster3x
		mov left,cx
		add left,2
		mov right,cx
		add right, 3
		mov cx,monster3y  
		mov down, cx
		sub down,13
		mov up,cx
		sub up,19
		mov color,1fh
		call drawRectangle

		mov cx,monster3x
		mov left,cx
		add left,1
		mov right,cx
		add right, 2
		mov cx,monster3y  
		mov down, cx
		sub down,19
		mov up,cx
		sub up,21
		mov color,1fh
		call drawRectangle

		mov cx,monster3x
		mov left,cx
		;add left,1
		mov right,cx
		add right, 1
		mov cx,monster3y  
		mov down, cx
		sub down,21
		mov up,cx
		sub up,23
		mov color,1fh
		call drawRectangle

		mov cx,monster3x
		mov left,cx
		sub left,5
		mov right,cx
		; right, 2
		mov cx,monster3y  
		mov down, cx
		sub down,22
		mov up,cx
		sub up,23
		mov color,1fh
		call drawRectangle

		mov cx,monster3x
		mov left,cx
		sub left,8
		mov right,cx
		sub right, 5
		mov cx,monster3y  
		mov down, cx
		sub down,23
		mov up,cx
		sub up,25
		mov color,1fh
		call drawRectangle

		mov cx,monster3x
		mov left,cx
		sub left,7
		mov right,cx
		sub right, 4
		mov cx,monster3y  
		mov down, cx
		sub down,25
		mov up,cx
		sub up,26
		mov color,1fh
		call drawRectangle

		mov cx,monster3x
		mov left,cx
		sub left,6
		mov right,cx
		sub right, 3
		mov cx,monster3y  
		mov down, cx
		sub down,26
		mov up,cx
		sub up,27
		mov color,1fh
		call drawRectangle

		mov cx,monster3x
		mov left,cx
		sub left,5
		mov right,cx
		sub right, 3
		mov cx,monster3y  
		mov down, cx
		sub down,27
		mov up,cx
		sub up,30
		mov color,1fh
		call drawRectangle

	;HANDS
		mov cx,monster3x
		mov left,cx
		sub left,10
		mov right,cx
		sub right,5
		mov cx,monster3y  
		mov down, cx
		sub down,11
		mov up,cx
		sub up,14
		mov color,42h
		call drawRectangle

		mov cx,monster3x
		mov left,cx
		sub left,5
		mov right,cx
		sub right,4
		mov cx,monster3y  
		mov down, cx
		sub down,13
		mov up,cx
		sub up,14
		mov color,1Fh
		call drawRectangle

		mov cx,monster3x
		mov left,cx
		sub left,9
		mov right,cx
		sub right,7
		mov cx,monster3y  
		mov down, cx
		sub down,10
		mov up,cx
		sub up,16
		mov color,42h
		call drawRectangle

		mov cx,monster3x
		mov left,cx
		sub left,14
		mov right,cx
		sub right,11
		mov cx,monster3y  
		mov down, cx
		sub down,16
		mov up,cx
		sub up,17
		mov color,42h
		call drawRectangle

		mov cx,monster3x
		mov left,cx
		sub left,15
		mov right,cx
		sub right,13
		mov cx,monster3y  
		mov down, cx
		sub down,14
		mov up,cx
		sub up,16
		mov color,42h
		call drawRectangle

		mov cx,monster3x
		mov left,cx
		sub left,15
		mov right,cx
		sub right,13
		mov cx,monster3y  
		mov down, cx
		sub down,12
		mov up,cx
		sub up,14
		mov color,42h
		call drawRectangle

		mov cx,monster3x
		mov left,cx
		sub left,14
		mov right,cx
		sub right,13
		mov cx,monster3y  
		mov down, cx
		sub down,10
		mov up,cx
		sub up,11
		mov color,1fh
		call drawRectangle

		mov cx,monster3x
		mov left,cx
		sub left,14
		mov right,cx
		sub right,13
		mov cx,monster3y  
		mov down, cx
		sub down,13
		mov up,cx
		sub up,14
		mov color,1fh
		call drawRectangle

		mov cx,monster3x
		mov left,cx
		sub left,12
		mov right,cx
		sub right,11
		mov cx,monster3y  
		mov down, cx
		sub down,15
		mov up,cx
		sub up,16
		mov color,1fh
		call drawRectangle

		mov cx,monster3x
		mov left,cx
		sub left,10
		mov right,cx
		sub right,9
		mov cx,monster3y  
		mov down, cx
		sub down,10
		mov up,cx
		sub up,11
		mov color,1Fh
		call drawRectangle
	
	;face
		;green
			mov cx,monster3x
			mov left,cx
			sub left,18
			mov right,cx
			sub right,12
			mov cx,monster3y  
			mov down, cx
			sub down,30
			mov up,cx
			sub up,33
			mov color,02h
			call drawRectangle

			mov cx,monster3x
			mov left,cx
			sub left,16
			mov right,cx
			sub right,12
			mov cx,monster3y  
			mov down, cx
			sub down,33
			mov up,cx
			sub up,35
			mov color,02h
			call drawRectangle

			mov cx,monster3x
			mov left,cx
			sub left,15
			mov right,cx
			sub right,10
			mov cx,monster3y  
			mov down, cx
			sub down,35
			mov up,cx
			sub up,36
			mov color,02h
			call drawRectangle

			mov cx,monster3x
			mov left,cx
			sub left,14
			mov right,cx
			sub right,7
			mov cx,monster3y  
			mov down, cx
			sub down,36
			mov up,cx
			sub up,37
			mov color,02h
			call drawRectangle

			mov cx,monster3x
			mov left,cx
			sub left,12
			mov right,cx
			sub right,7
			mov cx,monster3y  
			mov down, cx
			sub down,37
			mov up,cx
			sub up,38
			mov color,02h
			call drawRectangle

			mov cx,monster3x
			mov left,cx
			sub left,11
			mov right,cx
			sub right,7
			mov cx,monster3y  
			mov down, cx
			sub down,38
			mov up,cx
			sub up,39
			mov color,02h
			call drawRectangle			
		;SKIN
			mov cx,monster3x
			mov left,cx
			sub left,14
			mov right,cx
			sub right,12
			mov cx,monster3y  
			mov down, cx
			sub down,23
			mov up,cx
			sub up,25
			mov color,42h
			call drawRectangle

			mov cx,monster3x
			mov left,cx
			sub left,13
			mov right,cx
			sub right,12
			mov cx,monster3y  
			mov down, cx
			sub down,24
			mov up,cx
			sub up,27
			mov color,42h
			call drawRectangle

			mov cx,monster3x
			mov left,cx
			sub left,11
			mov right,cx
			sub right,11
			mov cx,monster3y  
			mov down, cx
			sub down,24
			mov up,cx
			sub up,29
			mov color,42h
			call drawRectangle

			mov cx,monster3x
			mov left,cx
			sub left,10
			mov right,cx
			sub right,10
			mov cx,monster3y  
			mov down, cx
			sub down,28
			mov up,cx
			sub up,32
			mov color,42h
			call drawRectangle

			mov cx,monster3x
			mov left,cx
			sub left,13
			mov right,cx
			sub right,10
			mov cx,monster3y  
			mov down, cx
			sub down,32
			mov up,cx
			sub up,32
			mov color,42h
			call drawRectangle

			mov cx,monster3x
			mov left,cx
			sub left,15
			mov right,cx
			sub right,13
			mov cx,monster3y  
			mov down, cx
			sub down,31
			mov up,cx
			sub up,31
			mov color,42h
			call drawRectangle

			mov cx,monster3x
			mov left,cx
			sub left,15
			mov right,cx
			sub right,13
			mov cx,monster3y  
			mov down, cx
			sub down,31
			mov up,cx
			sub up,31
			mov color,42h
			call drawRectangle		

			mov cx,monster3x
			mov left,cx
			sub left,18
			mov right,cx
			sub right,15
			mov cx,monster3y  
			mov down, cx
			sub down,30
			mov up,cx
			sub up,30
			mov color,42h
			call drawRectangle

			mov cx,monster3x
			mov left,cx
			sub left,21
			mov right,cx
			sub right,18
			mov cx,monster3y  
			mov down, cx
			sub down,31
			mov up,cx
			sub up,32
			mov color,42h
			call drawRectangle

			mov cx,monster3x
			mov left,cx
			sub left,21
			mov right,cx
			sub right,19
			mov cx,monster3y  
			mov down, cx
			sub down,32
			mov up,cx
			sub up,33
			mov color,42h
			call drawRectangle

			mov cx,monster3x
			mov left,cx
			sub left,21
			mov right,cx
			sub right,21
			mov cx,monster3y  
			mov down, cx
			sub down,33
			mov up,cx
			sub up,34
			mov color,42h
			call drawRectangle	

			mov cx,monster3x
			mov left,cx
			sub left,19
			mov right,cx
			sub right,19
			mov cx,monster3y  
			mov down, cx
			sub down,33
			mov up,cx
			sub up,34
			mov color,42h
			call drawRectangle

			mov cx,monster3x
			mov left,cx
			sub left,20
			mov right,cx
			sub right,20
			mov cx,monster3y  
			mov down, cx
			sub down,35
			mov up,cx
			sub up,35
			mov color,42h
			call drawRectangle	

			mov cx,monster3x
			mov left,cx
			sub left,12
			mov right,cx
			sub right,11
			mov cx,monster3y  
			mov down, cx
			sub down,33
			mov up,cx
			sub up,33
			mov color,42h
			call drawRectangle	

			mov cx,monster3x
			mov left,cx
			sub left,9
			mov right,cx
			sub right,8
			mov cx,monster3y  
			mov down, cx
			sub down,37
			mov up,cx
			sub up,39
			mov color,42h
			call drawRectangle

			mov cx,monster3x
			mov left,cx
			sub left,8
			mov right,cx
			sub right,8
			mov cx,monster3y  
			mov down, cx
			sub down,38
			mov up,cx
			sub up,40
			mov color,42h
			call drawRectangle

			mov cx,monster3x
			mov left,cx
			sub left,7
			mov right,cx
			sub right,7
			mov cx,monster3y  
			mov down, cx
			sub down,39
			mov up,cx
			sub up,41
			mov color,42h
			call drawRectangle

			

		;WHITE
			mov cx,monster3x
			mov left,cx
			sub left,15
			mov right,cx
			sub right,15
			mov cx,monster3y  
			mov down, cx
			sub down,24
			mov up,cx
			sub up,25
			mov color,1Fh
			call drawRectangle

			mov cx,monster3x
			mov left,cx
			sub left,13
			mov right,cx
			sub right,13
			mov cx,monster3y  
			mov down, cx
			sub down,26
			mov up,cx
			sub up,27
			mov color,1Fh
			call drawRectangle

			mov cx,monster3x
			mov left,cx
			sub left,11
			mov right,cx
			sub right,11
			mov cx,monster3y  
			mov down, cx
			sub down,28
			mov up,cx
			sub up,29
			mov color,1fh
			call drawRectangle

			mov cx,monster3x
			mov left,cx
			sub left,17
			mov right,cx
			sub right,15
			mov cx,monster3y  
			mov down, cx
			sub down,33
			mov up,cx
			sub up,33
			mov color,1fh
			call drawRectangle

			mov cx,monster3x
			mov left,cx
			sub left,15
			mov right,cx
			sub right,14
			mov cx,monster3y  
			mov down, cx
			sub down,34
			mov up,cx
			sub up,36
			mov color,1fh
			call drawRectangle	

			mov cx,monster3x
			mov left,cx
			sub left,10
			mov right,cx
			sub right,9
			mov cx,monster3y  
			mov down, cx
			sub down,37
			mov up,cx
			sub up,39
			mov color,1fh
			call drawRectangle

			mov cx,monster3x
			mov left,cx
			sub left,9
			mov right,cx
			sub right,9
			mov cx,monster3y  
			mov down, cx
			sub down,38
			mov up,cx
			sub up,40
			mov color,1fh
			call drawRectangle

			mov cx,monster3x
			mov left,cx
			sub left,8
			mov right,cx
			sub right,8
			mov cx,monster3y  
			mov down, cx
			sub down,39
			mov up,cx
			sub up,41
			mov color,1fh
			call drawRectangle	

			mov cx,monster3x
			mov left,cx
			sub left,7
			mov right,cx
			sub right,6
			mov cx,monster3y  
			mov down, cx
			sub down,41
			mov up,cx
			sub up,41
			mov color,1fh
			call drawRectangle	

			mov cx,monster3x
			mov left,cx
			add left,2
			mov right,cx
			add right,4
			mov cx,monster3y  
			mov down, cx
			sub down,25
			mov up,cx
			sub up,27
			mov color,1fh
			call drawRectangle

			mov cx,monster3x
			mov left,cx
			add left,4
			mov right,cx
			add right,5
			mov cx,monster3y  
			mov down, cx
			sub down,26
			mov up,cx
			sub up,29
			mov color,1fh
			call drawRectangle	

			mov cx,monster3x
			mov left,cx
			add left,8
			mov right,cx
			add right,10
			mov cx,monster3y  
			mov down, cx
			sub down,20
			mov up,cx
			sub up,22
			mov color,1fh
			call drawRectangle

			mov cx,monster3x
			mov left,cx
			add left,7
			mov right,cx
			add right,9
			mov cx,monster3y  
			mov down, cx
			sub down,18
			mov up,cx
			sub up,20
			mov color,1fh
			call drawRectangle	

			mov cx,monster3x
			mov left,cx
			add left,10
			mov right,cx
			add right,12
			mov cx,monster3y  
			mov down, cx
			sub down,13
			mov up,cx
			sub up,15
			mov color,1fh
			call drawRectangle

			mov cx,monster3x
			mov left,cx
			add left,9
			mov right,cx
			add right,10
			mov cx,monster3y  
			mov down, cx
			sub down,11
			mov up,cx
			sub up,14
			mov color,1fh
			call drawRectangle	



ret
drawmonster3 endp


drawFireball proc uses cx

	fire=2Bh
	mov cx,fireballx
	mov left,cx
	add left,3
	mov right,cx          
	add right,13  
	mov cx,firebally  
	mov down, cx
	add down,6
	mov up,cx
	add up,6
	mov color,fire
	call drawRectangle

	mov cx,fireballx
	mov left,cx
	add left,4
	mov right,cx          
	add right,12
	mov cx,firebally  
	mov down, cx
	add down,5
	mov up,cx
	add up,5
	mov color,fire
	call drawRectangle

	mov cx,fireballx
	mov left,cx
	add left,4
	mov right,cx          
	add right,12
	mov cx,firebally  
	mov down, cx
	add down,7
	mov up,cx
	add up,7
	mov color,fire
	call drawRectangle

	mov cx,fireballx
	mov left,cx
	add left,5
	mov right,cx          
	add right,11
	mov cx,firebally  
	mov down, cx
	add down,8
	mov up,cx
	add up,8
	mov color,fire
	call drawRectangle

	mov cx,fireballx
	mov left,cx
	add left,5
	mov right,cx          
	add right,11
	mov cx,firebally  
	mov down, cx
	add down,4
	mov up,cx
	add up,4
	mov color,fire
	call drawRectangle

	mov cx,fireballx
	mov left,cx
	add left,6
	mov right,cx          
	add right,10
	mov cx,firebally  
	mov down, cx
	add down,3
	mov up,cx
	add up,3
	mov color,fire
	call drawRectangle

	mov cx,fireballx
	mov left,cx
	add left,6
	mov right,cx          
	add right,10
	mov cx,firebally  
	mov down, cx
	add down,9
	mov up,cx
	add up,9
	mov color,fire
	call drawRectangle
	

	mov cx,fireballx
	mov left,cx
	add left,7
	mov right,cx          
	add right,9
	mov cx,firebally  
	mov down, cx
	add down,10
	mov up,cx
	add up,10
	mov color,fire
	call drawRectangle

	mov cx,fireballx
	mov left,cx
	add left,7
	mov right,cx          
	add right,9
	mov cx,firebally  
	mov down, cx
	add down,2
	mov up,cx
	add up,2
	mov color,fire
	call drawRectangle
	
	
ret
drawFireball endp

movefireball proc
	cmp fireballstate,1
	je isActive

	isntActive:
		mov ax,monster3x
		mov fireballx,ax
		mov ax,monster3y
		mov firebally,ax
		mov fireballstate,1
		ret

	isActive:
		;HURDLE 1	;38,85	;136	;KINGDOM 	;248 ,300	,106	
		cmp fireballx,85
		jbe saveHurdle1
		cmp fireballx,299
		jbe savekingdom

		saveHurdle1:
			cmp fireballx,38
			jbe endsave
			cmp firebally,135
			ja endMove
			jmp endsave

		savekingdom:
			cmp fireballx,248
			jbe endsave
			cmp firebally,106
			ja endMove
			jmp endsave

		endsave:
			cmp firebally,170
			ja endMove
			add firebally,1
		ret

	endMove:
		mov fireballstate,0
		call clearFireball

ret 
movefireball endp

clearFireball proc uses cx
	mov cx,fireballx
	mov left,cx
	add left,2
	mov right,cx          
	add right,14  
	mov cx,firebally  
	mov down, cx
	add down,11
	mov up,cx
	add up,1
	mov color,67h
	call drawRectangle
ret 
clearFireball endp


enemy proc 

taart:

.if(aa > 0)
jmp outerloop

.else
jmp exitship

.endif

outerloop:
add yy1, 50
;add yy2, 20
;add xx1, 30
;add xx2, 30

mov counterr, 15
add xx1,50
add yy1,60
dec aa
mov cx, xx1;197
mov dx, yy1;107
line2:
	mov ah,0ch
	mov al,4Fh
	mov bx,0
	inc cx
	inc dx
	int 10h
	dec counterr
	cmp counterr,0
	jne line2
	
mov counterr, 15
add xx1,2
sub yy1,1
mov cx, xx1;199
mov dx, yy1;106
linee2:
	mov ah,0ch
	mov al,1100b
	mov bx,0
	inc cx
	inc dx
	int 10h
	dec counterr
	cmp counterr,0
	jne linee2

mov counterr, 15
add xx1,15
add yy1,1
mov cx, xx1;214
mov dx, yy1;107
line3:
	mov ah,0ch
	mov al,4FH
	mov bx,0
	dec cx
	inc dx
	int 10h
	dec counterr
	cmp counterr,0
	jne line3
	
mov counterr, 15
sub xx1,2
sub yy1,1
mov cx, xx1;212
mov dx, yy1;106
linee3:
	mov ah,0ch
	mov al,1100b
	mov bx,0
	dec cx
	inc dx
	int 10h
	dec counterr
	cmp counterr,0
	jne linee3


mov counterr, 8
add xx1,1
add yy1,14
mov cx, xx1;200
mov dx, yy1;107
line4:
	mov ah,0ch
	mov al,5FH
	mov bx,0
	dec cx
	inc dx
	int 10h
	dec counterr
	cmp counterr,0
	jne line4

mov counterr, 7
add xx1,-7
add yy1,9
mov cx, xx1;199
mov dx, yy1;106
linee6:
	mov ah,0ch
	mov al,5Fh
	mov bx,0
	dec cx
	dec dx
	int 10h
	dec counterr
	cmp counterr,0
	jne linee6
	jmp taart


exitship:
ret
enemy endp




end

