
`include "uvm_macros.svh"
`include "uvm_pkg.sv"
`include "defines.sv"
`include "interface.sv"
`include "package.sv"
`include "fifo.v" // top design file
`include "asy_fifo_assertion.sv"

module top;
	import uvm_pkg::*;
	import asy_fifo_pkg::*;

	bit wclk, rclk, wrst_n, rrst_n;
	asy_fifo_interface intf(wclk, wrst_n, rclk, rrst_n);

	fifo #(.DSIZE(`DSIZE), .ASIZE(`ASIZE))
	dut(.wclk(wclk), .wrst_n(wrst_n), .wdata(intf.wdata), .wfull(intf.wfull), .winc(intf.winc),.rclk(rclk), .rrst_n(rrst_n), .rdata(intf.rdata), .rinc(intf.rinc), .rempty(intf.rempty));

	bind fifo assertions wa(.wclk(wclk), .wrst_n(wrst_n), .winc(winc), .wfull(wfull), .wdata(wdata), .rclk(rclk), .rrst_n(rrst_n), .rinc(rinc), .rempty(rempty), .rdata(rdata));

	always #5 wclk = ~wclk;
	always #10 rclk = ~rclk;
	initial begin
		wclk = 0;
		rclk = 0;

		wrst_n = 0;
		rrst_n = 0;
	        intf.winc = 0;
	        intf.rinc = 0;
		#10;
		wrst_n = 1;
		rrst_n = 1;
		#10;
		wrst_n = 1;
		rrst_n = 1;

		#100;
		wrst_n = 0;
		rrst_n = 0;
		#100;
		wrst_n = 1;
		rrst_n = 1;
/*
		#100;
		wrst_n = 0;
		rrst_n = 0;
		#100;
		wrst_n = 1;
		rrst_n = 1;
*/

	end

	initial begin
		uvm_config_db#(virtual asy_fifo_interface)::set(null, "*", "intf", intf);

		run_test("base_test");
	//	run_test("wr_test");
	//	run_test("rd_test");
	//	run_test("wr_test1");
	//	run_test("rd_test1");
	//	run_test("wr_test2");
	//	run_test("rd_test2");
	//	run_test("continuous_write_then_read");
	//	run_test("random_winc_rinc");
	end

	initial begin
		$dumpfile("wave.vcd");
		$dumpvars();
	end

endmodule

