.text
main:
	addi $2, $0, 4
	addi $3, $0, 4
	addi $4, $0, 4
	j Label1
Label1:
	addi $4, $0, 3
	j Label2

Label2:
	addi $5, $0, 32
	jr $5

Label3:
	jal final

final:
	addi $6, $0, 42
	jr $31
