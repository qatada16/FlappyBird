[org 0x0100]
jmp start

random: dw 4, 6, 8, 10, 12, 11       ; List of numbers
random_size equ 6			         ; Size of the random list
bgBuffer: times 1840 dw 0
bgDeadBuffer: times 20 dw 0
pillarsIndex: dw 60, 95, 130
pillarsRandomHeight: dw 8, 0, 0
birdRowIndex: dw 11
birdFlag: dw 0
birdStill: dw 0
birdDelay: dw 2
score: dw 0
timerCount: dw 62
collisions: dw 0
oldINT9hisr: dd 0
oldINT8hisr: dd 0
pauseF: db 0
pauseBuffer: times 19 dw 0





;StartScreen-------------------------------------------------------------------------
startString: db 'PRESS ANY KEY TO START ;)'
exitString: db 'Escape to EXIT :('
myself: db '23L-0998 Muhammad Qatada | 23L-0829 Saad Zafar'
lenOfStart: dw 46

; Instruction Screen -------------------------------------------------------------------

pressKeyStr: db 'PRESS ANY KEY TO CONTINUE'
firstInstruct: db 'Hold the UP Key to Fly'
secondInstruct: db 'Press P to Pause'
thirdInstruct: db 'Press Escape to Exit'


; Puse Screen ----------------------------------------------------------------------------------
pauseString: db 'PRESS P to Continue, E to Exit'

; End Screen ---------------------------------------------------------------------------------
endingString: db 'Thank you for playing!'
glhfString: db 'GLHF :)'
gameOver: db 'GAME OVER'
scoreStr: db 'SCORE: '
exitString2: db 'PRESS ANY KEY TO EXIT'

playMusic: db 1

; PCB layout:
; ax,bx,cx,dx,si,di,bp,sp,ip,cs,ds,ss,es,flags,next,dummy
; 0, 2, 4, 6, 8,10,12,14,16,18,20,22,24, 26 , 28 , 30
pcb: times 2*16 dw 0 ; space for 32 PCBs
nextpcb: dw 1 ; index of next free pcb
current: dw 0 ; index of current pcb

initpcb: 	push bp
			mov bp, sp
			push ax
			push bx
			push cx
			push si

			mov bx, [nextpcb] ; read next available pcb index
            
			mov cl, 5
			shl bx, cl ; multiply by 32 for pcb start ix2^5 

            mov [pcb+bx+18], cs ; save in pcb space for cs
            mov ax, tasktwo
            mov [pcb+bx+16], ax ; save in pcb space for cs
			mov word [pcb+bx+26], 0x0200 ; initialize thread flags
			mov ax, [pcb+28] ; read next of 0th thread in ax
			mov [pcb+bx+28], ax ; set as next of new thread
			mov ax, [nextpcb] ; read new thread index
			mov [pcb+28], ax ; set as next of 0th thread
			


			exit: 
            pop si
			pop cx
			pop bx
			pop ax
			pop bp
			ret 6


delayEnd:
	push bp
	mov bp, sp
	push cx
	push bx
	mov bx, [bp+4]
	checkDelayEndAgain:
		mov cx, 0x0700
		delayEndAgain:
			dec cx
			jnz delayEndAgain
		dec bx
		jnz checkDelayEndAgain
	
	pop bx
	pop cx
	pop bp
	ret 2
	
flappybirdEnd:
	push ax
    push bx
    push cx
	push dx
	push di
	push si
	push es
	push ds
    F1End:
        mov cx, 5
        mov di,(4*160+22)
        leftsideEnd:
            mov word[es:di], 0x3020 
            add di,160
            loop leftsideEnd
    F2End:
        mov cx,5
        mov di,(4*160+22)
        upperFEnd:
            mov word[es:di], 0x3020 
            add di,2
            loop upperFEnd
    F3End:
        mov cx,3
        mov di,(6*160+22)
        lowerFEnd:
            mov word[es:di], 0x3020 
            add di,2
            loop lowerFEnd
    
    CompleteLEnd:
        mov cx, 5
        mov di,(4*160+24+2*5)
        leftLEnd:
            mov word[es:di], 0x3020 
            add di,160
            loop leftLEnd

        mov cx, 5
        mov di,(8*160+24+2*5)
        lowerlEnd:
            mov word[es:di], 0x3020 
            add di,2
            loop lowerlEnd

    A1End:
        mov cx,4
        mov di,(4*160+46)
        AupperEnd:
            mov word[es:di], 0x3020 
            add di,2
            loop AupperEnd

        mov cx,5
        mov di,(4*160+46)
        AleftEnd:
            mov word[es:di], 0x3020 
            add di,160
            loop AleftEnd

        mov cx,5
        mov di,(4*160+54)
        ARightEnd:
            mov word[es:di], 0x3020 
            add di,160
            loop ARightEnd
        
        mov cx,4
        mov di,(7*160+46)
        ACenterEnd:
            mov word[es:di], 0x3020 
            add di,2
            loop ACenterEnd

    P1End:
        mov cx, 5
        mov di,(4*160+24+2*17)
        leftPEnd:
            mov word[es:di], 0x3020 
            add di,160
            loop leftPEnd
        
        mov cx,4
        mov di,(4*160+24+2*17)
        upperPEnd:
            mov word[es:di], 0x3020 
            add di,2
            loop upperPEnd
        
        mov cx, 2
        mov di,(3*160+24+2*172+2*8)
        RightPEnd:
            mov word[es:di], 0x3020 
            add di,160
            loop RightPEnd

        sub di,160
        LowerPEnd:
            sub di,2
            mov word[es:di],0x3020 
            sub di,2
            mov word[es:di],0x3020 

    P2End:
        mov cx, 5
        mov di,(4*160+24+2*17+2*5)
        leftP2End:
            mov word[es:di], 0x3020 
            add di,160
            loop leftP2End
        
        mov cx,4
        mov di,(4*160+24+2*17+2*5)
        upperP2End:
            mov word[es:di], 0x3020 
            add di,2
            loop upperP2End
        
        mov cx, 2
        mov di,(3*160+24+2*172+2*8+2*5)
        RightP2End:
            mov word[es:di], 0x3020 
            add di,160
            loop RightP2End
            
        sub di,160
        LowerP2End:
            sub di,2
            mov word[es:di],0x3020 
            sub di,2
            mov word[es:di],0x3020 

    YEnd:
        mov cx, 3
        mov di,(4*160+24+2*17+2*5+2*5)
        leftslantEnd:
            mov word[es:di], 0x3020 
            add di,162
            loop leftslantEnd

        mov cx, 2
        mov di,(4*160+24+2*17+2*5+2*9)
        RighslantEnd:
            mov word[es:di], 0x3020 
            add di,158
            loop RighslantEnd


        mov cx, 2
        mov di, (7*160+24+2*17+2*5+2*7)
        centerlineEnd:
        mov word[es:di], 0x3020 
            add di,160
            loop centerlineEnd

    BEnd:
        mov cx, 5
        mov di,(4*160+24+2*17+2*20)
        leftBEnd:
            mov word[es:di], 0x3020 
            add di,160
            loop leftBEnd

        mov cx, 3
        mov di, (4*160+24+2*17+2*20)
        UpperBEnd:
            mov word[es:di], 0x3020 
            add di, 2
            loop UpperBEnd

        add di, 160
        mov word[es:di], 0x3020 
        add di, 160
        
        mov cx,3
        midBEnd:
        sub di,2
        mov word[es:di], 0x3020 
        loop midBEnd

        add di, 6
        add di, 160
        mov word[es:di], 0x3020 
        mov cx,2
        add di, 160
        lowerBEnd:
        sub di, 2
        mov word[es:di], 0x3020   
        loop lowerBEnd

    IEndd:
        mov cx, 5
        mov di,(4*160+24+2*17+2*26)
        printIEnd:
            mov word[es:di], 0x3020 
            add di,160
            loop printIEnd

    REnd:
        mov cx, 5
        mov di,(4*160+24+2*17+2*28)
        LeftREnd:
            mov word[es:di], 0x3020 
            add di,160
            loop LeftREnd

        mov cx, 3
        mov di, (4*160+24+2*17+2*28)
        UpperREnd:
            mov word[es:di], 0x3020 
            add di, 2
            loop UpperREnd

        add di, 160
        mov word[es:di], 0x3020 
        add di, 160
        
        mov cx,3
        midREnd:
        sub di,2
        mov word[es:di], 0x3020 
        loop midREnd
        add di, 6
        add di, 160
        mov word[es:di], 0x3020 
        add di, 160
        mov word[es:di], 0x3020 
    
    DEnd:
        mov cx, 5
        mov di,(4*160+24+2*17+2*33)
        LeftDEnd:
            mov word[es:di], 0x3020 
            add di,160
            loop LeftDEnd
        
        mov cx, 4
        mov di,(4*160+24+2*17+2*33)
        upperDEnd:
            mov word[es:di], 0x3020 
            add di, 2
            loop upperDEnd
        
        mov cx,3
        rightsideDEnd:
        add di,160
        mov word[es:di], 0x3020 
        loop rightsideDEnd

        add di,160
        mov cx, 3
        
        lowerDEnd:
        sub di, 2
        mov word[es:di], 0x3020 
        loop lowerDEnd
	
	pop ds
	pop es
	pop si
	pop di
	pop dx
	pop cx
	pop bx
	pop ax
	ret
	
