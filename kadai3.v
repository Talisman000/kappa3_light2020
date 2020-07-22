
// @file kadai3.v
// @breif 課題3: 4ビットアップダウンカウンタのテストベンチ
// @author Yusuke Matsunaga (松永 裕介)
//
// Copyright (C) 2019 Yusuke Matsunaga
// All rights reserved.
//
// [概要]
// 課題3のテストベンチ
module kadai3();

   // カウンタのインスタンス
   reg        clock;
   reg 	      reset;
   reg 	      ud;
   reg        enable;
   wire [3:0] q;
   wire       carry;
   udcount4 u(.clock(clock), .reset(reset),
	      .ud(ud), .enable(enable),
	      .q(q), .carry(carry));

   // クロックの生成
   always begin
      clock = ~clock;
      #5;
   end

   // 初期化
   initial begin
      clock = 0;
      reset = 1;
      ud = 0;
      enable = 0;

      // リセット
      #1;
      reset = 0;
      #1;
      reset = 1;

      // カウントアップ開始
      #12;
      enable = 1;

      // カウント停止
      #200;
      enable = 0;

      // カウントダウン開始
      #50;
      ud = 1;
      enable = 1;

      // カウント停止
      #200;
      enable = 0;

      $finish;

   end // initial begin

   initial $monitor("ud = %b, enable = %b, q = %d, carry = %b",
		    ud, enable, q, carry);

endmodule // kadai3

module udcount4(  input clock, // クロック信号
                  input reset, // リセット信号
                  input ud, // 0: アップ，1: ダウン
                  input enable, // カウントイネーブル信号
                  output [3:0] q, // カウント値の出力
                  output carry); // キャリー出力
reg [3:0] q;
reg carry_q;
wire carry;

function CheckCarry(input[3:0] q,input ud);
   if(ud == 0 && q == 4'b1111)
      CheckCarry = 1;
   else if(ud == 1 && q == 4'b0000)
      CheckCarry = 1;
   else
      CheckCarry = 0;
endfunction

function[3:0] AddSub(input[3:0] q,input ud);
   case(ud)
   0: AddSub = q + 4'b0001;
   1: AddSub = q - 4'b0001;
   endcase
endfunction

always @(negedge reset or posedge clock)
begin
   if(!reset) 
      q <= 4'b0000;
   else
   begin
      if(enable)
         carry_q <= CheckCarry(q,ud);
         q <= AddSub(q,ud);
   end
end

assign carry = carry_q;
endmodule 
