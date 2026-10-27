// New brightness from old brightness: alive -> +ADD_ALIVE (max 255), dead -> -SUB_DEAD (min 0).

module led_cell #(
    parameter int TICKS_PER_GEN = 32,
    parameter int FADE_GENS     = 3,
    parameter int RISE_TICKS    = 8
)(
    input  logic       alive_r,
    input  logic       alive_g,
    input  logic       alive_b,
    input  logic [7:0] r_old,
    input  logic [7:0] g_old,
    input  logic [7:0] b_old,
    output logic [7:0] level_r,
    output logic [7:0] level_g,
    output logic [7:0] level_b
);

    localparam int FADE_TICKS = TICKS_PER_GEN * FADE_GENS;
    localparam int SUB_DEAD   = (255 + FADE_TICKS - 1) / FADE_TICKS;
    localparam int ADD_ALIVE  = (255 + RISE_TICKS - 1) / RISE_TICKS;

    always_comb begin
        if (alive_r) begin
            if (r_old > 255 - ADD_ALIVE) level_r = 8'd255;
            else                         level_r = r_old + ADD_ALIVE;
        end
        else begin
            if (r_old < SUB_DEAD) level_r = 8'd0;
            else                  level_r = r_old - SUB_DEAD;
        end

        if (alive_g) begin
            if (g_old > 255 - ADD_ALIVE) level_g = 8'd255;
            else                         level_g = g_old + ADD_ALIVE;
        end
        else begin
            if (g_old < SUB_DEAD) level_g = 8'd0;
            else                  level_g = g_old - SUB_DEAD;
        end

        if (alive_b) begin
            if (b_old > 255 - ADD_ALIVE) level_b = 8'd255;
            else                         level_b = b_old + ADD_ALIVE;
        end
        else begin
            if (b_old < SUB_DEAD) level_b = 8'd0;
            else                  level_b = b_old - SUB_DEAD;
        end
    end

endmodule
