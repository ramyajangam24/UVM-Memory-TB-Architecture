interface mem_intrf(input logic clk,input logic res);
logic wr_rd;
logic [`ADDR_WIDTH-1:0]addr;
logic [`WIDTH-1:0]wdata;
logic [`WIDTH-1:0]rdata;
logic ready;
logic valid;
clocking bfm_cb @(posedge clk);
default input #0 output #1;
input ready,rdata;
output wr_rd,addr,wdata,valid;
endclocking
clocking mon_cb@(posedge clk);
default input #1;
input wr_rd,addr,wdata,rdata,valid,ready;
endclocking

endinterface
