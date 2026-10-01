package pkg;

import uvm_pkg::*;
`include "uvm_macros.svh"
`include "config.sv"

`include "apb_tx.sv"
`include "apb_seq.sv"
`include "aux_tx.sv"
`include "aux_seq.sv"
`include "io_tx.sv"
`include "io_seq.sv"

`include "apb_seqr.sv"
`include "apb_driver.sv"
`include "apb_monitor.sv"


`include "aux_seqr.sv"
`include "aux_driver.sv"
`include "aux_monitor.sv"

`include "io_seqr.sv"
`include "io_driver.sv"
`include "io_monitor.sv"

`include "io_agent.sv"
`include "apb_agent.sv"
`include "aux_agent.sv"
`include "scb.sv"
`include "env.sv"
`include "test.sv"
//`include ""
endpackage
