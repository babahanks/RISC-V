module memory(
  input  logic       clk,
  input  logic       reset,
  input  logic[31:0] mem_rd_addr,
  input  logic		 mem_rd_addr_valid,
  output logic[31:0] mem_rd_data,
  output logic       mem_rd_ack,
  input  logic[31:0] mem_wr_addr,
  input  logic[31:0] mem_wr_data,
  input  logic       mem_wr_data_valid,
  output logic       mem_wr_ack);
  
  localparam int MEM_SIZE = 64000; // Compile-time constant
  logic [31:0] memory [0:MEM_SIZE - 1]; // Array with 64000 elements  

  
  always_ff @(posedge clk) begin
    if (reset || ~mem_rd_addr_valid) begin
      mem_rd_ack = 1'b0;
    end
    else if(~reset && mem_rd_addr_valid) begin
      mem_rd_data <= memory[mem_rd_addr];
      mem_rd_ack <= 1'b1;
    end 
  end
  
  always_ff @(posedge clk) begin
    if (reset) begin
      // boot load for testing
      $readmemb("memory_boot_load.txt", memory);  
    end
    else if (reset || ~mem_wr_data_valid) begin
      mem_wr_ack = 1'b0;
    end
    else if (~reset && mem_wr_data_valid) begin
      memory[mem_wr_addr] <= mem_wr_data;
      mem_wr_ack <= 1'b1;
    end
  end
endmodule
  
  
  
  
  