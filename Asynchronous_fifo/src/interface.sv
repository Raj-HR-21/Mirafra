interface wr_interface(input logic wclk, input logic wrst_n);
	logic winc;
	logic wfull;
//	logic wptr;
	logic [`DSIZE-1 : 0]wdata;

	clocking wr_drv_cb@(posedge wclk);
		default input #0 output #0;
		output winc, wdata;
	endclocking
	clocking wr_mon_cb@(posedge wclk);
		default input #0 output #0;
		input wdata, winc, wfull;
	endclocking

endinterface: wr_interface

interface rd_interface(input logic rclk, rrst_n);
	logic rinc;
	logic rempty;
//	logic rptr;
	logic [`DSIZE-1 : 0]rdata;

	clocking rd_drv_cb@(posedge rclk );
		default input #0 output #0;
		output rinc;
	endclocking
	clocking rd_mon_cb@(posedge rclk);
		default input #0 output #0;
		input rdata, rempty, rinc;
	endclocking

endinterface: rd_interface
