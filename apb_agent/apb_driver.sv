class drivera extends uvm_driver#(apb_tx);
`uvm_component_utils(drivera)
virtual apb_intf.Drv vif;
conf cf;
function new(string name="driver",uvm_component parent);
	super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
	if(!uvm_config_db#(conf)::get(this,"","conf",cf))
		`uvm_error("apb_agent","failed")
endfunction

function void connect_phase(uvm_phase phase);
	vif=cf.apb_vif;
endfunction

task run_phase(uvm_phase phase);
	reset();
	forever begin
		seq_item_port.get_next_item(req);
		drive();
		seq_item_port.item_done();
	//	`uvm_info("apb_driver","apb",UVM_MEDIUM)		
	//	req.print();	
	end
endtask

task reset();
		$display("*****************apb driver ended_--------------__");
	@(vif.drv);
	vif.drv.preset<=1'b1;
	@(vif.drv);
	vif.drv.preset<=1'b0;
endtask

task drive();
//	$display(" apb drive started");
	@(vif.drv);
	vif.drv.preset<=req.preset;
	vif.drv.paddr<=req.paddr;
	vif.drv.pwrite<=req.pwrite;
	vif.drv.psel<=1;
	vif.drv.penable<=0;
//	$display("apb setup completed");
	if(req.pwrite)
	vif.drv.pwdata<=req.pwdata;
//	$display("after apb pwdata");
	@(vif.drv);
	vif.drv.penable<=1;
	req.pready<=vif.drv.pready;
//	$display("start of enable phase");
	wait(vif.drv.pready)
		if(!req.pwrite)
			req.prdata<=vif.drv.prdata;
	@(vif.drv);	
		
		vif.drv.psel<=0;
		vif.drv.penable<=0;
//	$display("apb driv ended");
	@(vif.drv);	
endtask

endclass

