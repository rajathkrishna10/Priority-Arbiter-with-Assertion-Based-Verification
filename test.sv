`include "environment.sv"

program test (intf i_intf);   // program lets design code run first

  environment env;

  initial begin
    env = new(i_intf);
    env.gen.repeat_count = 150;   // more cycles gives coverage a realistic chance to close
    env.run();
  end
endprogram
