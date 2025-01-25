
`include "test_code.sv"

module test_code_tb();
  logic      clk;
  logic      reset;
  logic      inc;
  logic[4:0] addr;
  logic[4:0] result;
  
  test_code test_code_1(
    .clk(clk),
    .reset(reset),
    .inc(inc),
    .addr(addr),
    .result(result));
  
  
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
    $display("result: %b", result);

    @(posedge clk);
    $display("PC: %b", test_code_1.PC);
    $display("addr: %b", addr);
    $display("result: %b", result);
    
    reset = 1'b0;
    @(posedge clk);
    $display("PC: %b", test_code_1.PC);
    $display("addr: %b", addr);  
    $display("result: %b", result);

    @(posedge clk);
    $display("PC: %b", test_code_1.PC);
    $display("addr: %b", addr);  
    $display("result: %b", result);

    @(posedge clk);
    $display("PC: %b", test_code_1.PC);
    $display("addr: %b", addr);  
    $display("result: %b", result);
    
    inc = 1'b1;
    @(posedge clk);
    $display("PC: %b", test_code_1.PC);
    $display("addr: %b", addr);  
    $display("result: %b", result);
    
    inc = 1'b0;
    
    @(posedge clk);
    $display("PC: %b", test_code_1.PC);
    $display("addr: %b", addr);  
    $display("result: %b", result);

    $finish();
  end
  
endmodule