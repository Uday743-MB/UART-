`timescale 1ns/1ps

module tb_rx_fsm;

    // Inputs
    reg clk;
    reg rst;
    reg baud_tick;
    reg rx;

    // Output
    wire [2:0] state;

    // Instantiate DUT
    rx_fsm uut (
        .clk(clk),
        .rst(rst),
        .baud_tick(baud_tick),
        .rx(rx),
        .state(state)
    );

    // State Parameters
    localparam IDLE   = 3'd0,
               START  = 3'd1,
               DATA   = 3'd2,
               PARITY = 3'd3,
               STOP   = 3'd4;

    // Clock Generation (10 ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Baud Tick Task
    task baud_pulse;
    begin
        baud_tick = 1;
        #10;
        baud_tick = 0;
        #10;
    end
    endtask

    // Monitor Signals
    initial begin
        $display("Time\tRST\tRX\tBaud\tState");
        $monitor("%0t\t%b\t%b\t%b\t%d",
                 $time, rst, rx, baud_tick, state);
    end

    // Test Sequence
    initial begin

        // Initialize
        rst = 1;
        rx = 1;          // Idle line
        baud_tick = 0;

        #20;
        rst = 0;

        //---------------------------------------------------
        // Test 1 : IDLE -> START
        //---------------------------------------------------
        rx = 0;          // Start bit detected
        baud_pulse();

        //---------------------------------------------------
        // Test 2 : START -> DATA
        //---------------------------------------------------
        baud_pulse();

        //---------------------------------------------------
        // Test 3 : DATA state (8 bits)
        //---------------------------------------------------
        repeat(8)
            baud_pulse();

        //---------------------------------------------------
        // Test 4 : PARITY
        //---------------------------------------------------
        baud_pulse();

        //---------------------------------------------------
        // Test 5 : STOP
        //---------------------------------------------------
        rx = 1;
        baud_pulse();

        //---------------------------------------------------
        // Back to IDLE
        //---------------------------------------------------
        baud_pulse();

        #20;
        $display("RX FSM Simulation Completed Successfully.");
        $finish;

    end

endmodule
