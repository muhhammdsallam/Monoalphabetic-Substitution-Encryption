
name "Encyption/Decryption"

org 100h

;-------------------------------------------------------------------
.MODEL SMALL
.DATA


        MSG1  DB 13,10, ' enter your string :  $'
        MSG2 DB 13,10, ' your encrypted string is :  $'
        MSG3 DB 13,10, ' your decrypted string is :  $'
        MSG4 DB 13,10, ' to close the program press any key :  $'
        STR1 DB  255 DUP('$') 
        
        ;                       'abcdefghijklmnopqrstvuwxyz'
        
        TABLE1 DB 97 dup (' '), 'qwertyuiopasdfghjklzxcvbnm'
        
        TABLE2 DB 97 dup (' '), 'kxvmcnophqrszyijadlegwbuft'
                                                          
.CODE  
;-------------------------------------------------------------------



BEGIN:

    MOV AX,@DATA
    MOV DS,AX    
    
    LEA DX,MSG1                                                          
    MOV AH,09H
    INT 21H   
    
    LEA SI,STR1
    MOV AH,01H     
            
;-------------------------------------------------------------------            
            
            
READS:
    
    INT 21H
    MOV [SI],AL
    INC SI
    CMP AL,13
    JNE READS

   
;-------------------------------------------------------------------         
         
               
ENCRYPTS:
    LEA BX, TABLE1
    LEA SI, STR1 
    CALL TRANSLATE  ;encrypt the string
    LEA SI, STR1
    CALL REMOVES    ;remove spaces from string
    
      
    
    LEA DX,MSG2     ;output message2
    MOV AH,09H
    INT 21H     
    
    LEA DX, STR1
    MOV AH, 09H
    INT 21H
       
       
;-------------------------------------------------------------------       
       
       
DECRYPTS:
    LEA BX, TABLE2
    LEA SI, STR1
    CALL TRANSLATE    ;decrypt the string
    LEA SI, STR1
    CALL REMOVES      ;remove spaces from string


      
    LEA DX,MSG3     ;output message3
    MOV AH,09H
    INT 21H
       
    LEA DX, STR1
    MOV AH, 09H
    INT 21H 
    
    
    
; wait for any key to exit program
    MOV AH, 0
    INT 16H  
          
    RET
















     
;-------------------------------------------------------------------  
;PROCEDURES---------------------------------------------------------
    
         
REMOVES PROC NEAR 
        
        MOV DI,SI
        
    NEXT_CHA:
        CMP [DI],'$'
        JE ENDSTRING  
        
        MOV AL,[DI]
        CMP AL,' '
        JE SKIPS
        MOV [SI],AL
        INC SI
        INC DI  
        JMP NEXT_CHA
        
    SKIPS:
        INC DI
        JMP NEXT_CHA
           
    ENDSTRING:

  
    RET
REMOVES ENDP


     
     
TRANSLATE PROC NEAR

    NEXT_CHAR:
    	CMP [SI], '$'      
    	JE END_OF_STRING
    	
    	MOV AL, [SI]
    	CMP AL, 'a'
    	JB  SKIP
    	CMP AL, 'z'
    	JA  SKIP	
    	; xlat algorithm: al = ds:[bx + unsigned al] 
    	XLATB     ; encrypt using table.  
    	MOV [SI], AL   
    	
    SKIP:
    	INC SI	
    	JMP NEXT_CHAR
    	
    END_OF_STRING:
 
        
         
    RET            
    
TRANSLATE ENDP

  
  
  
 .EXIT
   
END BEGIN
