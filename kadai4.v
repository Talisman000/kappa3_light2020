
// @file kadai4.v
// @breif 課題4: キー入力エンコーダのテストベンチ
// @author Yusuke Matsunaga (松永 裕介)
//
// Copyright (C) 2019 Yusuke Matsunaga
// All rights reserved.
//
// [概要]
// 課題4のテストベンチ
module kadai4();

   // エンコーダのインスタンス
   reg [15:0] keys;
   wire       key_in;
   wire [3:0] key_val;
   keyenc u(.keys(keys), .key_in(key_in), .key_val(key_val));

   // 初期化
   initial begin
      // 全部0
      keys = 16'b0000_0000_0000_0000;
      #10;
      // 一つだけ1
      keys = 16'b1000_0000_0000_0000;
      #10;
      keys = 16'b0100_0000_0000_0000;
      #10;
      keys = 16'b0010_0000_0000_0000;
      #10;
      keys = 16'b0001_0000_0000_0000;
      #10;
      keys = 16'b0000_1000_0000_0000;
      #10;
      keys = 16'b0000_0100_0000_0000;
      #10;
      keys = 16'b0000_0010_0000_0000;
      #10;
      keys = 16'b0000_0001_0000_0000;
      #10;
      keys = 16'b0000_0000_1000_0000;
      #10;
      keys = 16'b0000_0000_0100_0000;
      #10;
      keys = 16'b0000_0000_0010_0000;
      #10;
      keys = 16'b0000_0000_0001_0000;
      #10;
      keys = 16'b0000_0000_0000_1000;
      #10;
      keys = 16'b0000_0000_0000_0100;
      #10;
      keys = 16'b0000_0000_0000_0010;
      #10;
      keys = 16'b0000_0000_0000_0001;
      #10;
      keys = 16'b1000_0000_0000_0001;
      // 2つ以上1
      #10;
      keys = 16'b1001_0101_0001_1111;
      #10;
      keys = 16'b1001_0101_0001_0000;

   end // initial begin

   initial $monitor("keys= %b%b%b%b_%b%b%b%b_%b%b%b%b_%b%b%b%b, key_in = %b, key_val = %d",
		    keys[15], keys[14], keys[13], keys[12], keys[11], keys[10], keys[9], keys[8],
		    keys[7], keys[6], keys[5], keys[4], keys[3], keys[2], keys[1], keys[0],
		    key_in, key_val);
endmodule

module keyenc(input [15:0] keys,output key_in,output [3:0] key_val);
reg key_in;
always @(*)begin
   if(keys)
   key_in <= 1;
   else
   key_in <= 0;
end
function[3:0] key(input [15:0] keys);
   casex(keys)
      16'b1xxx_xxxx_xxxx_xxxx: key = 4'h0;
      16'bx1xx_xxxx_xxxx_xxxx: key = 4'h1;
      16'bxx1x_xxxx_xxxx_xxxx: key = 4'h2;
      16'bxxx1_xxxx_xxxx_xxxx: key = 4'h3;
      16'bxxxx_1xxx_xxxx_xxxx: key = 4'h4;
      16'bxxxx_x1xx_xxxx_xxxx: key = 4'h5;
      16'bxxxx_xx1x_xxxx_xxxx: key = 4'h6;
      16'bxxxx_xxx1_xxxx_xxxx: key = 4'h7;
      16'bxxxx_xxxx_1xxx_xxxx: key = 4'h8;
      16'bxxxx_xxxx_x1xx_xxxx: key = 4'h9;
      16'bxxxx_xxxx_xx1x_xxxx: key = 4'ha;
      16'bxxxx_xxxx_xxx1_xxxx: key = 4'hb;
      16'bxxxx_xxxx_xxxx_1xxx: key = 4'hc;
      16'bxxxx_xxxx_xxxx_x1xx: key = 4'hd;
      16'bxxxx_xxxx_xxxx_xx1x: key = 4'he;
      16'bxxxx_xxxx_xxxx_xxx1: key = 4'hf;
      default : key = 4'hx;
   endcase
endfunction
assign key_val = key(keys);
endmodule // kadai3
