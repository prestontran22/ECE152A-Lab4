module ucsbece152a_taillights (
    input logic clk,
    input logic rst_n,
    input logic clk_dimmer_i,

    input logic left_i,
    input logic right_i,
    input logic hazard_i,
    input logic brake_i,
    input logic runlights_i,

    output logic [5:0] lights_o
);

logic [5:0] fsm_pattern;

ucsbece152a_fsm fsm (
    .clk(clk),
    .rst_n(rst_n),
    .left_i(left_i),
    .right_i(right_i),
    .hazard_i(hazard_i),
    .pattern_o(pattern_o)
);

logic [5:0] lights_runlightson;

// TODO: Convert 'fsm_pattern' into 'lights_o'
assign fsm_pattern = pattern_o;
assign lights_runlightson = (clk_dimmer_i) ? 6'b111_111 : 6'b000_000;

always_comb begin
    lights_o = fsm_pattern;

    if (brake_i) begin
        if (left_i)
            lights_o = {fsm_pattern[5:3], 3'b111};
        else if (right_i)
            lights_o = {3'b111, fsm_pattern[2:0]};
        else 
            lights_o = 6'b111_111;
    end else if (runlights_i) begin
        lights_o = (lights_o | lights_runlightson);
    end 
end

endmodule