module uart_rx(
input clk,
input rst,
input baud_tick,
input rx,
output [7:0] rx_data,
output rx_done,
output parity_error,
output framing_error);
wire start_detect;
//-----------------------------
// Start Bit Detector
//-----------------------------
start_bit_detector u1(
.clk(clk),
.rst(rst),
.rx(rx),
.start_detect(start_detect));
// RX FSM
rx_fsm u2(
.clk(clk),
.rst(rst),
.start_detect(start_detect),
.baud_tick(baud_tick),
.rx(rx),
.rx_done(rx_done));
//-----------------------------
// SIPO
//-----------------------------
sipo u3(
.clk(clk),
.rst(rst),
.baud_tick(baud_tick),
.rx(rx),
.data_out(rx_data));
//-----------------------------
// Parity Checker
//-----------------------------
parity_checker u4(
.data(rx_data),
.parity_bit(rx),
.error(parity_error));
//-----------------------------
// Stop Bit Checker
//-----------------------------
stop_bit_detector u5(
.stop_bit(rx),
.error(framing_error));
endmodule
