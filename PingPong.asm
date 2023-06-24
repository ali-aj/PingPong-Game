[org 0x0100]
	jmp start

lengthPl:	dw 5 
counter:	dd 0
gameName:	db 'Welcome to Ping Pong Game'
hyphen:		db '-------------------------'
creater:	db 'Creater:'
studentName:db 'Muhammad Ali Mustafa (21F-9088)'
menu:		db 'Game Menu:' ; length = 10
players:	db 'Player 1 -> Left   Player 2 -> Right' ; length = 36
menu1:		db '1.Pressing u will move the player upward.' ;length = 41
menu2:		db '2.Pressing d will move the player downward.' ;length = 43
menu3:		db '3.Whenever a player hits the ball control transfer to opponent player.' ; length = 70
menu4:		db '4.If the ball touches left side of screen then Player 2 Wins.' ; length = 61
menu5:		db '5.If the ball touches right side of screen then Player 1 Wins.' ; length = 62
player1:	db 'Player 1 Wins.' ; length = 14
player2:	db 'Player 2 Wins.' ; length = 14
gameOver:	db 'GAME OVER!!!!' ; length = 13
score:		db 'Score: ' ; length = 7	
press:		db 'Press Enter to start...' ; length = 23
scoreP1:	db 'Player 1 Score: ' ; length = 16
scoreP2:	db 'Player 2 Score: ' ; length = 16
score1:		dw 0
score2:		dw 0
win:		dw 0

; Sub-Routine to clear the screen
clrscr: 	push es
			push ax
			push cx
			push di
			mov ax, 0xb800
			mov es, ax
			xor di, di
			mov cx, 2000
			mov ax, 0x0FDB
			
			cld
			rep STOSW

			pop di
			pop cx
			pop ax
			pop es
			ret
			
; Sub-Routine to print center line
centerLine:	push bp
			mov bp, sp
			push ax
			push cx
			push di
			push es
			mov ax, 0xb800
			mov es, ax
			
outerLoop:	mov di, word[bp+4] ; Load starting postion of line 
			mov ax, 0x0700
			mov cx, 25

; Printing line that divides both players			
printLine:	mov [es:di], ax
			add di, 160
			loop printLine
			
			pop es
			pop di
			pop cx
			pop ax
			pop bp
			ret 2
			
; Sub-Routine to print border on the screen
border:		push bp
			mov bp, sp
			sub sp, 4
			mov word[bp-2], 0 ; Left Vertical Border
			mov word[bp-4], 158 ; Right Vertical Border
			push ax
			push di
			push es
			mov ax, 0xb800
			mov es, ax			

			mov ax, 0x1700
			
vertical:	mov di, word[bp-2]
			mov [es:di], ax
			add word[bp-2], 160
			mov di, word[bp-4]
			mov [es:di], ax
			add word[bp-4], 160
			cmp word[bp-2], 4000
			jne vertical
			
			pop es
			pop di
			pop cx
			pop ax
			mov sp, bp
			pop bp
			ret
			
; Checking if the ball has touched the right side of grid			
rightCollisionCheck:
			cmp dx, si
			je rightCollisionTrue
			add dx, 160
			cmp dx, 4000
			jl rightCollisionCheck
			ret
			
rightCollisionTrue:
			mov word[win], 1
			call gameOverr
			
; Checking if the ball has touched the left side of grid
leftCollisionCheck:
			cmp dx, si
			je leftCollisionTrue
			add dx, 160
			cmp dx, 4000
			jl leftCollisionCheck
			ret
			
leftCollisionTrue:
			mov word[win], 2
			call gameOverr
			
moveBallStraightPLayer1:	
			push ax
			push si
			push dx
			
			mov ax, 0x0FDB
			mov si, word[bp-10]
			mov [es:si], ax
			add word[bp-10], 2
			mov si, word[bp-10]
			
			call checkPlayer2HitsBall
			mov dx, 158
			call rightCollisionCheck
			
			mov ax, 0x2700
			mov [es:si], ax
			
			pop dx
			pop si
			pop ax
			ret
			
moveBallStraightPLayer2:	
			push ax
			push si
			push dx
			
			mov ax, 0x0FDB
			mov si, word[bp-10]
			mov [es:si], ax
			sub word[bp-10], 2
			mov si, word[bp-10]
			
			call checkPlayer1HitsBall
			mov dx, 0
			call leftCollisionCheck
			
			mov ax, 0x2700
			mov [es:si], ax
			
			pop dx
			pop si
			pop ax
			ret
			
