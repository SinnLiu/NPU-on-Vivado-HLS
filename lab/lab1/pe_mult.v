// 并行内积运算器每拍能处理多个神经元/权值分量
// 包含一组（32 个）乘法器、一个累加单元、一个加法器、一个部分和寄存器和一个数据选择器。

module pe_mult(
    input   [511:0] neuron,
    input   [511:0] weight,
    output  [1023:0] mult_result
  );
  /* int16 mult */
  genvar i;
  wire signed [15:0] int16_neuron[31:0];
  wire signed [15:0] int16_weight[31:0];
  wire signed [31:0] int16_mult_result[31:0];

  generate
    for(i = 0 ; i < 32 ; i = i + 1)
    begin:int16_mult
      assign int16_neuron[i] = neuron[i*16 +: 16];
      assign int16_weight[i] = weight[i*16 +: 16];
      assign int16_mult_result[i] = int16_neuron[i] * int16_weight[i];
      assign mult_result[i*32 +: 32] = int16_mult_result[i];
    end
  endgenerate

endmodule
