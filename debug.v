module debug();
reg [3:0]   cstate;
reg [31:0] 	ir;
reg [31:0]  mem_addr;
reg [31:0] 	alu_out;
wire 	pc_sel;
wire 	pc_ld;
wire 	mem_sel;
wire 	mem_read;
wire 	mem_write;
wire [3:0] 	mem_wrbits;
wire 	ir_ld;
wire [4:0] 	rs1_addr;
wire [4:0] 	rs2_addr;
wire [4:0] 	rd_addr;
wire [1:0] 	rd_sel;
wire 	rd_ld;
wire 	a_ld;
wire 	b_ld;
wire 	a_sel;
wire 	b_sel;
wire [31:0] imm;
wire [3:0] 	alu_ctl;
wire 	c_ld;

controller ctrl_inst(
	   		//input
			.cstate(cstate),
			.ir(ir),
			.addr(mem_addr),
			.alu_out(alu_out),
			//output
			.pc_sel(pc_sel),
			.pc_ld(pc_ld),
			.mem_sel(mem_sel),
			.mem_read(mem_read),
			.mem_write(mem_write),
			.mem_wrbits(mem_wrbits),
			.ir_ld(ir_ld),
			.rs1_addr(rs1_addr),
			.rs2_addr(rs2_addr),
			.rd_addr(rd_addr),
			.rd_sel(rd_sel),
			.rd_ld(rd_ld),
			.a_ld(a_ld),
			.b_ld(b_ld),
			.a_sel(a_sel),
			.b_sel(b_sel),
			.imm(imm),
			.alu_ctl(alu_ctl),
			.c_ld(c_ld));
initial begin
    cstate = 4'b0001;
    ir = 32'b0000_0000_1001_1011_0000_0011_0000_0011;
    mem_addr = 32'b0;
    alu_out = 32'b0;
      #10;
    cstate = 4'b0010;
    ir = 32'b0000_0000_1001_1011_0000_0011_0000_0011;
    mem_addr = 32'b0;
    alu_out = 32'b0;
      #10;
    cstate = 4'b0100;
    ir = 32'b0000_0000_1001_1011_0000_0011_0000_0011;
    mem_addr = 32'b0;
    alu_out = 32'b0;

      #10;
    cstate = 4'b1000;
    ir = 32'b0000_0000_1001_1011_0000_0011_0000_0011;
    mem_addr = 32'b0;
    alu_out = 32'b0;
      #10;

   end // initial begin

   initial $monitor("cstate = %d, pc_sel = %d, a_sel = %d, b_sel = %d, imm = %b, rd_sel = %b",cstate,pc_sel,a_sel,b_sel,imm,rd_sel);
endmodule



// @author Yusuke Matsunaga (松永 裕介)
//
// Copyright (C) 2019 Yusuke Matsunaga
// All rights reserved.
//
// [概要]
// データパスを制御する信号を生成する．
// フェイズは phasegen が生成するので
// このモジュールは完全な組み合わせ回路となる．
//
// [入力]
// cstate:     動作フェイズを表す4ビットの信号
// ir:         IRレジスタの値
// addr:       メモリアドレス(mem_wrbitsの生成に用いる)
// alu_out:    ALUの出力(分岐命令の条件判断に用いる)
//
// [出力]
// pc_sel:     PCの入力選択
// pc_ld:      PCの書き込み制御
// mem_sel:    メモリアドレスの入力選択
// mem_read:   メモリの読み込み制御
// mem_write:  メモリの書き込み制御
// mem_wrbits: メモリの書き込みビットマスク
// ir_ld:      IRレジスタの書き込み制御
// rs1_addr:   RS1アドレス
// rs2_addr:   RS2アドレス
// rd_addr:    RDアドレス
// rd_sel:     RDの入力選択
// rd_ld:      RDの書き込み制御
// a_ld:       Aレジスタの書き込み制御
// b_ld:       Bレジスタの書き込み制御
// a_sel:      ALUの入力1の入力選択
// b_sel:      ALUの入力2の入力選択
// imm:        即値
// alu_ctl:    ALUの機能コード
// c_ld:       Cレジスタの書き込み制御
module controller(input [3:0]   cstate,
		  input [31:0] 	ir,
		  input [31:0]  addr,
		  input [31:0] 	alu_out,
		  output 	pc_sel,
		  output 	pc_ld,
		  output 	mem_sel,
		  output 	mem_read,
		  output 	mem_write,
		  output [3:0] 	mem_wrbits,
		  output 	ir_ld,
		  output [4:0] 	rs1_addr,
		  output [4:0] 	rs2_addr,
		  output [4:0] 	rd_addr,
		  output [1:0] 	rd_sel,
		  output 	rd_ld,
		  output 	a_ld,
		  output 	b_ld,
		  output 	a_sel,
		  output 	b_sel,
		  output [31:0] imm,
		  output [3:0] 	alu_ctl,
		  output 	c_ld);

