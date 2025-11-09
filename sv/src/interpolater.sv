`timescale 1ns / 1ps
`include "../include/types.sv"
import types::*; 
`include "../include/interpolater_if.vh"

module interpolater (input logic clk, rst,
                     interpolater_if.interp intif
  );

  logic [23:0] denom_tdata, numer_tdata, numer_reg, denom_reg;
  logic n_ready_flag, ready_flag_reg;

  logic signed [DW + 1:0] ex_max, ex_min, denom_temp, numer_temp;
  assign ex_max = MAX_VAL;
  assign ex_min = MIN_VAL;

  always_ff @(posedge clk) begin : regs
    if (rst) begin
      numer_reg      <= 0;
      denom_reg      <= 0;
      ready_flag_reg <= 0;
    end
    else begin
      numer_reg      <= numer_tdata;
      denom_reg      <= denom_tdata;
      ready_flag_reg <= n_ready_flag;
    end
  end

  always_comb begin
    numer_tdata = numer_reg;
    denom_tdata = denom_reg;
    numer_temp = 24'h0;
    denom_temp = 24'h0;
    n_ready_flag = ready_flag_reg;

    if (intif.frame_done) begin
      denom_tdata = 24'h0;
      numer_tdata = 24'h0;
      n_ready_flag = 1'b0;
    end
    else if (intif.trough_found) // found a trough 
    begin
      denom_temp = (intif.prev_yin - (intif.curr_yin <<< 1) + intif.next_yin);
      numer_temp = (intif.prev_yin - intif.next_yin) >>> 1;
      
      if (denom_temp > ex_max)
        begin
          denom_temp = ex_max;
        end
      else if (denom_temp < ex_min)
        begin
          denom_temp = ex_min;
        end
      else
        begin
          denom_temp = denom_temp;
        end

      if (numer_temp > ex_max)
        begin
          numer_temp = ex_max;
        end
      else if (numer_temp < ex_min)
        begin
          numer_temp = ex_min;
        end
      else
        begin
          numer_temp = numer_temp;
        end
        
      denom_tdata = {{6{denom_temp[17]}}, denom_temp[17:0]};
      numer_tdata = {{6{numer_temp[17]}}, numer_temp[17:0]};
      n_ready_flag = 1'b1;   
      end
  end

  assign intif.numer = numer_reg;
  assign intif.denom = denom_reg;
  assign intif.divide_out_ready = ready_flag_reg;

endmodule