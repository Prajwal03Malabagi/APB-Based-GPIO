class apb_seq extends uvm_sequence#(apb_tx);
	`uvm_object_utils(apb_seq)
	function new(string name="apb_seq");
		super.new(name);
	endfunction
endclass

// reset sequence
class apb_seq_rst extends apb_seq;
	`uvm_object_utils(apb_seq_rst)
	function new(string name="seq_rst");
		super.new(name);
	endfunction

	task body();
		repeat(1)begin
			req=apb_tx::type_id::create("req");	
			start_item(req);
			req.randomize() with{req.preset==1;};
			finish_item(req);
		//	`uvm_info("apb_seq_reset","apb",UVM_MEDIUM)
		//	req.print();
		end
	endtask
endclass

//GPIO as output sequence
class apb_seq_out extends apb_seq;
	`uvm_object_utils(apb_seq_out)
	function new(string name="seq_out");
		super.new(name);
	endfunction

	task body();
		repeat(4)begin
			req=apb_tx::type_id::create("req");
			$display("******************************seq start**************");
			//write into gpio_out 	
			start_item(req);
			req.randomize() with{req.preset==0;req.pwrite==1;req.paddr==32'h04;req.pwdata==32'hf0f0_ff00;};
			finish_item(req);
		
			
			//write into rgpio_oe
			start_item(req);
			req.randomize() with{req.preset==0;req.pwrite==1;req.paddr==32'h08;req.pwdata==32'hffff_ffff;};
			finish_item(req);
	
			//read from rgpio_out
			start_item(req);
			req.randomize() with{req.preset==0;req.pwrite==0;req.paddr==32'h04;};
			finish_item(req);

			//read from rgpio_oe
			start_item(req);
			req.randomize() with{req.preset==0;req.pwrite==0;req.paddr==32'h08;};
			finish_item(req);
		//	$display("*************************before end*****");
		//	`uvm_info("apb_seq_out","apb",UVM_MEDIUM)
		//	req.print();
	//		$display("**********************end*******************");
		end
	endtask
endclass

//gpio as input sequence with interupt mode - with pclk or system clk
class apb_seq_in extends apb_seq;
	`uvm_object_utils(apb_seq_in)
	function new(string name="seq_in");
		super.new(name);
	endfunction

	task body();
		repeat(4)begin
			req=apb_tx::type_id::create("req");
			//write into gpio_ptrig
			start_item(req);
			req.randomize() with{req.preset==0;req.pwrite==1;req.paddr==32'h10;req.pwdata==32'h0;};//all the 32 pins must be cleared to enable input mode
			finish_item(req);
		
			//write from rgpio_ctrl
			start_item(req);
			req.randomize() with{req.preset==0;req.pwrite==1;req.paddr==32'h18;req.pwdata==32'h00000001;};
			finish_item(req);

			//write into rgpio_inte
			start_item(req);
			req.randomize() with{req.preset==0;req.pwrite==1;req.paddr==32'h0c;req.pwdata==32'hffffffff;};//interrupt generation are enabled
			finish_item(req);
	
			// read from rgpio_in
			start_item(req);
			req.randomize() with{req.preset==0;req.pwrite==0;req.paddr==2'b0;};
			finish_item(req);
	
			//read from rgpio_ptrig
			start_item(req);
			req.randomize() with{req.preset==0;req.pwrite==0;req.paddr==32'h10;};
			finish_item(req);

			//read from rgpio_ctrl
			start_item(req);
			req.randomize() with{req.preset==0;req.pwrite==0;req.paddr==32'h18;};
			finish_item(req);
			
			//read from rgpio_inte
			start_item(req);
			req.randomize() with{req.preset==0;req.pwrite==0;req.paddr==32'h0c;};
			finish_item(req);

			`uvm_info("apb_seq_in","apb",UVM_MEDIUM)
			req.print();
		end
	endtask
endclass

//gpio bi-directional

class apb_seq_bi extends apb_seq;
	`uvm_object_utils(apb_seq_bi)
	function new(string name="seq_bi");
		super.new(name);
	endfunction

	task body();
		repeat(3)begin
			req=apb_tx::type_id::create("req");
			//write into gpio_out	
			start_item(req);
			req.randomize() with{req.preset==0;req.pwrite==1;req.paddr==32'h04;};//all the 32 pins must be cleared to enable input mode
			finish_item(req);
		
			//write from rgpio_oe
			start_item(req);
			req.randomize() with{req.preset==0;req.pwrite==1;req.paddr==32'h08;req.pwdata==32'hf0f0f0f0;};
			finish_item(req);

			//read form rgpio_in
			start_item(req);
			req.randomize() with{req.preset==0;req.pwrite==0;req.paddr==32'h00;};//interrupt are masked
			finish_item(req);
	
			//read from rgpio_oe
			start_item(req);
			req.randomize() with{req.preset==0;req.pwrite==0;req.paddr==32'h08;};
			finish_item(req);

			//read from gpio_out	
			start_item(req);
			req.randomize() with{req.preset==0;req.pwrite==0;req.paddr==32'h04;};//all the 32 pins must be cleared to enable input mode
			finish_item(req);

		//	`uvm_info("apb_seq_bi","apb",UVM_MEDIUM)
		//	req.print();
		end
	endtask
endclass

