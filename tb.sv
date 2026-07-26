module tb;

  logic clk,res;
  mem_intrf pif(clk,res);
  memory dut(.clk(pif.clk),.res(pif.res),.wr_rd(pif.wr_rd),.addr(pif.addr),.wdata(pif.wdata),.rdata(pif.rdata),.valid(pif.valid),.ready(pif.ready));
  always #5 clk=~clk;
initial begin
  clk=0;
  res=1;
  
    void'($value$plusargs("N=%0d",mem_common::N));
 
// uvm_resource_db#(virtual mem_intrf)::set("GLOBAL","mem_pif",pif,null);
  uvm_config_db#(virtual mem_intrf)::set(uvm_root::get(),"uvm_test_top.env.agent.*","mem_pif",pif);
  run_test("test_nwr_nrd");
end
  initial begin

    repeat(2)@(posedge clk);
  res=0;
end
initial begin
    $dumpfile("1.vcd");
    $dumpvars;
  end
endmodule






