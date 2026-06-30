// ============================================================
// File: 12_uart_top.v
// Description: UART Top-Level Module - Organized Structure
// ============================================================

module uart_top (
    input         clk,
    input         rst,
    // TX Interface
    input         tx_start,
    input  [7:0]  tx_data,
    output        tx,
    output        tx_done,
    // RX Interface  
    input         rx,
    output [7:0]  rx_data,
    output        rx_done,
    output        rx_error
);

    // ========================================================
    // Internal Wires
    // ========================================================
    wire        baud_tick;
    
    // TX wires
    wire        tx_load, tx_shift;
    wire        tx_parity_bit;
    wire        tx_serial_out;
    
    // RX wires
    wire        rx_start_bit, rx_stop_bit;
    wire        rx_load, rx_shift;
    wire        rx_parity_ok;
    wire        rx_frame_done;

    // ========================================================
    // 1. BAUD RATE GENERATOR (Common for TX & RX)
    // ========================================================
    baud_gen u_baud_gen (
        .clk       (clk),
        .rst       (rst),
        .baud_tick (baud_tick)
    );

    // ========================================================
    // TRANSMITTER SECTION
    // ========================================================
    
    // 2. TX FINITE STATE MACHINE
    tx_fsm u_tx_fsm (
        .clk       (clk),
        .rst       (rst),
        .tx_start  (tx_start),
        .baud_tick (baud_tick),
        .tx_done   (tx_done),
        .load      (tx_load),
        .shift     (tx_shift)
    );

    // 3. PARITY GENERATOR
    parity_generator u_parity_generator (
        .data   (tx_data),
        .parity (tx_parity_bit)
    );

    // 4. PISO - Parallel In Serial Out (TX)
    piso u_piso_tx (
        .clk   (clk),
        .rst   (rst),
        .load  (tx_load),
        .shift (tx_shift),
        .pdata ({tx_data, tx_parity_bit}),
        .sout  (tx_serial_out)
    );

    // 5. UART TX OUTPUT DRIVER
    uart_tx u_uart_tx (
        .clk       (clk),
        .rst       (rst),
        .baud_tick (baud_tick),
        .tx_start  (tx_start),
        .tx_data   (tx_data),
        .tx        (tx),
        .tx_done   (tx_done)
    );

    // ========================================================
    // RECEIVER SECTION
    // ========================================================
    
    // 6. START BIT DETECTOR
    start_bit_detector u_start_bit_detector (
        .clk       (clk),
        .rst       (rst),
        .rx        (rx),
        .baud_tick (baud_tick),
        .start_bit (rx_start_bit)
    );

    // 7. SIPO - Serial In Parallel Out (RX)
    sipo u_sipo_rx (
        .clk   (clk),
        .rst   (rst),
        .load  (rx_load),
        .shift (rx_shift),
        .sin   (rx),
        .pdata (rx_data)
    );

    // 8. PARITY CHECKER
    parity_checker u_parity_checker (
        .data      (rx_data),
        .parity    (rx_parity_bit),
        .parity_ok (rx_parity_ok)
    );

    // 9. STOP BIT DETECTOR
    stop_bit_detector u_stop_bit_detector (
        .clk       (clk),
        .rst       (rst),
        .rx        (rx),
        .baud_tick (baud_tick),
        .stop_bit  (rx_stop_bit)
    );

    // 10. RX FRAME CONTROLLER
    rx_frame u_rx_frame (
        .clk        (clk),
        .rst        (rst),
        .start_bit  (rx_start_bit),
        .stop_bit   (rx_stop_bit),
        .baud_tick  (baud_tick),
        .load       (rx_load),
        .shift      (rx_shift),
        .rx_done    (rx_done),
        .rx_error   (rx_error)
    );

    // 11. UART RX MODULE
    uart_rx u_uart_rx (
        .clk       (clk),
        .rst       (rst),
        .rx        (rx),
        .baud_tick (baud_tick),
        .rx_data   (rx_data),
        .rx_done   (rx_done)
    );

endmodule
Order of Instantiation:
1. baud_gen           → Clock source for all modules
                         
TX Section (2-5):      → Data flows: FSM → Parity → PISO → TX Driver
2. tx_fsm             
3. parity_generator   
4. piso (TX)          
5. uart_tx            
                         
RX Section (6-11):     → Data flows: Start Detect → SIPO → Parity → Stop Detect → Frame Ctrl
6. start_bit_detector 
7. sipo (RX)          
8. parity_checker     
9. stop_bit_detector  
10. rx_frame          
11. uart_rx           
