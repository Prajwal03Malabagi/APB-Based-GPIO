class driver extends uvm_driver#(io_tx);
	`uvm_component_utils(driver)
	virtual io_intf.Drv vif;
	conf cf;
	
	function new(string name="driver",uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		if(!uvm_config_db#(conf)::get(this,"","conf",cf))
			`uvm_error("apb_agent","failed")
	endfunction

	function void connect_phase(uvm_phase phase);
		vif=cf.io_vif;
	endfunction
	
	task run_phase(uvm_phase phase);
		forever begin
	//	$display("*****************io driver started_--------------__");
			
			seq_item_port.get_next_item(req);
			driv();
			seq_item_port.item_done();
	//		`uvm_info(get_full_name(),"io",UVM_MEDIUM)			
	//		req.print();
		end
	endtask
	
	task driv();
		@(vif.drv)
		vif.drv.io_pad<=req.io_pad;
	endtask
endclass

