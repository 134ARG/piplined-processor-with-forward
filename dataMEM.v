`include "constants.v"

module MainMemory (
    clk, rst,
    mem_w,
    address,
    write_data,
    data_out
);
    input clk, rst;
    input mem_w;
    input [`WORD-1:0] address, write_data;
    output [`WORD-1:0] data_out;

    reg [`BYTE-1:0] DATA_RAM [0:`INS_SIZE*`FACTOR-1];

    always @(posedge clk) begin
        if (rst) begin
            for (i = 0; i < `INS_SIZE*`FACTOR; i = i + 1)
                DATA_RAM[i] <= 0;
        end else if (mem_r) begin
            {DATA_RAM[address], DATA_RAM[address+1], DATA_RAM[address+2], DATA_RAM[address+3]} <= write_data;
        end
    end

    assign data_out = {DATA_RAM[address], DATA_RAM[address+1], DATA_RAM[address+2], DATA_RAM[address+3]};

endmodule //dataMEM