class env extends uvm_env;
`uvm_component_utils(env)
apb_agent apb_agt[];
aux_agent aux_agt[];
io_agent  io_agt[];
scb sb;
conf cf;
function new(string name="env",uvm_component parent);
	super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
	if(!uvm_config_db#(conf)::get(this,"","conf",cf))
		`uvm_error("in env class","failed to get conf")
	apb_agt=new[cf.no_of_apb];
	aux_agt=new[cf.no_of_aux];
	io_agt=new[cf.no_of_io];
	foreach(apb_agt[i])
		apb_agt[i]=apb_agent::type_id::create($sformatf("apb_agt[%0d]",i),this);
	foreach(aux_agt[i])
		aux_agt[i]=aux_agent::type_id::create($sformatf("aux_agt[%0d]",i),this);
	foreach(io_agt[i])
		io_agt[i]=io_agent::type_id::create($sformatf("io_agt[%0d]",i),this);
	sb=scb::type_id::create("sb",this);
	$display("******************env build completed");
endfunction
	
	function void connect_phase(uvm_phase phase);
		foreach(apb_agt[i])
			apb_agt[i].mon.apb_port.connect(sb.fifo_apb[i].analysis_export);
		foreach(aux_agt[i])
			aux_agt[i].mon.aux_port.connect(sb.fifo_aux[i].analysis_export);
		foreach(io_agt[i])
			io_agt[i].mon.io_port.connect(sb.fifo_io[i].analysis_export);
	endfunction
endclass
