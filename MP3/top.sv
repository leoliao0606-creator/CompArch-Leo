// 3 games of life (r, g, b) on the 8x8 matrix, one generation every 32 frames

module top (
    input logic clk,
    output logic _48b,
    output logic _45a
);

    logic [5:0] pixel;
    logic [4:0] frame;
    logic load_sreg, transmit_pixel, shift, ws2812b_out;

    logic [63:0] state_r = 0;
    logic [63:0] state_g = 0;
    logic [63:0] state_b = 0;
    logic [63:0] next_r, next_g, next_b;

    logic [7:0] old_r, old_g, old_b;
    logic [7:0] new_r, new_g, new_b;
    logic [23:0] shift_reg = 0;

    logic [7:0] seed_r [0:7];
    logic [7:0] seed_g [0:7];
    logic [7:0] seed_b [0:7];
    logic loaded = 0;

    initial begin
        $readmemh("seed_r.mem", seed_r);
        $readmemh("seed_g.mem", seed_g);
        $readmemh("seed_b.mem", seed_b);
    end

    controller ctrl (.clk(clk), .load_sreg(load_sreg), .transmit_pixel(transmit_pixel), .pixel(pixel), .frame(frame));
    ws2812b ws (.clk(clk), .serial_in(shift_reg[23]), .transmit(transmit_pixel), .ws2812b_out(ws2812b_out), .shift(shift));

    game game_r (.state(state_r), .next_state(next_r));
    game game_g (.state(state_g), .next_state(next_g));
    game game_b (.state(state_b), .next_state(next_b));

    memory mem_r (.clk(clk), .address(pixel), .write_enable(load_sreg), .write_data(new_r), .read_data(old_r));
    memory mem_g (.clk(clk), .address(pixel), .write_enable(load_sreg), .write_data(new_g), .read_data(old_g));
    memory mem_b (.clk(clk), .address(pixel), .write_enable(load_sreg), .write_data(new_b), .read_data(old_b));

    led_cell lc (
        .alive_r(state_r[pixel]), .alive_g(state_g[pixel]), .alive_b(state_b[pixel]),
        .r_old(old_r), .g_old(old_g), .b_old(old_b),
        .level_r(new_r), .level_g(new_g), .level_b(new_b)
    );

    always_ff @(posedge clk) begin
        // load seeds on the first clock
        if (!loaded) begin
            for (int r = 0; r < 8; r++) begin
                state_r[8*r +: 8] <= seed_r[r];
                state_g[8*r +: 8] <= seed_g[r];
                state_b[8*r +: 8] <= seed_b[r];
            end
            loaded <= 1;
        end
        // next generation after the last pixel of frame 31
        else if (load_sreg && pixel == 63 && frame == 31) begin
            state_r <= next_r;
            state_g <= next_g;
            state_b <= next_b;
        end
    end

    always_ff @(posedge clk) begin
        if (load_sreg)
            shift_reg <= {new_g, new_r, new_b};
        else if (shift)
            shift_reg <= {shift_reg[22:0], 1'b0};
    end

    assign _48b = ws2812b_out;
    assign _45a = ~ws2812b_out;

endmodule
