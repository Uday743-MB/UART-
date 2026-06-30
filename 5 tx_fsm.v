module tx_fsm(
    input clk,
    input rst,
    input tx_start,
    input bit_done,
    input parity_enable,
    output reg load,
    output reg shift,
    output reg tx_done,
    output reg tx_sel);
reg [2:0] state, next_state;
localparam IDLE   = 3'd0,
           START  = 3'd1,
           DATA   = 3'd2,
           PARITY = 3'd3,
           STOP   = 3'd4;
// State Register
always @(posedge clk or posedge rst)
begin
    if(rst)
        state <= IDLE;
    else
        state <= next_state;
end
// Next State Logic
always @(*)begin
    case(state)
    IDLE:
        if(tx_start)
            next_state = START;
        else
            next_state = IDLE;
    START:
      next_state = DATA;
    DATA:
        if(bit_done)
            if(parity_enable)
                next_state = PARITY;
            else
                next_state = STOP;
        else
            next_state = DATA;
    PARITY: next_state = STOP;
    STOP:   next_state = IDLE;
    default:
        next_state = IDLE;
    endcase
end
// Output Logic
always @(*)begin
    load    = 0;
    shift   = 0;
    tx_done = 0;
    tx_sel  = 0;
    case(state)
    IDLE:  load = 1;
    START:   tx_sel = 0;
    DATA:    shift = 1;
    PARITY:   tx_sel = 1;
    STOP:  tx_done = 1;
    endcase
end
endmodule
