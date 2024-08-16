module fifo 
#(parameter FIFO_WIDTH = 16 , parameter FIFO_DEPTH = 512 )
(
input [FIFO_WIDTH-1:0] din_a,
input wen_a, ren_b, rst,
input clk_a, clk_b,
output reg [FIFO_WIDTH-1:0] dout_b,
output reg full, empty
);

reg [FIFO_WIDTH-1:0] mem[FIFO_DEPTH-1:0];
reg [9:0] wr_count, red_count; // 10-bit counters for FIFO depth 512

always @(posedge clk_a or posedge rst) begin
    if (rst) begin
        wr_count <= 0;
        full <= 0;
    end else if (wen_a && !full) begin
        mem[wr_count] <= din_a;
        wr_count <= (wr_count + 1) % FIFO_DEPTH;
        full <= ((wr_count + 1) % FIFO_DEPTH == red_count);
        empty <= 0;
    end
end

always @(posedge clk_b or posedge rst) begin
    if (rst) begin
        red_count <= 0;
        dout_b <= 0;
        empty <= 1;
    end else if (ren_b && !empty) begin
        dout_b <= mem[red_count];
        red_count <= (red_count + 1) % FIFO_DEPTH;
        empty <= (red_count + 1) % FIFO_DEPTH == wr_count;
        full <= 0;
    end
end

endmodule

