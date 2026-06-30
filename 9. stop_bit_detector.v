module stop_bit_detector(
    input  stop_bit,
    input  enable,
    output reg frame_done,
    output reg framing_error);
always @(*)begin
    frame_done     = 0;
    framing_error  = 0;
   if(enable)
    begin
        if(stop_bit == 1'b1)
        begin
            frame_done    = 1'b1;
            framing_error = 1'b0;
        end
        Else begin
            frame_done    = 1'b0;
            framing_error = 1'b1;
        end
    end
end
endmodule
