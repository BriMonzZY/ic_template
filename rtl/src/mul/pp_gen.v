// partial product generator
// Radix-4 Booth

`include "array_port.vh"

module pp_gen(
  input [15:0] a, // Multiplicand
  input [15:0] b, // Mutiplier
  output [143:0] pp_out // eight 18-bit pp
);

  wire [16:0] b_extended;
  wire [17:0] a_pos, a_neg, a_extend;
  reg [2:0] booth_bits [7:0];
  reg [17:0] pp [7:0]; // 18-bit partial products

  assign b_extended = {b, 1'b0}; // and 1 bit to LSB
  assign a_extend = {{2{a[15]}}, a};
  assign a_pos = a_extend;
  assign a_neg = ~a_extend + 1'b1;

  // Booth Encoder
  integer i;
  always @(*) begin
    for(i = 0; i < 8; i=i+1) begin
      booth_bits[i] = {b_extended[2*i+2], b_extended[2*i+1], b_extended[2*i]};  
      case (booth_bits[i])
        3'b000, 3'b111: pp[i] = 18'd0;
        3'b001, 3'b010: pp[i] = a_pos;
        3'b011:         pp[i] = a_pos << 1;
        3'b100:         pp[i] = a_neg << 1;
        3'b101, 3'b110: pp[i] = a_neg;
        default: pp[i] = 18'd0;
      endcase
    end
  end

  `PACK_ARRAY(18, 8, pp, pp_out);

endmodule

