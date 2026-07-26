class mem_sbd extends uvm_scoreboard;
`uvm_component_utils(mem_sbd)
  uvm_analysis_imp #(mem_tx,mem_sbd) an_ex;
  int asso[*];
  mem_tx tx;
function new(string name="mem_sbd",uvm_component parent=null);
super.new(name,parent);
endfunction
function void build();
an_ex=new("an_ex",this);
endfunction
  function void write(mem_tx t);
  tx=new t;
  if(tx.wr_rd==1)begin
  asso[tx.addr]=tx.wdata;
  end
  else begin
  if(tx.rdata==asso[tx.addr])mem_common::matchings++;
  else mem_common::mismatchings++;
  end
  endfunction
function void report_phase(uvm_phase phase);
if(mem_common::matchings!=0&&mem_common::mismatchings==0)begin
$display("******test_passed**********");
$display("matchings=%0d,mismatchings=%0d",mem_common::matchings,mem_common::mismatchings);
end
else begin
$display("******test_failed**********");
$display("matchings=%0d,mismatchings=%0d",mem_common::matchings,mem_common::mismatchings);
end
endfunction
endclass