function pc_selgen(input [3:0] cstate,
		   input [31:0] ir,
		   input [31:0] alu_out);//pc_sel
begin
	case(cstate)
	4'b1000:
	begin
		casex(ir)
		32'bxxxx_xxxx_xxxx_xxxx_xxxx_xxxx_x110_x111: pc_selgen=1;   //JAL&JALR
		32'bxxxx_xxxx_xxxx_xxxx_x000_xxxx_x110_0011://分岐命令
		begin
			case(alu_out)
				32'b1:pc_selgen=1;
				32'b0:pc_selgen=0;
			endcase
		end
		default: pc_selgen=0;
		endcase
	end
	endcase //
	//default:;
end
endfunction

function pc_ldgen(input [3:0] cstate);//pc_ld
begin
	case(cstate)
	4'b1000:pc_ldgen=1;
	default:pc_ldgen=0;
	endcase
end
endfunction

function mem_selgen(input [3:0] cstate,
		    input [31:0] ir);//mem_sel
begin
	case(cstate)
	4'b0001: mem_selgen=0;
	4'b1000:
	begin
		casex(ir)
		32'bxxxx_xxxx_xxxx_xxxx_xxxx_xxxx_x000_0011:mem_selgen=1;//ロード命令
    	32'bxxxx_xxxx_xxxx_xxxx_xxxx_xxxx_x010_0011:mem_selgen=1;//ストア命令 (Bレジスタの値をCレジスタのアドレス先に書き込む)
		default:;
		endcase
	end
	default:; //
	endcase
end
endfunction

function mem_readgen(input [3:0] cstate,
		     input [31:0] ir);//mem_read
begin
	case(cstate)
	4'b1000:
	begin
		casex(ir)
		32'bxxxx_xxxx_xxxx_xxxx_xxxx_xxxx_x000_0011:mem_readgen=1;//ロード命令
		default:mem_readgen=0;
		endcase
	end
	default:mem_readgen=0;
	endcase
end
endfunction

function mem_writegen(input [3:0] cstate,
		     input [31:0] ir);//mem_write
begin
	casex(cstate) //
	4'b1000:
	begin
		casex(ir)
		32'bxxxx_xxxx_xxxx_xxxx_xxxx_xxxx_x010_0011:mem_writegen=1;
		default:mem_writegen=0;
		endcase
	end
	default:mem_writegen=0;
	endcase
end
endfunction

function [3:0] mem_wrbitsgen(input [3:0] cstate,
			     input [31:0] ir,
			     input [31:0] addr);//mem_wrbits
