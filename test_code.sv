module test_code(
  input  logic      clk,
  input  logic      reset,
  output logic[4:0] addr);
  
  logic[4:0] PC;
  
  
  always_ff @(posedge clk) begin
    if (reset) begin
      	PC <= 5'b0;
    end
    else if (~reset) begin
      addr <= PC;
      PC <= PC + 1;
    end
  end
  
endmodule