module test_code(
  input  logic      clk,
  input  logic      reset,
  input  logic		inc,
  output logic[4:0] addr,
  output logic[4:0] result);
  
  logic[4:0] PC;
  
  
  always_ff @(posedge clk) begin
    if (reset) begin
      	PC <= 5'b0;
    end
    else if (~reset) begin
      result <= 1'b0;
      addr <= PC;
      PC <= PC + 1;
      if (inc) begin
        $display("in inc");
        PC <= PC + 2;
        result <= PC;
      end       
    end
  end
  
endmodule