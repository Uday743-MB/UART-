`timescale 1ns/1ps

module tb_uart_rx;

    reg clk;
    reg rst;
    reg baud_tick;
    reg rx;

    wire [7:0] rx_data;
    wire rx_done;
    wire parity_error;
    wire framing_error;

    //--------------------------------------------------
    // DUT
    //--------------------------------------------------
    uart_rx dut(
        .clk(clk),
        .rst(rst),
        .baud_tick(baud_tick),
        .rx(rx),
        .rx_data(rx_data),
        .rx_done(rx_done),
        .parity_error(parity_error),
        .framing_error(framing_error)
    );

    //--------------------------------------------------
    // Clock Generation
    //--------------------------------------------------
    initial begin
        clk = 0;
        forever #5 clk = ~clk;      //100MHz
    end

    //--------------------------------------------------
    // Baud Tick Generation
    //--------------------------------------------------
    initial begin
        baud_tick = 0;
        forever begin
            #20 baud_tick = 1;
            #10 baud_tick = 0;
        end
    end

    //--------------------------------------------------
    // UART Frame Task
    // 8-bit Data
    // Even Parity
    // 1 Stop Bit
    //--------------------------------------------------
    task send_uart_frame;

        input [7:0] data;

        integer i;
        reg parity;

        begin

            parity = ^data;   //Even parity

            //-----------------
            // Idle
            //-----------------
            rx = 1;
            @(posedge baud_tick);

            //-----------------
            // Start Bit
            //-----------------
            rx = 0;
            @(posedge baud_tick);

            //-----------------
            // Data Bits
            //-----------------
            for(i=0;i<8;i=i+1)
            begin
                rx = data[i];     //LSB First
                @(posedge baud_tick);
            end

            //-----------------
            // Parity Bit
            //-----------------
            rx = parity;
            @(posedge baud_tick);

            //-----------------
            // Stop Bit
            //-----------------
            rx = 1;
            @(posedge baud_tick);

        end

    endtask

    //--------------------------------------------------
    // Test Sequence
    //--------------------------------------------------
    initial begin

        rst = 1;
        rx  = 1;

        #30;
        rst = 0;

        //-------------------------
        // Test Case-1
        //-------------------------
        send_uart_frame(8'hA5);

        #200;

        //-------------------------
        // Test Case-2
        //-------------------------
        send_uart_frame(8'h3C);

        #200;

        $finish;

    end

    //--------------------------------------------------
    // Monitor
    //--------------------------------------------------
    initial begin

        $monitor("Time=%0t  RX=%b  Data=%h  Done=%b  Parity_Error=%b  Framing_Error=%b",
                 $time,
                 rx,
                 rx_data,
                 rx_done,
                 parity_error,
                 framing_error);

    end

endmodule
