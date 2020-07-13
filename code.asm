.model tiny     ; By: Abdallah Kharouf 
                ; note: executing all operations in same time may generate some conflict when changing to capital or to small then to count
                 
                                 

.data 

   
Res db ' The result is :  ' ,'$'


Sen db 102 dup (?)        ; main sentence 


tempVal db 101 dup (?)  ; in order to make some manipulations and to save the original sentence in register

 
intro db 'Hi, please enter your sentence:',10,13,'$'

 
next db 10,13,'$'                        

                                           
confirm db 'The sentence is : ',10,13,'$' 
                                      
   
mistaken db 'You made an Error in input',10,13,'$'    


menu db 10,13 ,'Choose one of the following', 10,13,'S.s To convert all letters to small',10,13,'C.c To convert all letters to capital', 10,13, 'W.w To count the number of words in the sentence',10,13,'O.o To convert first letter into Upeercase',10,13,'N.n To calculate the number of alphapets in statement',10,13,'U.u To display the number of capitals in statement',10,13,'L.l to dipslay number of small letters in statement',10,13,'B.b To continue displaying menu (Automatic)',10,13,'Q.q To quit showing menu and to halt executing',10,13,'The Input is : ','$'


ending db 10,13, 'Thanks for dealing with us! Abdallah Kharouf 1183328',10,13,'$'


select db 10,13 ,' Choose B,b to continue executing or Q,q to quit',10,13,'$' 




.code 


mov dx,offset intro ; into to print    lea dx,intro
call print    

mov si,0 ; index of array of characters(String)                      


; reading character by character sequentially    

;call reading
     ; mov ah,1 int 21h ; reads from kb
     ; mov ah,9 int 21 ; pirnts 
     ; mov ah,2 int 21h ; prints the content of dl

;--------------------------------------------------------; 
reading:
   
mov Sen[si],'$'
mov ah,01
int 21h  
 
cmp al,13   ; enter ascii code
jz readsuc

cmp al,32   ; space ascii code
jz saving
      
mov dl,al
and dl,0dfh; 1101111 to small 0010000     ; difference between lower and upper is the 5th bit, so we convert them to capital and then we compare 

cmp dl,65 
jl error

cmp dl,90
jg error  

;-------------------------------------------;

saving:
                
mov Sen[si],al  
inc si

cmp si,100
jz readsuc
jmp reading  

;------------------------------------------;  

readsuc:  
    
mov dx,offset next
call print       

mov dx, offset confirm
call print 
  
mov dx, offset Sen                        ; Step before selecting the operations
call print

options:    

mov dx,offset menu 
call print    


mov ah,01
int 21h ; reading first option 

cmp al,66    ;B
jz go        
cmp al,98    ;b
jz go

cmp al,83  ; S
jz toSmall 
cmp al,115
jz toSmall ; s

cmp al,99  ;c
jz CAP
cmp al,67  ;C
jz CAP

cmp al,119 ; ascii of w
jz wordCounter             
cmp al,87  ; ascii code of W
jz wordCounter

cmp al,111 ;ascii of o
jz upperFirst       ;O
cmp al,79
jz upperFirst 

cmp al,78           ;N
jz ALP              ;n
cmp al,110
jz ALP

cmp al,85           ;U            I used capital and small correspondants in order to handle the case of different inputs
jz upcoi            ;u
cmp al,117
jz upcoi

cmp al,108          ;L
jz uncoi            ;l
cmp al,76
jz uncoi 

cmp al,71h          ;Q
jz endd             ;q
cmp al, 51h
jz endd 

         
jmp endd 
;------------------------------------------;

wordCounter:                 ; W w 

mov cl,1 
xor si,si ; masking like mov si,0
           
           
loopcount:
mov al,Sen[si] 

cmp al,'$'
jz donecount 

cmp al,32
jnz resume
 
inc cl


resume:
inc si 
jmp loopcount

donecount:
mov dx,offset next
call print
mov dx,offset Res
call print    

mov dl,cl
add dl,48  ; to print in decimal
mov ah,2
int 21h



jmp options 
            
;--------------------------------------;            
upperFirst:  ;here we use tempVal     O o 
mov si,0

mov al,Sen[si]
and al,0dfh      

mov tempVal[si],al  
inc si


