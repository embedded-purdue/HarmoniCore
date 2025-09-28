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

