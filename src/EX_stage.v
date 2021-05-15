`include "constants.v"

module EX_stage (
    clk, rst, 
    //mem_w, mem_r, wb_en,
    alu_op, //reg_rs, reg_rt, reg_dest,
    alu_1_data, alu_1_MEM, alu_1_WB, alu_1_sel,
    alu_2_data, alu_2_MEM, alu_2_WB, alu_2_sel,
    st_data, st_data_MEM, st_data_WB, st_data_sel,
    alu_out, st_data_out//mem_w_out, mem_r_out, wb_en_out
);
    input clk, rst;
    input [3:0] alu_op;
    input [4:0] reg_rs, reg_rt, reg_dest;
    input [31:0] alu_1_data, alu_1_MEM, alu_1_WB;
    input [31:0] alu_2_data, alu_2_MEM, alu_2_WB;
    input [31:0] st_data, st_data_MEM, st_data_WB;
    input [1:0] alu_1_sel, alu_2_sel, st_data_sel;

    output [31:0] alu_out, st_data_out;

    wire [31:0] alu_1, alu_2;

    initial begin
        $display("init EX");
    end



    // always @(st_data_sel) begin
    //     if (st_data_sel == 2'd0) $display("3; forward: default.");
    //     else if (st_data_sel == 2'd1) $display("3; forward: MEM: %b", st_data_MEM);
    //     else $display("3; forward: WB: %b", st_data_WB);
    // end

    data_mux_3 alu_1_src (
        .sel(alu_1_sel),
        .in1(alu_1_data),
        .in2(alu_1_MEM),
        .in3(alu_1_WB),
        .out(alu_1)
    );

    data_mux_3 alu_2_src (
        .sel(alu_2_sel),
        .in1(alu_2_data),
        .in2(alu_2_MEM),
        .in3(alu_2_WB),
        .out(alu_2)
    );

    data_mux_3 st_d (
        .sel(st_data_sel),
        .in1(st_data),
        .in2(st_data_MEM),
        .in3(st_data_WB),
        .out(st_data_out)
    );

    alu a (
        .data1(alu_1),
        .data2(alu_2),
        .alu_op(alu_op),
        .result(alu_out)
    );

endmodule //EX_stage