begin
	case(cstate)
	4'b1000:
	begin
		casex (ir)
		32'bxxxx_xxxx_xxxx_xxxx_x000_xxxx_x010_0011:    //SB
		begin
			casex (addr)
			32'bxxxx_xxxx_xxxx_xxxx_xxxx_xxxx_xxxx_xx00: mem_wrbitsgen= 4'b0001;
			32'bxxxx_xxxx_xxxx_xxxx_xxxx_xxxx_xxxx_xx01: mem_wrbitsgen= 4'b0010;
			32'bxxxx_xxxx_xxxx_xxxx_xxxx_xxxx_xxxx_xx10: mem_wrbitsgen= 4'b0100; 
			32'bxxxx_xxxx_xxxx_xxxx_xxxx_xxxx_xxxx_xx11: mem_wrbitsgen= 4'b1000;
			default:;
            		endcase 
            	end
         	32'bxxxx_xxxx_xxxx_xxxx_x001_xxxx_x010_0011:    //SH
            	begin
			casex (addr)
            		32'bxxxx_xxxx_xxxx_xxxx_xxxx_xxxx_xxxx_xx00: mem_wrbitsgen= 4'b0011;
            		32'bxxxx_xxxx_xxxx_xxxx_xxxx_xxxx_xxxx_xx10: mem_wrbitsgen= 4'b1100;  
			default:;
            		endcase
            	end
         	32'bxxxx_xxxx_xxxx_xxxx_x010_xxxx_x010_0011: mem_wrbitsgen= 4'b1111;    //SW
		default:;
        	endcase
	end
	default:;
	endcase
end
endfunction

function ir_ldgen(input [3:0] cstate);//ir_ld
begin
	case(cstate)
	4'b0001: ir_ldgen=1;
	default: ir_ldgen=0;
	endcase
end
endfunction

function [1:0] rd_selgen(input [3:0] cstate,
			 input [31:0] ir);//rd_sel
begin
	case(cstate)
	4'b1000:
	begin
		casex(ir)
		32'bxxxx_xxxx_xxxx_xxxx_xxxx_xxxx_x011_0111: rd_selgen=2'b10;	//LUI
		32'bxxxx_xxxx_xxxx_xxxx_xxxx_xxxx_xxx1_0011: rd_selgen=2'b10;   //演算命令
		32'bxxxx_xxxx_xxxx_xxxx_xxxx_xxxx_x000_0011: rd_selgen=2'b00;	//ロード命令
		32'bxxxx_xxxx_xxxx_xxxx_xxxx_xxxx_x110_x111: rd_selgen=2'b01;   //JAL&JALR		
		default:;
		endcase
	end
	default:;
	endcase
end
endfunction

function rd_ldgen(input [3:0] cstate,
		  input [31:0] ir);//rd_ld
begin
	case(cstate)
	4'b1000:
	begin
		casex(ir)
		32'bxxxx_xxxx_xxxx_xxxx_xxxx_xxxx_x011_0111: rd_ldgen=1;//LUI
		32'bxxxx_xxxx_xxxx_xxxx_xxxx_xxxx_xxx1_0011: rd_ldgen=1;//演算命令
		32'bxxxx_xxxx_xxxx_xxxx_xxxx_xxxx_x000_0011: rd_ldgen=1;//ロード命令
		32'bxxxx_xxxx_xxxx_xxxx_xxxx_xxxx_x110_x111: rd_ldgen=1;//JAL&JALR		
		default: rd_ldgen=0;
		endcase
	end
	default:rd_ldgen=0;
	endcase
end
endfunction

function ab_ldgen(input [3:0] cstate);//a_ld,b_ld
begin
	case(cstate)
	4'b0010:ab_ldgen=1;
	default:ab_ldgen=0;
	endcase
end
endfunction

function  a_selgen(input [3:0] cstate,
		   input [31:0] ir);//a_sel
begin
	case(cstate)
	4'b0100:
	begin
		casex(ir)
		32'bxxxx_xxxx_xxxx_xxxx_xxxx_xxxx_x001_0111:a_selgen=1;//AUIPC
		32'bxxxx_xxxx_xxxx_xxxx_xxxx_xxxx_x110_1111:a_selgen=1;//JAL
		32'bxxxx_xxxx_xxxx_xxxx_xxxx_xxxx_x110_0111:a_selgen=1;//JALR
		32'bxxxx_xxxx_xxxx_xxxx_xxxx_xxxx_x110_0011:a_selgen=1;//分岐アドレス計算
		32'bxxxx_xxxx_xxxx_xxxx_xxxx_xxxx_x001_0011:a_selgen=0;//ADDI系
		32'bxxxx_xxxx_xxxx_xxxx_xxxx_xxxx_x0x0_0011:a_selgen=0;//LORD,STORE
		32'bxxxx_xxxx_xxxx_xxxx_xxxx_xxxx_x011_0011:a_selgen=0;//ADD系
		default:;
		endcase	
	end
	4'b1000:
	begin
		casex(ir)
		32'bxxxx_xxxx_xxxx_xxxx_x000_xxxx_x110_0011:a_selgen=0;//分岐命令
		default:;
		endcase
	end
	default:;
	endcase
