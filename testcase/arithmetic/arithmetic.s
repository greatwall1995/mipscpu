.text 
main:  

   ori  $4,$0,0x8000      
   sll  $4,$4,16          
   ori  $4,$4,0x0010      
  
   ori  $2,$0,0x8000      
   sll  $2,$2,16          
   ori  $2,$2,0x0001      
  
   ori  $3,$0,0x0000      
   addu $3,$2,$4          
   ori  $3,$0,0x0000      
   add  $3,$2,$4          
                          
  
   sub   $3,$4,$3         
   subu  $3,$3,$2         
  
   addi $3,$3,2           
   ori  $3,$0,0x0000      
   addiu $3,$3,0x8000
   or   $4,$0,0xffff      
   sll  $4,$4,16          
   slt  $2,$4,$0          
   sltu $2,$4,$0          
   slti $2,$4,0x8000      
   sltiu $2,$4,0x8000     
   lui $4,0x0000          
   #clo $2,$4              
   #clz $2,$4       
   lui $4,0xffff          
   ori $4,$4,0xffff       
   #clz $2,$4              
   #clo $2,$4       
   lui $4,0xa100          
   #clz $2,$4              
   #clo $2,$4      
   lui $4,0x1100          
   #clz $2,$4              
   #clo $2,$4    
   ori  $4,$0,0xffff      
   sll  $4,$4,16  
   ori  $4,$4,0xfffb      
   ori  $2,$0,6           
   mul  $3,$4,$2      
   mult $4,$2      
   multu $4,$2        
