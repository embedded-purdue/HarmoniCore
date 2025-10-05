`include "../include/FPMultiply_if.vh"

module FPMultiply (
    FPMultiply_if.mult multif
);

// ALL INTERFACE SIGNALS (a, b, c) ARE SIGNED TYPE **IMPORTANT**
// IF YOUR VALUES DON'T HAVE SIGNED TYPE, CAST WITH $signed (i.e. $signed(a) * $signed(b))

logic signed [DW * 2 - 1:0] ex_max, ex_min, c_temp; // THESE VALUES ARE ALSO ALL SIGNED
assign ex_max = MAX_VAL;
assign ex_min = MIN_VAL;

always_comb
begin
    // Product has 22 decimal bits, but we only need 11 so we shift out the last 11 decimal bits
    c_temp = (multif.a * multif.b) >>> DECIMALBITS; // Arithmetic shift to preserve sign

    // Check if saturation is required
    if (c_temp > ex_max)
    begin
        c_temp = ex_max;
    end
    else if (c_temp < ex_min)
    begin
        c_temp = ex_min;
    end
    else
    begin
        c_temp = c_temp;
    end

    // Set the output to the lower 18 bits of the temp variable holding product
    multif.c = c_temp[DW - 1:0];
end

endmodule