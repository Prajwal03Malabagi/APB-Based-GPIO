class io_seq extends uvm_sequence#(io_tx);
	`uvm_object_utils(io_seq)
	function new(string name="io_seq");
		super.new(name);
	endfunction
endclass
// for reset seq
class io_rst extends io_seq;
	`uvm_object_utils(io_rst)
	function new(string name="io_rst");
		super.new(name);
	endfunction

	task body();
		repeat(1)begin
		req=io_tx::type_id::create("req");	
	
		start_item(req);
		req.randomize() with{req.io_pad_ctrl==1;};
		finish_item(req);
	//	req.print();
	//	`uvm_info(get_full_name(),"io",UVM_MEDIUM)		
		end
	endtask
endclass
// for gpio_in  poled and interrupt with exclk and system clk
class io_input extends io_seq;
	`uvm_object_utils(io_input)
	function new(string name="io_input");
		super.new(name);
	endfunction
	task body();
		$display("seq ------------------------------------J");
		repeat(1)begin
		req=io_tx::type_id::create("req");	
	
		start_item(req);
		req.randomize() with{req.io_pad_ctrl==1;};
		finish_item(req); 
	//	req.print();
	//	`uvm_info(get_full_name(),"io",UVM_MEDIUM)		
		end
	endtask
endclass
//for both with system clk and ext clk
class io_bi extends io_seq;
	`uvm_object_utils(io_bi)
	function new(string name="io_bi");
		super.new(name);
	endfunction
	task body();
		repeat(3)begin
		req=io_tx::type_id::create("req");	
	
		start_item(req);
		req.randomize() with{req.io_pad_ctrl==0;};
		finish_item(req); 
	//	`uvm_info(get_full_name(),"io",UVM_MEDIUM)
	//	req.print();
		end
	endtask
endclass

