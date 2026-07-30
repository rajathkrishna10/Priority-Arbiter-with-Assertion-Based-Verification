// scoreboard.sv
class scoreboard;
  mailbox mon2scb;

  int no_transactions;

  function new(mailbox mon2scb);
    this.mon2scb = mon2scb;
  endfunction

  // Reference model: fixed priority, lowest set bit of req wins.
  function bit [3:0] expected_gnt(bit [3:0] req);
    for (int i = 0; i < 4; i++) begin
      if (req[i]) return (4'b0001 << i);
    end
    return 4'b0000;
  endfunction

  task main;
    transaction trans;
    forever begin
      mon2scb.get(trans);
      if (trans.gnt == expected_gnt(trans.req))    // ref block
        $display("result is as expected");
      else
        $error("wrong result \n \t req: %04b expected: %04b actual: %04b",
                trans.req, expected_gnt(trans.req), trans.gnt);
      no_transactions++;
      trans.display("scoreboard");
    end
  endtask
endclass