moveBallDiagonallyUpPlayer1:
			push ax
			push si
			push dx
			mov ax, 0x0FDB
			mov si, word[bp-10]
			mov [es:si], ax
			sub word[bp-10], 158
			mov si, word[bp-10]
			
			call checkPlayer2HitsBall
			mov dx, 158
			call rightCollisionCheck
			
			mov ax, 0x2700
			mov [es:si], ax
			
			pop dx
			pop si
			pop ax
			ret
			
moveBallDiagonallyUpPlayer2:
			push ax
			push si
			push dx
			
			mov ax, 0x0FDB
			mov si, word[bp-10]
			mov [es:si], ax
			sub word[bp-10], 162
			mov si, word[bp-10]
			
			call checkPlayer1HitsBall
			mov dx, 0
			call leftCollisionCheck
			
			mov ax, 0x2700
			mov [es:si], ax
			
			pop dx
			pop si
			pop ax
			ret
			
moveBallDiagonallyDownPlayer1:
			push ax
			push si
			push dx
			
			mov ax, 0x0FDB
			mov si, word[bp-10]
			mov [es:si], ax
			add word[bp-10], 162
			mov si, word[bp-10]
			
			call checkPlayer2HitsBall
			mov dx, 158
			call rightCollisionCheck
			
			mov ax, 0x2700
			mov [es:si], ax
			
			pop dx
			pop si
			pop ax
			ret
			
moveBallDiagonallyDownPlayer2:
			push ax
			push si
			push dx
			
			mov ax, 0x0FDB
			mov si, word[bp-10]
			mov [es:si], ax
			add word[bp-10], 158
			mov si, word[bp-10]
			
			call checkPlayer1HitsBall
			mov dx, 0
			call leftCollisionCheck
			
			mov ax, 0x2700
			mov [es:si], ax
			
			pop dx
			pop si
			pop ax
			ret
	
; printing game over on screen along with which player wins and there scores	
gameOverr:	call clrscr
			mov ah, 0x13 
			mov al, 1 
			mov bh, 0 
			mov bl, 7 
			
			mov dx, 0x0101
			mov cx, 16
			push cs
			pop es 
			mov bp, scoreP1
			int 0x10
			
			mov dx, 0x0201
			mov cx, 16
			push cs
			pop es 
			mov bp, scoreP2
			int 0x10
			
			mov dx, 0x0123
			push cs
			pop es 	
			mov cx, 14
			
			cmp word[win], 1
			je p1Win
			jmp p2Win

p1Win:		mov bp, player1
			jmp printP
			
p2Win:		mov bp, player2			

			
printP:		int 0x10
			jmp printScore			
			
printScore:	mov dx, 196
			push dx
			mov dx, [score1]
			push dx 
			call printNum
			
			mov dx, 356
			push dx
			mov dx, [score2]
			push dx
			call printNum
			
			mov dx, 0x0C23
			mov cx, 13
			push cs
			pop es 
			mov bp, gameOver
			int 0x10
			
			mov ax, 0x4c00
			int 0x21

; Printing the score of both players
printNum:	push bp 
			mov  bp, sp
			push es 
			push ax 
			push bx 
			push cx 
			push dx 
			push di 

			mov ax, [bp+4]   
			mov bx, 10       
			mov cx, 0        
 
			nextdigit:	mov dx, 0    
						div bx       
						add dl, 0x30 
						push dx      
						inc cx       
						cmp ax, 0    
						jnz nextdigit 
						
						mov ax, 0xb800 
						mov es, ax 
						mov di, [bp+6]
    
			nextpos:    pop dx          
						mov dh, 0x03    
						mov [es:di], dx 
						add di, 2 
						loop nextpos    

			pop di 
			pop dx 
			pop cx 
			pop bx 
			pop ax 
			pop es
			pop bp 
			ret 8			

; Delaying movement of players			
delay:		mov dword[counter], 100000 

incCounter:	dec dword[counter] 
			cmp dword[counter],0 
			jne  incCounter
			ret

