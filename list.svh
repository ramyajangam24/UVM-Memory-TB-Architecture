`include "uvm_macros.svh"
import uvm_pkg::*;
//hardware structures and data objects first
`include "mem_common.sv"
`include "mem_tx.sv"
`include "mem_intrf.sv"
`include "memory.v"
`include "mem_sequence.sv"
//sequences and components next

`include "mem_sqr.sv"
`include "mem_driver.sv"
`include "mem_mon.sv"
`include "mem_cov.sv"
//containers and env next

`include "mem_agent.sv"
`include "mem_sbd.sv"
`include "mem_env.sv"
//top modules last

`include "test.sv"
`include "tb.sv"


