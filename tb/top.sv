module top;
import uvm_pkg::*;
import pkg::*;
bit clk,ext_clk_pad_i;
apb_intf apb_vif(clk);
aux_intf aux_vif(clk);
io_intf io_vif(ext_clk_pad_i);
always #5 clk=~clk;
always #10 ext_clk_pad_i=~ext_clk_pad_i;

gpio_top dut(clk, apb_vif.preset, apb_vif.psel, apb_vif.penable, apb_vif.pwrite, apb_vif.paddr, apb_vif.pwdata,aux_vif.aux_in, ext_clk_pad_i,io_vif.io_pad,apb_vif.irq,apb_vif.pready,apb_vif.prdata);

initial begin
	`ifdef VCS
		$fsdbDumpvars(0,top);
	`endif
	uvm_config_db#(virtual apb_intf)::set(null,"*","apb_intf",apb_vif);
	uvm_config_db#(virtual aux_intf)::set(null,"*","aux_intf",aux_vif);
	uvm_config_db#(virtual io_intf)::set(null,"*","io_intf",io_vif);
	run_test("");
	end
endmodule
