module keybuf(input clock,
	      input reset,
	      input key_in,
	      input [3:0] key_val,
	      input clear,
	      output [31:0] out);
reg [31:0] buffer; 
always @(posedge clock or negedge reset)
begin
	if(!reset)
	begin
		buffer<=32'b0;
	end
	else if(clear)
	begin
		buffer<=32'b0;
	end
	else if(key_in)
	begin
		buffer<={buffer[27:0],key_val};
	end
end
assign out=buffer;
endmodule