module color_cycle (
    input logic clk,
    output logic [7:0] red_duty,
    output logic [7:0] green_duty,
    output logic [7:0] blue_duty
);

    localparam int CLOCKS_PER_STEP = 8000;
    localparam int STEPS_PER_SECTOR = 250;
    localparam int NUM_SECTORS = 6;

    logic [$clog2(CLOCKS_PER_STEP)-1 : 0] tick_count = 0;
    logic [$clog2(STEPS_PER_SECTOR)-1 : 0] step = 0;
    logic [$clog2(NUM_SECTORS)-1 : 0] sector = 0;

    always_ff @(posedge clk) begin
        if (tick_count == CLOCKS_PER_STEP - 1) begin
            tick_count <= 0;
            if (step == STEPS_PER_SECTOR - 1) begin
                step <= 0;
                if (sector == NUM_SECTORS - 1) begin
                    sector <= 0;
                end else
                    sector <= sector + 1;
            end else
                step <= step + 1;
        end else
            tick_count <= tick_count + 1;
    end

    always_comb begin
        red_duty = 8'd0;
        green_duty = 8'd0;
        blue_duty = 8'd0;

        case (sector)
            3'd0: begin
                red_duty   = 8'd250;
                green_duty = step;
            end
            3'd1: begin
                red_duty   = 8'd250 - step;
                green_duty = 8'd250;
            end
            3'd2: begin
                green_duty   = 8'd250;
                blue_duty = step;
            end
            3'd3: begin
                green_duty   = 8'd250 - step;
                blue_duty = 8'd250;
            end
            3'd4: begin
                blue_duty   = 8'd250;
                red_duty = step;
            end
            3'd5: begin
                blue_duty   = 8'd250 - step;
                red_duty = 8'd250;
            end
        endcase
    end
endmodule
