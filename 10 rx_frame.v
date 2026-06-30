module rx_fsm(
    input clk,
    input rst,
    input baud_tick,
    input rx,
    output reg [2:0] state);
localparam IDLE   = 3'd0,
           START  = 3'd1,
           DATA   = 3'd2,
           PARITY = 3'd3,
           STOP   = 3'd4;
reg [2:0] bit_cnt;
always @(posedge clk or posedge rst)begin
    if(rst)
    begin
        state   <= IDLE;
        bit_cnt <= 0;
    end
    else if(baud_tick)
    begin
        case(state)
        IDLE:
        begin
            if(rx == 1'b0)
                state <= START;
        end
        START:
        begin
            bit_cnt <= 0;
            state   <= DATA;
        end
        DATA:
        begin
            if(bit_cnt == 3'd7)
                state <= PARITY;
            else
                bit_cnt <= bit_cnt + 1;
        end
        PARITY:
        begin
            state <= STOP;
        end
        STOP:
        begin
            state <= IDLE;
        end
        default:
            state <= IDLE;
        endcase
    end
end
endmodule