; Sub-Routine of PingPong Game
game:	 	push bp
			mov bp, sp
			sub sp, 10
			mov word[bp-2], 2 ; First player
			mov word[bp-4], 156 ; Second Player
			mov word[bp-6], 0 ; Last Position of player 1
			mov word[bp-8], 0 ; Last Position of player 2
			mov word[bp-10], 644 ; Ball position
			push es
			push ax
			push bx
			push cx
			push dx
			push si
			push di
			mov ax, 0xb800
			mov es, ax		
			
			mov si, word[bp-2] ; Load player 1 starting position
			mov di, word[bp-4] ; Load player 2 starting position
			mov cx, word[bp+4] ; Load player length
			mov ax, 0x2700
	
; Printing both players	
printPlayer:mov [es:si], ax ; PLayer 1
			mov [es:di], ax ; PLayer 2
			mov word[bp-6], si
			mov word[bp-8], di
			add si, 160
			add di, 160
			loop printPlayer
			
			; Printing ball
			mov si, word[bp-10]
			mov ax, 0x2700
			mov [es:si], ax
			
			; Call ball movements here
			call ballMovementDiagonallyDown1

;End Program					
endG:		pop di
			pop si
			pop dx
			pop cx
			pop bx
			pop ax
			pop es
			mov sp, bp
			pop bp
			ret 2

; Ball movement Diagonally Down when player 1 hits the ball			
ballMovementDiagonallyDown1:
			call moveBallDiagonallyDownPlayer1
			call delay
			add si, 162
			push ax
			mov ax, 80 ; Starting position of printing line between two players
			push ax
			call centerLine
			pop ax
			call inputP2
			cmp si, 4000
			jl ballMovementDiagonallyDown1
			
ballMovementDiagonallyUp1:
			call moveBallDiagonallyUpPlayer1
			call delay
			sub si, 158
			push ax
			mov ax, 80 ; Starting position of printing line between two players
			push ax
			call centerLine
			pop ax
			call inputP2
			cmp si, 0
			jg ballMovementDiagonallyUp1
			jmp ballMovementDiagonallyDown1
			
; Ball movement Diagonally Up when player 1 hits the ball			
ballMovementDiagonallyUpP1:
			call moveBallDiagonallyUpPlayer1
			call delay
			sub si, 158
			push ax
			mov ax, 80 ; Starting position of printing line between two players
			push ax
			call centerLine
			pop ax
			call inputP2
			cmp si, 0
			jg ballMovementDiagonallyUpP1

ballMovementDiagonallyDownP1:
			call moveBallDiagonallyDownPlayer1
			call delay
			add si, 162
			push ax
			mov ax, 80 ; Starting position of printing line between two players
			push ax
			call centerLine
			pop ax
			call inputP2
			cmp si, 4000
			jl ballMovementDiagonallyDownP1
			jmp ballMovementDiagonallyUpP1
			
; Ball movement Diagonally Up when player 2 hits the ball			
ballMovementDiagonallyUpP2:
			call moveBallDiagonallyUpPlayer1
			call delay
			sub si, 162
			push ax
			mov ax, 80 ; Starting position of printing line between two players
			push ax
			call centerLine
			pop ax
			call inputP1
			cmp si, 0
			jg ballMovementDiagonallyUpP2

ballMovementDiagonallyDownP2:
			call moveBallDiagonallyDownPlayer1
			call delay
			add si, 158
			push ax
			mov ax, 80 ; Starting position of printing line between two players
			push ax
			call centerLine
			pop ax
			call inputP1
			cmp si, 4000
			jl ballMovementDiagonallyDownP2
			jmp ballMovementDiagonallyUpP2			
			
; Ball movement Straight when player 1 hits the ball			
ballMovementStraight1:
			call moveBallStraightPLayer1
			call delay
			add si, 2
			push ax
			mov ax, 80 ; Starting position of printing line between two players
			push ax
			call centerLine
			pop ax
			call inputP2
			jmp ballMovementStraight1
			
; Ball movement Straight when player 2 hits the ball			
ballMovementStraight2:
			call moveBallStraightPLayer2
			call delay
			sub si, 2
			push ax
			mov ax, 80 ; Starting position of printing line between two players
			push ax
			call centerLine
			pop ax
			call inputP1
			jmp ballMovementStraight2
			
; Ball movement Diagonally Down when player 2 hits the ball		
ballMovementDiagonallyDown2:
			call moveBallDiagonallyDownPlayer2
			call delay
			add si, 158
			push ax
			mov ax, 80 ; Starting position of printing line between two players
			push ax
			call centerLine
			pop ax
			call inputP1
			cmp si, 4000
			jl ballMovementDiagonallyDown2
			
