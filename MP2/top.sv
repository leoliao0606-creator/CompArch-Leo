module top (
    input  logic clk,
    output logic RGB_R,
    output logic RGB_G,
    output logic RGB_B
);
    logic [7:0] red_duty, green_duty, blue_duty;
    logic red_on, green_on, blue_on;

    color_cycle colors (
        .clk(clk),
        .red_duty(red_duty),
        .green_duty(green_duty),
        .blue_duty(blue_duty)
    );

    pwm red_pwm (
        .clk(clk),
        .duty(red_duty),
        .on(red_on)
    );

    pwm green_pwm (
        .clk(clk),
        .duty(green_duty),
        .on(green_on)
    );

    pwm blue_pwm (
        .clk(clk),
        .duty(blue_duty),
        .on(blue_on)
    );
    

    assign RGB_R = ~red_on;
    assign RGB_G = ~green_on;
    assign RGB_B = ~blue_on;
    
endmodule