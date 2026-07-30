`include "transaction.sv"
`include "generator.sv"
`include "driver.sv"
`include "monitor.sv"
`include "scoreboard.sv"
`include "coverage.sv"

class environment;
  generator  gen;
  driver     driv;
  monitor    mon;
  scoreboard scb;
  coverage   cov;

  mailbox gen2driv;
  mailbox mon2scb;
  mailbox mon2cov;

  virtual intf vif;

  function new(virtual intf vif);
    this.vif = vif;
    gen2driv = new();
    mon2scb  = new();
    mon2cov  = new();
    gen  = new(gen2driv);
    driv = new(vif, gen2driv);
    mon  = new(vif, mon2scb, mon2cov);
    scb  = new(mon2scb);
    cov  = new(mon2cov);
  endfunction

  task pre_test();
    driv.reset();
  endtask

  task test();
    fork                       // threads
      gen.main();
      driv.main();
      mon.main();
      scb.main();
      cov.main();
    join_any
  endtask

  task post_test();
   
    wait (gen.ended.triggered);
    wait (gen.repeat_count == driv.no_transactions);
    repeat (5) @(posedge vif.clk);
    $display("========================================");
    $display("Functional coverage (num_req + gnt bins): %0.2f%%", cov.get_coverage());
    cov.print_report();
    $display("========================================");
  endtask

  task run;
    pre_test();
    test();
    post_test();
    $finish;
  endtask
endclass
