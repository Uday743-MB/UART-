`timescale 1ns/1ps

module tb_stop_bit_detector;

    // Inputs
    reg stop_bit;
    reg enable;

    // Outputs
    wire frame_done;
    wire framing_error;

    // Instantiate DUT
    stop_bit_detector uut (
        .stop_bit(stop_bit),
        .enable(enable),
        .frame_done(frame_done),
        .framing_error(framing_error)
    );
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(1,tb_stop_bit_detector);
  end

    initial begin

        $display("-----------------------------------------------");
        $display(" Time\tEnable\tStopBit\tFrameDone\tFramingError");
        $display("-----------------------------------------------");

        $monitor("%0t\t%b\t%b\t%b\t\t%b",
                 $time, enable, stop_bit, frame_done, framing_error);

        // Test Case 1: Enable = 0
        enable   = 0;
        stop_bit = 0;
        #10;

        // Test Case 2: Enable = 0
        stop_bit = 1;
        #10;

        // Test Case 3: Valid Stop Bit
        enable   = 1;
        stop_bit = 1;
        #10;

        // Test Case 4: Invalid Stop Bit
        stop_bit = 0;
        #10;

        // Test Case 5: Disable Again
        enable   = 0;
        stop_bit = 1;
        #10;

        $display("-----------------------------------------------");
        $display("Simulation Completed");
        $finish;

    end

endmodule
