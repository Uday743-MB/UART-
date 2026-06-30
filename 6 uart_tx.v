module uart_tx(
input clk,
input rst,
input baud_tick,
input tx_start,
input [7:0] tx_data,
output reg tx,
output reg tx_done);
reg [7:0] shift_reg;
reg [2:0] bit_count;
reg [1:0] state;
localparam
IDLE  = 2'd0,
START = 2'd1,
DATA  = 2'd2,
STOP  = 2'd3;
always @(posedge clk or posedge rst)
begin
if(rst)
begin
state <= IDLE;
tx <= 1'b1;
tx_done <= 0;
bit_count <= 0;
end
else if(baud_tick)
begin
case(state)
IDLE:
begin
tx <= 1'b1;
tx_done <= 0;
if(tx_start)
begin
shift_reg <= tx_data;
state <= START;
end
end
START:
begin
tx <= 1'b0;
bit_count <= 0;
state <= DATA;
end
DATA:
begin
tx <= shift_reg[0];
shift_reg <= shift_reg >> 1;
if(bit_count == 7)
state <= STOP;
else
bit_count <= bit_count + 1;
end
STOP:
begin
tx <= 1'b1;
tx_done <= 1'b1;
state <= IDLE;
end
endcase
end
end
endmodule
