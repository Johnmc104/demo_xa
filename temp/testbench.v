`timescale 1ns/ 10ps

module top;
	reg [3:0] a, b;
	wire [3:0] s;
	reg cin;
	wire cout;

	task test;
		input [3:0] in1, in2;
		input inc;
		reg [3:0] real_out, exp_out;
		reg real_cout, exp_cout;
	begin
		a = in1;
		b = in2;
		cin = inc;
		#10
		real_out = s;
		real_cout = cout;
		
		assign {exp_cout, exp_out} = in1 + in2 + inc;
		if ($test$plusargs("COMPARE")) begin
			if (exp_out !== real_out)
				$display("COMPARE ERROR! Expected_s=%h Real_s=%h", exp_out, real_out);
			if (exp_cout !== real_cout)
				$display("COMPARE ERROR! Expected_cout=%b Real_cout=%b", exp_cout, real_cout);
			end
		end
	endtask

	addr4 dut (.a(a[3:0]), .b(b[3:0]), .cin(cin), .s(s[3:0]), .cout(cout)); 

	initial begin
		$fsdbDumpfile("vcs.fsdb");
		$fsdbDumpvars;
		$monitor($time,,, "a= %h ", a, "b= %h ", b, "cin= %b ", cin, "s= %h ", s, "cout= %b ", cout);
		#0
		//test(ValueForInput1, ValueForInput2, CarryIn);
		test(0,1,0);
		test(0,1,1);
		test(1,1,1);
		test(15,15,0);
		test(15,15,1);
		$finish(2);
	end
endmodule
