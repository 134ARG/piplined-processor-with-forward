`include "constants.v"

module MEM_to_WB (
    clk, rst,
    wb_in, mem_r_in,
    mem_result_in, alu_result_in,
    reg_dest_in,
    terminate_in,

    wb_out, mem_r_out,
    mem_result_out, alu_result_out,
    reg_dest_out,
    terminate_out
);
    input clk, rst;
    input wb_in, mem_r_in, terminate_in;
    input [`WORD-1:0] mem_result_in, alu_result_in;
    input [4:0] reg_dest_in;

    output reg wb_out, mem_r_out, terminate_out;
    output reg [`WORD-1:0] mem_result_out, alu_result_out;
    output reg [4:0] reg_dest_out;

    initial begin
        $display("init memtowb");
        {wb_out, mem_r_out, terminate_out} <= 0;
        reg_dest_out <= 0;
        {mem_result_out, alu_result_out} <= 0;
    end
    always @(posedge clk) begin
        if (rst) begin
            {wb_out, mem_r_out, terminate_out} <= 0;
            reg_dest_out <= 0;
            {mem_result_out, alu_result_out} <= 0;
        end else begin
            wb_out <= wb_in;
            mem_r_out <= mem_r_in;
            mem_result_out <= mem_result_in;
            alu_result_out <= alu_result_in;
            reg_dest_out <= reg_dest_in;
            terminate_out <= terminate_in;
        end
    end

endmodule //MEM_to_WB