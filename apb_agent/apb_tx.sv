class apb_tx extends uvm_sequence_item;
	`uvm_object_utils(apb_tx)
	bit pclk;
	rand bit preset;
	rand bit [31:0]paddr;
	rand bit pwrite;
	rand bit [31:0]pwdata;
	bit psel;
	bit penable;
	bit [31:0]prdata;
	bit pready;
	bit irq;

	bit [31:0] rgpio_in;
	bit [31:0] rgpio_out;
	bit [31:0] rgpio_oe;
	bit [31:0] rgpio_ptrig;
	bit [31:0] rgpio_aux;
	bit [31:0] rgpio_nec;
	bit [31:0] rgpio_eclk;
	bit [31:0] rgpio_ints;
	bit [31:0] rgpio_inte;
	bit rgpio_ctrl_inte;
	bit rgpio_ctrl_ints;	

	function new(string name="apb_tx");
		super.new(name);
	endfunction

	function void do_print(uvm_printer printer);
		super.do_print(printer);
		printer.print_field("presetn",preset, 1, UVM_DEC);
		printer.print_field("psel",psel, 1, UVM_DEC);
		printer.print_field("penable",penable, 1, UVM_DEC);
		printer.print_field("paddr", paddr, 32, UVM_HEX);
		printer.print_field("pwdata",pwdata, 32, UVM_HEX);
		printer.print_field("pwrite",pwrite, 1, UVM_DEC);
		printer.print_field("prdata",prdata, 32, UVM_DEC);
		printer.print_field("pready",pready, 1, UVM_DEC);
		printer.print_field("irq",irq, 1, UVM_DEC);



		printer.print_field("rgpio_in", this.rgpio_in, 32, UVM_HEX);
		printer.print_field("rgpio_out", this.rgpio_out, 32, UVM_HEX);
		printer.print_field("rgpio_oe", this.rgpio_oe, 32, UVM_HEX);
		printer.print_field("rgpio_ptrig", this.rgpio_ptrig, 32, UVM_HEX);
		printer.print_field("rgpio_aux", this.rgpio_aux, 32, UVM_HEX);
		printer.print_field("rgpio_nec", this.rgpio_nec, 32, UVM_HEX);
		printer.print_field("rgpio_eclk", this.rgpio_eclk, 32, UVM_HEX);
		printer.print_field("rgpio_ints", this.rgpio_ints, 32, UVM_HEX);
		printer.print_field("rgpio_inte", this.rgpio_inte, 32, UVM_HEX);
		printer.print_field("rgpio_ctrl_inte", this.rgpio_ctrl_inte, 1, UVM_DEC);
		printer.print_field("rgpio_ctrl_ints", this.rgpio_ctrl_ints, 1, UVM_DEC);

	endfunction
endclass
