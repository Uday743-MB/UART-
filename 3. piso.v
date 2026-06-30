module piso(input clk,
            input rst,
            input load,
            input shift,
            input [7:0] pdata,
            output reg sout
           );
reg [7:0] shift_reg;
always @(posedge clk or posedge rst)begin
    if(rst) begin
        shift_reg <= 8'd0;
        sout <= 1'b1;
    end
    else if(load) begin
        shift_reg <= pdata;
    end
    else if(shift)
    begin
        sout <= shift_reg[0];          // LSB First
        shift_reg <= shift_reg >> 1;
    end
end
endmodule
