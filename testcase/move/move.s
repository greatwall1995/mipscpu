.text
main:
   lui $2,0x0000          # $1 = 0x00000000  
   lui $3,0xffff          # $2 = 0xffff0000  
   lui $4,0x0505          # $3 = 0x05050000  
   lui $5,0x0000          # $4 = 0x00000000   
   movz $5,$3,$2          # $4 = 0xffff0000  
   movn $5,$4,$2          # $4 = 0xffff0000  
   movn $5,$4,$3          # $4 = 0x05050000  
   movz $5,$3,$4          # $4 = 0x05050000  
   mthi $0                # hi = 0x00000000  
   mthi $3                # hi = 0xffff0000  
   mthi $4                # hi = 0x05050000  
   mfhi $5                # $4 = 0x05050000  
   mtlo $4                # lo = 0x05050000  
   mtlo $3                # lo = 0xffff0000  
   mtlo $2                # lo = 0x00000000  
   mflo $5                # $4 = 0x00000000 
   