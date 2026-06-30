module sipo(
input clk,
input rst,
input shift_en,
input serial_in,
output reg [7:0] parallel_out);
always @(posedge clk or posedge rst)
begin
    if(rst)
        parallel_out <= 8'b00000000;
    else if(shift_en)
        parallel_out <= {parallel_out[6:0], serial_in};
end
endmodule
