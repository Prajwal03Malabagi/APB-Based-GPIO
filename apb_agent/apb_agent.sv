class apb_agent extends uvm_agent;
	drivera drv;
	monitora mon;
	seqra sqr;
	conf cf;
	`uvm_component_utils(apb_agent)
	function new(string name="apb_agent",uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		if(!uvm_config_db#(conf)::get(this,"","conf",cf))
			`uvm_error("apb_agent","failed")
		if(cf.is_active==UVM_ACTIVE)begin
		drv=drivera::type_id::create("drv",this);
		sqr=seqra::type_id::create("sqr",this);end
		mon=monitora::type_id::create("mon",this);
	$display("******************apb_agent build completed");
		
	endfunction

	function void connect_phase(uvm_phase phase);
		drv.seq_item_port.connect(sqr.seq_item_export);
	$display("******************apb_agent connect completed");
			
	endfunction
endclass

