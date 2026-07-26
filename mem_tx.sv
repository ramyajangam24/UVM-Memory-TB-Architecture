`define WIDTH 8
`define DEPTH 16
`define ADDR_WIDTH $clog2(`DEPTH)
class mem_tx extends uvm_sequence_item;
rand bit wr_rd;
rand bit [`ADDR_WIDTH-1:0]addr;
rand bit [`WIDTH-1:0]wdata;
bit [`WIDTH-1:0]rdata;
  time tx_time;
  `uvm_object_utils_begin(mem_tx)
`uvm_field_int(wr_rd,UVM_ALL_ON);
`uvm_field_int(addr,UVM_ALL_ON);
`uvm_field_int(wdata,UVM_ALL_ON);
`uvm_field_int(rdata,UVM_ALL_ON);
  `uvm_field_int(tx_time,UVM_TIME);
`uvm_object_utils_end
  function new(input string name="mem_tx");
super.new(name);
endfunction
endclass
class mem_err_tx extends mem_tx;
rand bit[1:0]err_type;
`uvm_object_utils_begin(mem_err_tx)
`uvm_field_int(err_type,UVM_ALL_ON)
`uvm_object_utils_end
function new(string name="mem_err_tx");
super.new(name);
endfunction
endclass



