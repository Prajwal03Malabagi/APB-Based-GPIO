class io_tx extends uvm_sequence_item;
	`uvm_object_utils(io_tx)

	function new(string name="io_tx");
		super.new(name);
	endfunction

	rand bit [31:0]io_pad;
	rand bit io_pad_ctrl;//if 1 io_pad = io_pad if 0 io_pad=Z (used to control bi-direction)

	function void do_print(uvm_printer printer);
		super.do_print(printer);
		printer.print_field("io_pad",io_pad,32,UVM_HEX);
		printer.print_field("ext_clk_pad_i",io_pad_ctrl,1,UVM_BIN);
	endfunction

	function void post_randomize();
		io_pad[31:28]=io_pad_ctrl?io_pad[31:28]:4'hz;
		io_pad[23:20]=io_pad_ctrl?io_pad[23:20]:4'hz;
		io_pad[15:12]=io_pad_ctrl?io_pad[15:12]:4'hz;
		io_pad[7:4]=io_pad_ctrl?io_pad[7:4]:4'hz;
	endfunction
endclass
