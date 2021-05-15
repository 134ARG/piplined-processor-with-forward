`include "constants.v"

module cpu(clk);
    wire rst = 0;
    wire branch_taken, jump_taken, stall;
    wire [`WORD-1:0] jump_target, branch_offset;

    wire [`WORD-1:0] PC, instruction;

    wire [`WORD-1:0] instruction_out;

    wire mem_w_ID, mem_r_ID, wb_en_ID, tem_ID;
    wire [3:0] alu_op_ID;
    wire [4:0] reg_rs_ID, reg_rt_ID, reg_dest_ID;
    wire [`WORD-1:0] alu_1_ID, alu_2_ID, st_data_ID;

    wire mem_w_EX, mem_r_EX, wb_en_EX, tem_EX;
    wire [3:0] alu_op_EX;
    wire [4:0] reg_rs_EX, reg_rt_EX, reg_dest_EX;
    wire [`WORD-1:0] alu_1_EX, alu_2_EX, st_data_EX;

    wire [`WORD-1:0] alu_out_EX, st_data_out_EX;

    wire [1:0] alu_1_sel, alu_2_sel, st_data_sel;
 
    wire mem_w_MEM, mem_r_MEM, wb_en_MEM, tem_MEM;
    wire [`WORD-1:0] alu_MEM, st_MEM;
    wire [4:0] reg_dest_MEM;

    wire [`WORD-1:0] mem_out_MEM, alu_out_MEM;

    wire wb_en_WB, mem_r_WB, tem_WB;
    wire [`WORD-1:0] mem_out_WB, alu_out_WB;
    wire [4:0] reg_dest_WB;

    wire [`WORD-1:0] wb_data;

    IF_stage if_stage (
        .clk(clk),
        .rst(rst),
        .branch_taken(branch_taken),
        .jump_taken(jump_taken),
        .branch_offset(branch_offset),
        .stall(stall),
        .new_addr(jump_target),
        // outputs
        .PC(),
        .instruction(insturction)
    );

    IF_to_ID IFID (
        .clk(clk),
        .rst(rst),
        .flush(branch_taken),
        .freeze(stall),
        .PC_in(),
        .insturction_in(insturction),
        // outputs
        .PC_out(),
        .instruction_out(instruction_out)
    );

    ID_stage id_stage (
        .clk(clk),
        .rst(rst),
        .instruction(instruction_out),
        .stall(stall),

        .wb_dest(reg_dest_WB),
        .wb_en(wb_en_WB),
        .wb_data(wb_data),
        // outputs
        .mem_w(mem_w_ID),
        .mem_r(mem_r_ID),
        .alu_op(alu_op_ID),
        .forward_wb_en(wb_en_ID),
        .branch_taken(branch_taken),
        .jump_taken(jump_taken),
        .reg_rs(reg_rs_ID),
        .reg_rt(reg_rt_ID),
        .reg_dest(reg_dest_ID),
        .alu_1_data(alu_1_ID),
        .alu_2_data(alu_2_ID),
        .st_data(st_data_ID),
        .branch_offset(branch_offset),
        .jump_address(jump_target),
        .terminate(tem_ID)
    );

    ID_to_EX pip_reg2 (
        .clk(clk),
        .rst(rst),
        .mem_w_in(mem_w_ID),
        .mem_r_in(mem_r_ID),
        .wb_en_in(wb_en_ID),
        .alu_op_in(alu_op_ID),
        .reg_rs_in(reg_rs_ID),
        .reg_rt_in(reg_rt_ID),
        .reg_dest_in(reg_dest_ID),
        .alu_1_data_in(alu_1_ID),
        .alu_2_data_in(alu_2_ID),
        .st_data_in(st_data_ID),
        .terminate_in(tem_ID),

        // outputs
        .mem_w_out(mem_w_EX),
        .mem_r_out(mem_r_EX),
        .wb_en_out(wb_en_EX),
        .alu_op_out(alu_op_EX),
        .reg_rs_out(reg_rs_EX),
        .reg_rt_out(reg_rt_EX),
        .reg_dest_out(reg_dest_EX),
        .alu_1_data_out(alu_1_EX),
        .alu_2_data_out(alu_2_EX),
        .st_data_out(st_data_EX),
        .terminate_out(tem_EX)
    );

    load_stall h (
        .mem_r_EX(mem_r_EX),
        .reg_dest_EX(reg_dest_EX),
        .reg_rt_ID(reg_rt_ID),
        .reg_rs_ID(reg_rs_ID),
        .stall(stall)
    );

    
    EX_stage ex(
        .clk(clk),
        .rst(rst),
        .alu_op(alu_op_EX),

        .alu_1_data(alu_1_EX),
        .alu_1_MEM(alu_MEM),
        .alu_1_WB(wb_data),
        .alu_1_sel(alu_1_sel),

        .alu_2_data(alu_2_EX),
        .alu_2_MEM(alu_MEM),
        .alu_2_WB(wb_data),
        .alu_2_sel(alu_2_sel),

        .st_data(st_data_EX),
        .st_data_MEM(st_MEM),
        .st_data_WB(wb_data),
        .st_data_sel(st_data_sel),

        .alu_out(alu_out_EX),
        .st_data_out(st_data_out_EX)
    );

    forward f(
        .wb_en_MEM(wb_en_MEM),
        .wb_en_WB(wb_en_WB),
        .reg_rs(reg_rs_EX),
        .reg_rt(reg_rt_EX),
        .reg_dest(reg_dest_EX),
        .reg_dest_MEM(reg_dest_MEM),
        .reg_dest_WB(reg_dest_WB),
        // outputs
        .alu_1_sel(alu_1_sel),
        .alu_2_sel(alu_2_sel),
        .st_data_sel(st_data_sel)
    );

    
    EX_to_MEM pip_reg3 (
        .clk(clk),
        .rst(rst),

        .alu_in(alu_out_EX),
        .st_data_in(st_data_out_EX),
        .mem_w_in(mem_w_EX),
        .mem_r_in(mem_r_EX),
        .wb_en_in(wb_en_EX),
        .reg_dest_in(reg_dest_EX),
        .terminate_in(tem_EX),

        .alu_out(alu_MEM),
        .st_data_out(st_MEM),
        .mem_w_out(mem_w_MEM),
        .mem_r_out(mem_r_MEM),
        .wb_en_out(wb_en_MEM),
        .reg_dest_out(reg_dest_MEM),
        .terminate_out(tem_MEM)
    );

    
    MEM_stage mem (
        .clk(clk),
        .rst(rst),
        .mem_w(mem_w_MEM),
        .alu_result(alu_MEM),
        .st_data(st_MEM),
        // outputs
        .mem_out(mem_out_MEM),
        .alu_out(alu_out_MEM)
    );

    
    MEM_to_WB pip_reg4 (
        .clk(clk),
        .rst(rst),
        .wb_in(wb_en_MEM),
        .mem_r_in(mem_r_MEM),
        .mem_result_in(mem_out_MEM),
        .alu_result_in(alu_out_MEM),
        .reg_dest_in(reg_dest_MEM),
        .terminate_in(tem_MEM),
        // outputs
        .wb_out(wb_en_WB),
        .mem_r_out(mem_r_WB),
        .mem_result_out(mem_out_WB),
        .alu_result_out(alu_out_WB),
        .reg_dest_out(reg_dest_WB),
        .terminate_out(tem_WB)
    );

    WB_stage wb (
        .mem_r(mem_r_WB),
        .mem_result(mem_out_WB),
        .alu_result(alu_out_WB),
        .terminate(tem_WB),
        .wb_data(wb_data)
    );

endmodule