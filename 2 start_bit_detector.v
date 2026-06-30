module start_bit_detector(
input clk,
input rst,
input rx,
output reg start_detect);
always @(posedge clk or posedge rst)begin
    if(rst) begin
        start_detect <= 1'b0;
    end
    else begin
        if(rx == 1'b0)
            start_detect <= 1'b1;
        else
            start_detect <= 1'b0;
    end
end
endmodule
