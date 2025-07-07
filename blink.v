module Blink #(
    parameter CLK_FREQ = 25_000_000
) (
    input wire clk,
    input wire rst_n,
    output reg [7:0] leds
);

localparam DELAY = CLK_FREQ / 4;

reg [31:0] counter;
reg [2:0] blink_count;
reg [2:0] state;
reg leds_on;

always @(posedge clk) begin
    if (!rst_n) begin
        counter     <= 0;
        blink_count <= 0;
        state       <= 0;
        leds        <= 0;
        leds_on     <= 0;
    end else begin
        if (counter >= DELAY) begin
            counter <= 0;
            leds_on <= ~leds_on;

            if (leds_on) begin
                blink_count <= blink_count + 1;

                case (state)
                    0: leds <= 8'b00000001;
                    1: leds <= 8'b00000110;
                    2: leds <= 8'b00000111;
                    3: leds <= 8'b00001111;
                    4: leds <= 8'b00011111;
                    default: leds <= 8'b00000000;
                endcase
            end else begin
                leds <= 8'b00000000;
            end

            if ((blink_count >= state + 1) && leds_on) begin
                blink_count <= 0;
                if (state >= 4)
                    state <= 0;
                else
                    state <= state + 1;
            end
        end else begin
            counter <= counter + 1;
        end
    end
end


endmodule
