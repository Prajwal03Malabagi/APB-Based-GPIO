class aux_seq extends uvm_sequence#(aux_tx);
	`uvm_object_utils(aux_seq)
	function new(string name="aux_seq");
		super.new(name);
	endfunction

	task body();
		req=aux_tx::type_id::create("req");
		repeat(1) begin 
			start_item(req);
			req.randomize();
			finish_item(req);
		end
	endtask
endclass


