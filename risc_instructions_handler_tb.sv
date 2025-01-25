`include "risc_instructions_handler.sv"

module risc_instructions_handler_tb();
  
  logic 	   clk;
  logic 	   reset;

  // memory signals
  logic[31:0]  mem_rd_addr;
  logic		   mem_rd_addr_valid;
  logic[31:0]  mem_rd_data;
  logic        mem_rd_ack;

  // registers signals
  logic[4:0]   reg_rd_addr_a;
  logic 		reg_rd_addrs_a_valid;
  logic[31:0]  reg_rd_data_a;
  logic		   reg_rd_data_a_ack;
  
  logic[4:0]   reg_rd_addr_b;
  logic 	   reg_rd_addrs_b_valid;  
  logic[31:0]  reg_rd_data_b;
  logic		   reg_rd_data_b_ack;
  
  // ALU signals
  ALU_OP_CODE  alu_op_code;
  logic[31:0]  alu_input_A;
  logic[31:0]  alu_input_B;
  logic		   alu_reg_out;
  logic[4:0]   alu_reg_addr;
  logic		   alu_mem_out;
  logic[31:0]  alu_mem_addr;

  logic        alu_pc_jump;
  logic        alu_inputs_valid;

  logic[31:0]  alu_pc_branch_data;
 
  logic        alu_pc_branch_data_valid;
  logic        alu_pc_branch_data_ack;
  
  
  risc_instructions_handler 
  rih(.clk(clk),
      .reset(reset),

  		// memory signals
      .mem_rd_addr(mem_rd_addr),
      .mem_rd_addr_valid(mem_rd_addr_valid),
      .mem_rd_data(mem_rd_data),
      .mem_rd_ack(mem_rd_ack),

  		// registers signals
      .reg_rd_addr_a(reg_rd_addr_a),
      .reg_rd_addrs_a_valid(reg_rd_addrs_a_valid),
      .reg_rd_data_a(reg_rd_data_a),
      .reg_rd_data_a_ack(reg_rd_data_a_ack),
  
      .reg_rd_addr_b(reg_rd_addr_b),
      .reg_rd_addrs_b_valid(reg_rd_addrs_b_valid),  
      .reg_rd_data_b(reg_rd_addrs_b_valid),
      .reg_rd_data_b_ack(reg_rd_data_b_ack),
  
      // ALU signals
      .alu_op_code(alu_op_code),
      .alu_input_A(alu_input_A),
      .alu_input_B(alu_input_B),
      .alu_reg_out(alu_reg_out),
      .alu_reg_addr(alu_reg_addr),
      .alu_mem_out(alu_mem_out),
      .alu_mem_addr(alu_mem_addr),

      .alu_pc_jump(alu_pc_jump),
      .alu_inputs_valid(alu_inputs_valid),

      .alu_pc_branch_data(alu_pc_branch_data),

      .alu_pc_branch_data_valid(alu_pc_branch_data_valid),
      .alu_pc_branch_data_ack(alu_pc_branch_data_ack),
      .done(done));
    
    
  
  
  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end

  initial begin
    reset = 1'b1;
    @(posedge clk);
    @(posedge clk);
    @(posedge clk);
    
    assert(mem_rd_addr_valid == 1'b0) 
      else $error("mem_rd_addr_valid should be %b. it is %b", 
                   1'b0, 
                   mem_rd_addr_valid); 

    assert(reg_rd_addrs_a_valid == 1'b0) 
      else $error("reg_rd_addrs_a_valid should be %b. it is %b", 
                   1'b0, 
                   reg_rd_addrs_a_valid); 
    
    assert(reg_rd_addrs_b_valid == 1'b0) 
      else $error("reg_rd_addrs_b_valid should be %b. it is %b", 
                   1'b0, 
                   reg_rd_addrs_b_valid); 
    
    assert(rih.inProcess == 1'b0) 
      else $error("rih.inProcess should be %b. it is %b", 
                   1'b0, 
                   rih.inProcess); 


    assert(rih.PC == 32'b0) 
      else $error("rih.PC should be %b. it is %b", 
                   32'b0, 
                   rih.PC); 

    reset = 1'b0;
    
    @(posedge clk);
    assert(rih.inProcess == 1'b1) 
      else $error("rih.inProcess should be %b. it is %b", 
                   1'b1, 
                   rih.inProcess); 

    @(posedge clk);

    assert(mem_rd_addr == 32'b0) 
      else $error("mem_rd_addr should be %b. it is %b", 
                   32'b0, 
                   mem_rd_addr); 

    assert(mem_rd_addr_valid == 1'b1) 
      else $error("mem_rd_addr_valid should be %b. it is %b", 
                   1'b1, 
                   mem_rd_addr_valid); 

    mem_rd_data = 32'b0000000000100000000000100110011;
    mem_rd_ack  = 1'b1;
    
    @(posedge clk);
    assert(rih.instruction == 32'b0000000000100000000000100110011) 
      else $error("rih.instruction should be %b. it is %b", 
                   32'b0000000000100000000000100110011, 
                   rih.instruction); 
    
    @(posedge clk);
    
    
    
	
    
    $finish();
  end
  
endmodule