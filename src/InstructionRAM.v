`timescale 100fs/100fs
`include "constants.v"

module InstructionRAM (
    rst, address,
    mem_out
);
    input rst;
    input [`WORD-1:0] address;
    output [`WORD-1:0] mem_out;

    wire [`WORD-1:0] address_four = (address - address % 4) / 4;
    wire [`WORD-1:0] word_offset1 = (address % 4)*`BYTE;
    wire [`WORD-1:0] word_offset2 = (4 - address % 4)*`BYTE;

    // reg [`BYTE-1:0] RAM [0:`INS_SIZE*`FACTOR-1];
    reg [`WORD-1:0] RAM [0:`INS_SIZE-1];

    // reg [`BYTE-1:0] RAM [0:1];
    integer i;

    initial begin
        $readmemb("instructions.bin", RAM);
        // $monitor("ins_load:%b, %b", RAM[0], RAM[1]);
    end
    always @(rst) begin
        if (rst) begin
            for (i = 0; i < `INS_SIZE; i = i + 1)
                RAM[i] <= 0;
        end
    end
    // assign mem_out = {RAM[address], RAM[address+1], RAM[address+2], RAM[address+3]};
    assign mem_out = (RAM[address_four] << word_offset1) | ((RAM[address_four+1] << word_offset2) >> word_offset2);
endmodule