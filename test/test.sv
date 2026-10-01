class test extends uvm_test;
	`uvm_component_utils(test)
	env e;
	conf cf;

	function new(string name="test",uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		cf=conf::type_id::create("cf");
		
		if(!uvm_config_db#(virtual apb_intf)::get(this,"","apb_intf",cf.apb_vif))
			`uvm_error("test","apb_intf failed")
		if(!uvm_config_db#(virtual aux_intf)::get(this,"","aux_intf",cf.aux_vif))
			`uvm_error("test","aux_intf failed")
		if(!uvm_config_db#(virtual io_intf)::get(this,"","io_intf",cf.io_vif))
			`uvm_error("test","io_intf failed")
		e=env::type_id::create("e",this);

		uvm_config_db#(conf)::set(this,"*","conf",cf);
		
	endfunction

	function void end_of_elaboration_phase(uvm_phase phase);
		uvm_top.print_topology();
	endfunction

endclass

class test_reset extends test;
	`uvm_component_utils(test_reset)
	function new(string name="test",uvm_component parent);
		super.new(name,parent);
	endfunction
	apb_seq_rst apb_sq;
	aux_seq aux_sq;
	io_rst io_sq;
	bit ctrl;

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);	
		apb_sq=apb_seq_rst::type_id::create("apb_sq");
		aux_sq=aux_seq::type_id::create("xux_sq");
		io_sq=io_rst::type_id::create("io_sq");
	//	$display("test build end_-------------------------------------------------");
		uvm_config_db#(bit)::set(this,"*","ctrl",ctrl);
	endfunction


	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		phase.raise_objection(this);
	//	fork
	//	$display("*****************run_test started_--------------__");
	
		for(int i=0;i<cf.no_of_apb;i++)
			apb_sq.start(e.apb_agt[i].sqr);
	///	$display("*****************run_test1 started_--------------__");
		
		for(int j=0;j<cf.no_of_aux;j++)
			aux_sq.start(e.aux_agt[j].sqr);
	//	$display("*****************run_test 2 started_--------------__");
		
		for(int k=0;k<cf.no_of_io;k++)
			io_sq.start(e.io_agt[k].sqr);
		
		#100;
		phase.drop_objection(this);
	endtask
endclass

class test_out extends test;   //io rtl issue
	`uvm_component_utils(test_out)
	function new(string name="test_out",uvm_component parent);
		super.new(name,parent);
	endfunction
	apb_seq_out apb_sq;
	aux_seq aux_sq;
	io_input io_sq;
	bit ctrl;

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);	
		apb_sq=apb_seq_out::type_id::create("apb_sq");
		aux_sq=aux_seq::type_id::create("xux_sq");
		io_sq=io_input::type_id::create("io_sq");
	//	$display("test build end_-------------------------------------------------");
		uvm_config_db#(bit)::set(this,"*","ctrl",ctrl);
	endfunction


	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		phase.raise_objection(this);
	//	$display("*****************run_test started_--------------__");
	fork
		for(int i=0;i<cf.no_of_apb;i++)
			apb_sq.start(e.apb_agt[i].sqr);
	//	$display("*****************run_test1 started_--------------__");
		
		for(int j=0;j<cf.no_of_aux;j++)
			aux_sq.start(e.aux_agt[j].sqr);
	//	$display("*****************run_test 2 started_--------------__");
		
		//for(int k=0;k<cf.no_of_io;k++)
		//	io_sq.start(e.io_agt[k].sqr);
	join
		phase.drop_objection(this);
	endtask
endclass

class test_input_intr extends test; //working
	`uvm_component_utils(test_input_intr)
	function new(string name="test_input_intr",uvm_component parent);
		super.new(name,parent);
	endfunction
	apb_seq_in apb_sq;
	aux_seq aux_sq;
	io_input io_sq;
	bit ctrl;

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);	
		apb_sq=apb_seq_in::type_id::create("apb_sq");
		aux_sq=aux_seq::type_id::create("aux_sq");
		io_sq=io_input::type_id::create("io_sq");
		$display("test build end_-------------------------------------------------");
		uvm_config_db#(bit)::set(this,"*","ctrl",ctrl);
	endfunction


	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		phase.raise_objection(this);
		$display("*****************run_test started_--------------__");
	fork 
		for(int i=0;i<cf.no_of_apb;i++)
			apb_sq.start(e.apb_agt[i].sqr);
		$display("*****************run_test1 started_--------------__");
		
		for(int j=0;j<cf.no_of_aux;j++)
			aux_sq.start(e.aux_agt[j].sqr);
		$display("*****************run_test 2 started_--------------__");
		
		for(int k=0;k<cf.no_of_io;k++)
			io_sq.start(e.io_agt[k].sqr);
	join
		phase.drop_objection(this);
	endtask
endclass

class test_aux extends test;  //io rtl issue
	`uvm_component_utils(test_aux)
	function new(string name="test",uvm_component parent);
		super.new(name,parent);
	endfunction
	apb_seq_aux apb_sq;
	aux_seq aux_sq;