ballMovementDiagonallyUp2:
			call moveBallDiagonallyUpPlayer2
			call delay
			sub si, 162
			push ax
			mov ax, 80 ; Starting position of printing line between two players
			push ax
			call centerLine
			pop ax
			call inputP1
			cmp si, 0
			jg ballMovementDiagonallyUp2
			jmp ballMovementDiagonallyDown2
			
; Checking if player 2 hits the ball			
checkPlayer2HitsBall:
			push bx
			push si
			
			mov bx, word[bp-4]
			cmp si, bx
			jne secondP2
			inc word[score2]
			push ax
			mov ax, 0x2700
			mov [es:si], ax
			pop ax
			sub word[bp-10], 2
			jmp ballMovementDiagonallyUpP2

secondP2:	add bx, 160
			cmp si, bx
			jne thirdP2
			inc word[score2]
			push ax
			mov ax, 0x2700
			mov [es:si], ax
			pop ax
			sub word[bp-10], 2
			jmp ballMovementDiagonallyUpP2

thirdP2:	add bx, 160
			cmp si, bx
			jne forthP2
			inc word[score2]
			push ax
			mov ax, 0x2700
			mov [es:si], ax
			pop ax
			sub word[bp-10], 2
			jmp ballMovementStraight2

forthP2:	add bx, 160
			cmp si, bx
			jne fifthP2
			inc word[score2]
			push ax
			mov ax, 0x2700
			mov [es:si], ax
			pop ax
			sub word[bp-10], 2
			jmp ballMovementDiagonallyDown2

fifthP2:	add bx, 160
			cmp si, bx
			jne hitP2exit
			inc word[score2]
			push ax
			mov ax, 0x2700
			mov [es:si], ax
			pop ax
			sub word[bp-10], 2
			jmp ballMovementDiagonallyDown2
			
hitP2exit:	pop si
			pop bx
			ret
			
; Checking if player 1 hits the ball			
checkPlayer1HitsBall:
			push bx
			push si
			
			mov bx, word[bp-2]
			cmp si, bx
			jne secondP1
			inc word[score1]
			push ax
			mov ax, 0x2700
			mov [es:si], ax
			pop ax
			add word[bp-10], 2
			jmp ballMovementDiagonallyUpP1
			
secondP1	add bx, 160
			cmp si, bx
			jne thirdP1
			inc word[score1]
			push ax
			mov ax, 0x2700
			mov [es:si], ax
			pop ax
			add word[bp-10], 2
			jmp ballMovementDiagonallyUpP1
			
thirdP1		add bx, 160
			cmp si, bx
			jne forthP1
			inc word[score1]
			push ax
			mov ax, 0x2700
			mov [es:si], ax
			pop ax
			add word[bp-10], 2
			jmp ballMovementStraight1
			
forthP1:	add bx, 160
			cmp si, bx
			jne fifthP1
			inc word[score1]
			push ax
			mov ax, 0x2700
			mov [es:si], ax
			pop ax
			add word[bp-10], 2
			jmp ballMovementDiagonallyDown1
			
fifthP1		add bx, 160
			cmp si, bx
			jne hitP1exit
			inc word[score1]
			push ax
			mov ax, 0x2700
			mov [es:si], ax
			pop ax
			add word[bp-10], 2
			jmp ballMovementDiagonallyDown1			
			
hitP1exit:	pop si
			pop bx
			ret			
			
; Movement of player 1 Downward
movePlayer1Down:
			push ax
			push si
			
			mov si, word[bp-6]
			add si, 160
			cmp si, 4000
			jg exitP1Down
			add word[bp-6], 160
			mov ax, 0x2700
			mov [es:si], ax
			mov si, word[bp-2]
			mov ax, 0x0FDB
			mov [es:si], ax			
			add word[bp-2], 160
			
exitP1Down:	pop si
			pop ax
			ret			

; Movement of player 1 Upward
movePlayer1Up:
			push ax
			push si
			
			mov si, word[bp-2]
			sub si, 160
			cmp si, 0
			jl exitP1Up
			sub word[bp-2], 160
			mov ax, 0x2700
			mov [es:si], ax			
			mov si, word[bp-6]
			mov ax, 0x0FDB
			mov [es:si], ax
			sub word[bp-6], 160
			
