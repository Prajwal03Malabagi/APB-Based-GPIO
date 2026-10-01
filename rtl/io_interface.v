module io_interface (
    input [31:0] out_pad_o,      // Output data from GPIO register
    input [31:0] oen_padoe_o,    // Output enable: 1=output, 0=input
    inout [31:0] io_pad,         // Actual bidirectional I/O pads
    output [31:0] in_pad_i,  
	 output        gpio_eclk,           
    input         ext_clk_pad_i        // Read-back data from I/O pads
);
	
    // Tri-state buffer for each bit
    genvar i;
    generate
        for (i = 0; i < 32; i = i + 1) begin : IO_PAD_LOGIC
            assign io_pad[i]   = oen_padoe_o[i] ? out_pad_o[i] : 1'bz;
            assign in_pad_i[i] = io_pad[i];
        end
    endgenerate

endmodule
