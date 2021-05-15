`timescale 100fs/100fs
`include "constants.v"

module InstructionRAM (
    rst, address,
    mem_out
);
    input rst;
    input [`WORD-1:0] address;
    output [`WORD-1:0] mem_out;

    reg [`BYTE-1:0] RAM [0:`INS_SIZE*`FACTOR-1];

    initial begin
        $readmemb("instruction.bin", RAM);
    end
    always @(rst) begin
        if (rst) mem_out <= 0;
    end
    assign mem_out = {RAM[address], RAM[address+1], RAM[addres+2], RAM[address+3]};
endmodule