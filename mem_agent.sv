class mem_agent extends uvm_agent;
mem_sqr sqr;
mem_driver dri;
mem_mon mon;
mem_cov cov;
`uvm_component_utils(mem_agent)
function new(string name,uvm_component parent=null);
super.new(name,parent);
endfunction
function void build_phase(uvm_phase phase);
super.build_phase(phase);
sqr=mem_sqr::type_id::create("sqr",this);
dri=mem_driver::type_id::create("dri",this);
mon=mem_mon::type_id::create("mon",this);
cov=mem_cov::type_id::create("cov",this);
endfunction
function void connect_phase(uvm_phase phase);
super.connect_phase(phase);
dri.seq_item_port.connect(sqr.seq_item_export);
mon.ap.connect(cov.an_co);
endfunction
endclass
