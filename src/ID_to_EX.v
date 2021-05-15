`include "constants.v"

module ID_to_EX (
    clk, rst, 
    mem_w_in, mem_r_in, wb_en_in, 
    alu_op_in, reg_rs_in, reg_rt_in, reg_dest_in,
    alu_1_data_in, alu_2_data_in, st_data_in,
    terminate_in,

    mem_w_out, mem_r_out, wb_en_out,
    alu_op_out, reg_rs_out, reg_rt_out, reg_dest_out,
    alu_1_data_out, alu_2_data_out, st_data_out,
    terminate_out
);
    input clk, rst;
    input mem_w_in, mem_r_in, wb_en_in, terminate_in;
    input [3:0] alu_op_in;
    input [4:0] reg_rs_in, reg_rt_in, reg_dest_in;
    input [`WORD-1:0] alu_1_data_in, alu_2_data_in, st_data_in;

    output reg mem_w_out, mem_r_out, wb_en_out, terminate_out;
    output reg [3:0] alu_op_out;
    output reg [4:0] reg_rs_out, reg_rt_out, reg_dest_out;
    output reg [`WORD-1:0] alu_1_data_out, alu_2_data_out, st_data_out;

    initial begin
        $display("init idtoex");
        {mem_w_out, mem_r_out, wb_en_out, terminate_out} <= 0;
        alu_op_out <= 0;
        {reg_rs_out, reg_rt_out, reg_dest_out} <= 0;
        {alu_1_data_out, alu_2_data_out, st_data_out} <= 0;
    end

    always @(posedge clk) begin
        if (rst) begin
            {mem_w_out, mem_r_out, wb_en_out, terminate_out} <= 0;
            alu_op_out <= 0;
            {reg_rs_out, reg_rt_out, reg_dest_out} <= 0;
            {alu_1_data_out, alu_2_data_out, st_data_out} <= 0;
        end else begin
            mem_w_out <= mem_w_in;
            mem_r_out <= mem_r_in;
            wb_en_out <= wb_en_in;
            alu_op_out <= alu_op_in;
            reg_rs_out <= reg_rs_in;
            reg_rt_out <= reg_rt_in;
            reg_dest_out <= reg_dest_in;
            alu_1_data_out <= alu_1_data_in;
            alu_2_data_out <= alu_2_data_in;
            st_data_out <= st_data_in;
            terminate_out <= terminate_in;
            $display("ID to Ex part");
            $display("mem_w:%b, mem_r:%b, reg_rs:%d, reg_rt: %d, reg_rd:%d, wb_en:%b, alu_op:%d, alu_1_data:%b, alu_2_data:%b", 
                    mem_w_in, mem_r_in, reg_rs_in, reg_rt_in, reg_dest_in, wb_en_in, alu_op_in, alu_1_data_in, alu_2_data_in);

        end
    end
endmodule //ID_to_EX