FILE ?= top.sv
TOP ?= top
COV_LOG_FILE ?= log_file.log
COV_UCDB ?= coverage.ucdb
COV_REPORT_DIR ?= covReport

compile:
	#@vlog -sv $(FILE)
	@vlog -sv +acc +cover +fcover -l $(COV_LOG_FILE) $(FILE)
run:
	@vsim -c work.$(TOP) -do "run -all; exit;"

simulate:
	@vlog -sv $(FILE)
	@vsim -c work.$(TOP) -do "run -all; exit;"

uvm_compile:
	@vlog +define+UVM_NO_DPI top.sv "+incdir+/tools/mentor/questasim_10.6c/questasim/uvm-1.1d/../verilog_src/uvm-1.1d/src"

uvm_run:
	@vlog +define+UVM_NO_DPI top.sv "+incdir+/tools/mentor/questasim_10.6c/questasim/uvm-1.1d/../verilog_src/uvm-1.1d/src"
	@vsim -c +UVM_NO_DPI top -do "run -all; exit;"

wave:
	@vlog +define+UVM_NO_DPI top.sv "+incdir+/tools/mentor/questasim_10.6c/questasim/uvm-1.1d/../verilog_src/uvm-1.1d/src"
	@vsim -novopt -suppress 12110 $(TOP)

coverage:
	@vlog -sv +acc +cover +fcover -l $(COV_LOG_FILE) $(FILE) +define+UVM_NO_DPI "+incdir+/tools/mentor/questasim_10.6c/questasim/uvm-1.1d/../verilog_src/uvm-1.1d/src"
	@vsim -vopt work.$(TOP) -voptargs=+acc=npr -assertdebug -l simulation.log -coverage -c -do "coverage save -onexit -assert -directive -cvg -codeAll $(COV_UCDB); run -all; exit"
	@vcover report -html $(COV_UCDB) -htmldir $(COV_REPORT_DIR) -details

clean:
	@rm -rf transcript vsim.wlf work *.log $(COV_LOG_FILE) $(COV_UCDB) $(COV_REPORT_DIR) wave.vcd vsim.wlf
