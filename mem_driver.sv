class mem_driver extends uvm_driver#(mem_tx);
  `uvm_component_utils(mem_driver)
virtual mem_intrf vif;

function new(string name="mem_driver",uvm_component parent=null);
super.new(name,parent);
endfunction
 virtual function void build_phase(uvm_phase phase);
 super.build_phase(phase);
   //void'( uvm_resource_db#(virtual mem_intrf)::read_by_name("GLOBAL","mem_pif",vif,this));
  if(! uvm_config_db#(virtual mem_intrf)::get(this,"","mem_pif",vif))
  `uvm_error("CONFIG_DB","not abled to get the vif");
endfunction

function void report();
`uvm_info("driver","driver functionality is happening",UVM_HIGH)
endfunction
task run_phase(uvm_phase phase);
forever begin
seq_item_port.get_next_item(req);
drive_tx(req);
rsp=new req;
  if(req.wr_rd==1) seq_item_port.item_done();
else seq_item_port.item_done(rsp);
end
endtask
task drive_tx(input mem_tx tx);
 @(vif.bfm_cb);
vif.bfm_cb.wr_rd<=tx.wr_rd;
vif.bfm_cb.addr<=tx.addr;
vif.bfm_cb.wdata<=tx.wdata;
vif.bfm_cb.valid<=1;
wait(vif.bfm_cb.ready==1);
if(tx.wr_rd==0)begin
@(vif.bfm_cb);
tx.rdata<=vif.bfm_cb.rdata;
end
@(vif.bfm_cb);
vif.bfm_cb.wr_rd<=0;
vif.bfm_cb.addr<=0;
vif.bfm_cb.wdata<=0;
vif.bfm_cb.valid<=0;

 
endtask
endclass








