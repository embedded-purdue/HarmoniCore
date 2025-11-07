`include "../include/types.sv"
import types ::*;

module Clock_divider (
  input clock_in,
  output reg clock_out
);
  
  logic [31:0] counter = 0;

  always_ff @(posedge clock_in) begin
    counter <= counter + 1;
    if (counter >= (DIVISOR - 1))
      counter <= 0;

    clock_out <= (counter < DIVISOR / 2) ? 1'b1 : 1'b0;
  end
endmodule