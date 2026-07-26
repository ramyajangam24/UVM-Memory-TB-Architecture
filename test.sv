class mem_test extends uvm_test;
mem_env env;
`uvm_component_utils(mem_test)
function new(string name="mem_test",uvm_component parent=null);
super.new(name,parent);
endfunction
function void build_phase(uvm_phase phase);
//uvm_config_db#(uvm_object_wrapper)::set(this,"env.agent.sqr.run_phase","default_sequence",seq_nwr_nrd::get_type());
  uvm_config_db#(int)::set(this,"env.agent.*","count",10);
super.build_phase(phase);
env=mem_env::type_id::create("env",this);
endfunction
function void end_of_elaboration();

//env.agent.dri.set_report_verbosity_level(UVM_FULL);
uvm_factory factory;
  factory=uvm_factory::get();
factory.print();
uvm_top.print();
endfunction

endclass

//1wr
class test_1wr extends mem_test;
`uvm_component_utils(test_1wr)
function new(string name="test_1wr",uvm_component parent=null);
super.new(name,parent);
endfunction
task run_phase(uvm_phase phase);
seq_1wr wr_seq;
wr_seq=seq_1wr::type_id::create("wr_seq");
phase.raise_objection(this);
wr_seq.start(env.agent.sqr);
phase.drop_objection(this);
endtask
endclass

//5wr
class test_5wr extends mem_test;
`uvm_component_utils(test_5wr)
  function new(string name="test_5wr",uvm_component parent=null);
super.new(name,parent);
endfunction
task run_phase(uvm_phase phase);
seq_5wr wr5_seq;
  wr5_seq=seq_5wr::type_id::create("wr5_seq");
phase.raise_objection(this);
wr5_seq.start(env.agent.sqr);
phase.drop_objection(this);
endtask
endclass

//1wr_1rd
class test_1wr_1rd extends mem_test;
  `uvm_component_utils(test_1wr_1rd)
  function new(string name="test_5wr",uvm_component parent=null);
super.new(name,parent);
endfunction
task run_phase(uvm_phase phase);
seq_1wr_1rd w1r;
w1r=seq_1wr_1rd::type_id::create("w1r");
phase.raise_objection(this);
w1r.start(env.agent.sqr);
phase.drop_objection(this);
endtask
endclass

//5wr_5rd
class test_5wr_5rd extends mem_test;
  `uvm_component_utils(test_5wr_5rd)
  function new(string name="test_5wr",uvm_component parent=null);
super.new(name,parent);
endfunction
task run_phase(uvm_phase phase);
seq_5wr_5rd w5r;
w5r=seq_5wr_5rd::type_id::create("w5r");
phase.raise_objection(this);
w5r.start(env.agent.sqr);
phase.drop_objection(this);
endtask
endclass

//nwr_nrd
class test_nwr_nrd extends mem_test;
  `uvm_component_utils(test_nwr_nrd)
  function new(string name="test_5wr",uvm_component parent=null);
super.new(name,parent);
endfunction
task run_phase(uvm_phase phase);
seq_nwr_nrd nwnr;
nwnr=seq_nwr_nrd::type_id::create("nwnr");
phase.raise_objection(this);
nwnr.start(env.agent.sqr);
phase.drop_objection(this);
endtask
endclass

//test_nwr_nrd_err
class test_nwr_nrd_err extends test_nwr_nrd;
`uvm_component_utils(test_nwr_nrd_err)
function new(string name="test_nwr_nrd",uvm_component parent=null);
super.new(name,parent);
endfunction
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
set_type_override("mem_tx","mem_err_tx");
endfunction
endclass


