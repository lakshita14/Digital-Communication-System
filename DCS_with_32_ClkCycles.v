module DCS(
input clk , start , d,
  input [47:0] fec_in,
  output [15:0] CRC_out,

  output  done_fec,
  output [95:0] final_ans
);
  wire [95:0] fec_out;
  
  CRC C(d , clk , start , CRC_out);
  FEC F(clk, start ,fec_in , fec_out,done_fec);
  
  Interleaver I(fec_out[95:88], fec_out[87:80] , fec_out[79:72] , fec_out[71:64] , fec_out[63:56] , fec_out[55:48] , fec_out[47:40] , fec_out[39:32] , fec_out[31:24] , fec_out[23:16] , fec_out[15:8] , fec_out[7:0] , final_ans); 
  
endmodule


module CRC(
input data , clk , start,
  output reg [15:0] r
);
  integer count;
  always @(posedge clk ,start)
    begin
      if(start)begin
        r = 16'hFFFF;
        count = 32;
      end
      else if(count != 0)
        begin
          r[0] <=  data + r[15];
          r[1] <=  r[0];
          r[2] <= r[1] + (data + r[15]);
          r[3] <= r[2];
          r[4] <= r[3];
          r[5] <= r[4];
          r[6] <= r[5];
          r[7] <= r[6];
          r[8] <= r[7];
          r[9] <= r[8];
          r[10] <= r[9];
          r[11] <= r[10];
          r[12] <= r[11];
          r[13] <= r[12];
          r[14] <= r[13];
          r[15] <= r[14]+(data+r[15]);
          count <= count -1;
          
        end
    end
endmodule




module FEC(
input clk,reset,
  input [47:0]q,
  output reg [95:0] fec,
  output reg done
);
  reg [3:0] D; integer count,i;
  reg [47:0] P1,P0;
  always @(posedge clk ,reset)
   begin
      if(reset == 1)
         begin
         D <= 4'b0000;
           count = 48;
         end
            else
               #325 begin
                for(i = 47 ; i>=0 ; i = i-1)
                  begin
                    P0[count] = D[3]^D[2]^D[1]^D[0];
                    P1[count] = D[3]^D[1]^D[0];
                    fec = {fec[93:0],P1[count],P0[count]};
                    D = {q[i],D[3:1]};
                    count = count -1;
                    done = 0;
                  end
                P0[0] = 1'b0^D[2]^D[1]^D[0];
                P1[0] = 1'b0^D[1]^D[0];
                fec = {fec[93:0],P1[0],P0[0]};
                count = count -1;
                done = 1;
              end
          end
endmodule






module Interleaver(
  input [7:0] byte0, byte1, byte2, byte3, byte4, byte5, byte6, byte7, byte8, byte9, byte10, byte11,
  output [95:0] final_ans
);
  wire [23:0] out0 , out1 , out2 , out3;
  
  assign  out0 = { byte11[1:0],byte10[1:0] , byte9[1:0] , byte8[1:0] , byte7[1:0] , byte6[1:0] , byte5[1:0] , byte4[1:0] , byte3[1:0] , byte2[1:0] , byte1[1:0] , byte0[1:0]}; 
  
  assign out1 = {byte11[3:2], byte10[3:2], byte9[3:2], byte8[3:2], byte7[3:2], byte6[3:2], byte5[3:2], byte4[3:2],byte3[3:2] , byte2[3:2] , byte1[3:2] , byte0[3:2]};
  
  assign out2 = {byte11[5:4], byte10[5:4], byte9[5:4], byte8[5:4], byte7[5:4], byte6[5:4], byte5[5:4], byte4[5:4],byte3[5:4] , byte2[5:4] , byte1[5:4] , byte0[5:4]};
  
  assign out3 = {byte11[7:6], byte10[7:6], byte9[7:6], byte8[7:6], byte7[7:6], byte6[7:6], byte5[7:6], byte4[7:6],byte3[7:6] , byte2[7:6] , byte1[7:6] , byte0[7:6]};
  
  assign final_ans = {out0 , out1 , out2 , out3};
  
endmodule



