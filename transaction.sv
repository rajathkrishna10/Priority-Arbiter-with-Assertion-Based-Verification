// transaction.sv
class transaction;
  rand bit [3:0] req;   // randomized stimulus (each bit = one requester)
       bit [3:0] gnt;   // captured DUT response (one-hot grant)

  function void display(string name);
    $display("[%-10s] req=%04b  gnt=%04b", name, req, gnt);
  endfunction
endclass
