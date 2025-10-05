module div_check (
    input logic nRST, 
    input logic clk, 
    input logic rollover_flag, 
    input logic t_valid, 
    output logic [17:0] fp
);

	// purpose of this program is to check if the divider is done with the cum_mean function
	logic[17:0] next_fp;
	always_ff@(posedge clk || negedge nRST) begin
		if(!nRST) begin
			fp <= '0; //reset
		end else begin
			fp <= next_fp; //sets fp = to next_fp
		end
	end
    
	always_comb begin
		if(rollover_flag && !t_valid) begin  // change default clear value
			next_fp = fp + 8; // sets up data points for the memory to pull addresses
        end else begin
            next_fp = fp; // sets values equal at the beginning
        end
	end
endmodule 
