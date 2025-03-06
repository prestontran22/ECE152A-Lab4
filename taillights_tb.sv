module ucsbece152a_taillights_tb ( );
    logic clk;
    logic rst_n;
    logic clk_dimmer_i;

    logic left_i;
    logic right_i;
    logic hazard_i;
    logic brake_i;
    logic runlights_i;

    logic [5:0] lights_o;

ucsbece152a_taillights dut (
    .clk(clk),
    .rst_n(rst_n),
    .clk_dimmer_i(clk_dimmer_i),
    .left_i(left_i),
    .right_i(right_i),
    .hazard_i(hazard_i),
    .brake_i(brake_i),
    .runlights_i(runlights_i),
    .lights_o(lights_o)
);

initial begin
    clk = 0;
    forever #10 clk = ~clk;
end

initial begin
    rst_n = 0;
    left_i = 0;
    right_i = 0;
    hazard_i = 0;
    brake_i = 0;
    runlights_i = 0;
    clk_dimmer_i = 0;
  
    #20
    rst_n = 1;
  
    // Left turn signal
    left_i = 1;
    #20
    assert (lights_o == 6'b001_000) else $error("Left turn signal failed");
    #20
    assert (lights_o == 6'b011_000) else $error("Left turn signal failed");
    #20
    assert (lights_o == 6'b111_000) else $error("Left turn signal failed");
    left_i = 0;
    #20
  
    // Right turn signal
    right_i = 1;
    #20
    assert (lights_o == 6'b000_100) else $error("Right turn signal failed");
    #20
    assert (lights_o == 6'b000_110) else $error("Right turn signal failed");
    #20
    assert (lights_o == 6'b000_111) else $error("Right turn signal failed");
    #20
    right_i = 0;
  
    // Hazard lights
    #20
    hazard_i = 1;
    #20
    assert (lights_o == 6'b111_111) else $error("Hazard lights failed");
    #20
    assert (lights_o == 6'b000_000) else $error("Hazard lights failed");
    #20
    assert (lights_o == 6'b111_111) else $error("Hazard lights failed");
    hazard_i = 0;
    #20
  
    // Brake lights
    brake_i = 1;
    #20
    assert (lights_o == 6'b111_111) else $error("Brake lights failed");
    brake_i = 0;

    // Brake lights with left turn signal
    brake_i = 1;
    left_i = 1;
    #20
    assert (lights_o == 6'b001_111) else $error("Brake/turn signal lights failed");
    #20
    assert (lights_o == 6'b011_111) else $error("Brake/turn signal failed");
    #20
    assert (lights_o == 6'b111_111) else $error("Brake/turn signal failed");
    brake_i = 0;
    left_i = 0;
    #20
  
    // Brake lights with right turn signal
    brake_i = 1;
    right_i = 1;
    #20
    assert (lights_o == 6'b111_100) else $error("Brake/turn signal lights failed");
    #20
    assert (lights_o == 6'b111_110) else $error("Brake/turn signal failed");
    #20
    assert (lights_o == 6'b111_111) else $error("Brake/turn signal failed");
    brake_i = 0;
    right_i = 0;
    #20
  
    // Brake with hazard lights
    brake_i = 1;
    hazard_i = 1;
    #20
    assert (lights_o == 6'b111_111) else $error("Brake/turn signal lights failed");
    brake_i = 0;
    hazard_i = 0;
    #20
  
    // Running lights
    runlights_i = 1;
    clk_dimmer_i = 1;
    #25
    assert (lights_o == 6'b111_111) else $error("Running lights failed");
    left_i = 1;
    #20
    assert (lights_o == 6'b111_111) else $error("Running lights failed");
    runlights_i = 0;
    left_i = 0;
    clk_dimmer_i = 0;
    #20
  
    // Simultaneous turn signals
    left_i = 1;
    right_i = 1;
    #20
    assert (lights_o == 6'b111_111) else $error("Hazard light failed");
    #20
    assert (lights_o == 6'b000_000) else $error("Brake/turn signal failed");
    #20
    left_i = 0;
    right_i = 0;
    #20
  
    // Abort sequence for turn signal
    left_i = 1;
    #20
    assert (lights_o == 6'b001_000) else $error("Left turn signal failed");
    #20
    left_i = 0;
    #20
    assert (lights_o == 6'b000_000) else $error("Abort failed");

    #20
    rst_n = 0;
    // Left turn signal with rst_n = 0;
    left_i = 1;
    #20
    assert (lights_o == 6'b000_000) else $error("Left turn signal failed");
    #20
    assert (lights_o == 6'b000_000) else $error("Left turn signal failed");
    #20
    assert (lights_o == 6'b000_000) else $error("Left turn signal failed");
    left_i = 0;
  
    // Right turn signal with rst_n = 0;
    right_i = 1;
    #20
    assert (lights_o == 6'b000_000) else $error("Right turn signal failed");
    #20
    assert (lights_o == 6'b000_000) else $error("Right turn signal failed");
    #20
    assert (lights_o == 6'b000_000) else $error("Right turn signal failed");
    right_i = 0;

    $display("Simulation finished");
end

endmodule
