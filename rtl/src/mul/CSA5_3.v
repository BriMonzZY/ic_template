// 4-2 compressor

module CSA5_3 (
  input a, b, c, d, cin,
  output sum, carry, cout
);
  wire s1, c1, c2;

  assign s1 = a ^ b ^ c;
  assign c1 = (a & b) | (b & c) | (c & a);

  assign sum = s1 ^ d ^ cin;
  assign c2 = (s1 & d) | (d & cin) | (cin & s1);

  assign carry = c1;
  assign cout = c2;

endmodule
