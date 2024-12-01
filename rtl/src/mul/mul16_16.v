// 16 x 16 multiplier use Radix-4 Booth and Wallace

`include "array_port.vh"

module mul16_16 (
  input [15:0] a, b,
  output [31:0] product
);

  wire [143:0] pp_out;
  wire [31:0] ppout1;
  wire [29:0] ppout2;
  wire [32:0] pp_sum;

  assign product = pp_sum[31:0];

  pp_compressor u_pp_compressor (
    .pp(pp_out),
    .ppout1(ppout1),
    .ppout2(ppout2)
  );

  pp_gen u_pp_gen(
    .a(a),
    .b(b),
    .pp_out(pp_out)
  );

  cla32 u_cla32 (
    .A(ppout1),
    .B({ppout2, 2'd0}),
    .Sum(pp_sum)
  );


  // assign product = a * b;

  // DW02_mult #(16, 16) mult_u1(a,b,1'b0,product);


endmodule

