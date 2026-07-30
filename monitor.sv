// monitor.sv
class monitor;

  virtual intf vif;
  mailbox mon2scb;
  mailbox mon2cov;

  function new(virtual intf vif, mailbox mon2scb, mailbox mon2cov);
    this.vif = vif;
    this.mon2scb = mon2scb;
    this.mon2cov = mon2cov;
  endfunction


  task main;
    forever begin
      transaction trans;
      trans = new();
      @(posedge vif.clk);
      trans.req = vif.req;
      trans.gnt = vif.gnt;
      mon2scb.put(trans);   // subscriber 1: checks correctness
      mon2cov.put(trans);   // subscriber 2: tracks functional coverage
      trans.display("monitor");
    end
  endtask
endclass
