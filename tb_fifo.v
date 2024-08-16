module tb_fifo 
#(parameter FIFO_WIDTH = 16 , parameter FIFO_DEPTH = 512)
();
reg [FIFO_WIDTH-1:0]din_a ;
reg wen_a , ren_b , rst ;
reg  clk_a , clk_b ;
wire [FIFO_WIDTH-1:0] dout_b ;
wire full ,empty ;

//dut
fifo #(.FIFO_WIDTH(FIFO_WIDTH) , .FIFO_DEPTH(FIFO_DEPTH)) dut
(
	.din_a(din_a),
	.wen_a(wen_a),
	.ren_b(ren_b),
	.rst(rst),
	.clk_a(clk_a),
	.clk_b(clk_b),
	.dout_b(dout_b),
	.full(full),
	.empty(empty)
);


//clk_a
initial begin
	clk_a = 0 ;
	forever#5 clk_a = ~clk_a ; //100MHZ clk
end
//clk_b
initial begin
	clk_b = 0 ;
	forever#10 clk_b = ~clk_b ; //50MHZ clk
end
initial begin
	$readmemh("mem.dat",dut.mem) ;
	rst = 1 ;
	din_a = 0 ;
	wen_a = 0 ;
	ren_b = 0 ;
	@(negedge  clk_a);
	rst = 0 ;
	repeat(250)begin
		din_a = $random ;
		wen_a = $random ;
		ren_b = $random ;
	@(negedge clk_b , clk_a);
	end
$stop ;
end
initial begin
	$monitor("Time = %0t, din_a = %h, wen_a = %b , ren_b = %b , dout_b = %h, full = %b, empty = %b , ", 
             $time, din_a,wen_a,ren_b, dout_b, full, empty);
end
endmodule
