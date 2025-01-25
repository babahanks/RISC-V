//`include "ALU.sv"
`include "memory.sv"
`include "regfile.sv"
`include "risc_instructions_handler_2.sv"

module risc_v(
  input logic  clk,
  input logic  reset);
  
  
  logic[31:0] mem_rd_addr;
  logic		  mem_rd_addr_valid;
  logic[31:0] mem_rd_data;
  logic       mem_rd_ack;
  logic[31:0] mem_wr_addr;
  logic[31:0] mem_wr_data;
  logic       mem_wr_data_valid;
  logic       mem_wr_ack;
  
  logic[4:0]  reg_rd_addr_a;
  logic       reg_rd_addr_a_valid;
  logic[31:0] reg_rd_data_a;
  logic	      reg_rd_data_a_ack;

  logic[4:0]  reg_rd_addr_b;
  logic       reg_rd_addr_b_valid;
  logic[31:0] reg_rd_data_b;
  logic	      reg_rd_data_b_ack;

  logic[4:0]  reg_wr_addr;
  logic[31:0] reg_wr_data;
  logic	      reg_wr_data_valid;
  logic 	  reg_wr_ack;  
  
  
  ALU_OP_CODE  alu_op_code;
  logic[31:0]  alu_input_A;
  logic[31:0]  alu_input_B;
  logic        alu_reg_out;
  logic[4:0]   alu_reg_addr;
  logic        alu_mem_out;
  logic[31:0]  alu_mem_addr;

  logic        alu_pc_jump;
  logic        alu_inputs_valid;

  logic[31:0]  alu_pc_branch_data;
  logic        alu_pc_branch_data_valid;
  logic        alu_pc_branch_data_ack;
  logic 	   alu_input_ack;
  logic        alu_done;

  
  memory memory_(
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

  regfile regfile_(
  	.clk(clk),
    .reset(reset),
    .rd_addr_a(reg_rd_addr_a),
    .rd_addr_a_valid(reg_rd_addr_a_valid),
    .rd_data_a(reg_rd_data_a),
    .rd_data_a_ack(reg_rd_data_a_ack),

    .rd_addr_b(reg_rd_addr_b),
    .rd_addr_b_valid(reg_rd_addr_b_valid),
    .rd_data_b(reg_rd_data_b),
    .rd_data_b_ack(reg_rd_data_b_ack),

    .wr_addr(reg_wr_addr),
    .wr_data(reg_wr_data),
    .wr_data_valid(reg_wr_data_valid),
    .wr_ack(reg_wr_ack) 
  );
  
  ALU alu (
    .clk(clk),
    .reset(reset),
    .op_code(alu_op_code),
    .input_A(alu_input_A),
    .input_B(alu_input_B),
    .reg_out(alu_reg_out),
    .reg_addr(alu_reg_addr),
    .mem_out(alu_mem_out),
    .mem_addr(alu_mem_addr),

    .pc_jump(alu_pc_jump),
    .inputs_valid(alu_inputs_valid),

    .reg_wr_data(reg_wr_data),
    .reg_wr_addr(reg_wr_addr),
    .reg_wr_data_valid(reg_wr_data_valid),
    .reg_wr_ack(reg_wr_ack),

    .mem_wr_data(mem_wr_data),
    .mem_wr_addr(mem_wr_addr),
    .mem_wr_data_valid(mem_wr_data_valid),
    .mem_wr_ack(mem_wr_ack),

    .pc_branch_data(alu_pc_branch_data),
    .pc_branch_data_valid(alu_pc_branch_data_valid),
    .pc_branch_data_ack(alu_pc_branch_data_ack),
    
    .alu_input_ack(alu_input_ack),
    .alu_done(alu_done)
  );

risc_instructions_handler_2
rih
(
  .clk(clk),
  .reset(reset),
  
  // memory signals
  .mem_rd_addr(mem_rd_addr),
  .mem_rd_addr_valid(mem_rd_addr_valid),
  .mem_rd_data(mem_rd_data),
  .mem_rd_ack(mem_rd_ack),
  
  // registers signals
  .reg_rd_addr_a(reg_rd_addr_a),
  .reg_rd_addr_a_valid(reg_rd_addr_a_valid),
  .reg_rd_data_a(reg_rd_data_a),
  .reg_rd_data_a_ack(reg_rd_data_a_ack),
  
  .reg_rd_addr_b(reg_rd_addr_b),
  .reg_rd_addr_b_valid(reg_rd_addr_b_valid),  
  .reg_rd_data_b(reg_rd_data_b),
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
 
  .alu_pc_branch_data_valid(alu_done),
  .alu_pc_branch_data_ack(alu_pc_branch_data_ack),
  .alu_input_ack(alu_input_ack),
  .alu_done(alu_done));
  
endmodule