class driverx extends uvm_driver#(aux_tx);
	`uvm_component_utils(driverx)
	virtual aux_intf.Drv vif;
	conf cf;
	function new(string name="driver",uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		if(!uvm_config_db#(conf)::get(this,"","conf",cf))
			`uvm_error("apb_agent","failed")
	endfunction

	function void connect_phase(uvm_phase phase);
		vif=cf.aux_vif;
	endfunction

	task run_phase(uvm_phase phase);
		forever begin
	//	$display("*****************aux driver started_--------------__");
			
			seq_item_port.get_next_item(req);
			drive();	
			seq_item_port.item_done();
	//		`uvm_info(get_full_name(),"aux",UVM_MEDIUM)		
	//		req.print();
	//		$display("hi-------------");
	//	$display("*****************aux driver ended_--------------__");
		
		end
	endtask
	task drive();
		@(vif.drv);
		vif.drv.aux_in<=req.aux_in;
	endtask
endclass
                                                                                                                                                                           