endScreen:
	push ax
    push bx
    push cx
	push dx
	push di
	push es
	push bp
	
    mov ax, 0xb800
    mov es, ax
    mov di, 0
    mov cx, 2000
    theloop:
        push 1
        call delayEnd
        mov word[es:di],0x0020
        add di, 2
        loop theloop

	mov byte [playMusic], 0
	
	call flappybirdEnd
	
	; End::: String
	mov  ah, 0x13         
	mov  al, 0             
	mov  bh, 0            
	mov  bl, 0x84
	mov  dx, 0x0c22
	mov  cx, 9       	; length 
	push cs 
	pop  es                 
	mov  bp, gameOver   
	int  0x10
	
	; Ending Thanks String 
	mov  bl, 0x06
	mov  dx, 0x0e1c
	mov  cx, 22       	; length               
	mov  bp, endingString   
	int  0x10
	
	; GLHF String 
	mov  bl, 0x86
	mov  dx, 0x0f24
	mov  cx, 7       	; length               
	mov  bp, glhfString   
	int  0x10
	
	; Ending Score String 
	mov  bl, 0x06
	mov  dx, 0x1223
	mov  cx, 7       	; length               
	mov  bp, scoreStr   
	int  0x10
	push (18*160+84)
	push word[score]
	call printnum2
	
	mov  bl, 0x87
	mov  dx, 0x141c
	mov  cx, 21       	; length               
	mov  bp, exitString2   
	int  0x10
	
    pop bp
    pop es
    pop di
	pop dx
    pop cx
    pop bx
	pop ax
ret

; End OF End Screen--------------------------------------------------------------------------------------


instructLayout:
	push ax
	push di
	push es
	
	mov ax, 0xb800 ; load video base in ax
	mov es, ax ; point es to video base
	mov di, 0 ; point di to top left column
	instructblueBackground: 
		mov word[es:di], 0x3020  
		add di, 2 
		cmp di, 3998 
		jne instructblueBackground 		
    mov di,3520
    instructground1:
		mov word[es:di], 0x2020 
		add di, 2 
		cmp di, 3680 
		jne instructground1 
	instructground2:
		mov word[es:di], 0x6020 
		add di, 2 
		cmp di, 4000 
		jne instructground2
	pop es
	pop di
	pop ax
	ret    

;-------------------------------------------------------------------------
instructsPrint:
    push ax
    push bx
    push cx
	push dx
	push di
	push es
	push bp

    mov ax, 0xb800
    mov es, ax
	; Press any key to Continue::: String
	mov  ah, 0x13         
	mov  al, 0             
	mov  bh, 0            
	mov  bl, 0xb4
	mov  dx, 0x0e1c
	mov  cx, 25        	; length 
	push cs 
	pop  es                 
	mov  bp, pressKeyStr    
	int  0x10
	
	; First Instruct
	mov  bl, 0x34
	mov  dx, 0x071d
	mov  cx, 22                   
	mov  bp, firstInstruct   
	int  0x10
	; First Instruct
	mov  dx, 0x0920
	mov  cx, 16                       
	mov  bp, secondInstruct   
	int  0x10
	; First Instruct
	mov  dx, 0x0b1e
	mov  cx, 20                 
	mov  bp, thirdInstruct   
	int  0x10
	
    pop bp
    pop es
    pop di
	pop dx
    pop cx
    pop bx
	pop ax
    ret

;------------------------------------------------------------------------------------------------------


IntroScreen:
    call instructLayout
    call instructsPrint
    ret

; End of Instruction ------------------------------------------------------------------

basiclayout:
	mov ax, 0xb800 ; load video base in ax
	mov es, ax ; point es to video base
	mov di, 0 ; point di to top left column
	blueBackground: 
		mov word[es:di], 0x3020  
		add di, 2 
		cmp di, 3998 
		jne blueBackground 		

    outline:
        mov cx, 58
        mov di,(2*160+20)
        upperline:

            mov word[es:di], 0x0720
            mov word[es:di], 0x6020
            add di,2
            loop upperline

        upperLeftSlant:
        mov di,(3*160+18)
        mov word[es:di], 0x6020
        mov di,(4*160+16)
        mov word[es:di], 0x6020
        upperRightSlant:
        mov di,(3*160+20+2*58)
        mov word[es:di], 0x6020
        mov di,(4*160+22+2*58)
        mov word[es:di], 0x6020
        
        mov di,(4*160+16)
        mov cx, 5
        leftline:
        mov word[es:di], 0x6020
        add di,160
        loop leftline

        mov di,(4*160+22+2*58)
        mov cx, 5
        rightline:
        mov word[es:di], 0x6020
        add di,160
        loop rightline
        

        lowerLeftSlant:
        mov di,(9*160+18)
        mov word[es:di], 0x6020
        lowerRightSlant:
        mov di,(9*160+20+2*58)
        mov word[es:di], 0x6020
        
        mov cx, 58
        mov di,(10*160+20)
        lowerline:
            mov word[es:di], 0x0720
            mov word[es:di], 0x6020
            add di,2
            loop lowerline    
    mov di,3520
    groundOfStart1:
		mov word[es:di], 0x2020 
		add di, 2 
		cmp di, 3680 
		jne groundOfStart1 
	groundOfStart2:
		mov word[es:di], 0x6020 
		add di, 2 
		cmp di, 4000 
		jne groundOfStart2
	ret    

