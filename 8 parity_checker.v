module parity_checker(
input  [7:0] data,
input        parity_bit,
input        parity_type,    // 0 = Even, 1 = Odd
output reg   parity_error);
always @(*) begin
    case(parity_type)
    1'b0: begin      // Even Parity
        parity_error = (^data) ^ parity_bit;
    end
    1'b1: begin      // Odd Parity
        parity_error = ~(^data) ^ parity_bit;
    end
    endcase
end
endmodule
