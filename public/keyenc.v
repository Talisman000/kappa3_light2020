// @file keyenc.v
// @brief キー入力用のエンコーダ
// @author Yusuke Matsunaga (松永 裕介)
//
// Copyright (C) 2019 Yusuke Matsunaga
// All rights reserved.
//
// [概要]
// 16個のキー入力用のプライオリティ付きエンコーダ
//
// [入出力]
// keys: キー入力の値
// key_in: いずれかのキーが押された時に1となる出力
// key_val: キーの値(0 - 15)
module keyenc(input [15:0] keys,
	      output 	   key_in,
	      output [3:0] key_val);
function [3:0] encoder (input [15:0] k); 
begin
    casex(k)
    16'b1xxx_xxxx_xxxx_xxxx: encoder=4'hf;
    16'b01xx_xxxx_xxxx_xxxx: encoder=4'he;
    16'b001x_xxxx_xxxx_xxxx: encoder=4'hd;		
    16'b0001_xxxx_xxxx_xxxx: encoder=4'hc;
    16'b0000_1xxx_xxxx_xxxx: encoder=4'hb;
    16'b0000_01xx_xxxx_xxxx: encoder=4'ha;
    16'b0000_001x_xxxx_xxxx: encoder=4'h9;
    16'b0000_0001_xxxx_xxxx: encoder=4'h8;
    16'b0000_0000_1xxx_xxxx: encoder=4'h7;
    16'b0000_0000_01xx_xxxx: encoder=4'h6;
    16'b0000_0000_001x_xxxx: encoder=4'h5;
    16'b0000_0000_0001_xxxx: encoder=4'h4;
    16'b0000_0000_0000_1xxx: encoder=4'h3;
    16'b0000_0000_0000_01xx: encoder=4'h2;
    16'b0000_0000_0000_001x: encoder=4'h1;
    16'b0000_0000_0000_0001: encoder=4'h0;
    default:                 encoder=4'hx;
    endcase
end
endfunction
assign key_in= |(keys);
assign key_val=encoder(keys);

endmodule // keyenc
