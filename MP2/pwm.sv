module pwm (
    input   logic       clk,
    input   logic [7:0] duty,
    output  logic       on
);

    logic [7:0] pwm_count = 0;
    always_ff @(posedge clk) begin
        if (pwm_count == 8'd249)
            pwm_count <= 8'd0;
        else
            pwm_count <= pwm_count + 1; 
    end

    assign on = pwm_count < duty;

endmodule