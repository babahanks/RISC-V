`include "risc_v.sv"

module risc_v_tb();
  
  logic clk;
  logic reset;
  
  
  risc_v r(	.clk(clk),
           .reset(reset));
  
  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end
  
  initial begin
    
    reset = 1'b1;
    
    @(posedge clk);
    @(posedge clk);
    @(posedge clk);
    
    assert(r.mem_rd_addr_valid == 1'b0) 
      else $error("r.mem_rd_addr_valid should be %b. it is %b", 
                   1'b0, 
                   r.mem_rd_addr_valid); 

    assert(r.reg_rd_addrs_a_valid == 1'b0) 
      else $error("r.reg_rd_addrs_a_valid should be %b. it is %b", 
                   1'b0, 
                   r.reg_rd_addrs_a_valid); 
    
    assert(r.reg_rd_addrs_b_valid == 1'b0) 
      else $error("r.reg_rd_addrs_b_valid should be %b. it is %b", 
                   1'b0, 
                   r.reg_rd_addrs_b_valid); 
    
    assert(r.rih.inProcess == 1'b0) 
      else $error("r.rih.inProcess should be %b. it is %b", 
                   1'b0, 
                   r.rih.inProcess); 
    
    reset = 1'b0;
    
    
    
    @(posedge clk);
    assert(r.rih.inProcess == 1'b1) 
      else $error("r.rih.inProcess should be %b. it is %b", 
                   1'b1, 
                   r.rih.inProcess); 

    @(posedge clk);

    assert(r.mem_rd_addr == 32'b0) 
      else $error("r.mem_rd_addr should be %b. it is %b", 
                   32'b0, 
                   r.mem_rd_addr); 

    assert(r.mem_rd_addr_valid == 1'b1) 
      else $error("r.mem_rd_addr_valid should be %b. it is %b", 
                   1'b1, 
                   r.mem_rd_addr_valid); 

    //mem_rd_data = 32'b0000000000100000000000100110011;
    //mem_rd_ack  = 1'b1;
    //32'b101011
    @(posedge clk);
    $display("r.rih.instruction %b", r.rih.instruction);
    
    @(posedge clk);
    $display("r.regfile_.rd_addr_b_valid %b", r.regfile_.rd_addr_b_valid);
    $display("r.regfile_.rd_addr_b %b", r.regfile_.rd_addr_b);
    @(posedge clk);
    $display("r.rih.alu_input_A %b", r.rih.alu_input_A);
    $display("r.rih.alu_input_B %b", r.rih.alu_input_B);
    @(posedge clk);
    $display("r.rih.alu_input_A %b", r.rih.alu_input_A);
    $display("r.rih.alu_input_B %b", r.rih.alu_input_B);

    /*
    assert(r.rih.instruction == 32'b0000000000100000000000100110011) 
      else $error("r.rih.instruction should be %b. it is %b", 
                   32'b0000000000100000000000100110011, 
                   r.rih.instruction); 

    assert(r.reg_rd_addrs_a_valid == 1'b1) 
      else $error("r.reg_rd_addrs_a_valid should be %b. it is %b", 
                   1'b1, 
                   r.reg_rd_addrs_a_valid); 

    
    
    @(posedge clk);
    @(posedge clk);

    assert(r.reg_rd_data_a == 32'b101011) 
      else $error("r.reg_rd_data_a should be %b. it is %b", 
                   32'b101011, 
                   r.reg_rd_data_a); 
    
    
    @(posedge clk);
    */

    $finish();
  end

  
endmodule