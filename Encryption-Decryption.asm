
name "Encyption/Decryption"

org 100h

;-------------------------------------------------------------------
.MODEL SMALL
.DATA


  MSG1 DB 13,10, ' - Enter The Message  >>>  $'   ;13 for carriage return to get back to start of the line ; 10 for new line 
  MSG2 DB 13,10, ' - Encrypted Message  >>>  $'
  MSG3 DB 13,10, ' - Decrypted Message  >>>  $'
  MSG4 DB 13,10, ' -------------------------------------------------  $'
  MSG5 DB 13,10, '  $'
  MSG6 DB 13,10, ' >>>>>>>>>>>>>>>>>>>>>>> WELCOME TO ENCRYPTION PROGRAM <<<<<<<<<<<<<<<<<<<<<<<<  $' 
  MSG7 DB 13,10, ' ! ERROR Please enter lowercase characters only   $'
  STR1 DB 255 DUP('$')  ;duplicate string with $
  
                          ;'abcdefghijklmnopqrstvuwxyz'
        
  TABLE1 DB 97 dup (' '), 'qwertyuiopasdfghjklzxcvbnm'
        
  TABLE2 DB 97 dup (' '), 'kxvmcnophqrszyijadlegwbuft'
  
                                                          
.CODE  
;-------------------------------------------------------------------
                                                                   
    LEA DX,MSG6
    MOV AH,09H
    INT 21H
                                                                   
                                                                   
BEGIN:                                                             
                                                                   
    LEA SI,STR1
    CALL CLEARSTRING    ;clear the string when restarting the program
    
                                                                   
    MOV AX,@DATA        ;moves the data to data segment            
    MOV DS,AX                                                     
    
    LEA DX,MSG5         ;displays empty line
    MOV AH,09H
    INT 21H
                                                                   
    LEA DX,MSG1         ;displays message 1                                                 
    MOV AH,09H                                                     
    INT 21H                                                       
                                                                   
                                                                   
                                                                   
;-------------------------------------------------------------------                                                                                                                                         
    LEA SI,STR1         ;read from user the string                 
     
                                                                                               
READNEXTCHAR:
                                                             
    MOV AH,01H                                                               
    INT 21H 
                                                           
    MOV [SI],AL         ;return entered character from (8-bit) Al to SI                                           
    INC SI
    ; characters above z 
    CMP AL,'{'
    JE ERROR
    CMP AL,'}'
    JE ERROR
    CMP AL,'|'
    JE ERROR
    CMP AL,'~'
    JE ERROR 
    CMP AL,' '
    JE READNEXTCHAR
    CMP AL,08H   ;backspace
    JE BACKSPACE
    CMP AL,'a'
    JAE READNEXTCHAR  
    
    
    CMP AL,13               ; if the character was enter , end and jump to remove spaces                                       
    JE REMOVE_SPACES 
    
ERROR:    
    CALL VALIDATION
    
BACKSPACE:
    DEC SI
    DEC SI
    JMP READNEXTCHAR    
    

                                                 
                                                                                                                                      
;-------------------------------------------------------------------                                                                   
REMOVE_SPACES:;-----------------------------------------------------                                                     
                                                                   
    LEA SI, STR1                                                   
    CALL REMOVES    ;remove spaces from the string                 
                                                                   
;-------------------------------------------------------------------                                                                           
ENCRYPTS:;----------------------------------------------------------                                                         
                                                                   
    LEA BX, TABLE1                                                 
                                                                   
    LEA SI, STR1                                                   
    CALL TRANSLATE  ;encrypt the string                           
                                                                    
                                                                   
    LEA DX,MSG2     ;output message2                                
    MOV AH, 09H                                                    
    INT 21H                                                        
                                                                   
    LEA DX, STR1    ;output the encrypted string                   
    MOV AH, 09H                                                    
    INT 21H
                                                            
                                                                   
                                                                   
;-------------------------------------------------------------------                                                                                                                                          ;
DECRYPTS:;----------------------------------------------------------                                                         
                                                                   
    LEA BX, TABLE2                                                 
                                                                   
    LEA SI, STR1                                                   
    CALL TRANSLATE    ;decrypt the string                          
                                                                   
                                                                   
    LEA DX,MSG3     ;output message3                               
    MOV AH, 09H                                                    
    INT 21H                                                        
                                                                   
    LEA DX, STR1    ;output the encrypted string                   
    MOV AH, 09H                                                    
    INT 21H                                                        
                                                                   
                                                                   
;-------------------------------------------------------------------
    LEA DX,MSG5      ;displays empty line
    MOV AH,09H
    INT 21H
    
    LEA DX,MSG4      
    MOV AH,09H
    INT 21H                                                                
                                                  
    JMP BEGIN
                                                                                                                                                                            
                                                              
                                                                   
                                                                   

   
                                                                 
                                                                   
                                                                   
                                                                   
                                                                   
                                                                   
                                                                                                                                                                                                         ;                                                                   ;                                                                   ;                                                                   ;                                                                    ;                                                                   ;                                                                   ;
;-------------------------------------------------------------------  
;PROCEDURES---------------------------------------------------------
    
         
REMOVES PROC NEAR 
        
        MOV DI,SI                ;copies content of SI to DI and loop on DI to check for space characters if it finds a space         
                                 ;it will increment DI(goes to next character)and repeat,if it finds a character it will store it in SI                         
                                 
    NEXT_CHA:
        CMP [DI],'$'
        JE REMOVE-EXTRA-CHAR  
        
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
           
    REMOVE-EXTRA-CHAR:    ;remove extra characters after removing spaces from SI because we overwrite on SI
        CMP [SI],'$'
        JE ENDSTRING
        MOV [SI],'$'
        INC SI
        JMP REMOVE-EXTRA-CHAR
        
    ENDSTRING:    

  
        RET
REMOVES ENDP

;-------------------------------------------------------------------     
     
TRANSLATE PROC NEAR

    NEXT_CHAR:
    	CMP [SI], '$'      
    	JE END_OF_STRING
    	
    	MOV AL, [SI] 
    	XLATB     ; encrypt using table, xlat algorithm: al = ds:[bx + unsigned al] 
    	MOV [SI], AL   
    	
    SKIP:
    	INC SI	
    	JMP NEXT_CHAR
    	
    END_OF_STRING:
        
         
    RET            
    
TRANSLATE ENDP 

;------------------------------------------------------------------

CLEARSTRING PROC NEAR
    
 NEXTCHAR:
 
    CMP [SI],'$'
    JE ENDOFSTRING
    
    MOV AL,'$'
    MOV [SI],AL
    INC SI
    JMP NEXTCHAR
    
 ENDOFSTRING:
 
    RET
    
CLEARSTRING ENDP    


;------------------------------------------------------------------

VALIDATION PROC NEAR
    
    
    LEA DX,MSG7      ;displays message 7                                                    
    MOV AH, 09H                                                    
    INT 21H
    
    LEA DX,MSG4      
    MOV AH,09H
    INT 21H   
    
    JMP BEGIN 
        
       
VALIDATION ENDP 


       
 .EXIT
END BEGIN 