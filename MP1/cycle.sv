// Blink

module top(
    input logic     clk, 
    output logic    RGB_B,
    output logic    RGB_G,
    output logic    RGB_R
);

    parameter INTERVAL = 2000000;
    parameter NUM_COLORS = 6;
    parameter RED = 0;
    parameter YELLOW = 1;
    parameter GREEN = 2;
    parameter CYAN = 3;
    parameter BLUE = 4;
    parameter MAGENTA = 5;

    logic [$clog2(INTERVAL) - 1:0] count = 0;
    logic [$clog2(NUM_COLORS) - 1:0] state = RED;
    logic [$clog2(NUM_COLORS) -1:0] next_state;

    always_comb begin
        RGB_B = 1'b1;
        RGB_G = 1'b1;
        RGB_R = 1'b1;
        next_state = RED;
        case (state) 
            RED: begin
                RGB_R = 1'b0;
                next_state = YELLOW;
            end
            YELLOW: begin
                RGB_R = 1'b0;
                RGB_G = 1'b0;
                next_state = GREEN;
            end
            GREEN: begin
                RGB_G = 1'b0;
                next_state = CYAN;
            end
            CYAN: begin
                RGB_G = 1'b0;
                RGB_B = 1'b0;
                next_state = BLUE;
            end
            BLUE: begin
                RGB_B = 1'b0;
                next_state = MAGENTA;
            end
            MAGENTA: begin
                RGB_B = 1'b0;
                RGB_R = 1'b0;
                next_state = RED;
            end
        endcase
    end

    always_ff @(posedge clk) begin
        if (count == INTERVAL - 1) begin
            count <= 0;
            state <= next_state;
        end
        else begin
            count <= count + 1;
        end
    end

endmodule

