
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
		  output pc_sel,
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

reg pc_sel_val;
reg pc_ld_val;
reg mem_sel_val;
reg mem_read_val;
reg mem_write_val;
reg [3:0] mem_wrbits_val;
reg ir_ld_val;
reg [4:0] rs1_addr_val;
reg [4:0] rs2_addr_val;
reg [4:0] rd_addr_val;
reg [1:0] rd_sel_val;
reg rd_ld_val;
reg a_ld_val;
reg b_ld_val;
reg a_sel_val;
reg b_sel_val;
reg [31:0] imm_val;
reg [3:0] alu_ctl_val;
reg c_ld_val;

always@(*)
begin
	pc_ld_val<=0;
	mem_read_val<=0;
	mem_write_val<=0;
	ir_ld_val<=0;
	rd_ld_val<=0;
	a_ld_val<=0;
	b_ld_val<=0;
	c_ld_val<=0;
	case(cstate)
	4'b0001://IF
	begin
		mem_sel_val<=0;
		ir_ld_val<=1;
	end
	4'b0010://DE
	begin
		casex(ir)
		32'bxxxx_xxxx_xxxx_xxxx_xxxx_xxxx_x011_0111://Utype
		begin
			imm_val<={ir[31:12],12'b0000_0000_0000};
		end
		32'bxxxx_xxxx_xxxx_xxxx_xxxx_xxxx_x001_0111://Utype
		begin
			imm_val<={ir[31:12],12'b0000_0000_0000};
		end
		32'bxxxx_xxxx_xxxx_xxxx_xxxx_xxxx_x110_1111://Jtype
		begin
			casex(ir)
			32'b1xxx_xxxx_xxxx_xxxx_xxxx_xxxx_xxxx_xxxx:
			begin
				imm_val<={11'b1111_1111_1111_111,ir[31],ir[19:12],ir[20],ir[30:21],1'b0};
			end
			32'b0xxx_xxxx_xxxx_xxxx_xxxx_xxxx_xxxx_xxxx:
			begin
				imm_val<={11'b0000_0000_0000_000,ir[31],ir[19:12],ir[20],ir[30:21],1'b0};
			end
			default:;
			endcase
		end
		32'bxxxx_xxxx_xxxx_xxxx_xxxx_xxxx_x010_0011://Stype
		begin
			casex(ir)
			32'b1xxx_xxxx_xxxx_xxxx_xxxx_xxxx_xxxx_xxxx:
			begin
				imm_val<={20'b1111_1111_1111_1111_1111,ir[31:25],ir[11:7]};
			end
			32'b0xxx_xxxx_xxxx_xxxx_xxxx_xxxx_xxxx_xxxx:
			begin
				imm_val<={20'b0000_0000_0000_0000_0000,ir[31:25],ir[11:7]};
			end	
			default:;
			endcase
		end
		32'bxxxx_xxxx_xxxx_xxxx_xxxx_xxxx_x110_0011://Btype
		begin
			casex(ir)
			32'b1xxx_xxxx_xxxx_xxxx_xxxx_xxxx_xxxx_xxxx:
			begin
				imm_val<={19'b111_1111_1111_1111_1111,ir[31],ir[7],ir[30:25],ir[11:8],1'b0};
			end
			32'b0xxx_xxxx_xxxx_xxxx_xxxx_xxxx_xxxx_xxxx:
			begin
				imm_val<={19'b000_0000_0000_0000_0000,ir[31],ir[7],ir[30:25],ir[11:8],1'b0};
			end
			default:;
			endcase
		end
		32'bxxxx_xxxx_xxxx_xxxx_xxxx_xxxx_x000_0011://Itype
		begin
			casex(ir)
			32'b1xxx_xxxx_xxxx_xxxx_xxxx_xxxx_xxxx_xxxx:
			begin
				imm_val<={20'b1111_1111_1111_1111_1111,ir[31:20]};
			end
			32'b0xxx_xxxx_xxxx_xxxx_xxxx_xxxx_xxxx_xxxx:
			begin
				imm_val<={20'b0000_0000_0000_0000_0000,ir[31:20]};
			end	
			default:;
			endcase
		end	
		32'bxxxx_xxxx_xxxx_xxxx_xxxx_xxxx_x001_0011://Itype
		begin
			casex(ir)
			32'b1xxx_xxxx_xxxx_xxxx_xxxx_xxxx_xxxx_xxxx:
			begin
				imm_val<={20'b1111_1111_1111_1111_1111,ir[31:20]};
			end
			32'b0xxx_xxxx_xxxx_xxxx_xxxx_xxxx_xxxx_xxxx:
			begin
				imm_val<={20'b0000_0000_0000_0000_0000,ir[31:20]};
			end	
			default:;
			endcase
		end
		default:;
		endcase
		rs1_addr_val<=ir[19:15];
		rs2_addr_val<=ir[24:20];
		a_ld_val<=1;
		b_ld_val<=1;	
	end
	4'b0100: //EX
	begin
		casex(ir)
		32'bxxxx_xxxx_xxxx_xxxx_xxxx_xxxx_x011_0111://LUI
		begin
			b_sel_val<=1;
			alu_ctl_val<=4'b0000;
		end
		32'bxxxx_xxxx_xxxx_xxxx_xxxx_xxxx_x001_0111://AUIPC
		begin
			a_sel_val<=1;
			b_sel_val<=1;
			alu_ctl_val<=4'b1000;
		end
		32'bxxxx_xxxx_xxxx_xxxx_x000_xxxx_x110_1111://JAL
		begin
			b_sel_val<=1;
			alu_ctl_val<=4'b0000;
		end
		32'bxxxx_xxxx_xxxx_xxxx_xxxx_xxxx_x110_0x11://分岐アドレス計算
		begin
			a_sel_val<=1;
			b_sel_val<=1;
			alu_ctl_val<=4'b1000;
		end
		32'bxxxx_xxxx_xxxx_xxxx_x000_xxxx_x001_0011://ADDI
		begin
			a_sel_val<=0;
			b_sel_val<=1;
			alu_ctl_val<=4'b1000;
		end
		32'bxxxx_xxxx_xxxx_xxxx_x01x_xxxx_x001_0011://SLTI
		begin
			a_sel_val<=0;
			b_sel_val<=1;
			alu_ctl_val<=4'b0110;
		end
		32'bxxxx_xxxx_xxxx_xxxx_x100_xxxx_x001_0011://XORI
		begin
			a_sel_val<=0;
			b_sel_val<=1;
			alu_ctl_val<=4'b1010;
		end
		32'bxxxx_xxxx_xxxx_xxxx_x110_xxxx_x001_0011://ORI
		begin
			a_sel_val<=0;
			b_sel_val<=1;
			alu_ctl_val<=4'b1011;
		end
		32'bxxxx_xxxx_xxxx_xxxx_x111_xxxx_x001_0011://ANDI
		begin
			a_sel_val<=0;
			b_sel_val<=1;
			alu_ctl_val<=4'b1100;
		end
		32'bxxxx_xxxx_xxxx_xxxx_x001_xxxx_x001_0011://SLLI
		begin
			a_sel_val<=0;
			b_sel_val<=1;
			alu_ctl_val<=4'b1101;
		end
		32'bx0xx_xxxx_xxxx_xxxx_x101_xxxx_x001_0011://SRLI
		begin
			a_sel_val<=0;
			b_sel_val<=1;
			alu_ctl_val<=4'b1110;
		end
		32'bx1x_xxxx_xxxx_xxxx_x001_xxxx_x001_0011://SRAI
		begin
			a_sel_val<=0;
			b_sel_val<=1;
			alu_ctl_val<=4'b1111;
		end
		32'bxxxx_xxxx_xxxx_xxxx_xxxx_xxxx_x0x0_0011://LORD,STORE
		begin
			a_sel_val<=0;
			b_sel_val<=1;
			alu_ctl_val<=4'b1000;
		end
		32'bx0xx_xxxx_xxxx_xxxx_x000_xxxx_x011_0011://ADD
		begin
			a_sel_val<=0;
			b_sel_val<=0;
			alu_ctl_val<=4'b1000;
		end
		32'bx1xx_xxxx_xxxx_xxxx_x000_xxxx_x011_0011://SUB
		begin
			a_sel_val<=0;
			b_sel_val<=0;
			alu_ctl_val<=4'b1001;
		end
		32'bxxxx_xxxx_xxxx_xxxx_x001_xxxx_x011_0011://SLL
		begin
			a_sel_val<=0;
			b_sel_val<=0;
			alu_ctl_val<=4'b1101;
		end
		32'bxxxx_xxxx_xxxx_xxxx_x010_xxxx_x011_0011://SLT
		begin
			a_sel_val<=0;
			b_sel_val<=0;
			alu_ctl_val<=4'b0100;
		end
		32'bxxxx_xxxx_xxxx_xxxx_x011_xxxx_x011_0011://SLTU
		begin
			a_sel_val<=0;
			b_sel_val<=0;
			alu_ctl_val<=4'b0110;
		end
		32'bxxxx_xxxx_xxxx_xxxx_x100_xxxx_x011_0011://XOR
		begin
			a_sel_val<=0;
			b_sel_val<=0;
			alu_ctl_val<=4'b1010;
		end
		32'bx0xx_xxxx_xxxx_xxxx_x101_xxxx_x011_0011://SRL
		begin
			a_sel_val<=0;
			b_sel_val<=0;
			alu_ctl_val<=4'b1110;
		end
		32'bx1xx_xxxx_xxxx_xxxx_x000_xxxx_x011_0011://SRA
		begin
			a_sel_val<=0;
			b_sel_val<=0;
			alu_ctl_val<=4'b1111;
		end
		default:;
		endcase
		c_ld_val<=1;	
	end
	4'b1000: //WB
	begin
		pc_sel_val<=0;
		pc_ld_val<=1;
		rd_addr_val<=ir[11:7];
		casex(ir)
		32'bxxxx_xxxx_xxxx_xxxx_xxxx_xxxx_x011_0111: 	//LUI
		begin
			rd_sel_val <= 2'b10;
			rd_ld_val <= 1;
		end
		32'bxxxx_xxxx_xxxx_xxxx_xxxx_xxxx_xxx1_0011:    //演算命令
      begin	
         rd_sel_val <= 2'b10;
			rd_ld_val <= 1;
      end
    	32'bxxxx_xxxx_xxxx_xxxx_xxxx_xxxx_x000_0011:		//ロード命令
      begin
         mem_sel_val <= 1;
         mem_read_val <= 1;
         rd_sel_val <= 2'b00;
         rd_ld_val <= 1;
      end
    	32'bxxxx_xxxx_xxxx_xxxx_xxxx_xxxx_x010_0011:    //ストア命令 (Bレジスタの値をCレジスタのアドレス先に書き込む)
      begin
         mem_sel_val <= 1;
         mem_write_val <= 1;
         casex (ir)
			32'bxxxx_xxxx_xxxx_xxxx_x000_xxxx_x010_0011:    //SB
				begin
            casex (alu_out)
            32'bxxxx_xxxx_xxxx_xxxx_xxxx_xxxx_xxxx_xx00: mem_wrbits_val <= 4'b0001;
				32'bxxxx_xxxx_xxxx_xxxx_xxxx_xxxx_xxxx_xx01: mem_wrbits_val <= 4'b0010;
            32'bxxxx_xxxx_xxxx_xxxx_xxxx_xxxx_xxxx_xx10: mem_wrbits_val <= 4'b0100; 
            32'bxxxx_xxxx_xxxx_xxxx_xxxx_xxxx_xxxx_xx11: mem_wrbits_val <= 4'b1000;
				default:;
            endcase 
            end
         32'bxxxx_xxxx_xxxx_xxxx_x001_xxxx_x010_0011:    //SH
            begin
            casex (alu_out)
            32'bxxxx_xxxx_xxxx_xxxx_xxxx_xxxx_xxxx_xx00: mem_wrbits_val <= 4'b0011;
            32'bxxxx_xxxx_xxxx_xxxx_xxxx_xxxx_xxxx_xx10: mem_wrbits_val <= 4'b1100;  
				default:;
            endcase
            end
         32'bxxxx_xxxx_xxxx_xxxx_x010_xxxx_x010_0011:    //SW
            begin
            mem_wrbits_val <= 4'b1111;
            end
			default:;
         endcase
		end
		32'bxxxx_xxxx_xxxx_xxxx_xxxx_xxxx_x110_x111:    //JAL&JALR
		begin
        	rd_sel_val <= 2'b01;
      	rd_ld_val <= 1;
       	pc_sel_val <= 1;
        	pc_ld_val <= 1;
		end
		32'bxxxx_xxxx_xxxx_xxxx_x000_xxxx_x110_0011://分岐命令
		begin
			casex(ir)
			32'bxxxx_xxxx_xxxx_xxxx_x000_xxxx_x110_0011://BEQ
			begin
				a_sel_val<=0;
				b_sel_val<=0;
				alu_ctl_val<=4'b0010;
			end
			32'bxxxx_xxxx_xxxx_xxxx_x001_xxxx_x110_0011://BNE
			begin
				a_sel_val<=0;
				b_sel_val<=0;
				alu_ctl_val<=4'b0011;		
			end	
			32'bxxxx_xxxx_xxxx_xxxx_x100_xxxx_x110_0011://BLT
			begin
				a_sel_val<=0;
				b_sel_val<=0;
				alu_ctl_val<=4'b0100;
			end
			32'bxxxx_xxxx_xxxx_xxxx_x101_xxxx_x110_0011://BGE
			begin
				a_sel_val<=0;
				b_sel_val<=0;
				alu_ctl_val<=4'b0101;
			end
			32'bxxxx_xxxx_xxxx_xxxx_x110_xxxx_x110_0011://BLTU
			begin
				a_sel_val<=0;
				b_sel_val<=0;
				alu_ctl_val<=4'b0110;	
			end
			32'bxxxx_xxxx_xxxx_xxxx_x111_xxxx_x110_0011://BGEU
			begin
				a_sel_val<=0;
				b_sel_val<=0;
				alu_ctl_val<=4'b0111;
			end
			default:;
			endcase
			case(alu_out)
			32'b1:
			begin
				pc_sel_val<=1;
				pc_ld_val<=1;
			end
			32'b0:
			begin
				pc_sel_val<=0;
				pc_ld_val<=1;
			end
			endcase
		end
		default:;
		endcase
	end
	endcase
end
assign pc_sel = pc_sel_val;
assign pc_ld = pc_ld_val;
assign mem_sel = mem_sel_val;
assign mem_read = mem_read_val;
assign mem_write = mem_write_val;
assign mem_wrbits = mem_wrbits_val;
assign ir_ld = ir_ld_val;
assign rs1_addr = rs1_addr_val;
assign rs2_addr = rs2_addr_val;
assign rd_addr = rd_addr_val;
assign rd_sel = rd_sel_val;
assign rd_ld = rd_ld_val;
assign a_ld = a_ld_val;
assign b_ld = b_ld_val;
assign a_sel = a_sel_val;
assign b_sel = b_sel_val;
assign imm = imm_val;
assign alu_ctl = alu_ctl_val;
assign c_ld = c_ld_val; 
endmodule // controller