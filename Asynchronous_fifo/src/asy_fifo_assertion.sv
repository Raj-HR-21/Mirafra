program write_assertion(wclk, wrst_n,winc, wfull, wdata);

        input wclk, wrst_n,winc, wfull;
        input [`DSIZE-1 : 0]wdata;

        property p1; // write reset check
                @(posedge wclk) !wrst_n |-> !wfull;
        endproperty
        a1: assert property(p1)
        else $warning("Assertion fail : wrst_n : %b |  wfull : %b ", wrst_n, wfull);

endprogram :write_assertion

program read_assertion(rdata, rempty, rinc, rclk, rrst_n);

        input rclk, rrst_n, rinc, rempty;
        input [`DSIZE-1 : 0] rdata;

        property p2; //read reset check
                @(posedge rclk) (!rrst_n) |-> (rempty );
        endproperty
        a2: assert property(p2)
        else $warning("Assertion fail : rrst_n : %b | rempty : %b | ", rrst_n, rempty);

        property p3; // read inc 0
                @(posedge rclk) disable iff (!rrst_n)
                (!rinc) |-> rdata == $past(rdata,1);
        endproperty
        a3: assert property(p3)
	else $warning("Assertion fail : when rinc = 0, rdata is not latched");

endprogram :read_assertion