flappybird:
	push ax
	push bx
	push cx
	push dx
	push di
	push si
	push es

    F1:
        mov cx, 5
        mov di,(4*160+22)
        leftside:
            mov word[es:di], 0x6020
            add di,160
            loop leftside
    F2:
        mov cx,5
        mov di,(4*160+22)
        upperF:
            mov word[es:di], 0x6020
            add di,2
            loop upperF
    F3:
        mov cx,3
        mov di,(6*160+22)
        lowerF:
            mov word[es:di], 0x6020
            add di,2
            loop lowerF
    
    CompleteL:
        mov cx, 5
        mov di,(4*160+24+2*5)
        leftL:
            mov word[es:di], 0x6020
            add di,160
            loop leftL

        mov cx, 5
        mov di,(8*160+24+2*5)
        lowerl:
            mov word[es:di], 0x6020
            add di,2
            loop lowerl

    A1:
        mov cx,4
        mov di,(4*160+46)
        Aupper:
            mov word[es:di], 0x6020
            add di,2
            loop Aupper

        mov cx,5
        mov di,(4*160+46)
        Aleft:
            mov word[es:di], 0x6020
            add di,160
            loop Aleft

        mov cx,5
        mov di,(4*160+54)
        ARight:
            mov word[es:di], 0x6020
            add di,160
            loop ARight
        
        mov cx,4
        mov di,(7*160+46)
        ACenter:
            mov word[es:di], 0x6020
            add di,2
            loop ACenter

    P1:
        mov cx, 5
        mov di,(4*160+24+2*17)
        leftP:
            mov word[es:di], 0x6020
            add di,160
            loop leftP
        
        mov cx,4
        mov di,(4*160+24+2*17)
        upperP:
            mov word[es:di], 0x6020
            add di,2
            loop upperP
        
        mov cx, 2
        mov di,(3*160+24+2*172+2*8)
        RightP:
            mov word[es:di], 0x6020
            add di,160
            loop RightP

        sub di,160
        LowerP:
            sub di,2
            mov word[es:di],0x6020
            sub di,2
            mov word[es:di],0x6020

    P2:
        mov cx, 5
        mov di,(4*160+24+2*17+2*5)
        leftP2:
            mov word[es:di], 0x6020
            add di,160
            loop leftP2
        
        mov cx,4
        mov di,(4*160+24+2*17+2*5)
        upperP2:
            mov word[es:di], 0x6020
            add di,2
            loop upperP2
        
        mov cx, 2
        mov di,(3*160+24+2*172+2*8+2*5)
        RightP2:
            mov word[es:di], 0x6020
            add di,160
            loop RightP2
            
        sub di,160
        LowerP2:
            sub di,2
            mov word[es:di],0x6020
            sub di,2
            mov word[es:di],0x6020

    Y:
        mov cx, 3
        mov di,(4*160+24+2*17+2*5+2*5)
        leftslant:
            mov word[es:di], 0x6020
            add di,162
            loop leftslant

        mov cx, 2
        mov di,(4*160+24+2*17+2*5+2*9)
        Righslant:
            mov word[es:di], 0x6020
            add di,158
            loop Righslant


        mov cx, 2
        mov di, (7*160+24+2*17+2*5+2*7)
        centerline:
        mov word[es:di], 0x6020
            add di,160
            loop centerline

    B:
        mov cx, 5
        mov di,(4*160+24+2*17+2*20)
        leftB:
            mov word[es:di], 0x6020
            add di,160
            loop leftB

        mov cx, 3
        mov di, (4*160+24+2*17+2*20)
        UpperB:
            mov word[es:di], 0x6020
            add di, 2
            loop UpperB

        add di, 160
        mov word[es:di], 0x6020
        add di, 160
        
        mov cx,3
        midB:
        sub di,2
        mov word[es:di], 0x6020
        loop midB

        add di, 6
        add di, 160
        mov word[es:di], 0x6020
        mov cx,2
        add di, 160
        lowerB:
        sub di, 2
        mov word[es:di], 0x6020  
        loop lowerB

    I:
        mov cx, 5
        mov di,(4*160+24+2*17+2*26)
        printI:
            mov word[es:di], 0x6020
            add di,160
            loop printI

    R:
        mov cx, 5
        mov di,(4*160+24+2*17+2*28)
        LeftR:
            mov word[es:di], 0x6020
            add di,160
            loop LeftR

        mov cx, 3
        mov di, (4*160+24+2*17+2*28)
        UpperR:
            mov word[es:di], 0x6020
            add di, 2
            loop UpperR

        add di, 160
        mov word[es:di], 0x6020
        add di, 160
        
        mov cx,3
        midR:
        sub di,2
        mov word[es:di], 0x6020
        loop midR
        add di, 6
        add di, 160
        mov word[es:di], 0x6020
        add di, 160
        mov word[es:di], 0x6020
    
    D:
        mov cx, 5
        mov di,(4*160+24+2*17+2*33)
        LeftD:
            mov word[es:di], 0x6020
            add di,160
            loop LeftD
        
        mov cx, 4
        mov di,(4*160+24+2*17+2*33)
        upperD:
            mov word[es:di], 0x6020
            add di, 2
            loop upperD
        
        mov cx,3
        rightsideD:
        add di,160
        mov word[es:di], 0x6020
        loop rightsideD

        add di,160
        mov cx, 3
        
        lowerD:
        sub di, 2
        mov word[es:di], 0x6020
        loop lowerD
	
	pop es
	pop si
	pop di
	pop dx
	pop cx
	pop bx
	pop ax
	ret

;----------------------------------------------------------------------------
startStringPrint:
	push ax
    push bx
    push cx
	push dx
	push di
	push es
	push bp

    mov ax, 0xb800
    mov es, ax
	; Start String of the Main Screen::: String
	mov  ah, 0x13         
	mov  al, 0             
	mov  bh, 0            
	mov  bl, 0x06
	mov  dx, 0x0e19
	mov  cx, 25        	; length 
	push cs 
	pop  es                 
	mov  bp, startString   
	int  0x10
	
	; Exit String
	mov  dx, 0x111d
	mov  cx, 17        	; length                
	mov  bp, exitString   
	int  0x10
	
	; Names String
	mov  bl, 0x30
	mov  dx, 0x1410
	mov  cx, 46        	; length            
	mov  bp, myself
	int  0x10
	
	pop bp
    pop es
    pop di
	pop dx
    pop cx
    pop bx
	pop ax
    ret
	ret

;End of Start Screen--------------------------------------------------------------------------------------


delay:
	push bp
	mov bp, sp
	push cx
	push bx
	mov bx, [bp+4]
	checkDelayAgain:
		mov cx, 0xffff
		delayAgain:
			dec cx
			jnz delayAgain
		dec bx
		jnz checkDelayAgain
	
	pop bx
	pop cx
	pop bp
	ret 2

