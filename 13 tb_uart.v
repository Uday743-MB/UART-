`timescale 1ns/1ps
module tb_uart;
    // Inputs
    reg clk;
    reg rst;
    reg rx;
    reg tx_start;
    reg [7:0] tx_data;
    // Outputs
    wire tx;
    wire [7:0] rx_data;
    wire tx_done;
    wire rx_done;
    // DUT (Design Under Test)
    uart_top DUT (
        .clk(clk),
        .rst(rst),
        .rx(rx),
        .tx(tx),
        .tx_start(tx_start),
        .tx_data(tx_data),
        .rx_data(rx_data),
        .tx_done(tx_done),
        .rx_done(rx_done));
    // Clock Generation
    always #5 clk = ~clk;
    // Test Sequence
    initial begin
        clk = 0;
        rst = 1;
        rx = 1;          // Idle State
        tx_start = 0;
        tx_data = 8'h00;
        // Reset
        #20;
        rst = 0;
        // Transmit Data
        #20;
        tx_data = 8'hA5;
        tx_start = 1;
        #10;
        tx_start = 0;
        // Wait
        #5000;
        $finish;
    end
endmodule
