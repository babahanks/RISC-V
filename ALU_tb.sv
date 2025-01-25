`include "ALU.sv"


module ALU_tb();
  logic        clk;
  logic 	   reset;
  ALU_OP_CODE  op_code;
  logic[31:0]  input_A;
  logic[31:0]  input_B;
  logic		   reg_out;
  logic[4:0]   reg_addr;
  logic		   mem_out;
  logic[31:0]  mem_addr;
  logic        pc_jump;
  logic        inputs_valid;
  
  logic[31:0]  reg_wr_data;
  logic[4:0]   reg_wr_addr;
  logic		   reg_wr_data_valid;
  logic        reg_wr_ack;
  
  logic[31:0]  mem_wr_data;
  logic[31:0]  mem_wr_addr;
  logic		   mem_wr_data_valid;
  logic        mem_wr_ack;
  
  
  logic[31:0]  pc_branch_data;
  logic        pc_branch_data_valid;
  logic        pc_branch_data_ack;
  logic        done;
  
  ALU alu(
    .clk(clk),
    .reset(reset),
    .op_code(op_code),
    .input_A(input_A),
    .input_B(input_B),
    .reg_out(reg_out),
    .reg_addr(reg_addr),
    .mem_out(mem_out),
    .mem_addr(mem_addr),
    .pc_jump(pc_jump),
    .inputs_valid(inputs_valid),

    .reg_wr_data(reg_wr_data),
    .reg_wr_addr(reg_wr_addr),
    .reg_wr_data_valid(reg_wr_data_valid),
    .reg_wr_ack(reg_wr_ack),

    .mem_wr_data(mem_wr_data),
    .mem_wr_addr(mem_wr_addr),
    .mem_wr_data_valid(mem_wr_data_valid),
    .mem_wr_ack(mem_wr_ack),


    .pc_branch_data(pc_branch_data),
    .pc_branch_data_valid(pc_branch_data_valid),
    .pc_branch_data_ack(pc_branch_data_ack),
    .done(done)
  );
  
  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end
  
  initial begin
    reset = 1'b1;
    @(posedge clk);
    @(posedge clk);
    @(posedge clk);
    assert(reg_wr_data_valid == 1'b0) 
      else $error("reg_wr_data_valid should be %b. it is %b", 
                   1'b0, 
                   reg_wr_data_valid); 

    assert(mem_wr_data_valid == 1'b0) 
      else $error("mem_wr_data_valid should be %b. it is %b", 
                   1'b0, 
                   mem_wr_data_valid); 
    
    assert(pc_branch_data_valid == 1'b0) 
      else $error("pc_branch_data_valid should be %b. it is %b", 
                   1'b0, 
                   pc_branch_data_valid); 
    
    assert(done == 1'b0) 
      else $error("done should be %b. it is %b", 
                   1'b0, 
                   done); 
       
    
    reset = 1'b0;
    @(posedge clk);
    @(posedge clk);
    
    reg_wr_ack = 1'b0;
    mem_wr_ack = 1'b0;
    pc_branch_data_ack = 1'b0;

    input_A = 32'b1;
    input_B = 32'b1;
    op_code = ADD;

    reg_out = 1'b1;
    mem_out = 1'b0;
    pc_jump = 1'b0;
    reg_addr = 5'b101;
    inputs_valid = 1'b1;
    
    @(posedge clk);
    
    assert(reg_wr_data_valid == 1'b1) 
      else $error("reg_wr_data_valid should be %b. it is %b", 
                   1'b1, 
                   reg_wr_data_valid); 

    assert(mem_wr_data_valid == 1'b0) 
      else $error("mem_wr_data_valid should be %b. it is %b", 
                   1'b0, 
                   mem_wr_data_valid); 
    
    assert(pc_branch_data_valid == 1'b0) 
      else $error("pc_branch_data_valid should be %b. it is %b", 
                   1'b0, 
                   pc_branch_data_valid); 

    assert(reg_wr_addr == 5'b101) 
      else $error("reg_wr_addr should be %b. it is %b", 
                   5'b101, 
                   reg_wr_addr); 
    
    assert(reg_wr_data == 32'b10) 
      else $error("reg_wr_data should be %b. it is %b", 
                   32'b10, 
                   reg_wr_data); 
    
    assert(done == 1'b0) 
      else $error("done should be %b. it is %b", 
                   1'b0, 
                   done); 
    
    reg_wr_ack = 1'b1;
    
    @(posedge clk);
    assert(reg_wr_data_valid == 1'b0) 
      else $error("reg_wr_data_valid should be %b. it is %b", 
                   1'b0, 
                   reg_wr_data_valid); 

    assert(mem_wr_data_valid == 1'b0) 
      else $error("mem_wr_data_valid should be %b. it is %b", 
                   1'b0, 
                   mem_wr_data_valid); 
    
    assert(pc_branch_data_valid == 1'b0) 
      else $error("pc_branch_data_valid should be %b. it is %b", 
                   1'b0, 
                   pc_branch_data_valid); 

    
    assert(done == 1'b1) 
      else $error("done should be %b. it is %b", 
                   1'b1, 
                   done); 
    
   
    @(posedge clk);
    @(posedge clk);
    @(posedge clk);
    @(posedge clk);
    
    input_A = 32'b10;
    input_B = 32'b10;
    op_code = ADD;

    reg_wr_ack = 1'b0;
    reg_out = 1'b0;
    mem_out = 1'b1;
    pc_jump = 1'b0;
    mem_addr = 32'b111;
    inputs_valid = 1'b1;
    
    @(posedge clk);
    
    assert(reg_wr_data_valid == 1'b0) 
      else $error("reg_wr_data_valid should be %b. it is %b", 
                   1'b0, 
                   reg_wr_data_valid); 

    assert(mem_wr_data_valid == 1'b1) 
      else $error("mem_wr_data_valid should be %b. it is %b", 
                   1'b1, 
                   mem_wr_data_valid); 
    
    assert(pc_branch_data_valid == 1'b0) 
      else $error("pc_branch_data_valid should be %b. it is %b", 
                   1'b0, 
                   pc_branch_data_valid); 

    assert(mem_wr_addr == 32'b111) 
      else $error("mem_wr_addr should be %b. it is %b", 
                   5'b101, 
                   mem_wr_addr); 
    
    assert(mem_wr_data == 32'b100) 
      else $error("mem_wr_data should be %b. it is %b", 
                   32'b100, 
                   mem_wr_data); 
    
    assert(done == 1'b0) 
      else $error("done should be %b. it is %b", 
                   1'b0, 
                   done); 
    
    mem_wr_ack = 1'b1;
    @(posedge clk);
    
    @(posedge clk);
    assert(reg_wr_data_valid == 1'b0) 
      else $error("reg_wr_data_valid should be %b. it is %b", 
                   1'b0, 
                   reg_wr_data_valid); 

    assert(mem_wr_data_valid == 1'b0) 
      else $error("mem_wr_data_valid should be %b. it is %b", 
                   1'b0, 
                   mem_wr_data_valid); 
    
    assert(pc_branch_data_valid == 1'b0) 
      else $error("pc_branch_data_valid should be %b. it is %b", 
                   1'b0, 
                   pc_branch_data_valid); 

    
    assert(done == 1'b1) 
      else $error("done should be %b. it is %b", 
                   1'b1, 
                   done); 
    
    
    
    mem_wr_ack = 1'b0;
    
    reg_out = 1'b0;
    mem_out = 1'b0;
    pc_jump = 1'b1;
    inputs_valid = 1'b1;
    
    @(posedge clk);
    
    assert(reg_wr_data_valid == 1'b0) 
      else $error("reg_wr_data_valid should be %b. it is %b", 
                   1'b0, 
                   reg_wr_data_valid); 

    assert(mem_wr_data_valid == 1'b0) 
      else $error("mem_wr_data_valid should be %b. it is %b", 
                   1'b0, 
                   mem_wr_data_valid); 
    
    assert(pc_branch_data_valid == 1'b1) 
      else $error("pc_branch_data_valid should be %b. it is %b", 
                   1'b1, 
                   pc_branch_data_valid); 
    
    assert(pc_branch_data == 32'b100) 
      else $error("pc_branch_data should be %b. it is %b", 
                   32'b100, 
                   pc_branch_data); 
    
    $finish();
    
   
  end
  
endmodule