`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/07/2022 04:52:18 PM
// Design Name: 
// Module Name: tb_microphone_sim_ii
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module tb_microphone_sim_ii;
    logic data;
    bit clk;
    bit ref_clk;

    always #160 clk = ~clk;
    always #5   ref_clk = ~ref_clk;
    always @ (posedge clk) begin
        data = $urandom();
    end 
   
    i2s_master #(
            .DATA_WIDTH(32), 
            .PCM_PRECISION(18)
            ) 
            DUT ( 
            .clk(ref_clk),
            .clk_1(clk),
            .i2s_lrcl(),

            .i2s_dout(data),
            .i2s_bclk(),
            .fifo_din (),
            .fifo_w_stb(),
            .fifo_full(0)
            );
   
    initial begin
        data = 0;
        clk = 0;
        ref_clk = 0;
    end
  
    // Simulator dependent system tasks that can be used to
    // dump simulation waves.
    /*initial begin
        $dumpvars;
        $dumpfile("dump.vcd");
    end*/
endmodule