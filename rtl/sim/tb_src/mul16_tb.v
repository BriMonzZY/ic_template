`timescale 1ns / 1ps

module mul16_tb;

	reg [15:0] a, b;
	wire [31:0] product;

	// generate reference results (note that the signed data)
	wire signed [15:0] a_e = a;
	wire signed [15:0] b_e = b;
	wire signed [31:0] product_ref = a_e * b_e;
	wire ok = (product_ref == product);

	mul16_16 uut (
		.a(a),
		.b(b),
		.product(product)
	);

	integer i;
	initial begin
		`ifdef DEBUG
		`ifdef FSDB
			$display("\n---use verdi---\n");
			$fsdbDumpfile("mul16_tb.fsdb");
			$fsdbDumpvars(0, mul16_tb);
			$fsdbDumpMDA(0, mul16_tb);
		`endif
		`endif

		// zero
		a=0; b=16;
		#20
		a=16; b=0;
		// pos
		#20
		a=2; b=4;
		#20
		a = 32767; b = 32767;
		#20
		a = 16'h5DF7; b = 16'h5DF7;
		#20
		a = 16'b0110000010000000; b = 16'b1000000000000001;
		// neg
		#20
		a = 16'h8000; b = 16'h6;
		#20
		a = 16'hF000; b = 16'hF000;
		#20
		// random
		for(i = 0; i < 10; i=i+1) begin
			a = $random; b = $random; #20;
		end

		$finish();
	end

	initial begin
    $monitor("A = %h, B = %h, Product = %h, ref = %h result_ref = %h", a, b, product, product_ref, ok);
  end

endmodule
