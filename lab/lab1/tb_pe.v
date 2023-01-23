module PE_tb;

  // Parameters

  // Ports
  reg clk = 0;
  reg rst_n = 0;
  reg [15:0] neuron;
  reg [15:0] weight;
  reg [1:0] ctrl;
  reg vld_i = 0;
  wire [31:0] result;
  wire vid_o;

  PE
    PE_dut (
      .clk (clk ),
      .rst_n (rst_n ),
      .neuron (neuron ),
      .weight (weight ),
      .ctrl (ctrl ),
      .vld_i (vld_i ),
      .result (result ),
      .vid_o  ( vid_o)
    );

  initial
  begin
    begin
      rst_n=0;
      #10;//延时100ns
      rst_n=1;//撤销复位
      $finish;
    end
  end

  always
    #5  clk = ! clk ;

endmodule
