`include "memory.sv"

module memory_tb();
  logic       clk;
  logic       reset;
  logic[31:0] mem_rd_addr;
  logic		  mem_rd_addr_valid;
  logic[31:0] mem_rd_data;
  logic       mem_rd_ack;
  logic[31:0] mem_wr_addr;
  logic[31:0] mem_wr_data;
  logic       mem_wr_data_valid;
  logic       mem_wr_ack;
  
  
  memory mem(
    .clk(clk),
    .reset(reset),
    .mem_rd_addr(mem_rd_addr),
    .mem_rd_addr_valid(mem_rd_addr_valid),
    .mem_rd_data(mem_rd_data),
    .mem_rd_ack(mem_rd_ack),
    .mem_wr_addr(mem_wr_addr),
    .mem_wr_data(mem_wr_data),
    .mem_wr_data_valid(mem_wr_data_valid),
    .mem_wr_ack(mem_wr_ack));
  
  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end

  initial begin
    reset = 1'b0;
    @(posedge clk);
    reset = 1'b1;
    mem_rd_addr_valid = 1'b1;
    @(posedge clk);
    @(posedge clk);
    
    
    reset = 1'b0;
    mem_rd_addr = 32'b0;
    mem_rd_addr_valid = 1'b1;
    @(posedge clk);
    assert(mem_rd_ack == 1'b1) 
      else $error("mem_rd_ack should be %b. it is %b", 1'b1, mem_rd_ack); 
    assert(mem_rd_data == 32'b0000000000100000000000100110011) 
      else $error("mem_rd_data should be %b. it is %b",32'b0000000000100000000000100110011, mem_rd_data); 
    
    
    mem_rd_addr = 32'b1;
    mem_rd_addr_valid = 1'b0;
    @(posedge clk);
    assert(mem_rd_ack == 1'b0) 
      else $error("mem_rd_ack should be %b. it is %b", 1'b0, mem_rd_ack);     
    
    
    mem_wr_addr = 32'b11;
    mem_wr_data = 32'b101111;
    mem_wr_data_valid = 1'b1;
    @(posedge clk);
    assert(mem_wr_ack == 1'b1) 
      else $error("mem_wr_ack should be %b. it is %b", 1'b1, mem_rd_ack); 
    
    
    mem_rd_addr = 32'b11;
    mem_rd_addr_valid = 1'b1;
    mem_wr_data_valid = 1'b0;
    
    @(posedge clk)
    assert(mem_wr_ack == 1'b0) 
      else $error("mem_wr_ack should be %b. it is %b", 1'b0, mem_rd_ack); 
    assert(mem_rd_ack == 1'b1) 
      else $error("mem_rd_ack should be %b. it is %b", 1'b1, mem_rd_ack); 
    assert(mem_rd_data == 32'b101111) 
      else $error("mem_rd_data should be %b. it is %b",32'b101111, mem_rd_data); 
    
    $finish();
    
  end
  
endmodule