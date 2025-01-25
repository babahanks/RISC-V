`include "ALU.sv"
`include "risc_instruction_constants.sv"

module risc_instructions_handler(
  input  logic 			  clk,
  input  logic 			  reset,
  
  // memory signals
  output logic[31:0]  mem_rd_addr,
  output logic		  mem_rd_addr_valid,
  input  logic[31:0]  mem_rd_data,
  input  logic        mem_rd_ack,
  
  // registers signals
  output logic[4:0]   reg_rd_addr_a,
  output logic 		  reg_rd_addr_a_valid,
  input  logic[31:0]  reg_rd_data_a,
  input  logic		  reg_rd_data_a_ack,
  
  output logic[4:0]   reg_rd_addr_b,
  output logic 		  reg_rd_addr_b_valid,  
  input  logic[31:0]  reg_rd_data_b,
  input  logic		  reg_rd_data_b_ack,

  
  
  // ALU signals
  output  ALU_OP_CODE alu_op_code,
  output  logic[31:0] alu_input_A,
  output  logic[31:0] alu_input_B,
  output  logic		  alu_reg_out,
  output  logic[4:0]  alu_reg_addr,
  output  logic		  alu_mem_out,
  output  logic[31:0] alu_mem_addr,

  output  logic       alu_pc_jump,
  output  logic       alu_inputs_valid,

  input   logic[31:0] alu_pc_branch_data, 
  input   logic       alu_pc_branch_data_valid,
  output  logic       alu_pc_branch_data_ack,
  
  input   logic		  done);

  
  logic[31:0] PC;
  logic		  inProcess;
  logic 	  gettingInstruction;
  logic[31:0] instruction;
  logic 	  gettingRegData;
  
  
  
  always_ff @(posedge clk) begin
    
    if (reset) begin
      mem_rd_addr_valid <= 1'b0;
      reg_rd_addr_a_valid <= 1'b0;
      reg_rd_addr_b_valid <= 1'b0;
      alu_inputs_valid <= 1'b0;
      inProcess <= 1'b0;
      gettingInstruction <= 1'b0;
	  gettingRegData <= 1'b0;
      
      PC <= 32'b0;
    end
    
    // request instruction from memory
    else if (~inProcess) begin
      inProcess <= 1'b1;
      gettingInstruction <= 1'b1;
      mem_rd_addr <= PC;
      mem_rd_addr_valid <= 1'b1;      
    end
    
    // receive instruction from memory
    else if (inProcess && gettingInstruction  && mem_rd_ack) begin
      instruction <= mem_rd_data;
      if (instruction[6:0] == 7'b0110011) begin        
        gettingRegData <= 1'b1;
        reg_rd_addr_a <= mem_rd_data[19:15];
        reg_rd_addr_b <= mem_rd_data[24:20];
        //reg_wr_addr <= instruction[11:7];
        reg_rd_addr_a_valid <= 1'b1;
        reg_rd_addr_b_valid <= 1'b1;
      end      
    end
    else if (inProcess && 
      		 gettingRegData  && 
      		 reg_rd_data_a_ack && 
      		 reg_rd_data_b_ack) 
      begin      
      if (instruction[14:12] == `RISC_R_FUNC_3_ADD && 
          instruction[31:25] == `RISC_R_FUNC_7_ADD)
        begin
          $display("instruction: ADD");
          alu_op_code <= ADD;                
        end
      else if (instruction[14:12] == `RISC_R_FUNC_3_SUBTRACT && 
               instruction[31:25] == `RISC_R_FUNC_7_SUBTRACT)
        begin
          alu_op_code <= SUBTRACT;                
        end
      else if (instruction[14:12] == `RISC_R_FUNC_3_XOR && 
               instruction[31:25] == `RISC_R_FUNC_7_XOR)
        begin
          alu_op_code <= XOR;                
        end
      else if (instruction[14:12] == `RISC_R_FUNC_3_OR && 
               instruction[31:25] == `RISC_R_FUNC_7_OR)
        begin
          alu_op_code <= OR;                
        end
      else if (instruction[14:12] == `RISC_R_FUNC_3_AND && 
               instruction[31:25] == `RISC_R_FUNC_7_AND)
        begin
          alu_op_code <= AND;                
        end
      else if (instruction[14:12] == `RISC_R_FUNC_3_SHIFT_LT_LOG && 
               instruction[31:25] == `RISC_R_FUNC_7_SHIFT_LT_LOG)
        begin
          alu_op_code <= SHIFT_LT_LOG;                
        end  
      else if (instruction[14:12] == `RISC_R_FUNC_3_SHIFT_RT_LOG && 
               instruction[31:25] == `RISC_R_FUNC_7_SHIFT_RT_LOG)
        begin
          alu_op_code <= SHIFT_RT_LOG;                
        end            
      else if (instruction[14:12] == `RISC_R_FUNC_3_SHIFT_RT_AR && 
               instruction[31:25] == `RISC_R_FUNC_7_SHIFT_RT_AR)
        begin
          alu_op_code <= SHIFT_RT_AR;                
        end                  
      alu_reg_out  <= 1'b1;
      alu_input_A  <= reg_rd_data_a;
      alu_input_B  <= reg_rd_data_b;
      alu_reg_addr <= instruction[11:7];
      alu_reg_out  <= 1'b1;  
      alu_inputs_valid <= 1'b1;
    end
    else if (inProcess && done) begin
      inProcess <= 1'b0;
      
    end
      
  end
  
       
endmodule
  
  