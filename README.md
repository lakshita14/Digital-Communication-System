# Digital-Communication-System
Implementing the transmitter part of a Digital communication System which includes three major modules:




CRC (Cyclic Redundancy Check):  
                             
It’s used to detect errors in data transmission and generated by a modulo 2 division with a generator polynomial. The remainder is the CRC. For this application, the generator polynomial is CRC16 (x16 + x15 + x2 + 1) with the CRC register initialized to all 1’s prior to calculating the CRC. This initialization ensures that leading 0’s in front of a packet are protected by the CRC. The figure below shows the shift register implementation for the CRC.

![alt text](https://github.com/lakshita14/Digital-Communication-System/blob/main/images/Register_impt_of_CRC.png)

 

We can see from the location of x-or gates in the shift register configuration how CRC16 is implemented. Using this hardware will give the following result:
Input: [4 bytes]  03 01 02 03                                                                                                                                                               Appended with CRC : [6 bytes]   03 01 02 03 30 3A
The CRC calculation is such that sending the data and appended CRC (6 bytes) through the same hardware used to generate the CRC will give a CRC of [00].




FEC (Forward Error Correction):

One example of FEC is convolution codes involving calculating parity bits and then sending only the parity bits. A convolution encoder uses a sliding window to calculate the parity bits. The size of the window is the constraint length (k). The rate is the number of parity bits(r) expressed as 1/r. Here we will use rate ½ constraint length 4 code.
A data stream is shown below with convolution code (k = 4) using these generators g0 = 1,1,1,1 and g1 = 1,1,0,1. The parity bits are then

![alt text](https://github.com/lakshita14/Digital-Communication-System/blob/main/images/parity%20bits.png)
                                                    
The parity bits are then sent as a single data stream: P1[0], P0[0], P1[1], P0[1], P1[2], P0[2], . . . . . 




Interleaver:

In many situations errors come in bursts: correlated multi-bit errors (e.g., fading or burst of interference on wireless channels, damage to storage media etc.) which wipes out the large number of adjacent data bits - defeating the convolution code. A simple solution is to interleave the data bits of a 4 byte packet so that adjacent data bits are spaced out in the transmitted sequence. Instead of sending all 8 bits of the byte 0, the low order bit pair of bytes 3, 2, 1, and 0 (starting at the LSB end) are transmitted followed by the next set of bit pairs until all bits are transmitted. This is implemented in many satellite communication systems.

The final task is to establish communication between each of these modules. The complete process, in serial mode, requires a 32 clock cycle to calculate the CRC followed by 48 clock cycles for the convolution encoder totaling 80 clock cycles.

![alt text](https://github.com/lakshita14/Digital-Communication-System/blob/main/images/block%20level%20view.png)
                                                         

But notice that the CRC result is not required while the convolution encoder is processing the first four bytes of data. So we will send the first 4 bytes of data to both CRC and FEC in parallel. After the last data bit has been shifted in, CRC has been computed and is available. At this time the input to the convolution encoder can be switched by control to the output of the CRC registers. CRC generation and convolution encoding takes 32 cycles and 16 more clock cycles to complete convolution encoding. By taking advantage of concurrent processing total processing is reduced from 80 clock cycles to 48 clock cycles.

![alt text](https://github.com/lakshita14/Digital-Communication-System/blob/main/images/Clk_cycle_reduction.png)

             
Total time can even be reduced further by computing the parity bits in parallel in one clock cycle. 



Result:

with 48 Clk Cycles

![alt text](https://github.com/lakshita14/Digital-Communication-System/blob/main/images/DCS_with%2048%20clk%20cycles.jpg)

with 32 Clk Cycles

![alt text](https://github.com/lakshita14/Digital-Communication-System/blob/main/images/DCS_with%2032%20clk%20cycles.jpg)




