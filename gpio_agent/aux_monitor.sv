class monitorx extends uvm_monitor;
	`uvm_component_utils(monitorx)
	conf cf;
	virtual aux_intf.Mon vif;
	bit ctrl;
	aux_tx xtn;
	uvm_analysis_port#(aux_tx)aux_port;

	function new(string name="monitor",uvm_component parent);
		super.new(name,parent);
		aux_port=new("aux_port",this);
	endfunction
	
	function void build_phase(uvm_phase phase);
		if(!uvm_config_db#(conf)::get(this,"","conf",cf))
			`uvm_error("aux_agent","failed to get configuration")
		if(!uvm_config_db#(bit)::get(this,"","ctrl",ctrl))
			`uvm_error("aux_agent","failed to get ctrl")
	endfunction

	function void connect_phase(uvm_phase phase);
		vif=cf.aux_vif;
	endfunction

	task run_phase(uvm_phase phase);
		forever begin
			xtn=aux_tx::type_id::create("xtn");
			if(ctrl==0)
				monitor();	
			else
				@(vif.mon);
			`uvm_info(get_full_name(),"aux",UVM_MEDIUM)		
			xtn.print();	
		end
	endtask

	task monitor();
		@(vif.mon)
		xtn.aux_in=vif.mon.aux_in;
		aux_port.write(xtn);
		@(vif.mon);
	endtask
endclass

