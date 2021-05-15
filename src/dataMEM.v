`include "constants.v"

module MainMemory (
    clk, rst,
    mem_w,
    terminate,
    address,
    write_data,
    data_out
);
    input clk, rst;
    input mem_w, terminate;
    input [`WORD-1:0] address, write_data;
    output [`WORD-1:0] data_out;

    reg [`BYTE-1:0] DATA_RAM [0:`MEM_SIZE*`FACTOR-1];
    integer i;
        initial begin
        $display("init dataMEM");
    end

    always @(posedge clk) begin
        if (rst) begin
            for (i = 0; i < `INS_SIZE*`FACTOR; i = i + 1)
                DATA_RAM[i] <= 0;
        end else if (mem_w) begin
            $display("Memory writing: address:%b data:%h", address, write_data);
            {DATA_RAM[address], DATA_RAM[address+1], DATA_RAM[address+2], DATA_RAM[address+3]} <= write_data;
        end
    end

    always @(terminate) begin
        if (terminate == 1) begin
            $writememh("memfile.s", DATA_RAM);
        end
    end

    assign data_out = {DATA_RAM[address], DATA_RAM[address+1], DATA_RAM[address+2], DATA_RAM[address+3]};

endmodule //dataMEM