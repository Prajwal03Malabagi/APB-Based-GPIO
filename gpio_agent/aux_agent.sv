class aux_agent extends uvm_agent;
	driverx drv;
	monitorx mon;
	seqrx sqr;
	conf cf;
	`uvm_component_utils(aux_agent)
	function new(string name="aux_agent",uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		if(!uvm_config_db#(conf)::get(this,"","conf",cf))
			`uvm_error("apb_agent","failed")
		if(cf.is_active)
		begin
			drv=driverx::type_id::create("drv",this);
			sqr=seqrx::type_id::create("sqr",this);
		end
		mon=monitorx::type_id::create("mon",this);
	endfunction

	function void connect_phase(uvm_phase phase);
		drv.seq_item_port.connect(sqr.seq_item_export);
	endfunction
endclass
