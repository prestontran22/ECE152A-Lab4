typedef enum logic [2:0] {
    S000_000, //lights off
    S000_100, // right turn stage 1
    S000_110, // right turn stage 2
    S000_111, // right turn stage 3
    S001_000, // left turn stage 1
    S011_000, // left turn stage 2
    S111_000, // left turn stage 3
    S111_111 // hazard lights
} state_t;

module ucsbece152a_fsm (
    input logic clk,
    input logic rst_n,

    input logic left_i,
    input logic right_i,
    input logic hazard_i,

    output state_t state_o,
    output logic [5:0] pattern_o
);

state_t state_d, state_q = S000_000;
assign state_o = state_q;

//TODO: implement the fsm and drive 'pattern_o'

always_comb begin
    case (state_q)
        S000_000: begin
            if (hazard_i)
                state_d = S111_111;
            else if (left_i & right_i) // if both turn signals are on, activates hazard lights
                state_d = S111_111;
            else if (left_i)
                state_d = S001_000;
            else if (right_i)
                state_d = S000_100;
            else state_d = S000_000;
        end

        // if the turn signals are turned off, the sequence is aborted and all lights are turned off
        S000_100: begin 
        if (~left_i) state_d = S000_000;
        else state_d = S000_110;
        end
        S000_110: begin
        if (~left_i) state_d = S000_000;
        else state_d = S000_111;
        end
        S000_111: state_d = S000_000;
       
        S001_000: begin
        if (~right_i) state_d = S000_000;
        else state_d = S011_000;
        end
        S011_000: begin
        if (~right_i) state_d = S000_000;
        else state_d = S111_000;
        end
        S111_000: state_d = S000_000;
       
        S111_111: state_d = S000_000;
    endcase
end

always_ff @(posedge clk or negedge rst_n) begin
    if (~rst_n)
        state_q <= S000_000;
    else 
        state_q <= state_d;
end

always_comb begin
    case (state_q)
        S000_000: pattern_o = 6'b000_000;
        S000_100: pattern_o = 6'b000_100;
        S000_110: pattern_o = 6'b000_110;
        S000_111: pattern_o = 6'b111_111;
        S001_000: pattern_o = 6'b001_000;
        S011_000: pattern_o = 6'b011_000;
        S111_000: pattern_o = 6'b111_000;
        S111_111: pattern_o = 6'b111_111;
        default: pattern_o = 6'b000_000;
    endcase
end

endmodule
