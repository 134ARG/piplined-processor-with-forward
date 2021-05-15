`include "constants.v"

module forward (
    wb_en_MEM,
    wb_en_WB,
    reg_rs, reg_rt, reg_dest, reg_dest_MEM,
    reg_dest_WB,
    alu_1_sel, alu_2_sel, st_data_sel
);

    input wb_en_MEM;
    input  wb_en_WB;
    input [4:0] reg_rs, reg_rt, reg_dest, reg_dest_MEM, reg_dest_WB;
    output reg [1:0] alu_1_sel, alu_2_sel, st_data_sel;

    initial begin
        $display("init forward");
        {alu_1_sel, alu_2_sel, st_data_sel} <= 0;
    end
    always @(*) begin
        

        if (reg_dest_MEM == reg_rs && reg_rs != 5'b0) begin
            if (wb_en_MEM) alu_1_sel <= 2'd1;
            else alu_1_sel <= 0;
        end else if (reg_dest_WB == reg_rs && reg_rs != 5'b0) begin
            if (wb_en_WB) alu_1_sel <= 2'd2;
            else alu_1_sel <= 0;
        end else alu_1_sel <= 0;

        if (reg_dest_MEM == reg_rt && reg_rt != 5'b0) begin
            if (wb_en_MEM) alu_2_sel <= 2'd1;
            else alu_2_sel <= 0;
        end else if (reg_dest_WB == reg_rt && reg_rt != 5'b0) begin
            if (wb_en_WB) alu_2_sel <= 2'd2;
            else alu_2_sel <= 0;
        end else alu_2_sel <= 0;

        if (reg_dest_MEM == reg_dest && reg_dest != 5'b0) begin
            if (wb_en_MEM) st_data_sel <= 2'd1;
            else st_data_sel <= 0;
        end else if (reg_dest_WB == reg_dest && reg_dest != 5'b0) begin
            if (wb_en_WB) st_data_sel <= 2'd2;
            else st_data_sel <= 0;
        end else st_data_sel <= 0;
    end


endmodule //forward

module forward2 (
    wb_en_MEM,
    wb_en_WB,
    wb_en_EX,
    mem_r_en,
    reg_rs, reg_rt, reg_dest_MEM,
    reg_dest_WB, reg_dest_EX,
    alu_1_sel, alu_2_sel
);

    input wb_en_MEM, wb_en_EX;
    input  wb_en_WB, mem_r_en;
    input [4:0] reg_rs, reg_rt, reg_dest_MEM, reg_dest_WB, reg_dest_EX;
    output reg [1:0] alu_1_sel, alu_2_sel;

    initial begin
        $display("init forward");
        {alu_1_sel, alu_2_sel} <= 0;
    end
    always @(*) begin
        if (mem_r_en) {alu_1_sel, alu_2_sel} <= 0;
        else begin
            if (reg_dest_EX == reg_rs && reg_rs != 5'b0) begin
            if (wb_en_EX) alu_1_sel <= 2'd1;
            else alu_1_sel <= 0;
        end else if (reg_dest_MEM == reg_rs && reg_rs != 5'b0) begin
            if (wb_en_MEM) alu_1_sel <= 2'd2;
            else alu_1_sel <= 0;
        end else if (reg_dest_WB == reg_rs && reg_rs != 5'b0) begin
            if (wb_en_WB) alu_1_sel <= 2'd3;
            else alu_1_sel <= 0;
        end
        else alu_1_sel <= 0;

        if (reg_dest_EX == reg_rt && reg_rt != 5'b0) begin
            if (wb_en_EX) alu_2_sel <= 2'd1;
            else alu_2_sel <= 0;
        end else if (reg_dest_MEM == reg_rt && reg_rt != 5'b0) begin
            if (wb_en_MEM) alu_2_sel <= 2'd2;
            else alu_2_sel <= 0;
        end else if (reg_dest_WB == reg_rt && reg_rt != 5'b0) begin
            if (wb_en_WB) alu_2_sel <= 2'd3;
            else alu_2_sel <= 0;
        end
        else alu_2_sel <= 0;
        end
    end
endmodule //forward