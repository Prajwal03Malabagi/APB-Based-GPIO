class conf extends uvm_object;
	`uvm_object_utils(conf)


	function new(string name="config");
		super.new(name);
	endfunction

	virtual apb_intf apb_vif;
	virtual aux_intf aux_vif;
	virtual io_intf io_vif;
	int no_of_apb=1;
	int no_of_aux=1;
	int no_of_io=1;
	uvm_active_passive_enum is_active=UVM_ACTIVE;
endclass

