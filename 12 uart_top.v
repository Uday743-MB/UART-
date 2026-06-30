module uart_top(
    input        clk,
    input        rst,
    input        tx_start,
    input  [7:0] tx_data,
    input        rx,
    output       tx,
    output [7:0] rx_data,
    output       tx_done,
    output       rx_done);
wire baud_tick;
//-------------------------------
// Baud Rate Generator
//-------------------------------
baud_gen BRG(
    .clk(clk),
    .rst(rst),
    .baud_tick(baud_tick));
//-------------------------------
// UART Transmitter
//-------------------------------
uart_tx TX(

    .clk(clk),
    .rst(rst),
    .baud_tick(baud_tick),
    .tx_start(tx_start),
    .tx_data(tx_data),
    .tx(tx),
    .tx_done(tx_done));
//-------------------------------
// UART Receiver
//-------------------------------
uart_rx RX(
    .clk(clk),
    .rst(rst),
    .baud_tick(baud_tick),
    .rx(rx),
    .rx_data(rx_data),
    .rx_done(rx_done));
endmodule
