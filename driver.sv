// driver.sv
class driver;

  int no_transactions;

  virtual intf vif;             // virtual interface = pointer to actual interface

  mailbox gen2driv;

  function new(virtual intf vif, mailbox gen2driv);
    this.vif = vif;
    this.gen2driv = gen2driv;
  endfunction

  task reset;
    wait (!vif.rst_n);
    $display("[driver]--------- reset started-------");
    vif.req <= 0;
    wait (vif.rst_n);
    $display("[driver]---------reset ended----");
  endtask

  task main;
    transaction trans;
    forever begin                      // infinite loop
      gen2driv.get(trans);             // take values from mailbox
    
      @(negedge vif.clk);
      vif.req <= trans.req;
      @(posedge vif.clk);              // let the DUT register the grant
      no_transactions++;
    end
  endtask
endclass
