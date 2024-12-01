// 3-2 compressor (full adder)

module CSA3_2(
  input a, b, cin, 
  output sum, cout
);

  assign	sum = a ^ b ^ cin;
  assign 	cout = (a & b) | (a & cin) | (b & cin);

endmodule
