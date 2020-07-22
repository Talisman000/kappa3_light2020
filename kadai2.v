
// @file kadai1.v
// @breif 課題2: 4ビット加算器のテストベンチ
// @author Yusuke Matsunaga (松永 裕介)
//
// Copyright (C) 2019 Yusuke Matsunaga
// All rights reserved.
//
// 1TE18159W 阪本 啓悟
//
// [概要]
// 課題2のテストベンチ
module kadai2();

   // 加算器のインスタンス
   reg [3:0]  a;
   reg [3:0]  b;
   reg 	      cin;
   wire [3:0] s;
   wire       cout;
   add4 add4(.a(a), .b(b), .cin(cin), .s(s), .cout(cout));

   initial begin
      a = 0;
      b = 0;
      cin = 0;
      #10;

      a = 1;
      b = 0;
      cin = 0;
      #10;

      a = 0;
      b = 2;
      cin = 0;
      #10;

      a = 1;
      b = 3;
      cin = 1;
      #10;

   end // initial begin

   initial $monitor("a = %d, b = %d, cin = %b, s = %d, cout = %b",
		    a, b, cin, s, cout);

endmodule // kadai2


module add4(input [3:0] a, b, input cin, output [3:0] s, output cout); 
   assign { cout , s } = a + b + cin ;
endmodule