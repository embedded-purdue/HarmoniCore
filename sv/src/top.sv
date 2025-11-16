`include "../include/interpolater_if.vh"
`include "../include/top_if.vh"
`include "../include/find_trough_if.vh"

module top (
    input logic clk, rst, top_if topif
);

    interpolater_if intif();
    find_trough_if trif();

    assign trif.yin_in = topif.yin_data; 
    assign trif.enable = topif.yin_valid; 

    assign intif.frame_done = trif.frame_done | topif.done_early;
    assign intif.next_yin = trif.next_yin;
    assign intif.prev_yin = trif.prev_yin;
    assign intif.curr_yin = trif.curr_yin;
    assign intif.trough_found = trif.trough_found;
    
    assign topif.numerator = intif.numer;
    assign topif.denominator = intif.denom;
    assign topif.num_denom_valid = intif.divide_out_ready;

    assign topif.tau = trif.tau; 


    interpolater interp(.clk(clk), .rst(rst), .intif(intif)
  );

  find_trough trough(.clk(clk), .rst(rst), .trif(trif)
);
endmodule