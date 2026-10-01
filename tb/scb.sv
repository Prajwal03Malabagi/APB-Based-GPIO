class scb extends uvm_scoreboard;
	`uvm_component_utils(scb)
	
	uvm_tlm_analysis_fifo #(apb_tx) fifo_apb[];
	uvm_tlm_analysis_fifo #(aux_tx) fifo_aux[];
	uvm_tlm_analysis_fifo #(io_tx) fifo_io[];
	apb_tx apb_xtn,apb_cov;
	aux_tx aux_xtn,aux_cov;
	io_tx io_xtn,io_cov;
	conf cf;

	reg [31:0]	mux,ext_in;     // to store external inputs ext_in and mux_inputs mux_in;
	reg [31:0] 	ints;		// To strore in the interrupt status inputs


	covergroup cg;
		option.per_instance=1;
	
		//apb cover points
		Preset: coverpoint apb_cov.preset {bins reset={0,1};}
		Psel: coverpoint apb_cov.psel {bins Psel[]={0,1};}
		Penable: coverpoint apb_cov.penable{bins Penable[]={0,1};}
		Pwrite: coverpoint apb_cov.pwrite{bins Pwrite[]={0,1};}
		Pready: coverpoint apb_cov.pready{bins Pready[]={0,1};}
		Paddr: coverpoint apb_cov.paddr{bins Paddr={[32'h0000_0000:32'hffff_ffff]};}
		Pwdata: coverpoint apb_cov.pwdata{bins Pwdata0={[32'h0000_0000:32'h8888_8887]};
						// bins Pwdata1={[32'h4444_4444:32'h]};
						bins Pwdata2={[32'h8888_8888:32'hcccc_cccb]};
						bins pwdata3={[32'hcccc_cccc:32'hffff_ffff]};}
		Prdata: coverpoint apb_cov.prdata{bins Prdata0={[32'h0000_0000:32'h8888_8887]};
					//	 bins Prdata1={[32'h4444_4444:32']};
						bins Prdata2={[32'h8888_8888:32'hcccc_cccb]};
						bins prdata3={[32'hcccc_cccc:32'hffff_ffff]};}
	RGPIO_IN	: coverpoint apb_cov.rgpio_in   {bins RGPIO_IN ={[32'h 0000_0000 : 32'h ffff_ffff]};}
	RGPIO_OE	: coverpoint apb_cov.rgpio_oe   {bins RGPIO_IN ={[32'h 0000_0000 : 32'h ffff_ffff]};}
	RGPIO_INTS	: coverpoint apb_cov.rgpio_ints {bins RGPIO_IN ={[32'h 0000_0000 : 32'h ffff_ffff]};}
	RGPIO_INTE	: coverpoint apb_cov.rgpio_inte {bins RGPIO_IN ={[32'h 0000_0000 : 32'h ffff_ffff]};}
	RGPIO_OUT	: coverpoint apb_cov.rgpio_out  {bins RGPIO_IN ={[32'h 0000_0000 : 32'h ffff_ffff]};}
	RGPIO_PTRIG	: coverpoint apb_cov.rgpio_ptrig{bins RGPIO_IN ={[32'h 0000_0000 : 32'h ffff_ffff]};}
	RGPIO_ECLK	: coverpoint apb_cov.rgpio_eclk {bins RGPIO_IN ={[32'h 0000_0000 : 32'h ffff_ffff]};}
	RGPIO_NEC	: coverpoint apb_cov.rgpio_nec  {bins RGPIO_IN ={[32'h 0000_0000 : 32'h ffff_ffff]};}

//=======================================================================================================================
//		AUX COVERAGE
//=======================================================================================================================


	AUX_IN	: coverpoint aux_cov.aux_in {bins AUX_IN0 = {[32'h 0000_0000:32'h 4444_4443]};
						  bins AUX_IN1 = {[32'h 4444_4444:32'h 8888_8887]};
						  bins AUX_IN2 = {[32'h 8888_8888:32'h cccc_cccc-1]};
						  bins AUX_IN3 = {[32'h cccc_cccc:32'h ffffffff]};}
	IO_PAD  : coverpoint io_cov.io_pad  {bins IO_PAD0  = {[32'h 0000_0000:32'h 4444_4443]};
						  bins IO_PAD1  = {[32'h 4444_4444:32'h 8888_8887]};
						  bins IO_PAD2  = {[32'h 8888_8888:32'h cccc_cccc-1]};
						  bins IO_PAD3  = {[32'h cccc_cccc:32'h ffffffff]};}
//============================
//	CROSS
//===========================

	PSEL_PENABLE_PREADY : cross  Psel,Penable,Pready;

  endgroup


	function new(string name="scoreboard",uvm_component parent);
		super.new(name,parent);
	//	c=new("c",this);
		cg=new();
	endfunction
	
	function void build_phase(uvm_phase phase);
		if(!uvm_config_db#(conf)::get(this,"","conf",cf))
			`uvm_error("scoreboard","failed to get cf")

		apb_xtn=apb_tx::type_id::create("apb_xtn");
		aux_xtn=aux_tx::type_id::create("aux_xtn");
		io_xtn=io_tx::type_id::create("io_tx");
	
		apb_cov=apb_tx::type_id::create("apb_cov");
		aux_cov=aux_tx::type_id::create("aux_cov");
		io_cov=io_tx::type_id::create("io_cov");

		fifo_apb = new[cf.no_of_apb];
		fifo_aux = new[cf.no_of_aux];
		fifo_io	 = new[cf.no_of_io];
	
	//	apb_cov = new();
	//	aux_cov = new();
	//	io_cov  = new();
	
	foreach(fifo_apb[i])
		fifo_apb[i] = new($sformatf("fifo_apb[%0d]",i),this);

	foreach(fifo_aux[i])
		fifo_aux[i] = new($sformatf("fifo_aux[%0d]",i),this);
	foreach(fifo_io[i])
		fifo_io[i] =new($sformatf("fifo_io[%0d]",i),this);
	//	`uvm_info(get_type_name(),"fifo_io",UVM_LOW)
  endfunction	


  task run_phase(uvm_phase phase);
	super.run_phase(phase);
	
	fork
	
	  begin
	    forever
	      begin
		fifo_apb[0].get(apb_xtn);
		apb_cov = new apb_xtn;
		`uvm_info("scoreboard","apb_xtn",UVM_MEDIUM)		
		apb_xtn.print();
		cg.sample();
		ref_model();
		compare_data(io_xtn);
		$display("****************SCB******************");
	      end
	  end

	  begin
	    forever
	      begin
		fifo_io[0].get(io_xtn);
		io_cov = new io_xtn;
		`uvm_info("scoreboard","io_xtn",UVM_MEDIUM)
		io_xtn.print();
		cg.sample();
	      end
	  end

	  begin
	    forever
	      begin
		fifo_aux[0].get(aux_xtn);
		aux_cov = new aux_xtn;
		`uvm_info("scoreboard","aux_xtn",UVM_MEDIUM)		
		aux_xtn.print();
		cg.sample();
		compare_aux_data(aux_xtn);
	      end
	  end
	
	join
  endtask


  task compare_data(io_tx io_xtn);
	$display("**********************************HI***************");
	if(apb_xtn.rgpio_in && apb_xtn.paddr ==32'h00)
	begin
	
	  if(apb_xtn.rgpio_in==io_xtn.io_pad)
	    begin
		`uvm_info(get_type_name(),$sformatf("rgpio_in and io_pad pass rgpio_in=%0d, io_pad=%0d***************************",apb_xtn.rgpio_in,io_xtn.io_pad),UVM_LOW)
			    end
	  else
	    begin
		`uvm_error(get_type_name(),"rgpio_in and io_pad failed ***************************************")
	    end
	end

	// rgpio_out or bi-directional
	if(apb_xtn.rgpio_oe && apb_xtn.paddr == 32'h08)
	
	begin
	
	  foreach(apb_xtn.rgpio_oe[i])
	  if(apb_xtn.rgpio_oe[i]==1)
	    begin
  	      if(apb_xtn.rgpio_out[i]==io_xtn.io_pad[i])	
  		begin
		  `uvm_info(get_type_name(),$sformatf(" rgpio and io_pad pass rgpio_out[%0d]=%0d,io_pad[%0d]=%0d*****************************",i,apb_xtn.rgpio_out[i],i,io_xtn.io_pad[i]),UVM_LOW)
			end
	      else
		 begin
		  `uvm_error(get_type_name(),$sformatf(" rgpio and io_pad failed**** rgpio_out[%0d]=%0d,io_pad[%0d]=%0d*****************************",i,apb_xtn.rgpio_out[i],i,io_xtn.io_pad[i]))
	         end
	
	    end
	end
	

	if(apb_xtn.rgpio_ints && apb_xtn.paddr == 32'h1C)
	  begin
	    if(apb_xtn.rgpio_ints==ints)
	      begin
		`uvm_info(get_type_name(),"rgpio_ints and ints are passed ***************************",UVM_LOW)
	     end
	    else
	      begin
		`uvm_error(get_type_name(),"rgpio_ints and ints are failed **************************")
	      end
	  end

	  

  endtask

  task compare_aux_data(aux_tx aux_xtn);
	wait(aux_xtn!= null);
	wait(apb_xtn!= null);
	
	if(apb_xtn.rgpio_aux && apb_xtn.paddr == 32'h14)
	  begin
	    foreach(apb_xtn.rgpio_aux[i])
		if(apb_xtn.rgpio_aux[i] == 1)
		  begin
			if(aux_xtn.aux_in[i] == io_xtn.io_pad[i])
				begin
				`uvm_info(get_type_name(),$sformatf("aux_in and io_pad pass aux_in[%0d]=%0d,io_pad[%0d]=%0d************************",i,aux_xtn.aux_in[i],i,io_xtn.io_pad[i]),UVM_LOW)	
	      			end
		
		  end
	   end


  endtask

  task ref_model();
	mux = (apb_xtn.rgpio_eclk & ext_in) | (~apb_xtn.rgpio_eclk & io_xtn.io_pad);
	ext_in = (~apb_xtn.rgpio_nec & io_xtn.io_pad) | (apb_xtn.rgpio_nec & io_xtn.io_pad);
	ints   = ((mux^apb_xtn.rgpio_in) & ~(mux ^ apb_xtn.rgpio_ptrig)) & apb_xtn.rgpio_inte;
  endtask		
		
endclass



