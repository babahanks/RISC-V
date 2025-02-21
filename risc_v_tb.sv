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
  
  task fetch_and_run_R_inst(
    input logic[31:0] exp_PC,
    input logic[31:0] exp_instruction,
    input logic[4:0]  exp_reg_rd_addr_a,
    input logic[4:0]  exp_reg_rd_addr_b,
    input logic[31:0] exp_reg_rd_data_a,
    input logic[31:0] exp_reg_rd_data_b,
    input ALU_OP_CODE exp_alu_code,
    input logic[31:0] exp_reg_wr_addr,
    input logic[31:0] exp_reg_wr_data);
    

    @(posedge clk);
    $display("clk: 1");
    setupToGetInstruction(exp_PC);
    
    @(posedge clk);  // spent in memory
    $display("clk: 2");
    
    @(posedge clk);  // instruction received
    $display("clk: 3");             
    setUpRegDataFromInstruction_R(
      exp_instruction,
      exp_reg_rd_addr_a,
      exp_reg_rd_addr_b);
    
    @(posedge clk);
    $display("clk: 4");
    getRegData_R(
      exp_reg_rd_data_a,
      exp_reg_rd_data_b);
    
    @(posedge clk);
    $display("clk: 5");
    setUpALUCall(
      exp_reg_rd_data_a,
      exp_reg_rd_data_b,
      exp_alu_code);
    
    @(posedge clk);
    $display("clk: 6");
    aluWriteResultToReg(
      exp_reg_wr_addr,
      exp_reg_wr_data);
    
    @(posedge clk)
    $display("clk: 7");
	checkDataWrittenInReg(
    	exp_reg_wr_addr,
      	exp_reg_wr_data);  
    
    @(posedge clk);
    $display("clk: 8");
    //rihReceivesAluDone();

    //@(posedge clk);
    //$display("clk: 9");
    //rihReceivesAluDoneDown();
    
    //@(posedge clk);
    //$display("clk: 10");

    //@(posedge clk);
    //$display("clk: 11");
    
    
  endtask
  
  
  task fetch_and_run_I_inst(
    input logic[31:0] exp_PC,
    input logic[31:0] exp_instruction,
    input logic[4:0]  exp_reg_rd_addr_a,
    input logic[31:0] exp_reg_rd_data_a,
    input logic[31:0] exp_immediate_value,
    input ALU_OP_CODE exp_alu_code,
    input logic[31:0] exp_reg_wr_addr,
    input logic[31:0] exp_reg_wr_data);
    

    @(posedge clk);
    $display("clk: 1");
    setupToGetInstruction(exp_PC);
    
    @(posedge clk);  // spent in memory
    $display("clk: 2");
    
    @(posedge clk);  // instruction received
    $display("clk: 3");             
    setUpRegDataFromInstruction_I(
      exp_instruction,
      exp_reg_rd_addr_a);
    
    @(posedge clk);
    $display("clk: 4");
    getRegData_I(
      exp_reg_rd_data_a);
    
    @(posedge clk);
    $display("clk: 5");
    setUpALUCall(
      exp_reg_rd_data_a,
      exp_immediate_value,
      exp_alu_code);
    
    @(posedge clk);
    $display("clk: 6");
    aluWriteResultToReg(
      exp_reg_wr_addr,
      exp_reg_wr_data);
    
    @(posedge clk)
    $display("clk: 7");
	checkDataWrittenInReg(
    	exp_reg_wr_addr,
      	exp_reg_wr_data);  
    
    @(posedge clk);
    $display("clk: 8");
    //rihReceivesAluDone();

    //@(posedge clk);
    //$display("clk: 9");
    //rihReceivesAluDoneDown();
    
    //@(posedge clk);
    //$display("clk: 10");

    //@(posedge clk);
    //$display("clk: 11");
    
    
  endtask
  
  task setupToGetInstruction(
    input logic[31:0] exp_PC);
    
   
    $display();
    $display("Setting up to get instruction");
    
    assert(r.rih.PC == exp_PC)
      else $error("exp_PC: %b. it is %b", 
                   exp_PC, 
                   r.rih.PC); 
    
    assert(r.mem_rd_addr_valid == 1'b1) 
      else $error("r.mem_rd_addr_valid: %b. it is %b", 
                   1'b1, 
                   r.mem_rd_addr_valid); 
    
    assert(r.reg_rd_addr_a_valid == 1'b0) 
      else $error("r.reg_rd_addr_a_valid should be %b. it is %b", 
                   1'b0, 
                   r.reg_rd_addr_a_valid);
    
    assert(r.reg_rd_addr_b_valid == 1'b0) 
      else $error("r.reg_rd_addr_b_valid should be %b. it is %b", 
                   1'b0, 
                   r.reg_rd_addr_b_valid);    

  endtask
  
  
  task setUpRegDataFromInstruction_R(
    input logic[31:0] exp_instruction,
    input logic[4:0]  exp_reg_rd_addr_a,
    input logic[4:0]  exp_reg_rd_addr_b);
    
    
    //@(posedge clk);
    $display();    
    $display("Instruction received");
    assert(r.mem_rd_data == exp_instruction) 
      else $error("expected_instruction: should be %b. it is %b", 
                   exp_instruction, 
                   r.mem_rd_data); 
    
    assert(r.reg_rd_addr_a == exp_reg_rd_addr_a) 
      else $error("r.reg_rd_addr_a should be %b. it is %b", 
                   exp_reg_rd_addr_a, 
                   r.reg_rd_addr_a); 
    
    assert(r.reg_rd_addr_b == exp_reg_rd_addr_b) 
      else $error("r.reg_rd_addr_b should be %b. it is %b", 
                   exp_reg_rd_addr_b, 
                   r.reg_rd_addr_b); 
    
        
    assert(r.reg_rd_addr_a_valid == 1'b1) 
      else $error("r.reg_rd_addr_a_valid should be %b. it is %b", 
                   1'b1, 
                   r.reg_rd_addr_a_valid); 
    
    assert(r.reg_rd_addr_b_valid == 1'b1) 
      else $error("r.reg_rd_addr_b_valid should be %b. it is %b", 
                   1'b1, 
                   r.reg_rd_addr_b_valid);    

  endtask
    
  task setUpRegDataFromInstruction_I(
      input logic[31:0] exp_instruction,
      input logic[4:0]  exp_reg_rd_addr_a);
    
    
    //@(posedge clk);
    $display();    
    $display("Instruction received");
    assert(r.mem_rd_data == exp_instruction) 
      else $error("expected_instruction: should be %b. it is %b", 
                   exp_instruction, 
                   r.mem_rd_data); 
    
    assert(r.reg_rd_addr_a == exp_reg_rd_addr_a) 
      else $error("r.reg_rd_addr_a should be %b. it is %b", 
                   exp_reg_rd_addr_a, 
                   r.reg_rd_addr_a); 
            
    assert(r.reg_rd_addr_a_valid == 1'b1) 
      else $error("r.reg_rd_addr_a_valid should be %b. it is %b", 
                   1'b1, 
                   r.reg_rd_addr_a_valid); 
    
  endtask
  
  
  
  task getRegData_R(
    input logic[31:0] exp_reg_rd_data_a,
    input logic[31:0] exp_reg_rd_data_b);

    $display();
    $display("Received Reg Data");

    assert(r.reg_rd_data_a == exp_reg_rd_data_a) 
      else $error("r.reg_rd_data_a should be %b. it is %b", 
                   exp_reg_rd_data_a, 
                   r.reg_rd_data_a); 
    
    assert(r.reg_rd_data_b == exp_reg_rd_data_b) 
      else $error("r.reg_rd_data_b should be %b. it is %b", 
                   exp_reg_rd_data_b, 
                   r.reg_rd_data_b); 
       
  endtask
  
  task getRegData_I(
    input logic[31:0] exp_reg_rd_data_a);

    $display();
    $display("Received Reg Data");

    assert(r.reg_rd_data_a == exp_reg_rd_data_a) 
      else $error("r.reg_rd_data_a should be %b. it is %b", 
                   exp_reg_rd_data_a, 
                   r.reg_rd_data_a); 
           
  endtask
  
  
  
  
  
  task setUpALUCall(
    input logic[31:0] exp_alu_input_A,
    input logic[31:0] exp_alu_input_B,
    input ALU_OP_CODE exp_alu_code);
    
    $display();
    $display("Setup ALU call");

    assert(r.rih.alu_input_A == exp_alu_input_A) 
      else $error("r.rih.alu_input_A should be %b. it is %b", 
                   exp_alu_input_A, 
                   r.rih.alu_input_A); 
    
    assert(r.rih.alu_input_B == exp_alu_input_B) 
      else $error("r.rih.alu_input_B should be %b. it is %b", 
                   exp_alu_input_B, 
                   r.rih.alu_input_B); 
    
    assert(r.rih.alu_op_code == exp_alu_code) 
      else $error("r.rih.alu_op_code should be %b. it is %b", 
                   exp_alu_code, 
                   r.rih.alu_op_code); 
   
  endtask
  
  
  task aluWriteResultToReg(
    input logic[31:0] exp_reg_wr_addr,
    input logic[31:0] exp_reg_wr_data);
    
    $display();
    $display("aluWriteResultToReg");
    
    
    assert(r.alu.reg_wr_data == exp_reg_wr_data) 
      else $error("r.alu.reg_wr_data should be %b. it is %b", 
                   exp_reg_wr_data, 
                   r.alu.reg_wr_data); 
    
    assert(r.alu.reg_wr_addr == exp_reg_wr_addr) 
      else $error("r.alu.reg_wr_addr should be %b. it is %b", 
                   exp_reg_wr_addr, 
                   r.alu.reg_wr_addr); 

    assert(r.alu.reg_wr_data_valid == 1'b1) 
      else $error("r.alu.reg_wr_data_valid should be %b. it is %b", 
                   1'b1, 
                   r.alu.reg_wr_data_valid); 
    
  endtask
  
  task checkDataWrittenInReg(
    input logic[31:0] exp_reg_wr_addr,
    input logic[31:0] exp_reg_wr_data);
    
    $display();
    $display("checkDataWrittenInReg");

    
    assert(r.regfile_.registers[exp_reg_wr_addr] == exp_reg_wr_data) 
      else $error("r.regfile_.registers[exp_reg_wr_addr] should be %b. it is %b", 
                   exp_reg_wr_data, 
                   r.regfile_.registers[exp_reg_wr_addr]); 

    
  endtask
  
  
  task rihReceivesAluDone();
    $display("RIH receives ALU done signal");
    
    assert(r.rih.alu_done == 1'b1) 
      else $error("r.rih.alu_done should be %b. it is %b", 
                   1'b1, 
                   r.rih.alu_done);    
  endtask

  task rihReceivesAluDoneDown();
    $display("RIH receives ALU done down signal");
    
    assert(r.rih.alu_done == 1'b0) 
      else $error("r.rih.alu_done should be %b. it is %b", 
                   1'b0, 
                   r.rih.alu_done);    
  endtask
  
    
  initial begin
    reset = 1'b1;    
    @(posedge clk);
    @(posedge clk);
    @(posedge clk);
        
    assert(r.mem_rd_addr_valid == 1'b0) 
      else $error("r.mem_rd_addr_valid should be %b. it is %b", 
                   1'b0, 
                   r.mem_rd_addr_valid); 
    reset = 1'b0; 
    
    fetch_and_run_R_inst(
      32'b0, // exp_PC,
      32'b0000000000100000000000100110011, // exp_instruction,
      5'b0,  // exp_reg_rd_addr_a,
      5'b1,  // exp_reg_rd_addr_b,
      32'b101011, // exp_reg_rd_data_a,
      32'b101010, // exp_reg_rd_data_b,
      ADD,    // exp_alu_code,
      5'b10,  //exp_reg_wr_addr,
      32'b1010101 //exp_reg_wr_data
    );
	
    fetch_and_run_R_inst(
      32'b1, // exp_PC,
      32'b00000000010000011000001010110011, // exp_instruction,
      5'b11,  // exp_reg_rd_addr_a,
      5'b100,  // exp_reg_rd_addr_b,
      32'b101111, // exp_reg_rd_data_a,
      32'b101011, // exp_reg_rd_data_b,
      ADD,    // exp_alu_code,
      5'b101,  //exp_reg_wr_addr,
      32'b1011010 //exp_reg_wr_data
    );
    
    fetch_and_run_R_inst(
      32'b10, // exp_PC,
      32'b01000000010000011000001100110011, // exp_instruction,
      5'b11,  // exp_reg_rd_addr_a,
      5'b100,  // exp_reg_rd_addr_b,
      32'b101111, // exp_reg_rd_data_a,
      32'b101011, // exp_reg_rd_data_b,
      SUBTRACT,    // exp_alu_code,
      5'b110,  //exp_reg_wr_addr,
      32'b000100 //exp_reg_wr_data
    );
    
    
    fetch_and_run_I_inst(
      32'b11, //exp_PC,
      32'b00000000101000001000001110010011,  // exp_instruction,
      5'b1, // exp_reg_rd_addr_a,
      32'b101010, // exp_reg_rd_data_a,
      12'b1010, // exp_immediate_value,
      ADD, //exp_alu_code,
      5'b111, // exp_reg_wr_addr,
      32'b110100 //exp_reg_wr_data
    );
    


    $finish();
    
  end
  
  
  /*
  
  initial begin
    
    reset = 1'b1;
    
    @(posedge clk);
    @(posedge clk);
    @(posedge clk);
    
    
    
    assert(r.mem_rd_addr_valid == 1'b0) 
      else $error("r.mem_rd_addr_valid should be %b. it is %b", 
                   1'b0, 
                   r.mem_rd_addr_valid); 

    reset = 1'b0;
    
    @(posedge clk);
    $display("1");
    $display("clk");
    
    assert(r.mem_rd_addr_valid == 1'b1) 
      else $error("r.mem_rd_addr_valid should be %b. it is %b", 
                   1'b1, 
                   r.mem_rd_addr_valid); 
    
    assert(r.reg_rd_addr_a_valid == 1'b0) 
      else $error("r.reg_rd_addr_a_valid should be %b. it is %b", 
                   1'b0, 
                   r.reg_rd_addr_a_valid); 


    @(posedge clk);
    $display("2");
    $display("clk");    
    assert(r.mem_rd_data == 32'b0000000000100000000000100110011) 
      else $error("r.mem_rd_data should be %b. it is %b", 
                   32'b0000000000100000000000100110011, 
                   r.mem_rd_data); 
    assert(r.reg_rd_addr_a_valid == 1'b0) 
      else $error("r.reg_rd_addr_a_valid should be %b. it is %b", 
                   1'b0, 
                   r.reg_rd_addr_a_valid); 
  
    @(posedge clk);
    $display("3");
    $display("clk");
    
    $display("r.reg_rd_addr_a: %b", r.reg_rd_addr_a);
    $display("r.reg_rd_addr_b: %b", r.reg_rd_addr_b);

    $display("r.regfile_.rd_data_a_ack: %b", r.regfile_.rd_data_a_ack);
    $display("r.regfile_.rd_data_b_ack: %b", r.regfile_.rd_data_a_ack);

    $display("r.regfile_.rd_data_a: %b", r.regfile_.rd_data_a);
    $display("r.regfile_.rd_data_b: %b", r.regfile_.rd_data_b);
    
    @(posedge clk);
    $display("4");
    $display("clk");
    $display("r.reg_rd_data_a_ack: %b", r.reg_rd_data_a_ack);
    $display("r.reg_rd_data_b_ack: %b", r.reg_rd_data_b_ack);

    $display("r.reg_rd_addr_a: %b", r.reg_rd_addr_a);
    $display("r.reg_rd_addr_b: %b", r.reg_rd_addr_b);
    
    assert(r.reg_rd_addr_a == 1'b0) 
      else $error("r.reg_rd_addr_a should be %b. it is %b", 
                   5'b00000, 
                   r.reg_rd_addr_a); 
    assert(r.reg_rd_addr_b == 1'b0) 
      else $error("r.reg_rd_addr_b should be %b. it is %b", 
                   5'b00001, 
                   r.reg_rd_addr_b); 
    
    
    
    @(posedge clk);
    $display("5");
    $display("clk");
    $display("r.alu_input_A: %b", r.alu_input_A);
    $display("r.alu_input_B: %b", r.alu_input_B);

    $display("r.alu_reg_addr: %b", r.alu_reg_addr);
    $display("r.alu_reg_out: %b", r.alu_reg_out);
    $display("r.alu_op_code: %b", r.alu_op_code);
    
    $display("r.alu.inputs_valid: %b", r.alu.inputs_valid);    
    $display("r.alu.alu_input_ack: %b", r.alu.alu_input_ack);
    
    
    @(posedge clk);
    $display("6");
    $display("clk");
    $display("r.alu_input_A: %b", r.alu_input_A);
    $display("r.alu_input_B: %b", r.alu_input_B);

    $display("r.alu_reg_addr: %b", r.alu_reg_addr);
    $display("r.alu_reg_out: %b", r.alu_reg_out);
    $display("r.alu_op_code: %b", r.alu_op_code);
    $display("r.alu.alu_done: %b", r.alu.alu_done);
    $display("r.alu.inputs_valid: %b", r.alu.inputs_valid);    
    $display("r.alu.alu_input_ack: %b", r.alu.alu_input_ack);

    
    @(posedge clk);
    $display("7");
    $display("clk");
    $display("r.alu_input_A: %b", r.alu_input_A);
    $display("r.alu_input_B: %b", r.alu_input_B);

    $display("r.alu_reg_addr: %b", r.alu_reg_addr);
    $display("r.alu_reg_out: %b", r.alu_reg_out);
    $display("r.alu_op_code: %b", r.alu_op_code);
    $display("r.alu.reg_wr_ack %b", r.alu.reg_wr_ack);
    $display("r.alu.alu_done: %b", r.alu.alu_done);
    $display("r.alu.inputs_valid: %b", r.alu.inputs_valid);    
    $display("r.alu.alu_input_ack: %b", r.alu.alu_input_ack);

    
    @(posedge clk);
    $display("8");
    $display("clk");
    $display("r.alu.input_A: %b", r.alu.input_A);
    $display("r.alu.input_B: %b", r.alu.input_B);
    $display("r.alu.op_code: %b", r.alu.op_code);

    $display("r.alu.reg_wr_addr: %b", r.alu.reg_wr_addr);
    $display("r.alu.reg_wr_data_valid: %b", r.alu.reg_wr_data_valid);
    $display("r.alu.reg_wr_data: %b", r.alu.reg_wr_data);
    $display("r.alu.reg_wr_ack %b", r.alu.reg_wr_ack);
    $display("r.alu.alu_done: %b", r.alu.alu_done);
    $display("r.alu.inputs_valid: %b", r.alu.inputs_valid);    
    $display("r.alu.alu_input_ack: %b", r.alu.alu_input_ack);


    @(posedge clk);
    $display("9");
    $display("clk");
    $display("r.regfile_.wr_data_valid: %b", r.regfile_.wr_data_valid);
    $display("r.regfile_.wr_addr: %b", r.regfile_.wr_addr);
    $display("r.regfile_.registers[wr_addr]: %b", r.regfile_.registers[r.regfile_.wr_addr]);       		
    $display("r.alu.reg_wr_ack %b", r.alu.reg_wr_ack);
	$display("r.alu.alu_done: %b", r.alu.alu_done);
    $display("r.alu.inputs_valid: %b", r.alu.inputs_valid);    
    $display("r.alu.alu_input_ack: %b", r.alu.alu_input_ack);


    @(posedge clk);
    $display("10");
    $display("clk");
    
    assert(r.mem_rd_addr_valid == 1'b1) 
      else $error("r.mem_rd_addr_valid should be %b. it is %b", 
                   1'b1, 
                   r.mem_rd_addr_valid); 
    
    assert(r.reg_rd_addr_a_valid == 1'b0) 
      else $error("r.reg_rd_addr_a_valid should be %b. it is %b", 
                   1'b0, 
                   r.reg_rd_addr_a_valid); 
        $display("r.alu_input_ack: %b", r.alu_input_ack);

    @(posedge clk);
	

    @(posedge clk);
    $display("11");
    $display("clk");    
    assert(r.mem_rd_data == 32'b0000000000100000000000100111111) 
      else $error("r.mem_rd_data should be %b. it is %b", 
                   32'b0000000000100000000000100111111, 
                   r.mem_rd_data); 
    
    assert(r.reg_rd_addr_a_valid == 1'b0) 
      else $error("r.reg_rd_addr_a_valid should be %b. it is %b", 
                   1'b0, 
                   r.reg_rd_addr_a_valid); 

  
    @(posedge clk);
    $display("12");
    $display("clk");
    $display("r.regfile_.rd_data_a_ack: %b", r.regfile_.rd_data_a_ack);
    $display("r.regfile_.rd_data_b_ack: %b", r.regfile_.rd_data_a_ack);

    $display("r.regfile_.rd_data_a: %b", r.regfile_.rd_data_a);
    $display("r.regfile_.rd_data_b: %b", r.regfile_.rd_data_b);
    
    @(posedge clk);
    $display("13");
    $display("clk");
    $display("r.reg_rd_data_a_ack: %b", r.reg_rd_data_a_ack);
    $display("r.reg_rd_data_b_ack: %b", r.reg_rd_data_b_ack);

    $display("r.reg_rd_data_a: %b", r.reg_rd_data_a);
    $display("r.reg_rd_data_b: %b", r.reg_rd_data_b);
    
    
    @(posedge clk);
    $display("14");
    $display("clk");
    $display("r.alu_input_A: %b", r.alu_input_A);
    $display("r.alu_input_B: %b", r.alu_input_B);

    $display("r.alu_reg_addr: %b", r.alu_reg_addr);
    $display("r.alu_reg_out: %b", r.alu_reg_out);
    $display("r.alu_op_code: %b", r.alu_op_code);
    
    $display("r.alu.inputs_valid: %b", r.alu.inputs_valid);    
    $display("r.alu.alu_input_ack: %b", r.alu.alu_input_ack);
    
    
    @(posedge clk);
    $display("15");
    $display("clk");
    $display("r.alu_input_A: %b", r.alu_input_A);
    $display("r.alu_input_B: %b", r.alu_input_B);

    $display("r.alu_reg_addr: %b", r.alu_reg_addr);
    $display("r.alu_reg_out: %b", r.alu_reg_out);
    $display("r.alu_op_code: %b", r.alu_op_code);
    $display("r.alu.alu_done: %b", r.alu.alu_done);
    $display("r.alu.inputs_valid: %b", r.alu.inputs_valid);    
    $display("r.alu.alu_input_ack: %b", r.alu.alu_input_ack);

    
    @(posedge clk);
    $display("16");
    $display("clk");
    $display("r.alu_input_A: %b", r.alu_input_A);
    $display("r.alu_input_B: %b", r.alu_input_B);

    $display("r.alu_reg_addr: %b", r.alu_reg_addr);
    $display("r.alu_reg_out: %b", r.alu_reg_out);
    $display("r.alu_op_code: %b", r.alu_op_code);
    $display("r.alu.reg_wr_ack %b", r.alu.reg_wr_ack);
    $display("r.alu.alu_done: %b", r.alu.alu_done);
    $display("r.alu.inputs_valid: %b", r.alu.inputs_valid);    
    $display("r.alu.alu_input_ack: %b", r.alu.alu_input_ack);

    
    @(posedge clk);
    $display("17");
    $display("clk");
    $display("r.alu.input_A: %b", r.alu.input_A);
    $display("r.alu.input_B: %b", r.alu.input_B);
    $display("r.alu.op_code: %b", r.alu.op_code);

    $display("r.alu.reg_wr_addr: %b", r.alu.reg_wr_addr);
    $display("r.alu.reg_wr_data_valid: %b", r.alu.reg_wr_data_valid);
    $display("r.alu.reg_wr_data: %b", r.alu.reg_wr_data);
    $display("r.alu.reg_wr_ack %b", r.alu.reg_wr_ack);
    $display("r.alu.alu_done: %b", r.alu.alu_done);
    $display("r.alu.inputs_valid: %b", r.alu.inputs_valid);    
    $display("r.alu.alu_input_ack: %b", r.alu.alu_input_ack);


    @(posedge clk);
    $display("18");
    $display("clk");
    $display("r.regfile_.wr_data_valid: %b", r.regfile_.wr_data_valid);
    $display("r.regfile_.wr_addr: %b", r.regfile_.wr_addr);
    $display("r.regfile_.registers[wr_addr]: %b", r.regfile_.registers[r.regfile_.wr_addr]);       		$display("r.alu.reg_wr_ack %b", r.alu.reg_wr_ack);
	$display("r.alu.alu_done: %b", r.alu.alu_done);
    $display("r.alu.inputs_valid: %b", r.alu.inputs_valid);    
    $display("r.alu.alu_input_ack: %b", r.alu.alu_input_ack);


    @(posedge clk);
    $display("19");
    $display("clk");
    
    assert(r.mem_rd_addr_valid == 1'b1) 
      else $error("r.mem_rd_addr_valid should be %b. it is %b", 
                   1'b1, 
                   r.mem_rd_addr_valid); 
    
    assert(r.reg_rd_addr_a_valid == 1'b0) 
      else $error("r.reg_rd_addr_a_valid should be %b. it is %b", 
                   1'b0, 
                   r.reg_rd_addr_a_valid); 
        $display("r.alu_input_ack: %b", r.alu_input_ack);

    @(posedge clk);
	

    @(posedge clk);
    $display("20");
    $display("clk");    
    assert(r.mem_rd_data == 32'b0000000000100000000000100111111) 
      else $error("r.mem_rd_data should be %b. it is %b", 
                   32'b0000000000100000000000100111111, 
                   r.mem_rd_data); 
    
    assert(r.reg_rd_addr_a_valid == 1'b1) 
      else $error("r.reg_rd_addr_a_valid should be %b. it is %b", 
                   1'b1, 
                   r.reg_rd_addr_a_valid); 

    
    //reset = 1'b0;
    
    $finish();
    
  end
  
  */
endmodule