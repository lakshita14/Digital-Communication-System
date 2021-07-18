module test;
  reg clk , start ,d;
  wire[95:0] final_ans;
  wire  done;
  wire [15:0] CRC_out;
  
  
  
  reg [31:0] data = 32'h03_01_02_03;
  
  reg [47 :0] fec_in;
  
  DCS R(clk , start , d  , fec_in, CRC_out, done,final_ans);
  
  initial
    begin
      clk = 0;
      repeat(70)
        #5 clk = ~clk;
    end
  
  initial
    begin
      $dumpfile("dump.vcd");
      $dumpvars(1,test);
      $monitor($time , " final = %h done = %h",final_ans,done);
      
      start = 1;d = 0; 
      #5  start= 0;
      repeat(32)
        begin
          d = data[31];
          #10 data = data << 1; 
          fec_in = {32'h03_01_02_03 , CRC_out};
        end
      
      
      
     
      
    end
 
endmodule
