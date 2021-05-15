`include "constants.v"

module EX_to_MEM (
    clk, rst, 
    alu_in, st_data_in,
    mem_w_in, mem_r_in, wb_en_in, reg_dest_in,
    terminate_in,

    mem_w_out, mem_r_out, wb_en_out, reg_dest_out,
    alu_out, st_data_out,
    terminate_out
);
    input clk, rst;
    input [`WORD-1:0] alu_in, st_data_in;
    input mem_w_in, mem_r_in, wb_en_in, terminate_in;
    input [4:0] reg_dest_in;

    output reg mem_w_out, mem_r_out, wb_en_out, terminate_out;
    output reg [4:0] reg_dest_out;
    output reg [`WORD-1:0] alu_out, st_data_out;

    initial begin
        $display("init extomem");
        {mem_w_out, mem_r_out, wb_en_out, terminate_out} <= 0;
        reg_dest_out <= 0;
        {alu_out, st_data_out} <= 0;
    end

    always @(posedge clk) begin
        if (rst) begin
            {mem_w_out, mem_r_out, wb_en_out, terminate_out} <= 0;
            reg_dest_out <= 0;
            {alu_out, st_data_out} <= 0;
        end else begin
            mem_w_out <= mem_w_in;
            mem_r_out <= mem_r_in;
            wb_en_out <= wb_en_in;
            reg_dest_out <= reg_dest_in;
            alu_out <= alu_in;
            st_data_out <= st_data_in;
            terminate_out <= terminate_in;
        end
    end

endmodule //EX_to_MEM