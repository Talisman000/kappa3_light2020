// @file kadai1.v
// @breif 課題1: 7SEGデコーダのテスト用トップモジュール
// @author Yusuke Matsunaga (松永 裕介)
//
// Copyright (C) 2019 Yusuke Matsunaga
// All rights reserved.
//
// 1TE18159W 阪本 啓悟
//
// [概要]
// 課題1 のテストベンチ
module kadai1();

   // 7SEGデコーダのインスタンス
   reg [3:0] 		    in;
   wire [7:0] 		    dec_out;
   decode_7seg decode1(.in(in), .out(dec_out));

   initial begin

      in = 0;
      #10;
      in = 1;
      #10;
      in = 2;
      #10;
      in = 3;
      #10;
      in = 4;
      #10;
      in = 5;
      #10;
      in = 6;
      #10;
      in = 7;
      #10;
      in = 8;
      #10;
      in = 9;
      #10;
      in = 10;
      #10;
      in = 11;
      #10;
      in = 12;
      #10;
      in = 13;
      #10;
      in = 14;
      #10;
      in = 15;
   end

   initial $monitor("in = %d, out = %b%b%b%b_%b%b%b%b", in,
		    dec_out[7], dec_out[6], dec_out[5], dec_out[4],
		    dec_out[3], dec_out[2], dec_out[1], dec_out[0]);


endmodule

module decode_7seg(input [3:0] in, output [7:0] out);
   function [7:0] to_7seg;
      input [3:0] inp;
      case (inp)
         4'b0000: to_7seg = 8'b1111_1100;
         4'b0001: to_7seg = 8'b0110_0000;
         4'b0010: to_7seg = 8'b1101_1010;
         4'b0011: to_7seg = 8'b1111_0010;
         4'b0100: to_7seg = 8'b0110_0110;
         4'b0101: to_7seg = 8'b1011_0110;
         4'b0110: to_7seg = 8'b1011_1110;
         4'b0111: to_7seg = 8'b1110_0000;
         4'b1000: to_7seg = 8'b1111_1110;
         4'b1001: to_7seg = 8'b1111_0110;
         4'b1010: to_7seg = 8'b1110_1110;
         4'b1011: to_7seg = 8'b0011_1110;
         4'b1100: to_7seg = 8'b0001_1010;
         4'b1101: to_7seg = 8'b0111_1010;
         4'b1110: to_7seg = 8'b1001_1110;
         4'b1111: to_7seg = 8'b1000_1110;
         default: to_7seg = 8'b0000_0000;
      endcase
   endfunction
   assign out = to_7seg(in);
endmodule 
