// coverage.sv
class coverage;

  mailbox mon2cov;
  transaction trans;

  
  // arrays works identically regardless of any simulator coverage setting.
  bit hit_num_req[5];   // index = number of simultaneous requesters (0..4)
  bit hit_gnt[5];       // index = which bin won: 0=idle,1=bit0,2=bit1,3=bit2,4=bit3

  function new(mailbox mon2cov);
    this.mon2cov = mon2cov;
  endfunction

  function int gnt_bin(bit [3:0] gnt);
    case (gnt)
      4'b0000: return 0;
      4'b0001: return 1;
      4'b0010: return 2;
      4'b0100: return 3;
      4'b1000: return 4;
      default: return -1;   // non-one-hot -- should never happen if design is correct
    endcase
  endfunction

  task main();
    int n, g;
    forever begin
      mon2cov.get(trans);
      n = $countones(trans.req);
      g = gnt_bin(trans.gnt);
      if (n inside {[0:4]}) hit_num_req[n] = 1;
      if (g != -1)          hit_gnt[g]     = 1;
    end
  endtask

  // Overall coverage = average of the two coverage models (10 bins total).
  function real get_coverage();
    int hit;
    hit = 0;
    foreach (hit_num_req[i]) if (hit_num_req[i]) hit++;
    foreach (hit_gnt[i])     if (hit_gnt[i])     hit++;
    return (100.0 * hit) / 10.0;
  endfunction

  function void print_report();
    string req_name[5] = '{"0 requesters", "1 requester", "2 requesters", "3 requesters", "4 requesters"};
    string gnt_name[5] = '{"idle (no grant)", "bit0 wins", "bit1 wins", "bit2 wins", "bit3 wins"};
    $display("---- Coverage bin detail ----");
    foreach (hit_num_req[i])
      $display("  num_req = %0d (%-14s): %s", i, req_name[i], hit_num_req[i] ? "HIT" : "MISSED");
    foreach (hit_gnt[i])
      $display("  gnt bin  (%-16s): %s", gnt_name[i], hit_gnt[i] ? "HIT" : "MISSED");
  endfunction
endclass
