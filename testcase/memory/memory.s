.text
main:
	lui	$2, 0xf0f0
	ori $2, $2, 0x0f0f
	sw $2, 0($0)
	sb $2, 4($0)
	lw $3, 0($0)
	lw $4, 4($0)
	lb $8, 0($0)
	lb $12, 1($0)
	lb $14, 2($0)
	lb $16, 3($0)