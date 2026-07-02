`timescale 1ns/1ps

module tb_sipo;

    // Inputs
    reg clk;
    reg rst;
    reg shift_en;
    reg serial_in;

    // Output
    wire [7:0] parallel_out;

    // Instantiate DUT
    sipo uut (
        .clk(clk),
        .rst(rst),
        .shift_en(shift_en),
        .serial_in(serial_in),
        .parallel_out(parallel_out)
    );

    // Clock Generation (10 ns period)
    always #5 clk = ~clk;
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(1,tb_sipo);
  end

    initial begin
        // Initialize
        clk = 0;
        rst = 1;
        shift_en = 0;
        serial_in = 0;

        // Apply Reset
        #15;
        rst = 0;

        // Enable shifting
        shift_en = 1;

        // Send serial data: 10110011
        serial_in = 1; #10;
        serial_in = 0; #10;
        serial_in = 1; #10;
        serial_in = 1; #10;
        serial_in = 0; #10;
        serial_in = 0; #10;
        serial_in = 1; #10;
        serial_in = 1; #10;

        // Disable shifting
        shift_en = 0;
        #20;

        $finish;
    end

    // Monitor Signals
    initial begin
        $display("Time\tRST\tEN\tSIN\tParallel_Out");
        $monitor("%0t\t%b\t%b\t%b\t%b",
                  $time, rst, shift_en, serial_in, parallel_out);
    end

endmodule
