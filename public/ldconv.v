
// @file ldconv.v
// @breif ldconv(ロードデータ変換器)
// @author Yusuke Matsunaga (松永 裕介)
//
// Copyright (C) 2019 Yusuke Matsunaga
// All rights reserved.
//
// [概要]
// ロードのデータタイプに応じてデータを変換する．
// 具体的には以下の処理を行う．
//
// * B(byte) タイプ
//   オフセットに応じたバイトを取り出し，符号拡張を行う．
// * BU(byte unsigned) タイプ
//   オフセットに応じたバイトを取り出し，上位に0を詰める．
// * H(half word) タイプ
//   オフセットに応じたハーフワード(16ビット)を取り出し，符号拡張を行う．
// * HU(half word unsigned) タイプ
//   オフセットに応じたハーフワード(16ビット)を取り出し，上位に0を詰める．
// * W(word) タイプ
//   そのままの値を返す．
//
// B, BU, H, HU, W タイプの判別は IR レジスタの内容で行う．
//
// [入出力]
// in:     入力(32ビット)
// ir:     IRレジスタの値
// offset: アドレスオフセット
// out:    出力(32ビット)
module ldconv(input [31:0] in,
	      input [31:0] 	ir,
	      input [1:0] offset,
	      output [31:0] out);
parameter LB = 3'b000;
parameter LH = 3'b001;
parameter LW = 3'b010;
parameter LBU = 3'b100;
parameter LHU = 3'b101;
function [31:0] convert(input [31:0] in,input [31:0] ir,input [1:0] offset);
	begin
	case (ir[14:12])
		LB:
		begin
			case(offset)
				0:convert = {{24{in[7]}},in[7-:8]};
				1:convert = {{24{in[15]}},in[15-:8]};
				2:convert = {{24{in[23]}},in[23-:8]};
				3:convert = {{24{in[31]}},in[31-:8]};
				default:;
			endcase
		end
		LH:
		begin
			case(offset)
				0:convert = {24'b0,in[7-:8]};
				1:convert = {24'b0,in[15-:8]};
				2:convert = {24'b0,in[23-:8]};
				3:convert = {24'b0,in[31-:8]};
				default:;
			endcase
		end
		LW:
			convert = in;
		LBU:
		begin
			case(offset)
				0:convert = {{16{in[15]}},in[15-:16]};
				1:convert = {{16{in[23]}},in[23-:16]};
				2:convert = {{16{in[31]}},in[31-:16]};
				3:convert = {{24{in[31]}},in[31-:8]};
				default:;
			endcase
		end
		LHU:
		begin
			case(offset)
				0:convert = {16'b0,in[15-:16]};
				1:convert = {16'b0,in[23-:16]};
				2:convert = {16'b0,in[31-:16]};
				3:convert = {24'b0,in[31-:8]};
				default:;
			endcase
		end
		default: 
			convert = in;
		endcase
	end
endfunction
assign out = convert(in,ir,offset);
endmodule // ldconv