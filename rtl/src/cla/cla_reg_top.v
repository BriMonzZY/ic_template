// Add input and output register for the full Combinational logic circuit(cla32)

module cla_reg_top (
  input clk, rst_n,
  input [31:0] A, B,
  output [32:0] Sum
);

  reg [31:0] A_reg, B_reg;
  reg [32:0] Sum_reg;

  wire [32:0] Sum_wire;

  always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
      A_reg <= 32'b0;
      B_reg <= 32'b0;
    end else begin
      A_reg <= A;
      B_reg <= B;
    end
  end

  always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
      Sum_reg <= 33'b0;
    end else begin
      Sum_reg <= Sum_wire;
    end
  end

  assign Sum = Sum_reg;


  cla32 u_cla32 (
    .A(A_reg),
    .B(B_reg),
    .Sum(Sum_wire)
  );

endmodule
