module gpio_top (
    input         pclk,
    input         presetn,
    input         psel,
    input         penable,
    input         pwrite,
    input  [31:0]  paddr,
    input  [31:0] pwdata,
    input  [31:0] aux_in,
    input         ext_clk_pad_i,
    inout  [31:0] io_pad,
    output        irq,
    output        pready,
    output [31:0] prdata
);

    // Internal signals
    wire        sys_clk, sys_rst, gpio_we;
    wire [31:0] gpio_addr, gpio_dat_i, gpio_dat_o;
    wire [31:0] aux_i;
    wire [31:0] out_pad_o, oen_padoe_o, in_pad_i;
    wire        gpio_eclk, gpio_inta_o;

    // ----------------- Module Instantiations -----------------

    // APB Slave Interface
    apb_slave_interface apb (
        .pclk(pclk),
        .presetn(presetn),
        .psel(psel),
        .penable(penable),
        .pwrite(pwrite),
        .paddr(paddr),
        .pwdata(pwdata),
        .gpio_dat_o(gpio_dat_o),
        .gpio_inta_o(gpio_inta_o),
        .pready(pready),
        .sys_clk(sys_clk),
        .sys_rst(sys_rst),
        .gpio_we(gpio_we),
        .gpio_addr(gpio_addr),
        .gpio_dat_i(gpio_dat_i),
        .prdata(prdata),
        .irq(irq)
    );

    // AUX Interface
    aux_interface aux (
        .sys_clk(sys_clk),
        .sys_rst(sys_rst),
        .aux_in(aux_in),
        .aux_i(aux_i)
    );

    // GPIO Register Block
    GPIO_register gp (
        .sys_clk(sys_clk),
        .sys_rst(sys_rst),
        .gpio_we(gpio_we),
        .gpio_addr(gpio_addr),
        .gpio_dat_i(gpio_dat_i),
        .aux_i(aux_i),
        .in_pad_i(in_pad_i),
        .gpio_eclk(ext_clk_pad_i),
        .gpio_inta_o(gpio_inta_o),
        .gpio_dat_o(gpio_dat_o),
        .out_pad_o(out_pad_o),
        .oen_padoe_o(oen_padoe_o)
    );

    // IO Interface
    io_interface io (
        .out_pad_o(out_pad_o),
        .oen_padoe_o(oen_padoe_o),
        .io_pad(io_pad),
        .in_pad_i(in_pad_i),
        .gpio_eclk(gpio_eclk),
        .ext_clk_pad_i(ext_clk_pad_i)
    );

endmodule

