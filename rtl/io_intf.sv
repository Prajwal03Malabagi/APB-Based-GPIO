interface io_intf(input bit ext_clk_pad);
wire [31:0]io_pad;
clocking drv@(posedge ext_clk_pad);
	default input #1 output #1;
	inout io_pad;
endclocking

clocking mon@(posedge ext_clk_pad);
	default input #1 output #1;
	inout io_pad;
endclocking

modport Drv(clocking drv);
modport Mon(clocking mon);
endinterface