end
endfunction

function  b_selgen(input [3:0] cstate,
		   input [31:0] ir);//b_sel
begin
	case(cstate)
	4'b0100:
	begin
		casex(ir)
		32'bxxxx_xxxx_xxxx_xxxx_xxxx_xxxx_x011_0111:b_selgen=1;//LUI
		32'bxxxx_xxxx_xxxx_xxxx_xxxx_xxxx_x001_0111:b_selgen=1;//AUIPC
		32'bxxxx_xxxx_xxxx_xxxx_xxxx_xxxx_x110_1111:b_selgen=1;//JAL
		32'bxxxx_xxxx_xxxx_xxxx_xxxx_xxxx_x110_0111:b_selgen=1;//JALR
		32'bxxxx_xxxx_xxxx_xxxx_xxxx_xxxx_x110_0011:b_selgen=1;//分岐アドレス計算
		32'bxxxx_xxxx_xxxx_xxxx_xxxx_xxxx_x001_0011:b_selgen=1;//ADDI系
		32'bxxxx_xxxx_xxxx_xxxx_xxxx_xxxx_x0x0_0011:b_selgen=1;//LORD,STORE
		32'bx0xx_xxxx_xxxx_xxxx_x000_xxxx_x011_0011:b_selgen=0;//ADD系
		default:;
		endcase	
	end
	4'b1000:
	begin
		casex(ir)
		32'bxxxx_xxxx_xxxx_xxxx_x000_xxxx_x110_0011:b_selgen=0;//分岐命令
		default:;
		endcase
	end
	default:;
	endcase
end
endfunction


function [31:0] immgen(input [3:0] cstate,
			input [31:0] ir);//imm