printnum2:     push bp 		; for the ending screen score print
              mov  bp, sp 
              push es 
              push ax 
              push bx 
              push cx 
              push dx 
              push di 
              mov  ax, 0xb800 
              mov  es, ax             ; point es to video base 
              mov  ax, [bp+4]         ; load number in ax 
              mov  bx, 10             ; use base 10 for division 
              mov  cx, 0              ; initialize count of digits 
	nextdigit2:
		mov  dx, 0              ; zero upper half of dividend 
		div  bx                 ; divide by 10 
		add  dl, 0x30           ; convert digit into ascii value 
		push dx                 ; save ascii value on stack 
		inc  cx                 ; increment count of values  
		cmp  ax, 0              ; is the quotient zero 
		jnz  nextdigit2          ; if no divide it again 
		mov  di, [bp+6]			  ; point di to the screen index
			  
		nextpos2:
			pop  dx       ; remove a digit from the stack 
			mov ax, word[es:di]
			mov  dh, 07          ; use normal attribute 
			mov [es:di], dx         ; print char on screen 
			add  di, 2              ; move to next screen location 
			loop nextpos2          ; repeat for all digits on stack
 
        pop  di 
        pop  dx 
        pop  cx 
        pop  bx 
        pop  ax 
        pop  es 
		pop  bp 
        ret  4 

printnum:     push bp 
              mov  bp, sp 
              push es 
              push ax 
              push bx 
              push cx 
              push dx 
              push di 
              mov  ax, 0xb800 
              mov  es, ax             ; point es to video base 
              mov  ax, [bp+4]         ; load number in ax 
              mov  bx, 10             ; use base 10 for division 
              mov  cx, 0              ; initialize count of digits 
	nextdigit:
		mov  dx, 0              ; zero upper half of dividend 
		div  bx                 ; divide by 10 
		add  dl, 0x30           ; convert digit into ascii value 
		push dx                 ; save ascii value on stack 
		inc  cx                 ; increment count of values  
		cmp  ax, 0              ; is the quotient zero 
		jnz  nextdigit          ; if no divide it again 
		mov  di, [bp+6]			  ; point di to the screen index
			  
		nextpos:
			pop  dx       ; remove a digit from the stack 
			mov ax, word[es:di]
			mov  dh, ah          ; use normal attribute 
			mov [es:di], dx         ; print char on screen 
			add  di, 2              ; move to next screen location 
			loop nextpos            ; repeat for all digits on stack
 
        pop  di 
        pop  dx 
        pop  cx 
        pop  bx 
        pop  ax 
        pop  es 
		pop  bp 
        ret  4 

;-----------------------------------------------------------
getRandomFromList:
	push bp
	mov bp, sp
    push bx
    push cx
    push dx
    
    ; Use system timer ticks for randomization
    mov ah, 0x00        ; Get system timer ticks
    int 1Ah             ; CX:DX = tick count
    
    mov ax, dx          ; Use lower word of tick count
    xor dx, dx          ; Clear DX for division
    mov bx, random_size ; Get size of list
    div bx              ; Divide by list size (DX = remainder)
    
    mov bx, dx          ; Move remainder (index) to BX
    add bx, bx          ; Multiply by 2 for word offset
    mov ax, [random + bx] ; Get the number at that index
    mov [bp+4], ax
	
    pop dx
    pop cx
    pop bx
	pop bp
    ret

;-----------------------------------------------------------------------------------
backGround:
	push di
	push ax
	push bx
	push cx
	push dx
	push di
	mov ax, 0xb800 ; load video base in ax
	mov es, ax ; point es to video base
	mov di, 0 ; point di to top left column
 
	blue: 
		mov word[es:di], 0x3020 
		add di, 2 
		cmp di, 3520 
		jne blue 
	ground1:
		mov word[es:di], 0x2020 
		add di, 2 
		cmp di, 3680 
		jne ground1 
	ground2:
		mov word[es:di], 0x6020 
		add di, 2 
		cmp di, 4000 
		jne ground2
		
	mov di, 3680
	randomItems:
		mov word[es:di], 0x684f 
		add di, 28 
		cmp di, 3840
		jnae randomItems
		
	mov di, 3852
	randomItems2:
		mov word[es:di], 0x6851 
		add di, 28 
		cmp di, 4000
		jnae randomItems2
	pop di
	pop dx
	pop cx
	pop bx
	pop ax
	pop es
	ret

;------------------------------------------------------------------------
cloud:
	push bp
	mov bp, sp
	push ax
	push cx
	push dx
	push di
	push es
	mov ax, 0xb800
	mov es, ax ; point es to video base
	mov di, [bp + 4]
	mov ax, 0x38b2
	mov dx, 0x380f
	c1:
		cld
		mov word[es:di], ax
		add di, 2
		mov word[es:di], ax
		add di, 154
		mov cx, 6
		rep stosw
		add di, 144
		mov word[es:di], dx
		add di, 2
		mov cx, 8
		rep stosw
		mov word[es:di], dx
	
	pop es
	pop di
	pop dx
	pop cx
	pop ax
	pop bp
	ret
;-----------------------------------------------------------------
; Subroutine to load all the elements in dosbox to the buffer
loadBG:
	push ax
    push cx
    push di
    push si
    push ds
    push es
    
    mov ax, 0xb800      ; Video memory segment
	push ds
	pop es
    mov ds, ax          ; ES points to video memory
    mov di, bgBuffer    ; DI points to destination buffer (NASM syntax)
    mov si, 0           ; SI points to start of video memory
    mov cx, 1840        ; Counter for 2000 words (full screen)
    
    cld                 ; Clear direction flag (forward copying)
	mov word [ds:si], ax
    rep movsw           ; Copy CX words from DS:SI to ES:DI
	
    pop es
    pop ds
    pop si
    pop di
    pop cx
    pop ax
    ret
	
restoreBgAll:
	push ax
    push cx
    push di
    push si
    push ds
    push es
    
    mov ax, 0xb800      ; Video memory segment
    mov es, ax          ; ES points to video memory
    mov si, bgBuffer    ; DI points to destination buffer (NASM syntax)
    mov di, 0           ; SI points to start of video memory
    mov cx, 1840        ; Counter for 2000 words (full screen)
    
    cld                 ; Clear direction flag (forward copying)
    rep movsw           ; Copy CX words from DS:SI to ES:DI
    
    pop es
    pop ds
    pop si
    pop di
    pop cx
    pop ax
    ret

