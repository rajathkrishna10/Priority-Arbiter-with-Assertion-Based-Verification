// Code your testbench here
// or browse Examples
`include "interface.sv"
`include "test.sv"

module top;

  bit clk, rst_n;

  always #5 clk = ~clk;

  initial begin
    rst_n = 0;
    repeat (2) @(negedge clk);   // release reset on a clock-aligned edge
    rst_n = 1;
  end

  intf i_intf (clk, rst_n);

  test t1 (i_intf);

  priority_arbiter dut (
    .clk   (i_intf.clk),
    .rst_n (i_intf.rst_n),
    .req   (i_intf.req),
    .gnt   (i_intf.gnt)
  );

  initial begin
    $dumpfile("arbiter.vcd");
    $dumpvars;
  end
endmodule
