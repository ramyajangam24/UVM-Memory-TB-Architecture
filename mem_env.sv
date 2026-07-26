class mem_env extends uvm_env;
mem_agent agent;
mem_sbd sbd;

`uvm_component_utils(mem_env)
function new(string name,uvm_component parent=null);
super.new(name,parent);
endfunction
function void build_phase(uvm_phase phase);
super.build_phase(phase);
agent=mem_agent::type_id::create("agent",this);
sbd=mem_sbd::type_id::create("sbd",this);

endfunction
function void connect_phase(uvm_phase phase);
super.connect_phase(phase);
  agent.mon.ap.connect(sbd.an_ex);
endfunction
endclass


