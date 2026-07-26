
module memory(clk,res,valid,ready,wr_rd,addr,wdata,rdata);
input clk,res,wr_rd,valid;
input [`ADDR_WIDTH-1:0]addr;
input [`WIDTH-1:0]wdata;
output reg ready;
output reg [`WIDTH-1:0]rdata;
reg [`WIDTH-1:0]mem[`DEPTH-1:0];
integer i;
always@(posedge clk)begin
if(res==1)begin
rdata=0;
ready=0;
for(i=0;i<`DEPTH;i=i+1)
mem[i]=0;
end
else begin
if(valid==1)begin
ready=1;
if(wr_rd==1)mem[addr]=wdata;
else rdata=mem[addr];
end
else ready=0;
end
end
endmodule
