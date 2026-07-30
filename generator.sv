// generator.sv
class generator;

  rand transaction trans;
  int repeat_count;

  mailbox gen2driv;             // communication btw gen and driv

  event ended;                  // indicates end of generating random values

  function new(mailbox gen2driv);   // constructor
    this.gen2driv = gen2driv;
  endfunction

  task main();
    repeat (repeat_count) begin
      trans = new();
      if (!trans.randomi
