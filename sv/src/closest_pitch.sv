`include "../include/closest_pitch_if.vh"

module closest_pitch #(
    parameter int START_OCTAVE = 2,   // lowest octave (inclusive)
    parameter int END_OCTAVE   = 6    // highest octave (inclusive)
)(
    input logic clk, nRST, closest_pitch_if.cp cpif
);

    // Derived note frequency table based on START/END octaves
    localparam int NUM_OCTAVES = (END_OCTAVE - START_OCTAVE + 1);
    localparam int NUM_NOTES   = NUM_OCTAVES * 12;
    localparam int BASE_OCTAVE = 4;  // C4 is our reference octave

    // FSM: Linear scan search

    typedef enum logic [1:0] {IDLE, SCAN, FINALIZE, DONE} state_t;
    state_t state, nxt_state;

    logic [31:0] target_freq;
    logic [31:0] best_diff, diff, nxt_diff;
    int   best_idx, nxt_best;
    int   i, nxt_i;
    logic [PITCH_ADDRESS_BITS - 1:0] nxt_pitch;
    logic nxt_done;

    logic [31:0] scaled_note;
    logic [3:0] note_in_oct;
    int octave_num, shift_amt;

    // Compute scaled target frequency
    assign target_freq = cpif.freq_in << cpif.scale;

    always_ff @(posedge clk, negedge nRST) begin
        if (!nRST) begin
            state           <= IDLE;
            cpif.pitch_addr <= 0;
            cpif.done       <= 0;
            best_idx        <= 0;
            best_diff       <= 32'hFFFFFFFF;
            i               <= 0;
        end else begin
            state           <= nxt_state;
            cpif.pitch_addr <= nxt_pitch;
            cpif.done       <= nxt_done;
            best_idx        <= nxt_best;
            best_diff       <= nxt_diff;
            i               <= nxt_i;
        end
    end

    always_comb 
    begin
        nxt_state = state;
        nxt_pitch = cpif.pitch_addr;
        nxt_done = cpif.done;
        nxt_best = best_idx;
        nxt_diff = best_diff;
        nxt_i = i;

        // Default values
        diff       = 0;
        scaled_note = 0;
        note_in_oct = i % SEMITONES_IN_OCTAVE;
        octave_num  = START_OCTAVE + (i / SEMITONES_IN_OCTAVE);
        shift_amt   = octave_num - BASE_OCTAVE;

        case (state)
            IDLE: begin
                nxt_done = 0;
                if (cpif.start) begin
                    nxt_diff = 32'hFFFFFFFF;
                    nxt_best = 0;
                    nxt_i = 0;
                    nxt_state = SCAN;
                end
            end
            SCAN: begin
                // Compute scaled note frequency on the fly
                if (shift_amt > 0)
                    scaled_note = BASE_FREQS_C4[note_in_oct] << shift_amt;
                else if (shift_amt < 0)
                    scaled_note = BASE_FREQS_C4[note_in_oct] >> (-shift_amt);
                else
                    scaled_note = BASE_FREQS_C4[note_in_oct];

                if (cpif.active_tones[note_in_oct]) begin
                    diff = (target_freq > scaled_note) ?
                            (target_freq - scaled_note) :
                            (scaled_note - target_freq);
                    if (diff < best_diff) begin
                        nxt_diff = diff;
                        nxt_best = i;
                    end
                end

                if (i == NUM_NOTES-1) begin
                    nxt_state = FINALIZE;
                end else begin
                    nxt_i = i + 1;
                end
            end

            FINALIZE: begin
                    nxt_pitch = best_idx[PITCH_ADDRESS_BITS:0];
                    nxt_done = 1;
                    nxt_state = DONE;
                end

            DONE: begin
                if (!cpif.start)
                    nxt_state = IDLE;
            end
        endcase

    end
endmodule
