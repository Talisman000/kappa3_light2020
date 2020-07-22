// @file stconv.v
// @breif stconv(ストアデータ変換器)
// @author Yusuke Matsunaga (松永 裕介)
//
// Copyright (C) 2019 Yusuke Matsunaga
// All rights reserved.
//
// [概要]
// ストア命令用のデータ変換を行う．
// wrbits が1のビットの部分のみ書き込みを行う．
// 具体的には以下の処理を行う．
//
// * B(byte) タイプ
//   in の下位8ビットを4つ複製する．
// * H(half word) タイプ
//   in の下位16ビットを2つ複製する．
// * W(word) タイプ
//   out は in をそのまま．
//
// B, H, W タイプの判別は IR レジスタの内容で行う．
//
// [入出力]
// in:     入力(32ビット)
// ir:     IRレジスタの値
// out:    出力(32ビット)
module stconv(input [31:0]      in,
	      input [31:0] 	ir,
	      output [31:0] out);
function [31:0] stconverter (input [31:0] in,
			     input [31:0] ir);
begin
	casex(ir)
	32'bxxxx_xxxx_xxxx_xxxx_x000_xxxx_xxxx_xxxx:stconverter={in[7:0],in[7:0],in[7:0],in[7:0]};
	32'bxxxx_xxxx_xxxx_xxxx_x001_xxxx_xxxx_xxxx:stconverter={in[15:0],in[15:0]};
	32'bxxxx_xxxx_xxxx_xxxx_x010_xxxx_xxxx_xxxx:stconverter=in;
	default :; 
	endcase
end
endfunction
assign out=stconverter(in,ir);
endmodule // stconv
