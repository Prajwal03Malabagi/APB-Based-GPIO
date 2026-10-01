class monitora extends uvm_monitor;
	`uvm_component_utils(monitora)
	conf cf;
	apb_tx xtn;
	uvm_analysis_port#(apb_tx)apb_port;
	virtual apb_intf.Mon vif;
	function new(string name="monitor",uvm_component parent);
		super.new(name,parent);
		apb_port=new("apb_port",this);
	endfunction
	function void build_phase(uvm_phase phase);
		if(!uvm_config_db#(conf)::get(this,"","conf",cf))
			`uvm_error("apb_agent","failed")
	endfunction

	function void connect_phase(uvm_phase phase);
		vif=cf.apb_vif;
	endfunction

	task run_phase(uvm_phase phase);
		forever begin
			xtn=apb_tx::type_id::create("xtn");	
		//	$display("8999**********************HII pready=%0d",vif.mon.pready);
			
			monitor();
		//	$display("8***********************HII");
			`uvm_info("apb_monitor","apb",UVM_MEDIUM)					
			xtn.print();
		end
	endtask
	
	task monitor();
		@(vif.mon)
@(vif.mon);
		xtn.irq=vif.mon.irq;
		xtn.preset=vif.mon.preset;
	
		wait(vif.mon.penable && vif.mon.pready);
		xtn.penable=vif.mon.penable;
		xtn.psel=vif.mon.psel;
		xtn.pready=vif.mon.pready;
		xtn.pwrite=vif.mon.pwrite;
		
		if(xtn.pready)
		begin
			if(xtn.pwrite)
			begin
				xtn.paddr=vif.mon.paddr;
				xtn.pwdata=vif.mon.pwdata;
			end
			else  // !pwrite
			begin
				xtn.paddr=vif.mon.paddr;
				xtn.prdata=vif.mon.prdata;
		
				//rgpio_in register
				if(xtn.paddr==32'h0)
					xtn.rgpio_in=vif.mon.prdata;
				//rgpio_out register
				if(xtn.paddr==32'h04)
					xtn.rgpio_out=vif.mon.prdata;
				//rpio_oe register
				if(xtn.paddr==32'h08)
					xtn.rgpio_oe=vif.mon.prdata;
				//rgpio_inte register
				if(xtn.paddr==32'h0c)
					xtn.rgpio_inte=vif.mon.prdata;
				//rgpio_ptrig register
				if(xtn.paddr==32'h10)
					xtn.rgpio_ptrig=vif.mon.prdata;
				//rgpio_aux register
				if(xtn.paddr==32'h14)
					xtn.rgpio_aux=vif.mon.prdata;
				//rpio_ctrl register
				if(xtn.paddr==32'h18)	begin
					xtn.rgpio_ctrl_inte=vif.mon.prdata[0];
					xtn.rgpio_ctrl_ints=vif.mon.prdata[1];
					end
				//rgpio_ints register
				if(xtn.paddr==32'h1c)
					xtn.rgpio_ints=vif.mon.prdata;
				//rgpio_eclk register
				if(xtn.paddr==32'h20)
					xtn.rgpio_eclk=vif.mon.prdata;
				//rgpio_nec register
				if(xtn.paddr==32'h24)
					xtn.rgpio_nec=vif.mon.prdata;
			end
		end
		apb_port.write(xtn);
		@(vif.mon);
	endtask
endclass

