//*******************         ȫ�ֵĺ궨��        ***************************  
`define RstEnable			1'b1               //��λ�ź���Ч  
`define RstDisable			1'b0               //��λ�ź���Ч  
`define BblEnable			1'b1  
`define BblDisable			1'b0  
`define ZeroWord			32'h00000000       //32λ����ֵ0  
`define WriteEnable			1'b1               //ʹ��д  
`define WriteDisable		1'b0               //��ֹд  
`define ReadEnable			1'b1               //ʹ�ܶ�  
`define ReadDisable			1'b0               //��ֹ��  
`define AluOpBus			7:0                //����׶ε����aluop_o�Ŀ��  
`define AluSelBus			3:0                //����׶ε����alusel_o�Ŀ��  
`define InstValid			1'b0               //ָ����Ч  
`define InstInvalid			1'b1               //ָ����Ч  
`define True_v				1'b1               //�߼����桱  
`define False_v				1'b0               //�߼����١�  
`define ChipEnable			1'b1               //оƬʹ��  
`define ChipDisable			1'b0               //оƬ��ֹ  
`define Stop				1'b1
`define NotStop				1'b0
`define Branch				1'b1
`define NotBranch			1'b0
  
//*********************   �����ָ���йصĺ궨��  *****************************  
`define EXE_AND				6'b100100          // andָ��Ĺ�����  
`define EXE_OR				6'b100101          //  orָ��Ĺ�����  
`define EXE_XOR				6'b100110          // xorָ��Ĺ�����  
`define EXE_NOR				6'b100111          // norָ��Ĺ�����  
`define EXE_ANDI			6'b001100          //andiָ���ָ����  
`define EXE_ORI				6'b001101          // oriָ���ָ����  
`define EXE_XORI			6'b001110          //xoriָ���ָ����  
`define EXE_LUI				6'b001111          // luiָ���ָ����

`define EXE_SLT	  			6'b101010
`define EXE_SLTU			6'b101011
`define EXE_SLTI			6'b001010
`define EXE_SLTIU			6'b001011
  
`define EXE_SLL				6'b000000          // sllָ��Ĺ�����  
`define EXE_SRL				6'b000010          // sraָ��Ĺ�����  
`define EXE_SRA				6'b000011          // sraָ��Ĺ�����  
`define EXE_SLLV			6'b000100          //sllvָ��Ĺ�����  
`define EXE_SRLV			6'b000110          //srlvָ��Ĺ�����  
`define EXE_SRAV			6'b000111          //sravָ��Ĺ�����

`define EXE_ADD				6'b100000
`define EXE_ADDU			6'b100001
`define EXE_SUB				6'b100010
`define EXE_SUBU  			6'b100011
`define EXE_ADDI			6'b001000
`define EXE_ADDIU			6'b001001

`define EXE_MOVZ			6'b001010
`define EXE_MOVN			6'b001011
`define EXE_MFHI			6'b010000
`define EXE_MTHI			6'b010001
`define EXE_MFLO			6'b010010
`define EXE_MTLO			6'b010011

//`define EXE_CLO			6'b100000
//`define EXE_CLZ			6'b100001

//`define EXE_MUL			6'b000010
`define EXE_MULT			6'b011000
`define EXE_MULTU			6'b011001

`define EXE_DIV				6'b011010
`define EXE_DIVU			6'b011011

`define EXE_JR				6'b001000
`define EXE_JALR			6'b001001
`define EXE_J				6'b000010
`define EXE_JAL				6'b000011
  
`define EXE_SYNC			6'b001111         //syncָ��Ĺ�����  
`define EXE_PREF			6'b110011         //prefָ���ָ����  
`define EXE_SPECIAL_INST	6'b000000  //SPECIAL��ָ���ָ����  
  
//AluOp  
`define EXE_NOP_OP			8'b00000000 

`define EXE_AND_OP			8'b00100100
`define EXE_OR_OP			8'b00100101
`define EXE_XOR_OP			8'b00100110
`define EXE_NOR_OP			8'b00100111

`define EXE_SLT_OP			8'b00101010
`define EXE_SLTU_OP			8'b00101011

`define EXE_SLL_OP			8'b00000001
`define EXE_SRL_OP			8'b00000010
`define EXE_SRA_OP			8'b00000011

`define EXE_ADD_OP			8'b00100000
`define EXE_ADDU_OP			8'b00100001
`define EXE_SUB_OP			8'b00100010
`define EXE_SUBU_OP			8'b00100011

`define EXE_MOVZ_OP			8'b00001010
`define EXE_MOVN_OP			8'b00001011
`define EXE_MFHI_OP			8'b00010000
`define EXE_MTHI_OP			8'b00010001
`define EXE_MFLO_OP			8'b00010010
`define EXE_MTLO_OP			8'b00010011

`define EXE_MULT_OP			8'b00011000
`define EXE_MULTU_OP		8'b00011001

`define EXE_DIV_OP			8'b00011010
`define EXE_DIVU_OP			8'b00011011

`define EXE_JAL_OP			8'b01000011
  
//AluSel  
`define EXE_RES_NOP			4'b0000  
`define EXE_RES_LOGIC		4'b0001  
`define EXE_RES_SHIFT		4'b0010
`define EXE_RES_COMPARE		4'b0011
`define EXE_RES_ADD			4'b0100
`define EXE_RES_MOVE		4'b0101
`define EXE_RES_MULT		4'b0110
`define EXE_RES_DIV			4'b0111
`define EXE_RES_JUMP		4'b1000
  
  
//*********************   ��ָ��洢��ROM�йصĺ궨��   **********************  
`define InstAddrBus          31:0               //ROM�ĵ�ַ���߿��  
`define InstBus              31:0               //ROM���������߿��  
`define InstMemNum           131071             //ROM��ʵ�ʴ�СΪ128KB  
`define InstMemNumLog2       17                 //ROMʵ��ʹ�õĵ�ַ�߿��  
  
  
//*********************  ��ͨ�üĴ���Regfile�йصĺ궨��   *******************  
`define RegAddrBus           4:0                //Regfileģ��ĵ�ַ�߿��  
`define RegBus               31:0               //Regfileģ��������߿��  
`define RegWidth             32                 //ͨ�üĴ����Ŀ��  
`define DoubleRegWidth       64                 //������ͨ�üĴ����Ŀ��  
`define DoubleRegBus         63:0               //������ͨ�üĴ����������߿��  
`define RegNum               32                 //ͨ�üĴ���������  
`define RegNumLog2           5                  //Ѱַͨ�üĴ���ʹ�õĵ�ַλ��  
`define NOPRegAddr           5'b00000  
