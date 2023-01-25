module pe_acc(
    input  [1023:0] mult_result,
    output [31:0]   acc_result
  );
  genvar i;
  genvar j;
  wire [31:0] int16_result[31:0][5:0];
  /* add tree */
  // TODO:
  for(i = 0 ; i < 6 ; i = i + 1)
  begin:int16_add_tree
    for(j = 0 ; j < 32/(2**i) ; j = j + 1)
    begin
      if(i == 0)
      begin
        assign int16_result[i][j] = mult_result[j*32 +: 32];
      end
      else
      begin
        assign int16_result[i][j] = int16_result[i-1][j*2] + int16_result[i-1][j*2+1];
      end
    end
  end
  assign acc_result = int16_result[5][0];
endmodule
