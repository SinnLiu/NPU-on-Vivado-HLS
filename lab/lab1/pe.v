// 串行内积运算器每拍最多接收一个神经元和一个权值分量进行乘法运算，然后再将乘法结果累加到部分和寄存器。
// 当串行内积运算器处理的神经元/权值数据是一组神经元/权值向量的第一个元素时，乘法结果直接写入部分和寄存器，不需进行累加；
// 当处理的神经元/权值数据是一组神经元/权值向量的最后一个元素时，串行内积运算器将累加结果输出。
// 主要包括：一个乘法器、一个加法器、一个部分和寄存器和一个数据选择器。

module PE(
    input   clk,
    input   rst_n,
    input signed [15:0] neuron,
    input signed [15:0] weight,
    input        [1:0]  ctrl,
    input   vld_i,
    output       [31:0] result,
    output reg  vid_o
  );
  /* multiplier */
  wire signed [31:0] mult_res = neuron * weight;
  reg [31:0] psum_r;

  /* adder */
  wire [31:0] psum_d = mult_res + psum_r;

  /* partial sum reg */
  always@(posedge clk or negedge rst_n)
  begin
    if(!rst_n)
    begin
      psum_r <= 32'h0;
    end
    else if(vld_i)
    begin
      psum_r <= psum_d;
    end
  end

  always@(posedge clk or negedge rst_n)
  begin
    if(!rst_n)
    begin
      vid_o <= 1'h0;
    end
    else if(vld_i)
    begin
      vid_o <= 1'h1;
    end
    else
    begin
      vid_o <= 1'h0;
    end
  end

  /* output */
  assign result = psum_r;
endmodule
