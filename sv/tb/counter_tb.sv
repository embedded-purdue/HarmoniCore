`timescale 1ns / 10ps

`include "../include/types.sv"
import types::*;


parameter PERIOD = 10;


module counter_tb;

	logic clk;
	logic rst; //reset held low, synchronous ACTIVE HIGH SYNCHRNOUS, RESET not nreset
	logic clear;
	logic count_en;
	logic [1:0] rollover_val;
	logic [1:0] count;
	logic flag;

	//CLK gen
   	always #(PERIOD/2) clk++;
	
	counter DUT(clk, rst, clear, count_en, rollover_val, count, flag);

	initial begin
		rst = 1'b0;
		clear = 1'b1;
		count_en = 1'b0;
		rollover_val = 10;
		
		@(posedge clk);
		//#(PERIOD*2); (waits this amount of time, not used)

		//testing always_ff
		if((count !== '0) || (flag !== 1'b0))begin
			$display("always_ff: Incorrect for count or flag (desired 0, is %b), begin (desired 1'b0, is %b)", count, flag);	
		end

		rst = 1'b1; 		//actually begins the program
		@(posedge clk); 	//new clock edge
		
		//testing always_comb 
		//when clear = 1
		if(count !== '0)begin
			$display("always_comb, clear: Incorrect for count(desired 0, is %b)", count);
		end

		clear = 1'b0;
		count_en = 1'b1;
		
		//when count_enable = 1, counting sequentially from 1-10
		for (int i = 1; i < (rollover_val + 1); i++) begin
			@(posedge clk); 	//new clock edge

			if (count !== i)begin
				$display("always_comb, count_enable: Incorrect for count(desired %b, is %b)", i, count);
			end

			//checks flag inbetween each check
			//if rollover value not reached yet
			if ((count !== rollover_val) && (flag !== 1'b0))begin
				$display("always_comb, rollover_val: Incorrect for flag(desired 0, is %b)", flag);
			end

			//if REACHED rollover value			
			if ((count == rollover_val) && (flag !== 1'b1))begin
				$display("always_comb, rollover_val: Incorrect for flag(desired 1, is %b)", flag);
			end
		end
			
	end
endmodule
