//Functional Verification of Priority Arbiter with Assertion-Based Verification
// Code your design here
`include "arbiter_assertions.sv"

module priority_arbiter (
  input  logic       clk,
  input  logic       rst_n,
  input  logic [3:0] req,
  output logic [3:0] gnt
);

  reg [3:0] tmp_gnt;

  //always
  //always_comb
  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n)
      tmp_gnt <= 4'b0000;
    else begin
      tmp_gnt <= 4'b0000;                 // default: no grant this cycle
      for (int i = 0; i < 4; i++) begin
        if (req[i]) begin
          tmp_gnt[i] <= 1'b1;             // grant first (lowest-index) requester
          break;                          // stop scanning once granted
        end
      end
    end
  end

  assign gnt = tmp_gnt;

endmodule
