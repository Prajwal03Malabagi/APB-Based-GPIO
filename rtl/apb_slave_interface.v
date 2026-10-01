module apb_slave_interface(
    input        pclk, presetn, psel, penable, pwrite,
    input  [31:0] paddr,
    input [31:0] pwdata,
    input [31:0] gpio_dat_o,
    input        gpio_inta_o,
    output       pready,
    output       sys_clk, sys_rst,
    output reg gpio_we,
    output [31:0] gpio_addr,
    output reg [31:0] gpio_dat_i,
    output reg [31:0] prdata,
    output       irq
);

    // FSM state encodings
    parameter IDLE   = 2'b00,
              ENABLE = 2'b10,
              SETUP  = 2'b01;

    reg [1:0] ps, ns;

    // FSM sequential logic
    always @(posedge pclk) begin
        if (presetn)
            ps <= IDLE;
        else
            ps <= ns;
    end

    // FSM combinational logic
    always @(*) begin
        case (ps)
            IDLE: begin
                if (psel && !penable) ns = SETUP;
                else                  ns = IDLE;
            end

            SETUP: begin
                if (psel && penable) ns = ENABLE;
                else if (psel && !penable) ns = SETUP;
                else ns = IDLE;
            end

            ENABLE: begin
                if (psel && penable) ns = ENABLE;
                else if (psel && !penable) ns = SETUP;
                else ns = IDLE;
            end

            default: ns = IDLE;
        endcase
    end

    // Port assignments
    assign sys_clk     = pclk;
    assign sys_rst     = presetn;
    assign gpio_addr  = paddr;
    assign irq        = gpio_inta_o;
    assign pready     = ((ps == ENABLE) )? 1'b1 : 1'b0;

    // Read/Write control
    always @(*) begin
        if (pwrite && penable && psel) begin
            gpio_dat_i = pwdata;
            gpio_we    = 1'b1;
        end else if (!pwrite && ps == ENABLE) begin
            prdata     = gpio_dat_o;
            gpio_we    = 1'b0;
        end else begin
            gpio_dat_i = gpio_dat_i;
            prdata     = prdata;
            gpio_we    = 1'b0;
        end
    end

endmodule
