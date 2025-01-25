`include "regfile.sv"

module regfile_tb();
  
  logic		  clk;
  logic		  reset;
  
  logic[4:0]  rd_addr_a;
  logic 	  rd_addrs_a_valid;
  logic[31:0] rd_data_a;
  logic		  rd_data_a_ack;
  
  logic[4:0]  rd_addr_b;
  logic       rd_addrs_b_valid;
  logic[31:0] rd_data_b;
  logic		  rd_data_b_ack;
  
  logic[4:0]  wr_addr;
  logic[31:0] wr_data;
  logic		  wr_data_valid;
  logic 	  wr_ack;
  
  
  regfile regfile_(
    .clk(clk),
    .reset(reset),
  
    .rd_addr_a(rd_addr_a),
    .rd_addrs_a_valid(rd_addrs_a_valid),
    .rd_data_a(rd_data_a),
    .rd_data_a_ack(rd_data_a_ack),
  
    .rd_addr_b(rd_addr_b),
    .rd_addrs_b_valid(rd_addrs_b_valid),
    .rd_data_b(rd_data_b),
    .rd_data_b_ack(rd_data_b_ack),
  
    .wr_addr(wr_addr),
    .wr_data(wr_data),
    .wr_data_valid(wr_data_valid),
    .wr_ack(wr_ack));

  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end
  
  
  
  initial begin
    
    reset = 1'b1;
    @(posedge clk);
    @(posedge clk);
    @(posedge clk);
    assert(rd_data_a_ack == 1'b0) 
      else $error("rd_data_a_ack should be %b. it is %b", 
                   1'b0, 
                   rd_data_a_ack); 

    assert(rd_data_b_ack == 1'b0) 
      else $error("rd_data_b_ack should be %b. it is %b", 
                   1'b0, 
                   rd_data_b_ack); 
    
    assert(wr_ack == 1'b0) 
      else $error("wr_ack should be %b. it is %b", 
                   1'b0, 
                   wr_ack); 
    
    
    reset = 1'b0;    
    wr_addr = 5'b101;
    wr_data = 32'h10;
    wr_data_valid = 1'b1;
    @(posedge clk);
    
    assert(wr_ack == 1'b1) 
      else $error("wr_ack should be %b. it is %b", 
                   1'b1, 
                   wr_ack); 
    
    
    wr_data_valid = 1'b0;    
    rd_addr_a = 5'b101;
    rd_addrs_a_valid = 1'b1;
    
    @(posedge clk)
    
    assert(rd_data_a_ack == 1'b1) 
      else $error("rd_data_a_ack should be %b. it is %b", 
                   1'b1, 
                   rd_data_a_ack); 

    assert (rd_data_a == 32'h10)
      else $error("rd_data_a should be %b. it is %b", 
                   32'h10, 
                   rd_data_a);
    
    rd_addrs_a_valid = 1'b0;
    @(posedge clk)    
    assert(rd_data_a_ack == 1'b0) 
      else $error("rd_data_a_ack should be %b. it is %b", 
                   1'b0, 
                   rd_data_a_ack); 

   
    rd_addr_b = 5'b101;
    rd_addrs_b_valid = 1'b1;
    
    @(posedge clk)
    
    assert(rd_data_b_ack == 1'b1) 
      else $error("rd_data_b_ack should be %b. it is %b", 
                   1'b1, 
                   rd_data_b_ack); 

    assert (rd_data_b == 32'h10)
      else $error("rd_data_b should be %b. it is %b", 
                   32'h10, 
                   rd_data_b);
    
    rd_addrs_b_valid = 1'b0;
    @(posedge clk)    
    assert(rd_data_b_ack == 1'b0) 
      else $error("rd_data_b_ack should be %b. it is %b", 
                   1'b0, 
                   rd_data_b_ack); 

    $finish();    
  end 
endmodule