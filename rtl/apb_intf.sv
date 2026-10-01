interface apb_intf(input logic clk);
	bit pclk;
	bit preset;
	bit [31:0]paddr;
	bit pwrite;
	bit [31:0]pwdata;
	bit psel;
	bit penable;
	bit [31:0]prdata;
	bit pready;
	bit irq;

	assign pclk=clk;
	
	clocking drv@(posedge pclk);
		default input #1 output #1;
		output preset,pwrite,psel,penable;
		output paddr;
		output pwdata;
		input pready,irq;
		input prdata;
	endclocking
	
	clocking mon@(posedge pclk);
		default input #1 output #1;
		input preset,pwrite,psel,penable,pready,irq;
		input paddr;
		input pwdata;
		input prdata;
	endclocking

	modport Drv(clocking drv);
	modport Mon(clocking mon);
endinterface