exitP1Up:	pop si
			pop ax
			ret

; Movement of player 2 Downward
movePlayer2Down:
			push es
			push ax
			push si
			
			mov ax, 0xb800
			mov es, ax
			
			mov si, word[bp-8]
			add si, 160
			cmp si, 4000
			jg exitP2Down
			add word[bp-8], 160
			mov ax, 0x2700
			mov [es:si], ax
			mov si, word[bp-4]
			mov ax, 0x0FDB
			mov [es:si], ax			
			add word[bp-4], 160
			
exitP2Down:	pop si
			pop ax
			pop es
			ret

; Movement of player 2 Upward
movePlayer2Up:
			push ax
			push si
			
			mov si, word[bp-4]
			sub si, 160
			cmp si, 0
			jl exitP2Up
			sub word[bp-4], 160
			mov ax, 0x2700
			mov [es:si], ax			
			mov si, word[bp-8]
			mov ax, 0x0FDB
			mov [es:si], ax
			sub word[bp-8], 160
			
exitP2Up:	pop si
			pop ax
			ret
			
; Taking input from player 1 controls
inputP1:	;push ax
			;push dx
			
			mov ah, 1
			int 0x16
			jz exitInputP1

			mov ah, 0
			int 0x16
			
			; AH = BIOS scan code
			cmp al, 'u'
			je movePlayer1Up
			cmp al, 'd'
			je movePlayer1Down
			
			
			cmp ah, 01
			je gameOverr
			
exitInputP1:;pop dx
			;pop ax
			ret
			
; Taking input from player 2 controls
inputP2:	;push ax
			;push dx
			
			mov ah, 1
			int 0x16
			jz exitInputP2
			
			mov ah, 0
			int 0x16
			; AH = BIOS scan code
			cmp al, 'u'
			je movePlayer2Up
			cmp al, 'd'
			je movePlayer2Down
			
			cmp ah, 01
			je gameOverr
			
exitInputP2:;pop dx
			;pop ax
			ret			
			
; Welcome screen
intro:		mov ah, 0x13 
			mov al, 1 
			mov bh, 0 
			mov bl, 7 
			mov dx, 0x0A19
			mov cx, 25
			push cs
			pop es 
			mov bp, gameName
			int 0x10
			
			mov dx, 0x0B19
			mov cx, 25
			push cs
			pop es
			mov bp, hyphen
			int 0x10
			
			mov dx, 0x1801
			mov cx, 8
			push cs
			pop es
			mov bp, creater
			int 0x10
			
			mov dx, 0x180A
			mov cx, 31
			push cs
			pop es
			mov bp, studentName
			int 0x10
			
			mov ah, 01
			int 0x21
			ret

; Displaying Game Menu/Instructions			
gameMenu:	mov ah, 0x13 
			mov al, 1 
			mov bh, 0 
			mov bl, 7 
			mov dx, 0x0101
			mov cx, 10
			push cs
			pop es 
			mov bp, menu
			int 0x10
			
			mov dx, 0x0301
			mov cx, 36 
			push cs
			pop es
			mov bp, players
			int 0x10
			
			mov dx, 0x0501
			mov cx, 41
			push cs
			pop es
			mov bp, menu1
			int 0x10
			
			mov dx, 0x0601
			mov cx, 43
			push cs
			pop es
			mov bp, menu2
			int 0x10
			
			mov dx, 0x0701
			mov cx, 70
			push cs
			pop es
			mov bp, menu3
			int 0x10
			
			mov dx, 0x0801
			mov cx, 61
			push cs
			pop es
			mov bp, menu4
			int 0x10
			
			mov dx, 0x0901
			mov cx, 62
			push cs
			pop es
			mov bp, menu5
			int 0x10
			
			mov dx, 0x1801
			mov cx, 23
			push cs
			pop es
			mov bp, press
			int 0x10
			
			mov ah, 01
			int 0x21
			ret
			
start: 		call clrscr ; call the clrscr subroutine
			call intro
			call clrscr
			
			call gameMenu
			call clrscr
			
			call border
			
			mov ax, 80 ; Starting position of printing line between two players
			push ax
			call centerLine
			
			push word [lengthPl]
			call game

mov ax, 0x4c00 ; terminate program
int 0x21