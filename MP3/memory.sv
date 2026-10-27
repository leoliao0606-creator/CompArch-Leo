module memory (
    input logic clk,
    input logic [5:0] address,
    input logic write_enable,
    input logic [7:0] write_data,
    output logic [7:0] read_data
);

    logic [7:0] mem [0:63];

    initial begin
        for (int i = 0; i < 64; i++) mem[i] = 8'd0;
    end

    always_ff @(posedge clk) begin
        if (write_enable) begin
            mem[address] <= write_data;
        end
        else begin
            read_data <= mem[address];
        end 
    end

endmodule