begin
	// case(cstate)
	// 4'b0010:
	begin
		casex(ir)
		32'bxxxx_xxxx_xxxx_xxxx_xxxx_xxxx_x011_0111:immgen={ir[31:12],12'b0000_0000_0000};//Utype
		32'bxxxx_xxxx_xxxx_xxxx_xxxx_xxxx_x001_0111:immgen={ir[31:12],12'b0000_0000_0000};//Utype
		32'bxxxx_xxxx_xxxx_xxxx_xxxx_xxxx_x110_1111:immgen={ { 10{ ir[31:31] } }, ir[31:31], ir[19:12], ir[20:20], ir[30:21], 2'b0 };//Jtype
		//begin
			//casex(ir)
			//32'b1xxx_xxxx_xxxx_xxxx_xxxx_xxxx_xxxx_xxxx:immgen={10'b11_1111_1111,ir[31],ir[19:12],ir[20],ir[30:21],2'b00};
			//32'b0xxx_xxxx_xxxx_xxxx_xxxx_xxxx_xxxx_xxxx:immgen={10'b00_0000_0000,ir[31],ir[19:12],ir[20],ir[30:21],2'b00};
			//default:;
			//endcase
		//end
		32'bxxxx_xxxx_xxxx_xxxx_xxxx_xxxx_x010_0011://Stype
		begin
			casex(ir)
			32'b1xxx_xxxx_xxxx_xxxx_xxxx_xxxx_xxxx_xxxx:immgen={20'b1111_1111_1111_1111_1111,ir[31:25],ir[11:7]};
			32'b0xxx_xxxx_xxxx_xxxx_xxxx_xxxx_xxxx_xxxx:immgen={20'b0000_0000_0000_0000_0000,ir[31:25],ir[11:7]};
			default:;
			endcase
		end
		32'bxxxx_xxxx_xxxx_xxxx_xxxx_xxxx_x110_0011://Btype
		begin
			casex(ir)
			32'b1xxx_xxxx_xxxx_xxxx_xxxx_xxxx_xxxx_xxxx:immgen={19'b111_1111_1111_1111_1111,ir[31],ir[7],ir[30:25],ir[11:8],1'b0};
			32'b0xxx_xxxx_xxxx_xxxx_xxxx_xxxx_xxxx_xxxx:immgen={19'b000_0000_0000_0000_0000,ir[31],ir[7],ir[30:25],ir[11:8],1'b0};
			default:;
			endcase
		end
		32'bxxxx_xxxx_xxxx_xxxx_xxxx_xxxx_x000_0011://Itype
		begin
			casex(ir)
			32'b1xxx_xxxx_xxxx_xxxx_xxxx_xxxx_xxxx_xxxx:immgen={20'b1111_1111_1111_1111_1111,ir[31:20]};
			32'b0xxx_xxxx_xxxx_xxxx_xxxx_xxxx_xxxx_xxxx:immgen={20'b0000_0000_0000_0000_0000,ir[31:20]};
			default:;
			endcase
		end	
		32'bxxxx_xxxx_xxxx_xxxx_xxxx_xxxx_x001_0011://Itype
		begin
			casex(ir)
			32'b1xxx_xxxx_xxxx_xxxx_xxxx_xxxx_xxxx_xxxx:immgen={20'b1111_1111_1111_1111_1111,ir[31:20]};
			32'b0xxx_xxxx_xxxx_xxxx_xxxx_xxxx_xxxx_xxxx:immgen={20'b0000_0000_0000_0000_0000,ir[31:20]};
			default:;
			endcase
		end
		32'bxxxx_xxxx_xxxx_xxxx_xxxx_xxxx_x110_0111://Itype
		begin
			casex(ir)
			32'b1xxx_xxxx_xxxx_xxxx_xxxx_xxxx_xxxx_xxxx:immgen={20'b1111_1111_1111_1111_1111,ir[31:20]};
			32'b0xxx_xxxx_xxxx_xxxx_xxxx_xxxx_xxxx_xxxx:immgen={20'b0000_0000_0000_0000_0000,ir[31:20]};
			default:;
			endcase
		end
		default:;
		endcase
	end
	// endcase
	//default:;
end
endfunction

function [3:0] alu_ctlgen(input [3:0] cstate,
			  input [31:0] ir);//alu_ctl