//GPIO as aux_in sequence
class apb_seq_aux extends apb_seq;
	`uvm_object_utils(apb_seq_aux)
	function new(string name="seq_aux");
		super.new(name);
	endfunction

	task body();
		repeat(3)begin
			req=apb_tx::type_id::create("req");

			//write into rgpio_oe
			start_item(req);
			req.randomize() with{req.preset==0;req.pwrite==1;req.paddr==32'h08;req.pwdata==32'hffff_ffff;};
			finish_item(req);

			//write into gpio_aux 	
			start_item(req);
			req.randomize() with{req.preset==0;req.pwrite==1;req.paddr==32'h14;req.pwdata==32'hffff_ffff;};
			finish_item(req);
		
			//read from rgpio_in
			start_item(req);
			req.randomize() with{req.preset==0;req.pwrite==0;req.paddr==32'h00;};
			finish_item(req);

			
			//read from rgpio_aux
			start_item(req);
			req.randomize() with{req.preset==0;req.pwrite==0;req.paddr==32'h14;};
			finish_item(req);

			//read from rgpio_out
			start_item(req);
			req.randomize() with{req.preset==0;req.pwrite==0;req.paddr==32'h04;};//in aux_in is 1 we bypass the rgpio_out so we won't get any data
			finish_item(req);

		//	`uvm_info("apb_seq_aux","apb",UVM_MEDIUM)
		//	req.print();
		end
	endtask
endclass

//GPIO as input polled with interupt mode
class apb_seq_polled extends apb_seq;
	`uvm_object_utils(apb_seq_polled)
	function new(string name="seq_out");
		super.new(name);
	endfunction

	task body();
		repeat(3)begin
			req=apb_tx::type_id::create("req");
			
			//write into rgpio_oe
			start_item(req);
			req.randomize() with{req.preset==0;req.pwrite==1;req.paddr==32'h08;req.pwdata==32'h0;};
			finish_item(req);
		
			//write into gpio_ctrl 
			start_item(req);
			req.randomize() with{req.preset==0;req.pwrite==1;req.paddr==32'h18;req.pwdata==32'h0;};
			finish_item(req);
		
			//write from rgpio_inte
			start_item(req);
			req.randomize() with{req.preset==0;req.pwrite==1;req.paddr==32'h0c;req.pwdata==32'h0;};
			finish_item(req);

	
			//write from rgpio_nec
			start_item(req);
			req.randomize() with{req.preset==0;req.pwrite==1;req.paddr==32'h24;req.pwdata==32'h0000ff0f;}; //does not have any impact as no inte is enabled
			finish_item(req);

			//write into gpio_eclk	
			start_item(req);
			req.randomize() with{req.preset==0;req.pwrite==1;req.paddr==32'h20;req.pwdata==32'h0000_ffff;};
			finish_item(req);
		
			//read from rgpio_in
			start_item(req);
			req.randomize() with{req.preset==0;req.pwrite==0;req.paddr==32'h00;};
			finish_item(req);

		//	`uvm_info("apb_seq_polled","apb",UVM_MEDIUM)
		//	req.print();
		end
	endtask
endclass

class apb_seq_in_ext extends apb_seq;
	`uvm_object_utils(apb_seq_in_ext)
	function new(string name="seq_in_ext");
		super.new(name);
	endfunction

	task body();
		repeat(4)begin
			req=apb_tx::type_id::create("req");
			//write into gpio_ptrig
			start_item(req);
			req.randomize() with{req.preset==0;req.pwrite==1;req.paddr==32'h10;req.pwdata==32'h0;};//all the 32 pins must be cleared to enable input mode
			finish_item(req);
		
			//write from rgpio_ctrl
			start_item(req);
			req.randomize() with{req.preset==0;req.pwrite==1;req.paddr==32'h18;req.pwdata==32'h00000001;};
			finish_item(req);

			//write into rgpio_inte
			start_item(req);
			req.randomize() with{req.preset==0;req.pwrite==1;req.paddr==32'h0c;req.pwdata==32'hffffffff;};//interrupt generation are enabled
			finish_item(req);
	
			// read from rgpio_in
			start_item(req);
			req.randomize() with{req.preset==0;req.pwrite==0;req.paddr==2'b0;};
			finish_item(req);
	
			//read from rgpio_ptrig
			start_item(req);
			req.randomize() with{req.preset==0;req.pwrite==0;req.paddr==32'h10;};
			finish_item(req);

			//write from rgpio_nec
			start_item(req);
			req.randomize() with{req.preset==0;req.pwrite==1;req.paddr==32'h24;req.pwdata==32'h0000ff0f;}; //does not have any impact as no inte is enabled
			finish_item(req);

			//write into gpio_eclk	
			start_item(req);
			req.randomize() with{req.preset==0;req.pwrite==1;req.paddr==32'h20;req.pwdata==32'h0000_ffff;};
			finish_item(req);

			//read from rgpio_ctrl
			start_item(req);
			req.randomize() with{req.preset==0;req.pwrite==0;req.paddr==32'h18;};
			finish_item(req);
			
			//read from rgpio_inte
			start_item(req);
			req.randomize() with{req.preset==0;req.pwrite==0;req.paddr==32'h0c;};
			finish_item(req);

			`uvm_info("apb_seq_in","apb",UVM_MEDIUM)
			req.print();
		end
	endtask
endclass

