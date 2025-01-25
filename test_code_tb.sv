
`include "test_code.sv"

module test_code_tb();
  logic      clk;
  logic      reset;
  logic[4:0] addr;
  
  test_code test_code_1(
    .clk(clk),
    .reset(reset),
    .addr(addr));
  
  
  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end
  
  
  
  initial begin
    
    reset = 1'b1;
    @(posedge clk);
    @(posedge clk);
    @(posedge clk);
    @(posedge clk);
    
    $display("PC: %b", test_code_1.PC);
    $display("addr: %b", addr);
    @(posedge clk);
    $display("PC: %b", test_code_1.PC);
    $display("addr: %b", addr);
    
    reset = 1'b0;
    @(posedge clk);
    $display("PC: %b", test_code_1.PC);
    $display("addr: %b", addr);  
    @(posedge clk);
    $display("PC: %b", test_code_1.PC);
    $display("addr: %b", addr);  
    @(posedge clk);
    $display("PC: %b", test_code_1.PC);
    $display("addr: %b", addr);  

    $finish();
  end
  
endmodule