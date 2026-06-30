module parity_generator(
input  [7:0] data,
input        parity_sel,   //0-Even  1-Odd
output reg   parity);
always @(*)begin
    if(parity_sel == 0)
        parity = ^data;      // Even parity
    else
        parity = ~(^data);   // Odd parity
end
endmodule
