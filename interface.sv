// interface.sv
interface intf (input logic clk, input logic rst_n);
  logic [3:0] req;   // driven by driver, consumed by DUT
  logic [3:0] gnt;   // driven by DUT, sampled by monitor
endinterface
