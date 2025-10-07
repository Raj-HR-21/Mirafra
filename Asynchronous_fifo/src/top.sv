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
	wr_interface wintf(wclk, wrst_n);
	rd_interface rintf(rclk, rrst_n);

	fifo #(.DSIZE(`DSIZE), .ASIZE(`ASIZE))
	dut(.wclk(wclk), .wrst_n(wrst_n), .wdata(wintf.wdata), .wfull(wintf.wfull), .winc(wintf.winc),.rclk(rclk), .rrst_n(rrst_n), .rdata(rintf.rdata), .rinc(rintf.rinc), .rempty(rintf.rempty));

	bind wintf write_assertion wa(.wclk(wclk), .wrst_n(wrst_n), .winc(winc), .wfull(wfull), .wdata(wdata));
	bind rintf read_assertion ra(.rclk(rclk), .rrst_n(rrst_n), .rinc(rinc), .rempty(rempty), .rdata(rdata));

	always #5 wclk = ~wclk;
	always #10 rclk = ~rclk;
	initial begin
		wclk = 0;
		rclk = 0;
		wrst_n = 0;
		rrst_n = 0;
		#10;
		wrst_n = 1;
		rrst_n = 1;

		#100;
		wrst_n = 0;
		rrst_n = 0;
		#100;
		wrst_n = 1;
		rrst_n = 1;


	end

	initial begin
		uvm_config_db#(virtual wr_interface)::set(null, "*", "wintf", wintf);
		uvm_config_db#(virtual rd_interface)::set(null, "*", "rintf", rintf);
		run_test("base_test");
	end

	initial begin
		$dumpfile("wave.vcd");
		$dumpvars();
	end

endmodule

