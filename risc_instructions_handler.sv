`include "ALU.sv"
`include "risc_instruction_constants.sv"



typedef enum logic [2:0] {
  None = 3'b000,
  R = 3'b001,
  I = 3'b010,
  S = 3'b011,
  B	= 3'b100
} 
RISC_INSTR_TYPE;


module risc_instructions_handler_2(
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
  input   logic 	  alu_input_ack,
  input   logic		  alu_done);

  
  logic[31:0] PC;
  logic[31:0] instruction;
  logic		  last_reset;
  logic	      last_alu_done;
  
  RISC_INSTR_TYPE risc_instruction;
  
  assign reset_negedge = ~reset && last_reset;
  
  
  /*
  assign risc_instruction =
    (mem_rd_ack && mem_rd_data[6:0] == 7'b0110011) ? R :
    (mem_rd_ack && mem_rd_data[6:0] == 7'b0010011) ? I :
    (mem_rd_ack && mem_rd_data[6:0] == 7'b0000011) ? I :
    (mem_rd_ack && mem_rd_data[6:0] == 7'b0100011) ? S :
    (mem_rd_ack && mem_rd_data[6:0] == 7'b1100011) ? B : None;
  */
  
  always @(posedge clk) begin
    if (reset) begin
      PC <= 1'b0;      
    end
    else if (alu_input_ack) begin
      $display("inc PC");
      PC <= PC + 1;
    end
  end
  
  
  
  // instruction fetch start and completion
  always @(posedge clk) begin    
    if (reset) begin
      last_reset <= 1'b1;
      mem_rd_addr_valid <= 1'b0;
    end
    else if (reset_negedge || alu_done) begin
      if (alu_done) begin
        $display("rih::alu_done");       
      end
      last_reset <= 1'b0;
      mem_rd_addr <= PC;
      mem_rd_addr_valid <= 1'b1;
    end
    else if (mem_rd_ack) begin
      mem_rd_addr_valid <= 1'b0;      
    end
  end
  
  
    
    
  // get instruction from memory and execution for R instruction
  always @(posedge clk) begin
    if (reset) begin
        reg_rd_addr_a_valid <= 1'b0;
        reg_rd_addr_b_valid <= 1'b0;      
    end
    else begin 
      if (mem_rd_ack && mem_rd_data[6:0] == 7'b0110011) begin
          instruction <= mem_rd_data;
          risc_instruction = R;
          reg_rd_addr_a <= mem_rd_data[19:15];
          reg_rd_addr_b <= mem_rd_data[24:20];
          reg_rd_addr_a_valid <= 1'b1;
          reg_rd_addr_b_valid <= 1'b1;
      end
      else begin 
        if (reg_rd_data_a_ack) begin
        	reg_rd_addr_a_valid <= 1'b0;
      	end
      	if (reg_rd_data_b_ack) begin
        	reg_rd_addr_b_valid <= 1'b0;      
      	end
      end
    end
  end
  
   always @(posedge clk) begin
    if (reset) begin
        reg_rd_addr_a_valid <= 1'b0;
        reg_rd_addr_b_valid <= 1'b0;      
    end
    else begin 
      if (mem_rd_ack && mem_rd_data[6:0] == 7'b0010011) begin
          instruction <= mem_rd_data;
          risc_instruction = I;
          reg_rd_addr_a <= mem_rd_data[19:15];
          reg_rd_addr_b <= mem_rd_data[24:20];
          reg_rd_addr_a_valid <= 1'b1;
          reg_rd_addr_b_valid <= 1'b1;
      end
      else begin 
        if (reg_rd_data_a_ack) begin
        	reg_rd_addr_a_valid <= 1'b0;
      	end
      	if (reg_rd_data_b_ack) begin
        	reg_rd_addr_b_valid <= 1'b0;      
      	end
      end
    end
  end
 
  
  
  
  // from reg to ALU
  always @(posedge clk) begin
    if (reset) begin
      alu_inputs_valid <= 1'b0;
    end
    else begin 
      if (alu_input_ack) begin
      	alu_inputs_valid <= 1'b0;
      end
      
      if (risc_instruction == R && reg_rd_data_a_ack && reg_rd_data_b_ack) begin
      
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

        alu_input_A  <= reg_rd_data_a;
        alu_input_B  <= reg_rd_data_b;
        alu_reg_addr <= instruction[11:7];
        alu_inputs_valid <= 1'b1;
        alu_reg_out  <= 1'b1; 
      end
    end     
  end
    
    
  
  
endmodule