;--------------------------------------------------------------------------------
specialPillar:
	push bp
	mov bp, sp
	push ax
	push bx
	push cx
	push dx
	push di
	push si
	push es
	
	mov dx, [bp+4]		; index of the pillar
	mov cx, [bp+6]		; height of the upper pillar
	
	mov di, dx
	cmp di, 0
	jnl diNotZero	 
	mov di, 0
	diNotZero:			; di = 0, if index in neg
		add di, di
		cmp dx, 79
		jnz near sp2
	; only left border
	inc cx
	sp1:
		mov word[es:di], 0x0020
		add di, 2
		mov si, di
		mov ax, [bgBuffer+si]			; restore BG value from buffer
		mov word[es:di], ax
		sub di, 2
		add di, 160
		loop sp1
		
		add di, 1120
		mov word[es:di], 0x0020
		add di, 2
		mov si, di
		mov ax, [bgBuffer+si]			; restore BG value from buffer
		mov word[es:di], ax
		sub di, 2
		add di, 160
		mov cx, 22
		sub cx, 9
		mov ax, [bp+6]
		sub cx, ax
		sp1b:
			mov word[es:di], 0x0020
			add di, 2
			mov si, di
			mov ax, [bgBuffer+si]			; restore BG value from buffer
			mov word[es:di], ax
			sub di, 2
			add di, 160
			loop sp1b
		cmp dx, -7
		jnz near endSp
		mov cx, 22
		mov di, 0
		restoreFirsCol:
			mov si, di
			mov ax, [bgBuffer+si]
			mov word[es:di], ax
			mov ax, [bgBuffer+si]
			mov word[es:di+2], ax
			add di, 160
			loop restoreFirsCol
		
		jmp endSp
	
	; only right border
	sp2:
		cmp dx, -7
		jz sp1
		cmp dx, 0
		jl near sp4
	;left border with inner part as well
	sp3:
		push cx
		mov word[es:di], 0x0020
		add di, 2
		mov cx, 79
		sub cx, dx
		mov bx, cx			; the inner width in bx
		mov ax, 0x2020
		rep stosw
		add di, 2
		mov si, di
		mov ax, [bgBuffer+si]			; restore BG value from buffer
		mov word[es:di], ax
		sub di, 2
		add di, 158
		shl bx, 1
		sub di, bx
		pop cx
		loop sp3
			
		mov word[es:di], 0x0020
		add di, 2
		mov cx, 79
		sub cx, dx
		mov bx, cx			; the inner width in bx
		mov ax, 0x20dc
		rep stosw
		add di, 2
		mov si, di
		mov ax, [bgBuffer+si]			; restore BG value from buffer
		mov word[es:di], ax
		sub di, 2
		
		add di, 158
		shl bx, 1
		sub di, bx
		
		; lower Part of sp3
		add di, 1120
		mov word[es:di], 0x0020
		add di, 2
		mov cx, 79
		sub cx, dx
		mov bx, cx			; the inner width in bx
		mov ax, 0x20df
		rep stosw
		add di, 2
		mov si, di
		mov ax, [bgBuffer+si]			; restore BG value from buffer
		mov word[es:di], ax
		sub di, 2
		add di, 158
		shl bx, 1
		sub di, bx
		
		mov cx, 22
		sub cx, 9
		mov ax, [bp+6]
		sub cx, ax
		sp3b:
			push cx
			mov word[es:di], 0x0020
			add di, 2
			mov cx, 79
			sub cx, dx
			mov bx, cx			; the inner width in bx
			mov ax, 0x2020
			rep stosw
			add di, 2
			mov si, di
			mov ax, [bgBuffer+si]			; restore BG value from buffer
			mov word[es:di], ax
			sub di, 2
			add di, 158
			shl bx, 1
			sub di, bx
			pop cx
			loop sp3b
		jmp endSp
	; RIGHT border with inner part as well
	sp4:
		push cx
		mov cx, 7
		add cx, dx
		mov bx, cx			; the inner width in bx
		mov ax, 0x2020
		rep stosw
		mov word[es:di], 0x0020
		add di, 2
		mov si, di
		mov ax, [bgBuffer+si]			; restore BG value from buffer
		mov word[es:di], ax
		sub di, 2
		add di, 160
		shl bx, 1
		sub di, bx
		pop cx
		loop sp4
			
		mov cx, 7
		add cx, dx
		mov bx, cx			; the inner width in bx
		mov ax, 0x20dc
		rep stosw
		mov word[es:di], 0x0020
		add di, 2
		mov si, di
		mov ax, [bgBuffer+si]			; restore BG value from buffer
		mov word[es:di], ax
		sub di, 2
		
		add di, 160
		shl bx, 1
		sub di, bx
		
		; lower Part of sp3
		add di, 1120		; Gap in a pillar (7 rows)
		mov cx, 7
		add cx, dx
		mov bx, cx			; the inner width in bx
		mov ax, 0x20df
		rep stosw
		mov word[es:di], 0x0020
		add di, 2
		mov si, di
		mov ax, [bgBuffer+si]			; restore BG value from buffer
		mov word[es:di], ax
		sub di, 2
		add di, 160
		shl bx, 1
		sub di, bx
		
		mov cx, 22
		sub cx, 9
		mov ax, [bp+6]		; height of the upper pillar
		sub cx, ax
		sp4b:
			push cx
			mov cx, 7
			add cx, dx
			mov bx, cx			; the inner width in bx
			mov ax, 0x2020
			rep stosw
			mov word[es:di], 0x0020
			add di, 2
			mov si, di
			mov ax, [bgBuffer+si]			; restore BG value from buffer
			mov word[es:di], ax
			sub di, 2
			add di, 160
			shl bx, 1
			sub di, bx
			pop cx
			loop sp4b
		jmp endSp
		
	endSp:
	pop es
	pop si
	pop di
	pop dx
	pop cx
	pop bx
	pop ax
	pop bp
	ret 4


