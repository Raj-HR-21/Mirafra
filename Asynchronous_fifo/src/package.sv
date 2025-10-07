
`include "uvm_macros.svh"
`include "uvm_pkg.sv"
package asy_fifo_pkg;

	import uvm_pkg::*;
	`include "asy_fifo_seq_item.sv"
	`include "asy_fifo_sequencer.sv"
	`include "asy_fifo_sequence.sv"
	`include "asy_fifo_driver.sv"
	`include "asy_fifo_monitor.sv"
	`include "asy_fifo_agent.sv"
	`include "asy_fifo_func_cvg.sv"
	`include "asy_fifo_scoreboard.sv"
	`include "asy_fifo_environment.sv"
	`include "asy_fifo_test.sv"

endpackage
