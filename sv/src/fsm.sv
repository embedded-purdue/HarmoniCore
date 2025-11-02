module fsm (
    input  logic clk,
    input  logic n_rst,
    input  logic empty,
    input  logic hop_flag, // moves away from READ (when we finish reading the first )
    input  logic hoplength_flag, // moves away from READ_BX
    input  logic countersel_flag, // ends READ_B1
    input  logic fft_done,
    output logic read_en,
    output logic count_en,
    output logic read_b1,
    output logic read_b2,
    output logic read_b3,
    output logic read_b4,
    output logic write_b1,
    output logic write_b2,
    output logic write_b3,
    output logic write_b4,
    output logic clear
);

typedef enum logic [2:0] {
    IDLE    = 3'b000,
    READ    = 3'b001,
    READ_B1 = 3'b010,
    READ_B2 = 3'b011,
    READ_B3 = 3'b100,
    READ_B4 = 3'b101
} state_t;

state_t current_state, next_state;

always_ff @(posedge clk, negedge n_rst) begin
    if (!n_rst)
        current_state <= IDLE;
    else
        current_state <= next_state;
end

always_comb begin
    // Default: stay in current state
    next_state = current_state;

    case(current_state) 
        IDLE: begin
            if (~empty & fft_done)
                next_state = READ;
        end
        
        READ: begin
            if (hop_flag)
                next_state = READ_B4;
        end
        
        READ_B4: begin
            if (hoplength_flag)
                next_state = READ_B3;
        end
        
        READ_B3: begin
            if (hoplength_flag)
                next_state = READ_B2;
        end
        
        READ_B2: begin
            if (hoplength_flag)
                next_state = READ_B1;
        end
        
        READ_B1: begin
            if (countersel_flag)
                next_state = IDLE;
        end
        
        default: next_state = current_state;  
    endcase
end


always_comb begin
    read_en   = 1'b0;
    count_en  = 1'b0;
    read_b1   = 1'b0;
    read_b2   = 1'b0;
    read_b3   = 1'b0;
    read_b4   = 1'b0;
    write_b1  = 1'b0;
    write_b2  = 1'b0;
    write_b3  = 1'b0;
    write_b4  = 1'b0;
    clear     = 1'b0;

    case(current_state)

        IDLE: begin
            clear = 1'b1;

            read_en   = 1'b0;
            count_en  = 1'b0;
            read_b1   = 1'b0;
            read_b2   = 1'b0;
            read_b3   = 1'b0;
            read_b4   = 1'b0;
            write_b1  = 1'b0;
            write_b2  = 1'b0;
            write_b3  = 1'b0;
            write_b4  = 1'b0;
        end

        READ: begin
            read_en = 1'b1;
            write_b1 = 1'b1;

            count_en  = 1'b0;
            read_b1   = 1'b0;
            read_b2   = 1'b0;
            read_b3   = 1'b0;
            read_b4   = 1'b0;
            write_b2  = 1'b0;
            write_b3  = 1'b0;
            write_b4  = 1'b0;
            clear     = 1'b0;
        end
        
        READ_B4: begin
            count_en = 1'b1;
            read_b4  = 1'b1;

            read_en   = 1'b0;
            read_b1   = 1'b0;
            read_b2   = 1'b0;
            read_b3   = 1'b0;
            write_b1  = 1'b0;
            write_b2  = 1'b0;
            write_b3  = 1'b0;
            write_b4  = 1'b0;
            clear     = 1'b0;
        end
// Note: Are we using a counter to read from fifo??? Do inputs come in fast enough?
        READ_B3: begin
            count_en = 1'b1;
            read_b3  = 1'b1;
            write_b4 = 1'b1;

            read_en   = 1'b0;
            read_b1   = 1'b0;
            read_b2   = 1'b0;
            read_b4   = 1'b0;
            write_b1  = 1'b0;
            write_b2  = 1'b0;
            write_b3  = 1'b0;
            clear     = 1'b0;
        end
        
        READ_B2: begin
            count_en = 1'b1;
            read_b2  = 1'b1;
            write_b3 = 1'b1;

            read_en   = 1'b0;
            read_b1   = 1'b0;
            read_b3   = 1'b0;
            read_b4   = 1'b0;
            write_b1  = 1'b0;
            write_b2  = 1'b0;
            write_b4  = 1'b0;
            clear     = 1'b0;
        end

        READ_B1: begin
            count_en = 1'b1;
            read_b1  = 1'b1;
            write_b2 = 1'b1;

            read_en   = 1'b0;
            read_b2   = 1'b0;
            read_b3   = 1'b0;
            read_b4   = 1'b0;
            write_b1  = 1'b0;
            write_b3  = 1'b0;
            write_b4  = 1'b0;
            clear     = 1'b0;
        end

        default: begin
            clear = 1'b1;

            read_en   = 1'b0;
            count_en  = 1'b0;
            read_b1   = 1'b0;
            read_b2   = 1'b0;
            read_b3   = 1'b0;
            read_b4   = 1'b0;
            write_b1  = 1'b0;
            write_b2  = 1'b0;
            write_b3  = 1'b0;
            write_b4  = 1'b0;
        end

    endcase


end


endmodule