;---------------------------------------------------------------------
pillarPrint:
    push ax
	push bx
	push cx
	push dx
	push di
	push si
	push es
	push ds
	
	mov ax, 0xb800
	mov es, ax
	mov di, [pillarsIndex]			; index of the first pillar
	add di, di						; times two index
	
	mov dx, [pillarsIndex]
	cmp dx, 79
	jg near noPrint1
	cmp dx, 79
	jnz notRandom1
	push ax
	call getRandomFromList
	pop ax
	mov word[pillarsRandomHeight], ax
	notRandom1:
		mov ax, [pillarsRandomHeight]
	; Upper Part of the pillar
	mov cx, ax
	cmp dx, 72
	jl check1Again
	push cx
	push dx
	call specialPillar
	jmp endOfP1
	check1Again:
		cmp dx, -1
		jg obsColAgain
		push cx
		push dx
		call specialPillar
		jmp endOfP1
		
	obsColAgain:
		push cx
		mov word[es:di], 0x0020
		add di, 2
		mov cx, 6
		mov ax, 0x2020
		rep stosw
		mov word[es:di], 0x0020
		add di, 2
		mov si, di
		mov ax, [bgBuffer+si]			; restore BG value from buffer
		mov word[es:di], ax
		sub di, 2
		add di, 146
		pop cx
		loop obsColAgain
	mov ax, 0x20dc
	mov word[es:di], 0x0020
	add di, 2
	mov cx, 6
	rep stosw
	mov word[es:di], 0x0020
	add di, 2
	mov si, di
	mov ax, [bgBuffer+si]			; restore BG value from buffer
	mov word[es:di], ax
	sub di, 2
	add di, 146
	
	;lower Part
	add di, 1120		; Gap of 7 rows
	mov word[es:di], 0x0020
	add di, 2
	mov cx, 6
	mov ax, 0x20df
	rep stosw
	mov word[es:di], 0x0020
	add di, 2
	mov si, di
	mov ax, [bgBuffer+si]			; restore BG value from buffer
	mov word[es:di], ax
	sub di, 2
	add di, 146
	mov cx, 22		; 22 rows with the blue backGround
	sub cx, 9
	mov ax, [pillarsRandomHeight]
	sub cx, ax
	obsColAgain2:
		push cx
		mov word[es:di], 0x0020
		add di, 2
		mov cx, 6
		mov ax, 0x2020
		rep stosw
		mov word[es:di], 0x0020
		add di, 2
		mov si, di
		mov ax, [bgBuffer+si]			; restore BG value from buffer
		mov word[es:di], ax
		sub di, 2
		add di, 146
		pop cx
		loop obsColAgain2
	endOfP1:
		cmp dx, -7
		jnz noPrint1
		mov word[pillarsIndex], 102
		
	
	; Second Pillar
	noPrint1:
	mov di, [pillarsIndex+2]
	add di, di			; times two index
	
	mov dx, [pillarsIndex+2]
	cmp dx, 79
	jg near noPrint2
	cmp dx, 79
	jnz notRandom2
	push ax
	call getRandomFromList
	pop ax
	mov word[pillarsRandomHeight+2], ax
	notRandom2:
		mov ax, [pillarsRandomHeight+2]
	; Upper Part of the second pillar
	mov cx, ax
	cmp dx, 72
	jl check2Again
	push cx
	push dx
	call specialPillar
	jmp endOfP2
	check2Again:
		cmp dx, -1
		jg obsColAgainb			; Go to normal print, if index is in between 0 and 72
		push cx
		push dx
		call specialPillar
		jmp endOfP2
	
	obsColAgainb:
		push cx
		mov word[es:di], 0x0020
		add di, 2
		mov cx, 6
		mov ax, 0x2020
		rep stosw
		mov word[es:di], 0x0020
		add di, 2
		mov si, di
		mov ax, [bgBuffer+si]			; restore BG value from buffer
		mov word[es:di], ax
		sub di, 2
		add di, 146
		pop cx
		loop obsColAgainb
	mov ax, 0x20dc
	mov word[es:di], 0x0020
	add di, 2
	mov cx, 6
	rep stosw
	mov word[es:di], 0x0020
	add di, 2
	mov si, di
	mov ax, [bgBuffer+si]			; restore BG value from buffer
	mov word[es:di], ax
	sub di, 2
	add di, 146
	
	;lower Part of the second Pillar
	add di, 1120			; Gap of 7 rows
	mov word[es:di], 0x0020
	add di, 2
	mov cx, 6
	mov ax, 0x20df
	rep stosw
	mov word[es:di], 0x0020
	add di, 2
	mov si, di
	mov ax, [bgBuffer+si]			; restore BG value from buffer
	mov word[es:di], ax
	sub di, 2
	add di, 146
	mov cx, 22		; 22 rows with the blue backGround
	sub cx, 9
	mov ax, [pillarsRandomHeight+2]
	sub cx, ax
	obsColAgain2b:
		push cx
		mov word[es:di], 0x0020
		add di, 2
		mov cx, 6
		mov ax, 0x2020
		rep stosw
		mov word[es:di], 0x0020
		add di, 2
		mov si, di
		mov ax, [bgBuffer+si]			; restore BG value from buffer
		mov word[es:di], ax
		sub di, 2
		add di, 146
		pop cx
		loop obsColAgain2b
	endOfP2:
		cmp dx, -7
		jnz noPrint2
		mov word[pillarsIndex+2], 102		; reset the index
	
	
	noPrint2:
	mov di, [pillarsIndex+4]
	add di, di			; times two index
	
	mov dx, [pillarsIndex+4]
	cmp dx, 79
	jg near endOfPrint
	cmp dx, 79
	jnz notRandom3
	push ax
	call getRandomFromList
	pop ax
	mov word[pillarsRandomHeight+4], ax
	notRandom3:
		mov ax, [pillarsRandomHeight+4]
	; Upper Part of the second pillar
	mov cx, ax
	cmp dx, 72
	jl check3Again
	push cx
	push dx
	call specialPillar
	jmp endOfP3
	check3Again:
		cmp dx, -1
		jg obsColAgainc				; Go to normal print, if index is in between 0 and 72
		push cx
		push dx
		call specialPillar
		jmp endOfP3
	
	obsColAgainc:
		push cx
		mov word[es:di], 0x0020
		add di, 2
		mov cx, 6
		mov ax, 0x2020
		rep stosw
		mov word[es:di], 0x0020
		add di, 2
		mov si, di
		mov ax, [bgBuffer+si]			; restore BG value from buffer
		mov word[es:di], ax
		sub di, 2
		add di, 146
		pop cx
		loop obsColAgainc
	mov ax, 0x20dc
	mov word[es:di], 0x0020
	add di, 2
	mov cx, 6
	rep stosw
	mov word[es:di], 0x0020
	add di, 2
	mov si, di
	mov ax, [bgBuffer+si]			; restore BG value from buffer
	mov word[es:di], ax
	sub di, 2
	add di, 146
	
	;lower Part of the second Pillar
	add di, 1120			; Gap of 7 rows
	mov word[es:di], 0x0020
	add di, 2
	mov cx, 6
	mov ax, 0x20df
	rep stosw
	mov word[es:di], 0x0020
	add di, 2
	mov si, di
	mov ax, [bgBuffer+si]			; restore BG value from buffer
	mov word[es:di], ax
	sub di, 2
	add di, 146
	mov cx, 22		; 22 rows with the blue backGround
	sub cx, 9
	mov ax, [pillarsRandomHeight+4]
	sub cx, ax
	obsColAgain2c:
		push cx
		mov word[es:di], 0x0020
		add di, 2
		mov cx, 6
		mov ax, 0x2020
		rep stosw
		mov word[es:di], 0x0020
		add di, 2
		mov si, di
		mov ax, [bgBuffer+si]			; restore BG value from buffer
		mov word[es:di], ax
		sub di, 2
		add di, 146
		pop cx
		loop obsColAgain2c
	endOfP3:
		cmp dx, -7
		jnz endOfPrint
		mov word[pillarsIndex+4], 102		; reset the index
	
	endOfPrint:
	pop ds
	pop es
	pop si
	pop di
	pop dx
	pop cx
	pop bx
	pop ax
	ret	

;---------------------------------------------------------------------------------------
bird:
    push ax
    push bx
    push cx
    push di
	push si
    push es
	push ds

	mov ax, 0xb800
	mov es, ax
	mov di, 60			; 30th COlumn
	
	cmp word[birdRowIndex], 20
	jl noTouchGround
	mov word[collisions], 1
	
	noTouchGround:
		mov ax, 160
		mul word[birdRowIndex]
		add di, ax
	
	mov word[es:di], 0x1020
	add di, 2
	mov word[es:di], 0x1020
	add di, 2
	mov word[es:di], 0x1020
	add di, 2
	mov word[es:di], 0x9f04
	add di, 154
	
	mov word[es:di], 0x1f2f
	add di, 2
	mov word[es:di], 0x1f2f
	add di, 2
	mov word[es:di], 0x1020
	add di, 2
	mov word[es:di], 0x1c11
	
	mov di, 60
	mov ax, 160
	mul word[birdRowIndex]
	add di, ax
	
	cmp word[birdStill], 0
	je checkForFlag
	;dec word[birdStill]
	
	
	checkForFlag:
		cmp word[birdFlag], 1
		jne upClear
		downClear:
			add di, 320
			mov cx, 4
			birdDownClearLoop:
				mov si, di
				mov ax, [bgBuffer+si]
				stosw
				loop birdDownClearLoop
			jmp endOfBird
			
		upClear:
			cmp word[birdStill], 0
			jg endOfBird
			cmp word[birdFlag], 0
			jne endOfBird
			sub di, 160
			mov cx, 4
			birdUpClearLoop:
				mov si, di
				mov ax, [bgBuffer+si]
				stosw
				loop birdUpClearLoop
			; add di, 160
			; mov si, di
			; mov ax, [bgBuffer+si]
			; stosw
		
		
	endOfBird:
	pop ds
	pop es
	pop si
	pop di
	pop cx
	pop bx
	pop ax
	ret
	
