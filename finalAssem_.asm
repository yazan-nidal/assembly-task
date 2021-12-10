.model small
.stack 64
.data
 
 ;------------------message------------------
  prompt db "Please Enter your registration nunber or( 'E' or 'e' for exitt ) :",10,13,"$"  
  noinput_ db "???!!!(no input : Please enter an 8-digit number)",10,13,"$"
  lessthanM db "???!!!(Please enter an 8-digit number)",10,13,"$"
  isString db  "???!!!(is String not Number : Please enter an 8-digit number)",10,13,"$"
  keyE db  "???!!!(The key is not definedr)",10,13,"$"
  enter db "enter key:$"
  thanks db "Thanks for using program :\)",07 ,"$"
 ;------------------keys------------------
  ;  Key for print the summation of all digits in center
  C__     equ     67 
  c_      equ     99 
  ;  Key for exit from Programme
  E__     equ     69
  e_      equ     101 
  ;  Key new Input 
  n_      equ     110
  N__     equ     78
  ;  Key for rotation    
  left    equ     4bh
  right   equ     4dh
  up      equ     48h
  down    equ     50h    
 ;------------------Parameter List------------------ 
  first db 2 dup(' '),"$"
  sacend db 2 dup(' '),"$"
  third db 2 dup(' '),"$"
  fourth db 2 dup(' '),"$"
  sum db 2 dup(' '),07,10,13,"$"   

  BUFF label byte
  MAXLEN db 9
  ACTLEN db ?
  VALUE db 10  dup(' ')
 ;--------------------------------------------- 
  
  .code
  main proc far
     mov ax,@data
     mov ds,ax       
         
   L1: 
     call clear ; call the clear procedure
     mov dx,0000    ; start point in screen   /upleft angle/
     call setcursor 
     
     L1_1:   
           
     lea dx, prompt ; function parameter              
     call printMessage ;; print the prompt message.  
     
     call acceptinput ;; Wait for the user input 
     
     ;--exit--
     cmp ACTLEN,1 
     je Lee
     
     ;;if( enter nothing /just end line/ ) 
     cmp ACTLEN,0  ;; Check if there is no input
     je Lni
     
     cmp ACTLEN,8  ;; Check if input is less than  8 digit
     jne Ls
     
     jmp val ; Check if there is number from 8 digit or string 
     
     valRet:
     
     call clear 
     call setAngleValue   ;sett 4 angle value( /upLeft: digit1,digit2/ , /upRight:digit5,digit6/ , /downLeft: digit3,digit4/ , /downRight: digit7,digit8/ )
     call PrintAngle ;print 4 angle ( upLeft,upRight,downLeft,downRight )

     
     loob: 
      mov ax,00
      ;enter key comand
        ;(E,e): exit
        ;(c,C): Display the summation of all digits in center after clean screen
        ;(n,N): new input
        ;left: shift circularly to the left
        ;right: shift circularly to the Right
        ;up: shift circularly to the up 
        ;down: shift circularly to the down    
     LK:
     call enterkey 
      
     loob_1:
      
     cmp     ah, left;left click    
     je         Lh
     
     cmp     ah, right;right click    
     je         Lh
     
     cmp     ah, up;up click    
     je         Lr
     
     cmp     ah, down;down click    
     je         Lr

     cmp     al, e_;enter e    
     je         Le
        
     cmp     al, E__;enter E   
     je         Le
     
     
     cmp     al, C__;enter C    
     je         Lc
       
     cmp     al, c_;enter c   
     je         Lc
     
     cmp     al, n_;enter n   
     je          L1
     
     cmp     al, N__;enter N   
     je          L1 
     
     ;----- undefined key ----  
     call clear
      mov dh,10        ; dh:R
      
      mov dl,32 ; length"???!!!(The key is not definedr)"
      shr dl,1 
      neg dl  
      add dl,40      ; dl:C
      
      call setcursor 
      
     lea dx, keyE ; function parameter              
     call printMessage ;; print the undefined key message. 
     jmp Lk
     
     jmp loob

     jmp L1
     
     ;check if not number
     val:
     
      lea si, VALUE ; 
      call ifnumber 
      pop dx
      
      cmp dx,0
      je l1_1
      
      cmp dx,1
      je valRet 
      
      jmp Le

     ;------------------for confirmed function principle ( use call function , no break function return by jmp )------------------
      Lh:
      call rotationHorizontal
      jmp loob
      
      Lr:
      call rotationVertical 
      jmp loob
      
      Lc:
      call printSum
      jmp loob_1
      
      Ls:
      call lessthan
      jmp l1_1
      
      Lni: 
      call noinput
      jmp l1_1 
      
      Lee:
      cmp Value[0],'e'
      je Le   
      
      cmp Value[0],'E'
      je Le 
      
      jmp Ls 
      
      Le:
      call endthanks      

     done:
       mov ax,4c00h
       int 21h
    main endp

  ;------------------Clear Procedure------------------   
   clear proc near
      mov ax,0600h  
      mov bh,30 ; blue color  
      mov cx,0000
      mov dx,184Fh
      int 10h     
   ret
   endp 
   
  ;------------------Set the cursor procedure------------------
   setcursor proc near
    mov ah,02h  ;; the service code to set the cursor
    mov bh,00 ; page#0
    int 10h    
   ret
   endp     
   
  ;------------------Print the message pointed by dx register, procedure------------------
   printMessage proc near
    mov ah,09h
    int 21h 
   ret
   endp 
   
  ;------------------Accept the input procedure------------------
   acceptinput proc near   
    mov ah,0aH 
    lea dx,BUFF 
    int 21h  
    call processinput
   ret
   endp   
   
  ;------------------Process the input before displaying------------------
   processinput proc near  
      mov bh,00
      mov bl,ACTLEN
      
      mov VALUE[bx],07 ;---Make the speaker to beep
      mov VALUE[bx+1],'$'  
   ret
   endp   
   
  ;------------------Center and Display------------------
   centdis proc near   
      mov dh,12 ; dh:R
      
      mov dl,ACTLEN 
      shr dl,1   
      neg dl  
      add dl,40   ; dl:C
      
      call setcursor
      
      lea dx, VALUE ; function parameter              
      call printMessage ;; print the input message.    
   ret
   endp 
   
  ;------------------enter key------------------
   enterKey proc near   
      mov dh,12        ; dh:R
      
      mov dl,10  ; length"enter key:" 
      shr dl,1 
      neg dl  
      add dl,40      ; dl:C
      
      call setcursor 
      
     lea dx, enter ; function parameter              
     call printMessage ;; print the enter key message.
     
    ; listen and record clicked key
     mov  ah, 00h
     int  16h    
   ret
   endp  
   
  ;------------------Display the summation of all digits in center after clean screen------------------
   printSum proc near
     call clear 
     
     lea si,Value 
     mov bx,0  
     mov ax,0 
     mov dx,0 
     
     sum_:
    ; get the summation of all digits  
    cmp [si],'$'
    je endSum 
    
    cmp [si],07
    je endSum 
     
    ; convert digit from char to int  
    mov ax,[si]
    sub ax,'0'
    
    ;sum bl,digit
    add bl,al
    ;next char
    inc si
    
    jmp sum_
    
     endSum:    
     lea si,sum 
     
     ;check Possible how many digit of sum
     cmp bl,9
     jle sum1 
     
     ;if sum 2 digit
     mov cl,2
     
     ;get digit ax:first digit , dx second digit
     mov ax,bx
     mov bx,10
     div bx 
     
     ;coonvert first digit from int to char 
     add ax,48
     mov [si],ax ;store first digit char 
     
     inc si
     
     ;coonvert second digit from int to char
     add dx,48
     mov [si],dx ;store second digit
     
     inc si 
     
     ;stor beep
     mov [si],07
     
     inc si  
     
     ;store '$'
     mov [si],'$'
     
     jmp fsum
     
     ;if sum 1 digit
     sum1:
     mov cl,1
     
     ;convert first digit to char
     add bl,48
     mov [si],bl ;store digit
     
     inc si
     
     ;store beep
     mov [si],07
      
     inc si
     
     ;store '$'
     mov [si],'$' 
     
     fsum:
     
     mov dh,12 ; dh:R
      
      mov dl,cl
      shr dl,1   
      neg dl  
      add dl,40   ; dl:C
      
      call setcursor
      
      lea dx, sum ; function parameter              
      call printMessage ;; print the summation of all digits message.    
      
     ;enter new key after center by two row without print any message before input key
      mov dh,14        ; dh:R
      
      mov dl,cl
      shr dl,1 
      neg dl  
      add dl,40      ; dl:C
      
      call setcursor 
     
    ; listen and record clicked key
     mov  ah, 00h
     int  16h    
   ret
   endp 
   
  ;------------------end of programme------------------
   endthanks proc near
      call clear
    
      mov dh,24    ; dh:R
       
      mov dl,45 ;length"Thanks for using program (Hussein__Yazan) :\)"
      shr dl,1   
      neg dl  
      add dl,42   ; dl:C
       
      call setcursor  
      
     lea dx, thanks ; function parameter              
     call printMessage ;; print the thanks message.  
   ret
   endp
  
   ;------------------if no input------------------
   noinput proc near 
     call clear 
      
     mov dx,0000 ; start point in screen   /upleft angle/
     call setcursor 
      
     lea dx, noinput_ ; function parameter              
     call printMessage ;; print the noinput_ message. 
   ret
   endp  
   
  ;------------------if input less than 8-digit------------------
   lessthan proc near 
     call clear 
      
     mov dx,0000 ; start point in screen   /upleft angle/
     call setcursor 
      
     lea dx, lessthanM ; function parameter              
     call printMessage ;; print the lessthanM message. 
   ret
   endp 
   
  ;------------------sett 4 angle value------------------
                    ; upLeft: digit1,digit2
                    ; upRight: digit5,digit6
                    ; downLeft: digit3,digit4
                    ; downRight: digit7,digit8
   setAngleValue proc near
    
     ;--set upLeft Angle Value-- 
     mov dl,VALUE[0] 
     mov dh,VALUE[1]
     
     mov first[0],dl
     mov first[1],dh    
     ;////////////////////////////
      
     ;--set downLeft Angle Value--
     mov dl,VALUE[2] 
     mov dh,VALUE[3]
     
     mov sacend[0],dl
     mov sacend[1],dh
     ;//////////////////////////// 
     
     ;--set upRight Angle Value--
     mov dl,VALUE[4] 
     mov dh,VALUE[5]
     
     mov third[0],dl
     mov third[1],dh  
     ;////////////////////////////
     
     ;--set downRight Angle Value--
     mov dl,VALUE[6] 
     mov dh,VALUE[7]
     
     mov fourth[0],dl
     mov fourth[1],dh
     ;////////////////////////////       
   ret
   endp     
        
  ;------------------set cursor for 4 angle then print them  ( upLeft,upRight,downLeft,downRight )------------------      
   PrintAngle proc near 
    ;--print upLeft Angle--  
     ; set Angle cursor
     mov dh,0  ; dh:R 
     mov dl,2 
     shr dl,1    
     neg dl   
     add dl,1  ; dl:C   
     call setcursor
     
     lea dx, first   ; function parameter 
     call printMessage ;; print the upleft Angle .
     ;////////////////////////////////////////////////////////   
     
    ;--print downLeft Angle-- 
     ; set Angle cursor
     mov dh,23       ; dh:R
     mov dl,2 
     shr dl,1    
     neg dl   
     add dl,1        ; dl:C
     call setcursor
      
     lea dx, sacend   ; function parameter 
     call printMessage ;; print the downLeft Angle .
     ;////////////////////////////////////////////////////////
    
    ;--print upRight Angle-- 
     ; set Angle cursor
     mov dh,0   ; dh:R
     mov dl,2 
     shr dl,1    
     neg dl   
     add dl,79  ; dl:C
     call setcursor 
               
     lea dx, third   ; function parameter 
     call printMessage ;; print the upRight Angle .
     ;////////////////////////////////////////////////////////
     
    ;--print downRight Angle-- 
     ; set Angle cursor
     mov dh,23  ; dh:R
     mov dl,2 
     shr dl,1    
     neg dl   
     add dl,79  ; dl:C
     call setcursor           
     lea dx, fourth   ; function parameter 
     call printMessage ;; print the downRight Angle .
     ;////////////////////////////////////////////////////////
   ret
   endp 
   
 ;------------------swap------------------ 
            ; swap between value pointed by si, value pointed by di via use temp 'bx' : si , di as a Parameter to function
            ; value is string from n db
   swap proc near
     loopSW: 
     ; swap iTH digit 
     mov bl,[si] 
     mov bh,[di]
     mov [si],bh
     mov [di],bl
     ;next digit
     inc si
     inc di  
     
     ; if one of them end end the procedure
     cmp [SI] , '$' 
     je stopSW 
     
     cmp [DI] , '$' 
     je stopSW
     ;if not end any one of them
     jmp  loopSW
    
     stopSW:
   ret
   endp 
   
 ;------------------shift circularly to the right , shift circularly to the left------------------ 
  rotationHorizontal   proc near 
    call clear 
    
    lea SI,first 
    lea DI,third
    call swap ; swap /d1,d2/  , /d5,d6/
    
    lea SI,sacend 
    lea DI,fourth
    call swap  ; swap /d3,d4/  , /d8,d7/
    
    call PrintAngle
   ret
   endp  
  
 ;------------------shift circularly to the up , shift circularly to the down------------------   
  rotationVertical   proc near 
    call clear 
    
    lea SI,first 
    lea DI,sacend
    call swap  ; swap /d1,d2/ , /d3,d4/
    
    lea SI,third 
    lea DI,fourth
    call swap  ; swap /d5,d6/ , /d8,d7/
    
    call PrintAngle  
  ret
  endp 
 
 ;-----------------Check if there is number from 8 digit or string-----------------  
                                                                       ; parameter pass by Si
                                                                       ; return 1 if valid number by stack
                                                                       ; return 0 if not valid number by stack
  ifNumber proc near 
    
    val_1:
    cmp [si],'$'
    je endc 
    
    cmp [si],07
    je endc
        
    cmp [si],'0'  
    jl notv 
    
    cmp [si],'9'
    jg notv 
    
    inc si
        
    jmp val_1 
    
    notv: 
     call clear 
      
     mov dx,0000 ; start point in screen   /upleft angle/
     call setcursor 
      
     lea dx, isstring ; function parameter              
     call printMessage ;; print the ifstring message.
     pop dx  ;ret 
     push 0D ;return value
     push dx ; return adres
     
  ret
  endp 
     
    endc:
    pop dx  ;ret
    push 1D ;return value
    push dx ; return address
     
  ret
  endp    