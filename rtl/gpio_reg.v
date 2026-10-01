`define RGPIO_IN     32'h00
`define RGPIO_OUT    32'h04
`define RGPIO_OE     32'h08
`define RGPIO_INTE   32'h0C
`define RGPIO_PTRIG  32'h10
`define RGPIO_AUX    32'h14
`define RGPIO_CTRL   32'h18
`define RGPIO_INTS   32'h1C
`define RGPIO_ECLK   32'h20
`define RGPIO_NEC    32'h24

`define RGPIO_CTRL_INTE 1'b0
`define RGPIO_CTRL_INTS 1'b1

module GPIO_register (
    input        sys_clk,
    input        sys_rst,
    input        gpio_we,
    input [31:0] gpio_addr,
    input [31:0] gpio_dat_i,
    input [31:0] aux_i,
    input [31:0] in_pad_i,
    input        gpio_eclk,
    output       gpio_inta_o,
    output reg [31:0] gpio_dat_o,
    output [31:0] out_pad_o,
    output [31:0] oen_padoe_o
);

    // Internal registers
    reg [31:0] rgpio_in, rgpio_out, rgpio_oe;
    reg [31:0] rgpio_inte, rgpio_ptrig, rgpio_aux, rgpio_ints, rgpio_eclk, rgpio_nec;
    reg [1:0]  rgpio_ctrl;
    reg [31:0] pextc_sampled, nextc_sampled;

    // Muxed Inputs
    wire [31:0] extc_in;
    wire [31:0] in_m;

    // --------------------- RGPIO_CTRL ---------------------
    always @(posedge sys_clk or posedge sys_rst) begin
        if (sys_rst)
            rgpio_ctrl <= 2'b00;
        else if ((gpio_addr == `RGPIO_CTRL) && gpio_we)
            rgpio_ctrl <= gpio_dat_i[1:0];
        else if (rgpio_ctrl[`RGPIO_CTRL_INTE])
            rgpio_ctrl[`RGPIO_CTRL_INTS] <= rgpio_ctrl[`RGPIO_CTRL_INTS] | gpio_inta_o;
    end

    // --------------------- RGPIO_OUT ---------------------
    always @(posedge sys_clk or posedge sys_rst) begin
        if (sys_rst)
            rgpio_out <= 32'b0;
        else if ((gpio_addr == `RGPIO_OUT) && gpio_we)
            rgpio_out <= gpio_dat_i;
    end

    // --------------------- RGPIO_OE ---------------------
    always @(posedge sys_clk or posedge sys_rst) begin
        if (sys_rst)
            rgpio_oe <= 32'b0;
        else if ((gpio_addr == `RGPIO_OE) && gpio_we)
            rgpio_oe <= gpio_dat_i;
    end

    // --------------------- RGPIO_INTE ---------------------
    always @(posedge sys_clk or posedge sys_rst) begin
        if (sys_rst)
            rgpio_inte <= 32'b0;
        else if ((gpio_addr == `RGPIO_INTE) && gpio_we)
            rgpio_inte <= gpio_dat_i;
    end

    // --------------------- RGPIO_PTRIG ---------------------
    always @(posedge sys_clk or posedge sys_rst) begin
        if (sys_rst)
            rgpio_ptrig <= 32'b0;
        else if ((gpio_addr == `RGPIO_PTRIG) && gpio_we)
            rgpio_ptrig <= gpio_dat_i;
    end

    // --------------------- RGPIO_AUX ---------------------
    always @(posedge sys_clk or posedge sys_rst) begin
        if (sys_rst)
            rgpio_aux <= 32'b0;
        else if ((gpio_addr == `RGPIO_AUX) && gpio_we)
            rgpio_aux <= gpio_dat_i;
    end

    // --------------------- RGPIO_ECLK ---------------------
    always @(posedge sys_clk or posedge sys_rst) begin
        if (sys_rst)
            rgpio_eclk <= 32'b0;
        else if ((gpio_addr == `RGPIO_ECLK) && gpio_we)
            rgpio_eclk <= gpio_dat_i;
    end

    // --------------------- RGPIO_NEC ---------------------
    always @(posedge sys_clk or posedge sys_rst) begin
        if (sys_rst)
            rgpio_nec <= 32'b0;
        else if ((gpio_addr == `RGPIO_NEC) && gpio_we)
            rgpio_nec <= gpio_dat_i;
    end

    // --------------------- External Clock Sampling ---------------------
    always @(posedge gpio_eclk or posedge sys_rst) begin
        if (sys_rst)
            pextc_sampled <= 32'b0;
        else
            pextc_sampled <= in_pad_i;
    end

    always @(negedge gpio_eclk or posedge sys_rst) begin
        if (sys_rst)
            nextc_sampled <= 32'b0;
        else
            nextc_sampled <= in_pad_i;
    end

    // --------------------- Input Sampling Logic ---------------------
    assign extc_in = (~rgpio_nec & pextc_sampled) | (rgpio_nec & nextc_sampled);
    assign in_m    = (rgpio_eclk ? extc_in : in_pad_i);

    // --------------------- Input Register ---------------------
    always @(posedge sys_clk or posedge sys_rst) begin
        if (sys_rst)
            rgpio_in <= 32'b0;
        else
            rgpio_in <= in_m;
    end

    // --------------------- GPIO Interrupt Logic ---------------------
    assign gpio_inta_o = |(rgpio_inte & ((rgpio_ptrig & in_m) | (~rgpio_ptrig & ~in_m)));

    // --------------------- Output Assignments ---------------------
    assign out_pad_o     = (rgpio_aux) ? aux_i : rgpio_out;
    assign oen_padoe_o   = rgpio_oe;

    // --------------------- Readback ---------------------
    always @(*) begin
	gpio_dat_o = 32'h00000000;
        case (gpio_addr)
            `RGPIO_IN:     gpio_dat_o = rgpio_in;
            `RGPIO_OUT:    gpio_dat_o = rgpio_out;
            `RGPIO_OE:     gpio_dat_o = rgpio_oe;
            `RGPIO_INTE:   gpio_dat_o = rgpio_inte;
            `RGPIO_PTRIG:  gpio_dat_o = rgpio_ptrig;
            `RGPIO_AUX:    gpio_dat_o = rgpio_aux;
            `RGPIO_CTRL:   gpio_dat_o = {30'b0, rgpio_ctrl};
            //`RGPIO_INTS:   gpio_dat_o = rgpio_ints;
            `RGPIO_ECLK:   gpio_dat_o = rgpio_eclk;
            `RGPIO_NEC:    gpio_dat_o = rgpio_nec;               
	    endcase
    end

endmodule

