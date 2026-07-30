// arbiter_assertions.sv
// Assertion-only module, bound to the DUT -- never edits DUT code directly.
module arbiter_assertions (
  input logic       clk,
  input logic       rst_n,
  input logic [3:0] req,
  input logic [3:0] gnt
);

  // Grant must be one-hot or all-zero, never two bits set at once.
  property p_onehot_gnt;
    @(posedge clk) disable iff (!rst_n)
    $onehot0(gnt);
  endproperty
  a_onehot_gnt: assert property (p_onehot_gnt)
    else $error("Grant is not one-hot/zero: gnt=%0b", gnt);

  // Any granted bit must correspond to a request made the previous cycle.
  property p_grant_implies_req;
    @(posedge clk) disable iff (!rst_n)
    (gnt != '0) |-> (($past(req) & gnt) == gnt);
  endproperty
  a_grant_implies_req: assert property (p_grant_implies_req)
    else $error("Grant given for a bit not requested last cycle");

  // No request pending -> no grant next cycle.
  property p_no_req_no_gnt;
    @(posedge clk) disable iff (!rst_n)
    (req == '0) |-> ##1 (gnt == '0);
  endproperty
  a_no_req_no_gnt: assert property (p_no_req_no_gnt)
    else $error("Grant issued with no request pending last cycle");

  // Grant must be clear immediately after reset deasserts.
  property p_reset_gnt;
    @(posedge clk)
    $fell(rst_n) |=> (gnt == '0);
  endproperty
  a_reset_gnt: assert property (p_reset_gnt)
    else $error("Grant not clear after reset");

  covergroup cg_arbiter_dut @(posedge clk iff rst_n);
    option.per_instance = 1;

    cp_req: coverpoint req {
      bins idle      = {4'b0000};
      bins only_bit0 = {4'b0001};
      bins only_bit1 = {4'b0010};
      bins only_bit2 = {4'b0100};
      bins only_bit3 = {4'b1000};
      bins multi_req = default;   // any combination with 2+ bits set
    }

    cp_gnt: coverpoint gnt {
      bins idle = {4'b0000};
      bins bit0 = {4'b0001};
      bins bit1 = {4'b0010};
      bins bit2 = {4'b0100};
      bins bit3 = {4'b1000};
    }

    cross cp_req, cp_gnt;
  endgroup

  cg_arbiter_dut cg_inst = new();

endmodule

// Attach the checker to the DUT without touching its source.
bind priority_arbiter arbiter_assertions u_arbiter_assertions (
  .clk   (clk),
  .rst_n (rst_n),
  .req   (req),
  .gnt   (gnt)
);
