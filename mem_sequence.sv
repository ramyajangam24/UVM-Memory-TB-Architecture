class base_sequence extends uvm_sequence#(mem_tx);
  `uvm_object_utils(base_sequence)
 uvm_phase phase;
  mem_tx tx,txQ[$];
  int count_l;
  function new(string name="base_sequence");
super.new(name);
endfunction
task pre_body();
phase=get_starting_phase();
if(phase!=null)
phase.raise_objection(this);
endtask
task post_body();
if(phase!=null)
phase.drop_objection(this);
endtask
//task body();
//endtask
endclass

//1wr
class seq_1wr extends base_sequence;
  rand bit [`ADDR_WIDTH-1:0]addr_t1;
`uvm_object_utils(seq_1wr)
  function new(string name="seq_1wr");
super.new(name);
endfunction
task body();
  `uvm_do_with(req,{req.wr_rd==1'b1;req.addr==addr_t1;})
endtask
endclass

//1rd
class seq_1rd extends base_sequence;
  rand bit [`ADDR_WIDTH-1:0]addr_t1;
`uvm_object_utils(seq_1rd)
  function new(string name="seq_1rd");
super.new(name);
endfunction
task body();
  `uvm_do_with(req,{req.wr_rd==1'b0;req.addr==addr_t1;})
endtask
endclass

//1wr_1rd from sequence layering
class seq_1wr_1rd extends base_sequence;
  rand bit [`ADDR_WIDTH-1:0]addr_t;
`uvm_object_utils(seq_1wr_1rd)
seq_1wr wr;
seq_1rd rd;
  function new(string name="seq_1wr_1rd");
super.new(name);
endfunction
  
  task body();
`uvm_do_with(wr,{wr.addr_t1==addr_t;})
`uvm_do_with(rd,{rd.addr_t1==addr_t;})
endtask
endclass

//nwr
class seq_nwr extends base_sequence;
rand bit [`ADDR_WIDTH-1:0]addr_t1;
`uvm_object_utils(seq_nwr)
function new(string name="seq_nwr");
super.new(name);
endfunction
task body();
 void'(uvm_config_db#(int)::get(null,get_full_name(),"count",count_l));
repeat(count_l)begin
  `uvm_do_with(req,{req.wr_rd==1'b1;req.addr==addr_t1;})
end
endtask
endclass

//nrd
class seq_nrd extends base_sequence;
rand bit [`ADDR_WIDTH-1:0]addr_t1;
`uvm_object_utils(seq_nrd)
function new(string name="seq_nrd");
super.new(name);
endfunction
task body();
 void'(uvm_config_db#(int)::get(null,get_full_name(),"count",count_l));
repeat(count_l)begin
  `uvm_do_with(req,{req.wr_rd==1'b0;req.addr==addr_t1;req.wdata==0;})
end
endtask
endclass

//nwr_nrd from sequence layering
class seq_nwr_nrd extends base_sequence;
  rand bit [`ADDR_WIDTH-1:0]addr_t;
`uvm_object_utils(seq_nwr_nrd)
seq_nwr nwr;
seq_nrd nrd;
  function new(string name="seq_nwr_nrd");
super.new(name);
endfunction
task body();
 void'(uvm_config_db#(int)::get(null,get_full_name(),"count",count_l));
 // This tells nwr and nrd: "only execute 1 transaction per call"
 // uvm_config_db#(int)::set(null, $sformatf("%s.nwr", get_full_name()), "count", 1);
 // uvm_config_db#(int)::set(null, $sformatf("%s.nrd", get_full_name()), "count", 1);
  //or
  // This tells UVM: "Set count to 1 for ANY child sequence inside me"
uvm_config_db#(int)::set(null, "*", "count", 1);
  repeat(count_l)begin

   this.randomize();

  `uvm_info("SAMPLE",$sformatf("value of count_l is %0d",count_l),UVM_LOW)
    `uvm_do_with(nwr,{nwr.addr_t1==addr_t;})
    `uvm_do_with(nrd,{nrd.addr_t1==addr_t;})
  end

endtask
endclass


//5wr
class seq_5wr extends base_sequence;
`uvm_object_utils(seq_5wr)
  function new(string name="seq_5wr");
super.new(name);
endfunction
task body();
 void'(uvm_config_db#(int)::get(null,get_full_name(),"count",count_l));
repeat(5)begin
  `uvm_do_with(req,{req.wr_rd==1'b1;})
end
endtask
endclass

//1wr_1rd
//class seq_1wr_1rd extends base_sequence;
//`uvm_object_utils(seq_1wr_1rd)
//function new(string name="seq_1wr_1rd");
//super.new(name);
//endfunction
//virtual task body();
//
////1wr_1rd(1wr)
//`uvm_do_with(req,{req.wr_rd==1'b1;})
////1wr_1rd(1rd)
//`uvm_do_with(req,{req.wr_rd==1'b0;})
//endtask
//endclass

//5wr_5rd
class seq_5wr_5rd extends base_sequence;
`uvm_object_utils(seq_5wr_5rd)
function new(string name="seq_5wr_5rd");
super.new(name);
endfunction
virtual task body();
//5writes
repeat(5)begin
`uvm_do_with(req,{req.wr_rd==1'b1;})
tx=new req;
txQ.push_back(tx);
end
//5reads
repeat(5)begin
tx=txQ.pop_front();
  `uvm_do_with(req,{req.wr_rd==1'b0;req.addr==tx.addr;req.wdata==0;})
end
endtask
endclass

//nwr_nrd
//class seq_nwr_nrd extends base_sequence;
//`uvm_object_utils(seq_nwr_nrd)
//function new(string name="seq_nwr_nrd");
//super.new(name);
//endfunction
//virtual task body();
//bit [3:0] used_add[$];
//  void'(uvm_config_db#(int)::get(null,get_full_name(),"count",count_l));
////nwrites
//repeat(count_l)begin
////repeat(mem_common::N)begin
////used_add for printing in different addresses
//`uvm_do_with(req,{req.wr_rd==1'b1;!(req.addr inside {used_add});})
//used_add.push_back(req.addr);
//tx=new req;
//txQ.push_back(tx);
//end
////nreads
//repeat(count_l)begin
////repeat(mem_common::N)begin
//tx=txQ.pop_front();
//`uvm_do_with(req,{req.wr_rd==0;req.addr==tx.addr;req.wdata==0;})
//get_response(rsp);//driver sending to sequencer through rsp
//$display("-----printing response tx in sequence");
//rsp.print();
//end
//endtask
//endclass




