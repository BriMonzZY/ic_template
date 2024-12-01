// Add input and output register for the full Combinational logic circuit(mul16_16)

module mul_reg_top (
  input clk, rst_n,
  input [15:0] a, b,
  output reg [31:0] product
);

  reg [15:0] a_reg, b_reg;
  reg [31:0] product_reg;

  mul16_16 u_mul16_16 (
    .a(a_reg),
    .b(b_reg),
    .product(product_reg)
  );

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      a_reg <= 16'd0;
      b_reg <= 16'd0;
      product <= 32'd0;
    end else begin
      a_reg <= a;
      b_reg <= b;
      product <= product_reg;
    end
  end

endmodule
