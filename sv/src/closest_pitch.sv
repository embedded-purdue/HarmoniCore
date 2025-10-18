`include "../include/closest_pitch_if.vh"

// ============================================================
// closest_pitch
// ------------------------------------------------------------
// Finds the closest active semitone (C..B) in the range
// START_OCTAVE .. END_OCTAVE to the input frequency.
//
// Octave frequencies are derived by shifting the C4 octave
// base frequencies left or right as needed.
// ============================================================

module closest_pitch #(
    parameter int START_OCTAVE = 2,   // lowest octave (inclusive)
    parameter int END_OCTAVE   = 6    // highest octave (inclusive)
)(
    input logic clk, nRST, closest_pitch_if.cp cpif
);

    // ============================================================
    // Base semitone frequencies for the C4 octave (middle C)
    // Represented in fixed-point Hz * 2048 (1.6.11 format)
    // ============================================================
    localparam int BASE_FREQS_C4 [0:11] = '{
        535718, 567969, 601268, 637601,
        675942, 715850, 757310, 803840,
        850534, 901120, 954908, 1011962
    };

    // ------------------------------------------------------------
    // Derived note frequency table based on START/END octaves
    // ------------------------------------------------------------
    localparam int NUM_OCTAVES = (END_OCTAVE - START_OCTAVE + 1);
    localparam int NUM_NOTES   = NUM_OCTAVES * 12;
    localparam int BASE_OCTAVE = 4;  // C4 is our reference octave

    logic [31:0] note_freqs [0:NUM_NOTES-1];

    genvar o, n;
    generate
        for (o = 0; o < NUM_OCTAVES; o++) begin : octave
            for (n = 0; n < 12; n++) begin : semitone
                localparam int idx = o*12 + n;
                localparam int octave_num = START_OCTAVE + o;
                localparam int shift_amt  = octave_num - BASE_OCTAVE;

                if (shift_amt > 0)
                    assign note_freqs[idx] = BASE_FREQS_C4[n] << shift_amt;
                else if (shift_amt < 0)
                    assign note_freqs[idx] = BASE_FREQS_C4[n] >> (-shift_amt);
                else
                    assign note_freqs[idx] = BASE_FREQS_C4[n];
            end
        end
    endgenerate

    // ------------------------------------------------------------
    // FSM: Linear scan search
    // ------------------------------------------------------------
    typedef enum logic [1:0] {IDLE, SCAN, FINALIZE, DONE} state_t;
    state_t state;

    logic [31:0] target_freq;
    logic [31:0] best_diff, diff;
    int   best_idx;
    int   i;

    // Compute scaled target frequency
    assign target_freq = cpif.freq_in << cpif.scale;

    // ------------------------------------------------------------
    // Sequential FSM
    // ------------------------------------------------------------
    always_ff @(posedge clk, negedge nRST) begin
        if (!nRST) begin
            state           <= IDLE;
            cpif.pitch_addr <= 0;
            cpif.done       <= 0;
            best_idx        <= 0;
            best_diff       <= 32'hFFFFFFFF;
            i               <= 0;
        end else begin
            case (state)
                IDLE: begin
                    cpif.done <= 0;
                    if (cpif.start) begin
                        best_diff <= 32'hFFFFFFFF;
                        best_idx  <= 0;
                        i         <= 0;
                        state     <= SCAN;
                    end
                end

                SCAN: begin
                    if (cpif.active_tones[i % 12]) begin
                        diff = (target_freq > note_freqs[i]) ?
                               (target_freq - note_freqs[i]) :
                               (note_freqs[i] - target_freq);
                        if (diff < best_diff) begin
                            best_diff <= diff;
                            best_idx  <= i;
                        end
                    end

                    if (i == NUM_NOTES-1) begin
                        state           <= FINALIZE;
                    end else begin
                        i <= i + 1;
                    end
                end

                FINALIZE: begin
                    cpif.pitch_addr <= best_idx[PITCH_ADRESS_BITS:0];
                    cpif.done       <= 1;
                    state           <= DONE;
                end

                DONE: begin
                    if (!cpif.start)
                        state <= IDLE;
                end
            endcase
        end
    end

endmodule
