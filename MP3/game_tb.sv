`timescale 1ns/1ps
module game_tb;
    logic [63:0] state;
    logic [63:0] next_state;
    logic [63:0] initial_state;

    int errors = 0; 
    int n = 0;
    logic [63:0] expected;


    game dut (
        .state(state),
        .next_state(next_state)
    );

    initial begin
        state = 0;
        #1;
        $display("state      = %h", state);
        $display("next_state = %h", next_state);

        // Modify the following cells to get a blinker,
        // The expected next state is 64'h0000000404040000
        state = 0;
        state[27] = 1;
        state[26] = 1;
        state[25] = 1;
        #1;
        $display("state = %h", state);
        $display("next_state = %h", next_state);

        if (next_state == 64'h0000000404040000) begin
            $display("Pass");
        end
        else begin
            $display("Wrong output");
        end

        // Modify the following cells to get a glider,
        // The expected state after 32 generations should be the same as the initial state.
        state = 0;
        state[1] = 1;
        state[10] = 1;
        state[16] = 1;
        state[17] = 1;
        state[18] = 1;
        initial_state = state;
        for (int g = 0; g < 32; g++) begin
            #1;
            state = next_state;
        end
        $display("initial_state = %h", state);
        $display("state = %h", next_state);

        if (state == initial_state) begin
            $display("Pass");
        end
        else begin
            $display("Wrong output");
        end


        for (int i = 0; i < 1000; i++) begin
            state = {$urandom, $urandom};
            #1;
            for (int r = 0; r < 8; r++) begin
                for (int c = 0; c < 8; c++) begin
                    n = 0;
                    for (int dr = -1; dr < 2; dr++) begin
                        for (int dc = -1; dc < 2; dc++) begin
                            if (!(dr == 0 && dc == 0)) begin
                                n = n + state[8 * ((r + dr + 8) % 8) + (c + dc + 8) % 8];
                            end
                        end
                    end
                    if (state[8 * r + c]) 
                        expected[8 * r + c] = (n == 3 || n == 2);
                    else 
                        expected[8 * r + c] = n == 3;
                end
            end
            #1;
            if (next_state != expected) 
                errors++;
        end

        $display("Checked 1000 times, error: %0d", errors);

        $finish;
    end
endmodule

