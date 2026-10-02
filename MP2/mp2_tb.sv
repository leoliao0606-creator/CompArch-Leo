`timescale 1ns/1ps
module mp2_tb;
    localparam int CYCLES_TO_SIMULATE = 3;
    localparam int CLOCKS_PER_CYCLE = 12_000_000;

    logic clk = 0;
    logic RGB_R, RGB_G, RGB_B;

    always #41.667 clk = ~clk;

    top u0 (
        .clk(clk),
        .RGB_R(RGB_R),
        .RGB_G(RGB_G),
        .RGB_B(RGB_B)
    );

    initial begin
        $dumpfile("mp2.vcd");
        $dumpvars(0, u0.red_duty, u0.green_duty, u0.blue_duty,
             u0.red_on, u0.green_on, u0.blue_on);

        repeat (CYCLES_TO_SIMULATE * CLOCKS_PER_CYCLE + 1) @(posedge clk);
        $finish;
    end
endmodule
