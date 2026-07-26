class mem_cov extends uvm_subscriber#(mem_tx);
  `uvm_component_utils(mem_cov);
  uvm_analysis_imp#(mem_tx,mem_cov) an_co;
mem_tx tx;
covergroup cg;
ADDR:coverpoint tx.addr{
option.auto_bin_max=32;
}
WR_RD:coverpoint tx.wr_rd{
  bins WRITES={1'b1};
  bins READS={1'b0};
}
CROSS_ADDR_WR_RD:cross WR_RD,ADDR;
endgroup
  function new(string name="mem_cov",uvm_component parent=null);
super.new(name,parent);
cg=new();
endfunction
function void build();
an_co=new("an_co",this);
endfunction
function void write(mem_tx t);
tx=new t;
cg.sample();
endfunction
endclass


