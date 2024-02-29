//  Module: tb_top
//
module tb_top;


  reg din;
  reg clk;
  wire [3:0] dout;

  wire D2A_DIN;
  wire D2A_CLK;
  wire [3:0] A2D_DOUT;

  Xadc dut(
    .vin(D2A_DIN),
    .clock(D2A_CLK),
    .d0(A2D_DOUT[0]),
    .d1(A2D_DOUT[1]),
    .d2(A2D_DOUT[2]),
    .d3(A2D_DOUT[3])
  );

  always #100 clk = ~clk;

  initial begin
    din = 0;
    clk = 0;
    #1000 din = 1;

    #10_000 $finish;
  end

  assign D2A_DIN = din;
  assign D2A_CLK = clk;
  assign dout = A2D_DOUT;




	initial begin
		$timeformat(-9, 0, "ns", 4);
		$fsdbDumpfile("tb_top.fsdb");
		$fsdbDumpvars(0, tb_top, "+all");
		$fsdbDumpMDA;

		//$fsdbDumpoff("+fsdbfile+tb_top.fsdb");;
	end
  
endmodule: tb_top