//	io_input io_sq;
	bit ctrl;

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);	
		apb_sq=apb_seq_aux::type_id::create("apb_sq");
		aux_sq=aux_seq::type_id::create("xux_sq");
	//	io_sq=io_input::type_id::create("io_sq");
		$display("test build end_-------------------------------------------------");
		uvm_config_db#(bit)::set(this,"*","ctrl",ctrl);
	endfunction


	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		phase.raise_objection(this);
		fork
		$display("*****************run_test started_--------------__");
	
		for(int i=0;i<cf.no_of_apb;i++)
			apb_sq.start(e.apb_agt[i].sqr);
		$display("*****************run_test1 started_--------------__");
		
		for(int j=0;j<cf.no_of_aux;j++)
			aux_sq.start(e.aux_agt[j].sqr);
		$display("*****************run_test 2 started_--------------__");
		
	//	for(int k=0;k<cf.no_of_io;k++)
	//		io_sq.start(e.io_agt[k].sqr);
		join
		phase.drop_objection(this);
	endtask
endclass



class test_bi extends test; //working
	`uvm_component_utils(test_bi)
	function new(string name="test",uvm_component parent);
		super.new(name,parent);
	endfunction
	apb_seq_bi apb_sq;
	aux_seq aux_sq;
	io_bi io_sq;
	bit ctrl;

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);	
		apb_sq=apb_seq_bi::type_id::create("apb_sq");
		aux_sq=aux_seq::type_id::create("xux_sq");
		io_sq=io_bi::type_id::create("io_sq");
		$display("test build end_-------------------------------------------------");
		uvm_config_db#(bit)::set(this,"*","ctrl",ctrl);
	endfunction


	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		phase.raise_objection(this);
		fork
		$display("*****************run_test started_--------------__");
	
		for(int i=0;i<cf.no_of_apb;i++)
			apb_sq.start(e.apb_agt[i].sqr);
		$display("*****************run_test1 started_--------------__");
		
		for(int j=0;j<cf.no_of_aux;j++)
			aux_sq.start(e.aux_agt[j].sqr);
		$display("*****************run_test 2 started_--------------__");
		
		for(int k=0;k<cf.no_of_io;k++)
			io_sq.start(e.io_agt[k].sqr);
		join
		phase.drop_objection(this);
	endtask
endclass

class test_polled extends test; //working
	`uvm_component_utils(test_polled)
	function new(string name="test",uvm_component parent);
		super.new(name,parent);
	endfunction
	apb_seq_polled apb_sq;
	aux_seq aux_sq;
	io_input io_sq;
	bit ctrl;

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);	
		apb_sq=apb_seq_polled::type_id::create("apb_sq");
		aux_sq=aux_seq::type_id::create("xux_sq");
		io_sq=io_input::type_id::create("io_sq");
		$display("test build end_-------------------------------------------------");
		uvm_config_db#(bit)::set(this,"*","ctrl",ctrl);
	endfunction


	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		phase.raise_objection(this);
		fork
		$display("*****************run_test started_--------------__");
	
		for(int i=0;i<cf.no_of_apb;i++)
			apb_sq.start(e.apb_agt[i].sqr);
		$display("*****************run_test1 started_--------------__");
		
		for(int j=0;j<cf.no_of_aux;j++)
			aux_sq.start(e.aux_agt[j].sqr);
		$display("*****************run_test 2 started_--------------__");
		
		for(int k=0;k<cf.no_of_io;k++)
			io_sq.start(e.io_agt[k].sqr);
		join
		phase.drop_objection(this);
	endtask
endclass



class test_input_ext extends test; //working
	`uvm_component_utils(test_input_ext)
	function new(string name="test",uvm_component parent);
		super.new(name,parent);
	endfunction
	apb_seq_in_ext apb_sq;
	aux_seq aux_sq;
	io_input io_sq;
	bit ctrl;

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);	
		apb_sq=apb_seq_in_ext::type_id::create("apb_sq");
		aux_sq=aux_seq::type_id::create("xux_sq");
		io_sq=io_input::type_id::create("io_sq");
		$display("test build end_-------------------------------------------------");
		uvm_config_db#(bit)::set(this,"*","ctrl",ctrl);
	endfunction


	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		phase.raise_objection(this);
		fork
		$display("*****************run_test started_--------------__");
	
		for(int i=0;i<cf.no_of_apb;i++)
			apb_sq.start(e.apb_agt[i].sqr);
		$display("*****************run_test1 started_--------------__");
		
		for(int j=0;j<cf.no_of_aux;j++)
			aux_sq.start(e.aux_agt[j].sqr);
		$display("*****************run_test 2 started_--------------__");
		
		for(int k=0;k<cf.no_of_io;k++)
			io_sq.start(e.io_agt[k].sqr);
		join
		phase.drop_objection(this);
	endtask
endclass

