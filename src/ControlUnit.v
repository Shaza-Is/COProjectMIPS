module ControlUnit(Opcode,RegDstn,Branch,MemRead,MemtoReg,ALUop,MemWrite,ALUsrc,RegWrite,Jump,Arith);
	input [5:0] Opcode;
	output Branch,MemRead,MemWrite,ALUsrc,RegWrite,Jump,Arith;
	output [1:0] ALUop;
	output [1:0] MemtoReg;
	output [1:0] RegDstn;
	
	reg Branch,MemRead,MemWrite,ALUsrc,RegWrite,Jump,Arith;
	reg [1:0] ALUop;
	reg [1:0] MemtoReg;
	reg [1:0] RegDstn;
	
	parameter [5:0] R = 6'b000000,
	                Addi = 6'b001000,
	                Lw = 6'b100011,
			Sw = 6'b101011,
			Andi = 6'b001100,
			Beq = 6'b000100,
			Jal = 6'b000011;
					
	always @ (Opcode)
	begin
		case(Opcode)
		R: begin
			RegDstn <= #2 2'b01; //rd
			Branch <= #2 0;
			MemRead <= #2 0;
			MemtoReg <= #2 2'b00;
			ALUop <= #2 2'b10; //1	.. funct: add: 100000, subtract: 100010, AND: 100100, OR: 100101, SLT: 101010
			MemWrite <= #2 0;
			ALUsrc <= #2 0;
			RegWrite <= #2 1;
			Jump <= #2 0;
			Arith <= #2 1'bx;
		end
		Addi: begin
			RegDstn <= #2 2'b00; //rt
			Branch <= #2 0;
			MemRead <= #2 0;
			MemtoReg <= #2 2'b00;
			ALUop <= #2 2'b00; //00 for adding
			MemWrite <= #2 0;
			ALUsrc <= #2 1;
			RegWrite <= #2 1;
			Jump <= #2 0;
			Arith <= #2 1;
		end
		Lw: begin
			RegDstn <= #2 2'b00;
			Branch <= #2 0;
			MemRead <= #2 1;
			MemtoReg <= #2 2'b01;
			ALUop <= #2 2'b00; //00  for lw
			MemWrite <= #2 0;
			ALUsrc <= #2 1;
			RegWrite <= #2 1;
			Jump <= #2 0;
			Arith <= #2 1'b1;
		end
		Sw: begin
			RegDstn <= #2 2'bxx; //x
			Branch <= #2 0;
			MemRead <= #2 0;
			MemtoReg <= #2 2'bxx; //x
			ALUop <= #2 2'b00; //00 for sw
			MemWrite <= #2 1;
			ALUsrc <= #2 1;
			RegWrite <= #2 0;
			Jump <= #2 0;
			Arith <= #2 1;
		end
		Andi: begin
			RegDstn <= #2 2'b00; //rt
			Branch <= #2 0;
			MemRead <= #2 0;
			MemtoReg <= #2 2'b00;
			ALUop <= #2 2'b11; //11 for and
			MemWrite <= #2 0;
			ALUsrc <= #2 1;
			RegWrite <= #2 1;
			Jump <= #2 0;
			Arith <= #2 0;
		end
		Beq: begin
			RegDstn <= #2 2'bxx; //x
			Branch <= #2 1;
			MemRead <= #2 0;
			MemtoReg <= #2 2'bxx; //x
			ALUop <= #2 2'b01; //01 for beq .. zero flag
			MemWrite <= #2 0;
			ALUsrc <= #2 0;
			RegWrite <= #2 0;
			Jump <= #2 0;
			Arith <= #2 1;
		end
		Jal: begin
			RegDstn <= #2 2'b10;
			Branch <= #2 0;
			MemRead <= #2 0;
			MemtoReg <= #2 2'b10;
			ALUop <= #2 2'bxx; //x
			MemWrite <= #2 0;
			ALUsrc <= #2 1'bx; //x
			RegWrite <= #2 1;
			Jump <= #2 1;
			Arith <= #2 1'bx;
		end
		endcase
	end
		
endmodule	  