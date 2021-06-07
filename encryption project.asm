
name "Encyption/Decryption"

org 100h

;-------------------------------------------------------------------
.MODEL SMALL
.DATA


  MSG1 DB 13,10, ' enter your string >>>  $'
  MSG2 DB 13,10, ' encrypted string  >>>  $'
  MSG3 DB 13,10, ' decrypted string  >>>  $'
  MSG4 DB 13,10, ' To end press any key / To continue press enter >>>  $'
  STR1 DB 255 DUP('$')
   ;                      'abcdefghijklmnopqrstvuwxyz'
        
  TABLE1 DB 97 dup (' '), 'qwertyuiopasdfghjklzxcvbnm'
        
  TABLE2 DB 97 dup (' '), 'kxvmcnophqrszyijadlegwbuft'
                                                          
.CODE  
;-------------------------------------------------------------------
                                                                   
                                                                   
                                                                   
BEGIN:                                                             
                                                                   
    LEA SI,STR1
    CALL CLEARSTRING    ;clear the string when restarting the program
                                                                   
    MOV AX,@DATA        ;moves the data to data segment            
    MOV DS,AX                                                     
                                                                   
    LEA DX,MSG1         ;displays message 1                                                 
    MOV AH,09H                                                     
    INT 21H                                                       
                                                                   
                                                                   
                                                                   
;-------------------------------------------------------------------                                                                                                                                         
    LEA SI,STR1         ;read from user the string                 
    MOV AH,01H                                                     
                                                                  
READS:                                                             
                                                                   
    INT 21H                                                        
    MOV [SI],AL                                                    
    INC SI                                                         
    CMP AL,13                                                      
    JNE READS                                                     
                                                                                                                                      
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
    LEA DX,MSG4      ;displays message 4                                                    
    MOV AH, 09H                                                    
    INT 21H                                                        
                                                                   
                                                                   
    MOV AH,01H                                                     
    INT 21H                                                        
    CMP AL,13                                                      
    JE BEGIN ;if the user entered ENTER key,program will jumptobegin
             ;else it will end the program.                       
ENDPROGRAM:
                                                         
                                                                  
   ;MOV AH,0H                                                     
    INT 16H                                                       
    RET                                                            
                                                                   
                                                                   
                                                                  
                                                                   
                                                                   
                                                                   
                                                                   
                                                                   
                                                                                                                                                                                                         ;                                                                   ;                                                                   ;                                                                   ;                                                                    ;                                                                   ;                                                                   ;
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
        MOV [SI],'$'

  
    RET
REMOVES ENDP

;-------------------------------------------------------------------     
     
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
         ;MOV [SI],'$'
        
         
    RET            
    
TRANSLATE ENDP 


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

 
  
 .EXIT
   
END BEGIN