;-----------------------------------------------------------------------------	
deadBird:
    push ax
    push bx
    push cx
    push di
	push si
    push es
	push ds

	mov ax, 0xb800
	mov es, ax
	mov di, 60			; 30th COlumn
	
	mov ax, 160
	mul word[birdRowIndex]
	add di, ax
	
	mov word[es:di], 0x1e21
	add di, 2
	mov word[es:di], 0x1020
	add di, 2
	mov word[es:di], 0x1020
	add di, 2
	mov word[es:di], 0x1c04
	add di, 154
	
	mov word[es:di], 0x1f2f
	add di, 2
	mov word[es:di], 0x1f2f
	add di, 2
	mov word[es:di], 0x1020
	add di, 2
	mov word[es:di], 0x1711
	
	mov di, 60
	mov ax, 160
	mul word[birdRowIndex]
	add di, ax
		
	endOfDeadBird:
		pop ds
		pop es
		pop si
		pop di
		pop cx
		pop bx
		pop ax
	ret

;-----------------------------------------------------------
movGround:
	push ax
	push cx
	push di
	push si
	push es
	push ds
	
	mov ax, 0xb800
	mov es, ax
	mov ds, ax
	mov di, 3680
	mov si, 3682
	
	push word[es:di]
	mov cx, 79
	rep movsw
	pop ax
	stosw
	mov si, di
	add si, 2
	push word[es:di]
	mov cx, 79
	rep movsw
	pop ax
	stosw
	
	pop ds
	pop es
	pop si
	pop di
	pop cx
	pop ax
	ret

;-------------------------------------------------------------------------
movPillar:
	push ax
	
	dec word[pillarsIndex]
	dec word[pillarsIndex+2]
	dec word[pillarsIndex+4]
	call pillarPrint
	
	
	call pillarPrint			
	
	pop ax
	ret

;----------------------------------------------------------------------------------------------
movBird:
	push ax
	
	dec word[birdDelay]
	mov ax, [birdDelay]
	cmp ax, 0
	jg noBirdMove
	
	cmp word[birdFlag], 0
	jne movUp
	
	cmp word[birdStill], 0
	jg noBirdMove
	
	cmp word[birdRowIndex], 20
	jge noBirdRowDec
	inc word[birdRowIndex]
	jmp noBirdRowDec
	movUp:
		cmp word[birdRowIndex], 0
		jle noBirdRowDec
		dec word[birdRowIndex]
		
		noBirdRowDec:
			mov word[birdDelay], 2
	
	noBirdMove:
		call bird
		mov word[birdFlag], 0
	
	pop ax
	ret

;--------------------------------------------------------------------------------------
checkScore:
	cmp word[pillarsIndex], 22
	jne checkScorePillar2
	inc word[score]
	
	checkScorePillar2:
		cmp word[pillarsIndex+2], 22
		jne checkScorePillar3
		inc word[score]
	
	checkScorePillar3:
		cmp word[pillarsIndex+4], 22
		jne noAddScore
		inc word[score]
	
	noAddScore:
		push 78					; di value of score
		push word[score]
		call printnum
		ret

;-------------------------------------------------------------------------------------

pauseFun:
	push ax
	sti
	mov ah, 0
	int 16h
	mov ah, 0
	int 16h
	
	push 20
	push 99
	call printnum
	pop ax
	ret
	
;-------------------------------------------------------------------------------------

changeFlag:
	push ax
	push bx
	push cx
	push dx
	push es
	push bp
	
	cmp word [collisions], 0
	jg near noChangeFlag

	in al, 60h
	
	cmp byte[cs:pauseF], 1
	jne takeUpKey
	cmp al, 19h			; P scan code
	je pauseFlag
	
	cmp al, 12h
	jne near noChangeFlag
	inc word[collisions]
	jmp pauseFlag
	
	takeUpKey:
	cmp byte [cs:pauseF], 0
	jne noChangeFlag
	cmp al, 01h			; scan code for the Escape
	je pauseFlag
	cmp al, 48h				; scan code of up key
	jne noChangeFlag
	mov word[cs:birdFlag], 1
	mov word[cs:birdStill], 11		; ticks to keep bird still after UP

	jmp noChangeFlag
	
	pauseFlag:
		xor byte [cs:pauseF], 1
		push cs
		pop ds
		cmp byte [cs:pauseF], 1
		jne restoreInBufferOfPause
		storeInBufferOfPause:
			push ax
			push cx
			push di
			push si
			push ds
			push es
			
			mov ax, 0xb800      ; Video memory segment
			push ds
			pop es
			mov ds, ax          ; ES points to video memory
			mov di, pauseBuffer    ; DI points to destination buffer (NASM syntax)
			mov si, 1656           ; SI points to start of video memory
			mov cx, 30        ; Counter for 2000 words (full screen)
			
			cld                 ; Clear direction flag (forward copying)
			
			; mov word [ds:si], ax
			rep movsw           ; Copy CX words from DS:SI to ES:DI
			pop es
			pop ds
			pop si
			pop di
			pop cx
			pop ax
			; Text Pause Print with the int
			mov  ah, 0x13         
			mov  al, 0             
			mov  bh, 0            
			mov  bl, 0x47
			mov  dx, 0x096c
			mov  cx, 30             
			push cs 
			pop  es                 
			mov  bp, pauseString     
			int  0x10
			jmp noChangeFlag
		
		restoreInBufferOfPause:
			; hooking timer again again
			; xor ax, ax
			; mov es, ax
			; cli                    
			; mov  word [es:8*4], timerStill
			; mov  [es:8*4+2], cs   
			; sti
			push ax
			push cx
			push di
			push si
			push ds
			push es
			
			mov ax, 0xb800      ; Video memory segment
			mov es, ax          ; ES points to video memory
			mov si, pauseBuffer ; DI points to destination buffer (NASM syntax)
			mov di, 1656           ; SI points to start of video memory
			mov cx, 30        ; Counter for 2000 words (full screen)
			
			cld                 ; Clear direction flag (forward copying)
			rep movsw           ; Copy CX words from DS:SI to ES:DI
			
			pop es
			pop ds
			pop si
			pop di
			pop cx
			pop ax
			
	noChangeFlag:
		pop bp
		pop es
		pop dx
		pop cx
		pop bx
		pop ax
		jmp far[cs:oldINT9hisr]
	
;--------------------------------------------------------
checkCollision:
	push bx
	
	cmp word[pillarsIndex], 34		; actual 34 col nmbr
	jg checkCollision2
	cmp word[pillarsIndex], 23
	jl checkCollision2
	mov bx, word[pillarsRandomHeight]
	inc bx
	cmp word[birdRowIndex], bx
	jle incCollision
	
	add bx, 5
	cmp word[birdRowIndex], bx		; check for the lower pillar
	jge incCollision
	
	checkCollision2:
		cmp word[pillarsIndex+2], 34		; actual 34 col nmbr
		jg checkCollision3
		cmp word[pillarsIndex+2], 23
		jl checkCollision3
		mov bx, word[pillarsRandomHeight+2]
		inc bx
		cmp word[birdRowIndex], bx
		jle incCollision
		
		add bx, 5
		cmp word[birdRowIndex], bx		; check for the lower pillar
		jge incCollision
	
	checkCollision3:
		cmp word[pillarsIndex+4], 34		; actual 34 col nmbr
		jg justCollisionEnd
		cmp word[pillarsIndex+4], 23
		jl justCollisionEnd
		mov bx, word[pillarsRandomHeight+4]
		inc bx
		cmp word[birdRowIndex], bx
		jle incCollision
		
		add bx, 5
		cmp word[birdRowIndex], bx		; check for the lower pillar
		jge incCollision
	jmp justCollisionEnd

	incCollision:
		inc word[collisions]
		
	justCollisionEnd:
		pop bx
		ret


