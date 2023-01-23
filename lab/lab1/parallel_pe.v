// 并行内积运算器每拍能处理多个神经元/权值分量
// 包含一组（32 个）乘法器、一个累加单元、一个加法器、一个部分和寄存器和一个数据选择器。


// 当 ctl[0] 有效时，累加单元结果直接写入部分和寄存器；否则，累加单元结果先通过加法器累加部分和寄存器，然后将累加结果写入部分和寄存器。
// 控制信号最高位 ctl[1] 表示输入神经元/权值数据是一组神经元/权值向量的最后一个子向量。
// 当 ctl[1] 有效时，并行内积运算器在下一个时钟周期将部分和寄存器输出到 result 端口。并行内积运算器输出 result 值，vld_o 置起 1 拍，表示输出内积结果有效。
module parallel_pe(
    input   clk,
    input   rst_n,
    input   [511:0] neuron,
    input   [511:0] weight,
    input   [1:0]  ctrl,
    input   vld_i,
    output  [31:0] result,
    output  reg  vid_o
  );
  // TODO:
  wire [ 1023 : 0 ] mult_result;
  pe_mult
    pe_mult_dut (
      .neuron (neuron ),
      .weight (weight ),
      .mult_result  ( mult_result)
    );

  wire [ 31 : 0 ] acc_result;
  // TODO: add tree
  
  reg [ 31 : 0 ] psum_r;

  /* adder */
  wire [31:0] psum_d = ctrl[0] ? acc_result : acc_result + psum_r;

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
  begin:getOutput
    if(!rst_n)
    begin
      vid_o <= 1'h0;
    end
    else if(ctrl[1])
    begin
      vid_o <= 1'h1;
    end
    else
    begin
      vid_o <= 1'h0;
    end
  end

  assign result = psum_r;
endmodule
