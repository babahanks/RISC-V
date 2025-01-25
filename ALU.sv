typedef enum logic [3:0] {
  
  ADD         = 4'b0000,
  SUBTRACT      = 4'b0001,
  XOR       = 4'b0010,
  OR        = 4'b0011,
  AND       = 4'b0100,
  SHIFT_LT_LOG    = 4'b0101,
  SHIFT_RT_LOG    = 4'b0110,
  SHIFT_RT_AR   = 4'b0111,
  BARREL_SHIFTER  = 4'b1000,
  IS_EQUAL      = 4'b1001,
  IS_GREATER    = 4'b1010
} 
ALU_OP_CODE;


module ALU(
  input  logic        clk,
  input  logic        reset,
  input  ALU_OP_CODE  op_code,
  input  logic[31:0]  input_A,
  input  logic[31:0]  input_B,
  input  logic		  reg_out,
  input  logic[4:0]   reg_addr,
  input  logic		  mem_out,
  input  logic[31:0]  mem_addr,

  input  logic        pc_jump,
  input  logic        inputs_valid,
  
  output logic[31:0]  reg_wr_data,
  output logic[4:0]   reg_wr_addr,
  output logic		  reg_wr_data_valid,
  input  logic        reg_wr_ack,
  
  output logic[31:0]  mem_wr_data,
  output logic[31:0]  mem_wr_addr,
  output logic		  mem_wr_data_valid,
  input  logic        mem_wr_ack,
  
  
  output logic[31:0]  pc_branch_data,
  output logic        pc_branch_data_valid,
  input  logic        pc_branch_data_ack,
  output logic 		  alu_input_ack,
  output logic 		  alu_done
  );
  
  logic[31:0] result;
  
    always_ff @(posedge clk) begin
    if (reset) begin
      alu_input_ack <= 1'b0;
    end
    else begin 
      if (inputs_valid && ~alu_input_ack) begin
        $display("alu_input_ack <= 1'b1;");
      	alu_input_ack <= 1'b1;
      end
      else if (alu_input_ack) begin
        $display("alu_input_ack <= 1'b0;");
      	alu_input_ack <= 1'b0;  // bring it down next clk cycle.
      end
    end
  end
   
  
  always_ff @(posedge clk) begin
    if (reset) begin
      alu_done <= 1'b0;      
    end   
    else if ((reg_wr_ack || mem_wr_ack) && ~ alu_done ) begin
      alu_done <= 1'b1;
    end 
    else if (alu_done) begin
      alu_done <= 1'b0;  // bring it down next clk cycle.
    end

  end
  
  
  always_ff @(posedge clk) begin
    if (reset || ~inputs_valid) begin
      reg_wr_data_valid <= 1'b0;      
    end
    else if (inputs_valid  && reg_out) begin
      reg_wr_addr  <= reg_addr;
      reg_wr_data_valid <= 1'b1;
      case (op_code)
        ADD:       reg_wr_data <= input_A + input_B;               
        SUBTRACT:  reg_wr_data <= input_A - input_B;
        XOR:       reg_wr_data <= input_A ^ input_B;
        OR:        reg_wr_data <= input_A | input_B;
        AND:       reg_wr_data <= input_A & input_B;
        SHIFT_LT_LOG:   reg_wr_data <= input_A << input_B;
        SHIFT_RT_LOG:   reg_wr_data <= input_A >> input_B;
        SHIFT_RT_AR:    reg_wr_data <= input_A >>> input_B;
        //BARREL_SHIFTER: 
        IS_EQUAL:     reg_wr_data <= input_A == input_B;
        IS_GREATER:   reg_wr_data <= input_A > input_B; 
      endcase
    end
    else if (reg_wr_ack) begin
      reg_wr_data_valid <= 1'b0;
    end    
  end
  
 
  always_ff @(posedge clk) begin
    if (reset || ~inputs_valid) begin
      mem_wr_data_valid <= 1'b0;      
    end
    else if (inputs_valid  && mem_out) begin
      mem_wr_addr  <= mem_addr;
      mem_wr_data_valid <= 1'b1;
      case (op_code)
        ADD:       mem_wr_data <= input_A + input_B;               
        SUBTRACT:  mem_wr_data <= input_A - input_B;
        XOR:       mem_wr_data <= input_A ^ input_B;
        OR:        mem_wr_data <= input_A | input_B;
        AND:       mem_wr_data <= input_A & input_B;
        SHIFT_LT_LOG:   mem_wr_data <= input_A << input_B;
        SHIFT_RT_LOG:   mem_wr_data <= input_A >> input_B;
        SHIFT_RT_AR:    mem_wr_data <= input_A >>> input_B;
        //BARREL_SHIFTER: 
        IS_EQUAL:     mem_wr_data <= input_A == input_B;
        IS_GREATER:   mem_wr_data <= input_A > input_B; 
      endcase
    end
    else if (mem_wr_ack) begin
      mem_wr_data_valid <= 1'b0;
    end       
  end
  
  

  
  /*
  always_ff @(posedge clk) begin
    if (reset) begin
      reg_wr_data_valid <= 1'b0;
      mem_wr_data_valid <= 1'b0;
      pc_branch_data_valid <= 1'b0;
      alu_done <= 1'b0;
    end
    else if (~inputs_valid) begin
      reg_wr_data_valid <= 1'b0;
      mem_wr_data_valid <= 1'b0;
      pc_branch_data_valid <= 1'b0;
      alu_done <= 1'b0;
    end
    else if (reg_wr_ack) begin
      reg_wr_data_valid <= 1'b0;
      alu_done <= 1'b1;
    end
    else if (mem_wr_ack) begin
      mem_wr_data_valid <= 1'b0;
      alu_done <= 1'b1;
    end
    else if (pc_branch_data_ack) begin
      pc_branch_data_valid <= 1'b0;
      alu_done <= 1'b1;
    end
    else if (inputs_valid  && reg_out) begin
      reg_wr_addr  <= reg_addr;
      reg_wr_data_valid <= 1'b1;
      mem_wr_data_valid <= 1'b0;
      pc_branch_data_valid <= 1'b0;
      alu_done <= 1'b0;
      case (op_code)
        ADD:       reg_wr_data <= input_A + input_B;               
        SUBTRACT:  reg_wr_data <= input_A - input_B;
        XOR:       reg_wr_data <= input_A ^ input_B;
        OR:        reg_wr_data <= input_A | input_B;
        AND:       reg_wr_data <= input_A & input_B;
        SHIFT_LT_LOG:   reg_wr_data <= input_A << input_B;
        SHIFT_RT_LOG:   reg_wr_data <= input_A >> input_B;
        SHIFT_RT_AR:    reg_wr_data <= input_A >>> input_B;
        //BARREL_SHIFTER: 
        IS_EQUAL:     reg_wr_data <= input_A == input_B;
        IS_GREATER:   reg_wr_data <= input_A > input_B; 
      endcase
    end
    else if (inputs_valid  && mem_out) begin
      mem_wr_addr  <= mem_addr;
      reg_wr_data_valid <= 1'b0;
      mem_wr_data_valid <= 1'b1;
      pc_branch_data_valid <= 1'b0;
      alu_done <= 1'b0;
      case (op_code)
        ADD:       mem_wr_data <= input_A + input_B;               
        SUBTRACT:  mem_wr_data <= input_A - input_B;
        XOR:       mem_wr_data <= input_A ^ input_B;
        OR:        mem_wr_data <= input_A | input_B;
        AND:       mem_wr_data <= input_A & input_B;
        SHIFT_LT_LOG:   mem_wr_data <= input_A << input_B;
        SHIFT_RT_LOG:   mem_wr_data <= input_A >> input_B;
        SHIFT_RT_AR:    mem_wr_data <= input_A >>> input_B;
        //BARREL_SHIFTER: 
        IS_EQUAL:     mem_wr_data <= input_A == input_B;
        IS_GREATER:   mem_wr_data <= input_A > input_B; 
      endcase
    end
    else if (inputs_valid  && pc_jump) begin
      reg_wr_data_valid <= 1'b0;
      mem_wr_data_valid <= 1'b0;
      pc_branch_data_valid <= 1'b1;
      alu_done <= 1'b0;
      case (op_code)
        ADD:       pc_branch_data <= input_A + input_B;               
        SUBTRACT:  pc_branch_data <= input_A - input_B;
        XOR:       pc_branch_data <= input_A ^ input_B;
        OR:        pc_branch_data <= input_A | input_B;
        AND:       pc_branch_data <= input_A & input_B;
        SHIFT_LT_LOG:   pc_branch_data <= input_A << input_B;
        SHIFT_RT_LOG:   pc_branch_data <= input_A >> input_B;
        SHIFT_RT_AR:    pc_branch_data <= input_A >>> input_B;
        //BARREL_SHIFTER: 
        IS_EQUAL:     pc_branch_data <= input_A == input_B;
        IS_GREATER:   pc_branch_data <= input_A > input_B; 
      endcase
    end     
  end  
  */
  
endmodule