class aux_tx extends uvm_sequence_item;
`uvm_object_utils(aux_tx)
function new(string name="aux_tx");
	super.new(name);
endfunction
rand bit [31:0]aux_in;

function void do_print(uvm_printer printer);
	super.do_print(printer);
	printer.print_field("aux_in",aux_in,32,UVM_HEX);
endfunction

endclass
