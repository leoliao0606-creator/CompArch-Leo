module game (
    input  logic [63:0] state,
    output logic [63:0] next_state
);
    genvar r, c;
    generate
        for (r = 0; r < 8; r++) begin : row
            for (c = 0; c < 8; c++) begin : col
                localparam int RU = (r + 7) % 8;
                localparam int RD = (r + 1) % 8;
                localparam int CL = (c + 7) % 8;
                localparam int CR = (c + 1) % 8;
                logic [3:0] n;
                assign n = state[8*RU + CL] + state[8*RU + CR] + state[8*RD + CL] + state[8*RD + CR] + state[8*RU + c] + state[8*r + CL] + state[8*RD + c] + state[8*r + CR];
                assign next_state[8*r + c] = (n == 2 && state[8*r + c] || n == 3);
            end
        end
    endgenerate
endmodule
