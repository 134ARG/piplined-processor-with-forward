`include "constants.v"

module MEM_stage (
    clk, rst, mem_w, alu_result, st_data,
    mem_out, alu_out
);
    input mem_w, clk, rst;
    input [`WORD-1:0] alu_result, st_data;
    output [`WORD-1:0] mem_out, alu_out;

    MainMemory m (
        .clk(clk),
        .rst(rst),
        .mem_w(mem_w),
        .address(alu_result),
        .write_data(st_data),
        .data_out(mem_out)
    );

    assign alu_out = alu_result;

endmodule //MEM_stage