;---------------------------------------------------------------------------------------
animate:
	cmp byte [cs:pauseF], 0
	jne exitAnimate
	call movGround
	call movBird
	call movPillar
	call checkScore
	call checkCollision
	exitAnimate:
	ret

;---------------------------------------------------------------------------------

deadBirdAnimate:
	call deadBird
	push 10
	call delay
	mov word[birdFlag], 0
	mov word[birdStill], 0
	mov word[birdDelay], 0
	call movBird
	call deadBird
	
	push 1
	call delay
	call movBird
	call deadBird
	
	mov cx, 20
	sub cx, word[birdRowIndex]
	deadBirdLoop:
		push 1
		call delay
		call movBird
		call pillarPrint
		call deadBird
		cmp word[birdRowIndex], 20
		jl deadBirdLoop
	
	ret

;----------------------------------------------------------------------------------
timerStill:
push ds
    push bx
    push cs
    pop ds ; initialize ds to data segment
    
    dec word[cs:birdStill]



    mov bx, [current] ; read index of current in bx
    shl bx, 1
    shl bx, 1
    shl bx, 1
    shl bx, 1
    shl bx, 1 ; multiply by 32 for pcb start

    mov [pcb+bx+0], ax ; save ax in current pcb
    mov [pcb+bx+4], cx ; save cx in current pcb
    mov [pcb+bx+6], dx ; save dx in current pcb
    mov [pcb+bx+8], si ; save si in current pcb
    mov [pcb+bx+10], di ; save di in current pcb
    mov [pcb+bx+12], bp ; save bp in current pcb
    mov [pcb+bx+24], es ; save es in current pcb
    pop ax ; read original bx from stack
    mov [pcb+bx+2], ax ; save bx in current pcb
    pop ax ; read original ds from stack
    mov [pcb+bx+20], ax ; save ds in current pcb
    pop ax ; read original ip from stack
    mov [pcb+bx+16], ax ; save ip in current pcb
    pop ax ; read original cs from stack
    mov [pcb+bx+18], ax ; save cs in current pcb
    pop ax ; read original flags from stack
    mov [pcb+bx+26], ax ; save flags in current pcb
    mov [pcb+bx+22], ss ; save ss in current pcb
    mov [pcb+bx+14], sp ; save sp in current pcb
    
    mov bx, [pcb+bx+28] ; read next pcb of this pcb
    mov [current], bx ; update current to new pcb
    mov cl, 5
    shl bx, cl ; multiply by 32 for pcb start
    
    mov cx, [pcb+bx+4] ; read cx of new process
    mov dx, [pcb+bx+6] ; read dx of new process
    mov si, [pcb+bx+8] ; read si of new process
    mov di, [pcb+bx+10] ; read diof new process
    mov bp, [pcb+bx+12] ; read bp of new process
    mov es, [pcb+bx+24] ; read es of new process
    mov ss, [pcb+bx+22] ; read ss of new process
    mov sp, [pcb+bx+14] ; read sp of new process
    push word [pcb+bx+26] ; push flags of new process
    push word [pcb+bx+18] ; push cs of new process
    push word [pcb+bx+16] ; push ip of new process
    push word [pcb+bx+20] ; push ds of new process

    ; mov al, 0x20
    ; out 0x20, al

    mov ax, [pcb+bx+0] ; read ax of new process
    mov bx, [pcb+bx+2] ; read bx of new process
    pop ds ; read ds of new process
			
	jmp far[cs:oldINT8hisr]
	
	
;iret ; return to new process

;----------------------------------------------------------------------------------------

tasktwo:
	cmp byte [cs:playMusic], 0
	je exitTaskTwo
	
    ; Prepare timer 2 for sound generation
    mov al, 0b6h
    out 43h, al
    ; Softer, gentler celebratory tones
    mov cx, 3              ; 3 ascending notes
    celebration_loop:
        ; Lower frequency, more melodic
        mov ax, 0x2000         ; Even lower base frequency
        shr ax, cl             ; Gentle ascending progression
        out 42h, al
        mov al, ah
        out 42h, al
    
        ; Turn speaker on
        in al, 61h
        or al, 3h
        out 61h, al
    
        ; Slightly longer soundelay for softer sound
        mov dx, cx
        mov cx, 5
        
        tone_delay:
                        mov bx, cx
                mov cx, 0xFFFF
            delay_loop:
                loop delay_loop
                mov cx, bx
            loop tone_delay
        
        mov cx, dx
    
        loop celebration_loop
    
    ; Turn speaker off
    in al, 61h
    and al, 0FCh
    out 61h, al
	exitTaskTwo:
jmp tasktwo
		
;----------------------------------------------------------------------------------------
	; Main
start:


    call initpcb
	
	; Start screen
    call basiclayout
    call flappybird
    call startStringPrint

	mov ah, 0
	int 0x16
	cmp al, 0x1b
	je near escDetected
	
	; Intro screen
	call IntroScreen
	
    mov ah, 0
	int 0x16
	cmp al, 0x1b
	je near escDetected
	
	;Saving old int 9h
	xor  ax, ax
	mov  es, ax         
	mov ax, [es:9*4] 
	mov [oldINT9hisr], ax        
	mov ax, [es:9*4+2] 
	mov [oldINT9hisr+2], ax
	
	mov ax, [es:8*4] 
	mov [oldINT8hisr], ax        
	mov ax, [es:8*4+2] 
	mov [oldINT8hisr+2], ax
	
	cli           
    mov  word [es:8*4], timerStill
	mov  [es:8*4+2], cs            
	mov  word [es:9*4], changeFlag 
	mov  [es:9*4+2], cs   
	sti
	
	
	restart:

	call backGround
	push 170
	call cloud
	push 230
	call cloud
	push 290
	call cloud
	push 840
	call cloud
	push 900
	call cloud
	
	call loadBG
	
	call pillarPrint
	call bird
	mov ax, 0xb800
    mov es, ax
	; Press any key to Continue::: String
	mov  ah, 0x13         
	mov  al, 0             
	mov  bh, 0            
	mov  bl, 0xb4
	mov  dx, 0x0e1c
	mov  cx, 25        	; length 
	push cs 
	pop  es                 
	mov  bp, pressKeyStr    
	int  0x10
	mov ah, 0
	int 0x16 				; wait for the key to be pressed

	call restoreBgAll
	callMovPillar:
		push 2
		call delay
		call animate
		cmp word [collisions], 1
		jl callMovPillar

	cli 
	
	call deadBirdAnimate
	
	;Unhooking int 9h 
	xor ax, ax
	mov es, ax
	mov ax, [cs:oldINT9hisr]       
	mov bx, [cs:oldINT9hisr+2]            
	mov [es:9*4], ax       
	mov [es:9*4+2], bx      
	
	;Unhooking int 8h
	mov ax, [cs:oldINT8hisr]       
	mov bx, [cs:oldINT8hisr+2] 
	mov [es:8*4], ax       
	mov [es:8*4+2], bx
	sti	
	
	; End screen
	escDetected:
		call endScreen
				
	in al, 61h
    and al, 0FCh
    out 61h, al
	
		
	mov ax, 0x4c00
	int 0x21