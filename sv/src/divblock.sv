
`timescale 1ns / 1ps
`include "../include/types.sv"
`include "../include/divwrapper_if.vh"
`include "../include/memwrapper_if.vh"
`include "../include/divblock_if.vh"

module divblock
import types::*;
(
    input logic clk, rst,
    divblock_if.divblock ctrif
);
    // declare interfaces
    divwrapper_if divif();
    memwrapper_if memif();

    // declare modules
    divwrapper DIV(clk, rst, divif);
    memwrapper MEM(clk, rst, memif);

    // declare FSM
    typedef enum logic [2:0] {IDLE, CUMMEAN, YINVAL, INTERP, FINAL} state_t;
    state_t state, next_state;

    // additional signals
    logic [10:0] sp_w, sp_r; // 11-bit depth
    logic [5:0] pipeline, next_pipeline;

    // ************************************************************************
    // START THE CODE
    // ************************************************************************

    always_ff @(posedge clk) begin : fsmControl
        if (rst) state <= IDLE;
        else     state <= next_state;
    end

    always_comb begin : fsmMove
        next_state = state;
        case (state)
            IDLE: if (ctrif.count >= MIN_PERIOD-2)                  next_state = CUMMEAN;
            CUMMEAN: if (ctrif.rollover_flag & ~divif.out_valid)    next_state = YINVAL;
            YINVAL: if (ctrif.interp_enable)                        next_state = INTERP;
            INTERP: if (divif.out_valid && (pipeline == 1))         next_state = FINAL;
            FINAL: if (rst)                                         next_state = IDLE;
            default:                                                next_state = IDLE;
        endcase
    end

    always_ff @(posedge clk) begin : writeControl
        if (rst)                                      sp_w <= '0;
        else if (sp_w == 12'hFFE)                     sp_w <= sp_w;
        else if (state == CUMMEAN && divif.out_valid) sp_w <= sp_w + 2;
    end

    always_ff @(posedge clk) begin : readControl
        if (rst)                  sp_r <= '0;
        else if (sp_r == 12'hFFE) sp_r <= sp_r;
        else if (state == YINVAL) sp_r <= sp_r + 2;
    end

    always_comb begin : fsmOutput
        divif.dividend_valid = 1'b0;
        divif.dividend_data = '0;
        divif.divisor_valid = 1'b0;
        divif.divisor_data = '0;

        memif.wea = 1'b0;
        memif.addra = '0;
        memif.dina = '0;
        memif.web = 1'b0;
        memif.addrb = '0;
        memif.dinb = '0;

        ctrif.yin_valid = 1'b0;
        ctrif.yin_out = '0;

        ctrif.final_valid = 1'b0;
        ctrif.final_out = '0;

        case (state)
            CUMMEAN: begin
                if (~ctrif.rollover_flag) begin
                    divif.dividend_valid = 1'b1;
                    divif.dividend_data = ctrif.total;
                    divif.divisor_valid = 1'b1;
                    divif.divisor_data = ctrif.count;
                end

                if (divif.out_valid) begin
                    memif.wea = 1'b1;
                    memif.addra = sp_w;
                    memif.dina = divif.out_data;
                    memif.web = 1'b1;
                    memif.addrb = sp_w + 1;
                    memif.dinb = ctrif.delayed_diff;
                end
            end

            YINVAL: begin
                memif.wea = 1'b0;
                memif.addra = sp_r;
                memif.dina = '0;
                memif.web = 1'b0;
                memif.addrb = sp_r + 1;
                memif.dinb = '0;

                if (ctrif.interp_enable) begin
                    divif.dividend_valid = 1'b1;
                    divif.dividend_data = ctrif.interp_dividend;
                    divif.divisor_valid = 1'b1;
                    divif.divisor_data = ctrif.interp_divisor;
                end
                else if ( (memif.valid_a & memif.valid_b) && (sp_r != 12'hFFE)) begin
                    divif.dividend_valid = 1'b1;
                    divif.dividend_data = memif.douta;
                    divif.divisor_valid = 1'b1;
                    divif.divisor_data = memif.doutb;
                end

                if (divif.out_valid) begin
                    ctrif.yin_valid = 1'b1;
                    ctrif.yin_out = divif.out_data;
                end
            end

            INTERP: begin
                if (divif.out_valid && (pipeline == 1)) begin
                    divif.dividend_valid = 1'b1;
                    divif.dividend_data = DR;
                    divif.divisor_valid = 1'b1;
                    divif.divisor_data = divif.out_data + ctrif.interp_tau;
                end
            end

            FINAL: begin
                if (divif.out_valid && (pipeline == 1)) begin
                    ctrif.final_valid = 1'b1;
                    ctrif.final_out = divif.out_data;
                end
            end
        endcase
    end

    always_ff @(posedge clk) begin : nextPipeline
        if (rst) pipeline <= '0;
        else     pipeline <= next_pipeline;
    end

    always_comb begin : trackPipeline
        next_pipeline = pipeline;
        if (divif.dividend_valid & divif.divisor_valid) next_pipeline += 1;
        if (divif.out_valid) next_pipeline -= 1;
    end

endmodule