convert:
mov al,Sen[si] 

cmp al,'$'     
jz doneconvert 
  
cmp al,32      ; space case 
jz nextupper   

or al,20h
mov tempVal[si],al
inc si 

jmp convert  


nextupper:
inc si   
mov al,Sen[si]
and al,0dfh
mov tempVal[si],al  
inc si
jmp convert



doneconvert:  
mov tempVal[si],'$'     
mov dx ,offset next
call print  
mov dx,offset Res
call print
mov dx,offset tempVal
call print ;; printing the converted sentence
 
jmp options

;----------------------------------------;
toSmall:  ;here we use tempVal     O o 
mov si,0

mov al,Sen[si]
or al,20h      

mov tempVal[si],al  
inc si


vert:
mov al,Sen[si] 

cmp al,'$'     
jz donevert 
  
;cmp al,32      ; space case 
;jz nextupper   

or al,20h
mov tempVal[si],al
inc si   
jmp vert

;jmp vert  


;nextupper:
;inc si   
;mov al,Sen[si]
;and al,0dfh
;mov tempVal[si],al  
;inc si
;jmp vert



donevert:  
mov tempVal[si],'$'     
mov dx ,offset next
call print 
mov dx,offset Res
call print
mov dx,offset tempVal
call print ;; printing the converted sentence
 
jmp options

;-----------------------------------------------;

CAP:  ;here we use tempVal     O o 
mov si,0

mov al,Sen[si]
and al,0dfh      

mov tempVal[si],al  
inc si


verter:
mov al,Sen[si] 

cmp al,'$'     
jz doneverter 
  
;cmp al,32      ; space case 
;jz nextupper   

and al,0dfh
mov tempVal[si],al
inc si   
jmp verter

;jmp vert  


;nextupper:
;inc si   
;mov al,Sen[si]
;and al,0dfh
;mov tempVal[si],al  
;inc si
;jmp vert



doneverter:  
mov tempVal[si],'$'     
mov dx ,offset next
call print 
mov dx,offset Res
call print
mov dx,offset tempVal
call print ;; printing the converted sentence
 
jmp options  


;------------------------------------------;

ALP:          

mov bl,0
lea si, Sen
;xor si,si ; masking 
           
           
loopcounter:
mov al,[si] 

cmp al,'$'                           
jz donecounter

inc si
inc bl
jmp loopcounter 


donecounter:   
mov dx,offset next
call print  
mov dx,offset Res
call print  
mov ah,2  
mov dl,bl
add dl,48
int 21h    ; prints in Hexadecimal. if you added 11 character it will print B
           ; you need to look on ascii table to see the coressponding answer 
           ; E.g: if prints U means 85: - 48 =   37 characters in sentence


jmp options 


;----------------------------------------;   


upcoi:       ;capital letter counter  
mov cl,0
mov si,0

back:
mov al,Sen[si]
cmp al,'$'
jz work
cmp al,65
jl stop
cmp al,32
jz stop

inc cl

stop:
inc si
jmp back

work:
lea dx,next
call print  
lea dx,res 
call print
mov  al, cl
aam                            ; this case to handle the numbering problem in displaying the number 
add  ax, "0"
xchg al, ah
mov  dx, ax
mov  ah, 2h
int  21h
mov  dl, dh
int  21h


jmp options  

;---------------------------------------------;

uncoi: ;Option L begins

mov cl, 0
mov si,0

backer: 
mov al,Sen[si]

cmp al, '$'
jz works

cmp al, 97
jl stops

cmp al,122
jg stops

cmp al,32 ;space
jz stops

inc bl

stops:
inc si
jmp backer

works:

lea dx, next
call print
lea dx,res
call print

mov  al, bl
aam               
add  ax, "0"
xchg al, ah
mov  dx, ax
mov  ah, 2h
int  21h
mov  dl, dh
int  21h

jmp options




;----------------------------------------;

print:
push ax    ;in order not to lose the value in ax 
mov ah,09
int 21h 
pop ax       
ret    

;--------------------------------------------;
go:

jmp options
        

;----------------------------------------;

error:  
mov dx , offset next 
call print
mov dx,offset mistaken
call print  
jmp endd

;----------------------------------------;

endd: 
lea dx,ending
call print
