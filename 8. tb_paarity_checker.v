`timescale 1ns/1ps

module tb_parity_checker;

    // Inputs
    reg [7:0] data;
    reg parity_bit;
    reg parity_type;

    // Output
    wire parity_error;

    // DUT
    parity_checker uut (
        .data(data),
        .parity_bit(parity_bit),
        .parity_type(parity_type),
        .parity_error(parity_error)
    );

    initial begin

        $display("-----------------------------------------------");
        $display(" Time\tData\t\tType\tP_Bit\tError");
        $display("-----------------------------------------------");

        //=========================
        // EVEN PARITY TEST CASES
        //=========================

        // Test Case 1 : Correct Even Parity
        data = 8'b10110010;      // Number of 1's = 4 (Even)
        parity_type = 0;
        parity_bit = 0;
        #10;
        $display("%0t\t%b\tEven\t%b\t%b",$time,data,parity_bit,parity_error);

        // Test Case 2 : Wrong Even Parity
        parity_bit = 1;
        #10;
        $display("%0t\t%b\tEven\t%b\t%b",$time,data,parity_bit,parity_error);

        //=========================
        // ODD PARITY TEST CASES
        //=========================

        // Test Case 3 : Correct Odd Parity
        parity_type = 1;
        parity_bit = 1;
        #10;
        $display("%0t\t%b\tOdd\t%b\t%b",$time,data,parity_bit,parity_error);

        // Test Case 4 : Wrong Odd Parity
        parity_bit = 0;
        #10;
        $display("%0t\t%b\tOdd\t%b\t%b",$time,data,parity_bit,parity_error);

        //=========================
        // Another Data Pattern
        //=========================

        // Data = 11110001 (5 ones -> Odd)
        data = 8'b11110001;

        // Correct Even Parity
        parity_type = 0;
        parity_bit = 1;
        #10;
        $display("%0t\t%b\tEven\t%b\t%b",$time,data,parity_bit,parity_error);

        // Correct Odd Parity
        parity_type = 1;
        parity_bit = 0;
        #10;
        $display("%0t\t%b\tOdd\t%b\t%b",$time,data,parity_bit,parity_error);

        $display("-----------------------------------------------");
        $finish;

    end

endmodule