begin
	case(cstate)
	4'b0100:
	begin
		casex(ir)
		32'bxxxx_xxxx_xxxx_xxxx_xxxx_xxxx_x011_0111:alu_ctlgen=4'b0000;//LUI
		32'bxxxx_xxxx_xxxx_xxxx_xxxx_xxxx_x001_0111:alu_ctlgen=4'b1000;//AUIPC
		32'bxxxx_xxxx_xxxx_xxxx_xxxx_xxxx_x110_1111:alu_ctlgen=4'b1000;//JAL
		32'bxxxx_xxxx_xxxx_xxxx_xxxx_xxxx_x110_0111:alu_ctlgen=4'b1000;//JALR
		32'bxxxx_xxxx_xxxx_xxxx_xxxx_xxxx_x110_0011:alu_ctlgen=4'b1000;//分岐アドレス計算
		32'bxxxx_xxxx_xxxx_xxxx_x000_xxxx_x001_0011:alu_ctlgen=4'b1000;//ADDI
		32'bxxxx_xxxx_xxxx_xxxx_x01x_xxxx_x001_0011:alu_ctlgen=4'b0110;//SLTI
		32'bxxxx_xxxx_xxxx_xxxx_x100_xxxx_x001_0011:alu_ctlgen=4'b1010;//XORI
		32'bxxxx_xxxx_xxxx_xxxx_x110_xxxx_x001_0011:alu_ctlgen=4'b1011;//ORI
		32'bxxxx_xxxx_xxxx_xxxx_x111_xxxx_x001_0011:alu_ctlgen=4'b1100;//ANDI
		32'bxxxx_xxxx_xxxx_xxxx_x001_xxxx_x001_0011:alu_ctlgen=4'b1101;//SLLI	
		32'bx0xx_xxxx_xxxx_xxxx_x101_xxxx_x001_0011:alu_ctlgen=4'b1110;//SRLI
		32'bx1xx_xxxx_xxxx_xxxx_x001_xxxx_x001_0011:alu_ctlgen=4'b1111;//SRAI
		32'bxxxx_xxxx_xxxx_xxxx_xxxx_xxxx_x0x0_0011:alu_ctlgen=4'b1000;//LORD,STORE
		32'bx0xx_xxxx_xxxx_xxxx_x000_xxxx_x011_0011:alu_ctlgen=4'b1000;//ADD
		32'bx1xx_xxxx_xxxx_xxxx_x000_xxxx_x011_0011:alu_ctlgen=4'b1001;//SUB
		32'bxxxx_xxxx_xxxx_xxxx_x001_xxxx_x011_0011:alu_ctlgen=4'b1101;//SLL
		32'bxxxx_xxxx_xxxx_xxxx_x010_xxxx_x011_0011:alu_ctlgen=4'b0100;//SLT
		32'bxxxx_xxxx_xxxx_xxxx_x011_xxxx_x011_0011:alu_ctlgen=4'b0110;//SLTU
		32'bxxxx_xxxx_xxxx_xxxx_x100_xxxx_x011_0011:alu_ctlgen=4'b1010;//XOR
		32'bx0xx_xxxx_xxxx_xxxx_x101_xxxx_x011_0011:alu_ctlgen=4'b1110;//SRL
		32'bx1xx_xxxx_xxxx_xxxx_x000_xxxx_x011_0011:alu_ctlgen=4'b1111;//SRA
		default:;
		endcase	
	end
	4'b1000:
	begin
		casex(ir)
		32'bxxxx_xxxx_xxxx_xxxx_x000_xxxx_x110_0011:alu_ctlgen=4'b0010;//BEQ
		32'bxxxx_xxxx_xxxx_xxxx_x001_xxxx_x110_0011:alu_ctlgen=4'b0011;//BNE
		32'bxxxx_xxxx_xxxx_xxxx_x100_xxxx_x110_0011:alu_ctlgen=4'b0100;//BLT
		32'bxxxx_xxxx_xxxx_xxxx_x101_xxxx_x110_0011:alu_ctlgen=4'b0101;//BGE
		32'bxxxx_xxxx_xxxx_xxxx_x110_xxxx_x110_0011:alu_ctlgen=4'b0110;//BLTU
		32'bxxxx_xxxx_xxxx_xxxx_x111_xxxx_x110_0011:alu_ctlgen=4'b0111;//BGEU
		default:;
		endcase
	end
	default:;
	endcase
end
endfunction

function c_ldgen(input [3:0] cstate);//c_ld
begin
	casex(cstate)
	4'b0100:c_ldgen=1;
	default:c_ldgen=0;
	endcase
end
endfunction

assign pc_sel = pc_selgen(cstate,ir,alu_out);
assign pc_ld = pc_ldgen(cstate);
assign mem_sel = mem_selgen(cstate,ir);
assign mem_read = mem_readgen(cstate,ir);
assign mem_write = mem_writegen(cstate,ir);
assign mem_wrbits = mem_wrbitsgen(cstate,ir,addr);
assign ir_ld = ir_ldgen(cstate);
assign rs1_addr = ir[19:15];
assign rs2_addr = ir[24:20];
assign rd_addr = ir[11:7];
assign rd_sel = rd_selgen(cstate,ir);
assign rd_ld = rd_ldgen(cstate,ir);
assign a_ld = ab_ldgen(cstate);
assign b_ld = ab_ldgen(cstate);
assign a_sel = a_selgen(cstate,ir);
assign b_sel = b_selgen(cstate,ir);
assign imm = immgen(cstate,ir);
assign alu_ctl = alu_ctlgen(cstate,ir);
assign c_ld = c_ldgen(cstate); 
endmodule // controller