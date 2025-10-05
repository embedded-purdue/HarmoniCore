<<<<<<< Updated upstream
module counter (input nRST, input CLR, input clk, input count_enable, input[17:0] rollover_value, output rollover_flag, output[17:0] count); begin
	logic[17:0] next_count;
	always_ff@(posedge clk or negedge nRST) begin
		if(not nRST) begin
			count <= 0;
		end

		else begin
			count <= next_count;
		end
	end

	always_comb begin
		if(not nRST or not CLR) begin  // change default clear value
			next_count = 0; //reset on low nRST
			rollover_flag = 0;
		end

		else begin
			if(count_enable and not rollover_flag) begin
				next_count = count+1; //increment next_count
				if(next_count == rollover_value) begin
					rollover_flag = 1;
				end
			end

			else begin
				next_count = count; //do nothing
			end
		end
	end
end

=======
`timescale 1ns / 10ps

module flex_counter #(
    parameter SIZE = 4
) (
    input logic clk,
    input logic n_rst,
    input logic clear,
    input logic count_enable,
    input logic [SIZE - 1: 0] rollover_val,
    output logic [SIZE - 1: 0] count_out,
    output logic rollover_flag
);

logic [SIZE - 1:0] next;
logic flag_next;

always_ff @(posedge clk, negedge n_rst) begin : counter_ff
    if (!n_rst) begin
        count_out <= '0;
        rollover_flag <= 1'b0;
    end else begin
        count_out <= next;
        rollover_flag <= flag_next;
    end
end

always_comb begin : counter_comb
    if(clear) begin
        next = '0;
        flag_next = 1'b0;
    end else if (count_enable) begin
        if (count_out >= rollover_val) begin
            next = 1;
            flag_next = 1'b0;
        end else begin
            next = count_out + 1;
            if (next == rollover_val) begin
                flag_next = 1'b1;
            end else begin
                flag_next = 1'b0;
            end
        end
    end else begin
        next = count_out;
        flag_next = rollover_flag;
    end
end

endmodule
>>>>>>> Stashed changes
