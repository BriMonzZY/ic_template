`timescale 1ns / 1ps

module cla32_tb();

  reg [31:0] a,b;
  wire [32:0] Sum;
  
  cla32 u_cla32(
    .A(a),
    .B(b),
    .Sum(Sum)
  );
  
  initial begin
    `ifdef DEBUG
		`ifdef FSDB
			$display("\n---use verdi---\n");
			$fsdbDumpfile("cla32_tb.fsdb");
			$fsdbDumpvars(0, cla32_tb);
		`endif
		`endif

    a = 0; b = 0;
    #20
    a=32'd2; b=32'd2; 
    #20
    a=32'd2; b=32'd3;
    #20
    a=32'd18; b=32'd18;
    #20
    a=32'd100; b=32'd0;
    #20
    a=32'hFFFF_FFFF; b=32'hFFFF_FFFF;
    #20
    a=-32'd1; b=32'd1;
    #20
    $finish();
  end

  initial begin
    $monitor("A = %h, B = %h, Sum = %h", a, b, Sum);
  end

endmodule
