// 2-2 compressor (half adder)

module CSA2_2(
  input a, b,
  output sum, cout
);

  assign	sum = a ^ b;
  assign	cout = a & b;

endmodule
