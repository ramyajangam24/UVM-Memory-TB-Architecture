class mem_mon extends uvm_monitor;
`uvm_component_utils(mem_mon)
virtual mem_intrf vif;
uvm_analysis_port #(mem_tx) ap;
function new(string name="mem_mon",uvm_component parent=null);
super.new(name,parent);
endfunction
function void build_phase(uvm_phase phase);
super.build_phase(phase);
ap=new("ap",this);
 // void'(uvm_resource_db#(virtual mem_intrf)::read_by_name("GLOBAL","mem_pif",vif,this));
 if(!uvm_config_db#(virtual mem_intrf)::get(this,"","mem_pif",vif))
 `uvm_error("CONFIG _DB","not abled to get the vif");
endfunction
task run_phase(uvm_phase phase);
mem_tx tx;
forever begin
  @(vif.mon_cb);
  if(vif.mon_cb.valid==1&&vif.mon_cb.ready==1)begin

tx=mem_tx::type_id::create("tx",this);
tx.tx_time=$time;
tx.wr_rd=vif.mon_cb.wr_rd;
tx.addr=vif.mon_cb.addr;
tx.wdata=vif.mon_cb.wdata;
if(tx.wr_rd==0)begin
@(vif.mon_cb);
tx.rdata=vif.mon_cb.rdata;
end
tx.print();
ap.write(tx);
end
end
endtask
endclass


