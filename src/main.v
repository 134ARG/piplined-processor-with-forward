`timescale 1ns/1ns

module testbench ();
    reg clk;
    cpu top_module (clk);

    initial begin

        clk=1;
        repeat(5000) #50 clk=~clk ;
        
    end
endmodule // tes