// Carry-Look-ahead Adder 32-bit

module cla32 (
  input [31:0] A, B,
  output [32:0] Sum
);

  wire c1, c2;

  cla16 u_cla_0(.a(A[15:0]), .b(B[15:0]), .cin(1'b0), .sum(Sum[15:0]), .cout(c1));
  cla16 u_cla_1(.a(A[31:16]), .b(B[31:16]), .cin(c1), .sum(Sum[31:16]), .cout(c2));

  assign Sum[32] = c2;

  // assign Sum = A+B;

endmodule
