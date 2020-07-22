module decode_7seg(input [3:0] in,output [7:0] out);
    function [7:0] decoder(input [3:0] f_in);
    begin
        case (f_in)
        0:decoder=8'b1111_1100;
        1:decoder=8'b0110_0000;
        2:decoder=8'b1101_1010;
        3:decoder=8'b1111_0010;
        4:decoder=8'b0110_0110;
        5:decoder=8'b1011_0110;
        6:decoder=8'b1011_1110;
        7:decoder=8'b1110_0000;
        8:decoder=8'b1111_1110;
        9:decoder=8'b1111_0110;
        10:decoder=8'b1110_1110;
        11:decoder=8'b0011_1110;
        12:decoder=8'b0001_1010;
        13:decoder=8'b0111_1010;
        14:decoder=8'b1001_1110;
        15:decoder=8'b1000_1110;
        endcase
    end
    endfunction
    assign out=decoder(in);
    
endmodule