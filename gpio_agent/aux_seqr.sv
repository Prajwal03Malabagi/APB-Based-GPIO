class seqrx extends uvm_sequencer#(aux_tx);
`uvm_component_utils(seqrx)
function new(string name="seqr",uvm_component parent);
	super.new(name,parent);
endfunction
endclass
