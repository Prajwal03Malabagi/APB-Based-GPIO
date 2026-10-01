class monitor extends uvm_monitor;
	`uvm_component_utils(monitor)
	virtual io_intf.Mon vif;
	io_tx xtn;
	uvm_analysis_port#(io_tx)io_port;
	conf cf;

	function new(string name="monitor",uvm_component parent);
		super.new(name,parent);
		io_port=new("io_port",this);
	endfunction

	function void build_phase(uvm_phase phase);
		if(!uvm_config_db#(conf)::get(this,"","conf",cf))
			`uvm_error("aux_agent","failed to get configuration")
			xtn=io_tx::type_id::create("xtn");
	endfunction

	function void connect_phase(uvm_phase phase);
		vif=cf.io_vif;
	endfunction

	task run_phase(uvm_phase phase);
		forever 
		begin
			mon();
			`uvm_info("io_monitor","io",UVM_MEDIUM)	
			xtn.print();
		end
	endtask

	task mon();
		@(vif.mon)
		xtn.io_pad=vif.mon.io_pad;
		io_port.write(xtn);
		@(vif.mon);
	endtask

endclass

