class seqra extends uvm_sequencer#(apb_tx);
`uvm_component_utils(seqra)
function new(string name="seqr",uvm_component parent);
	super.new(name,parent);
endfunction
endclass

