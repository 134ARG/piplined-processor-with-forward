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
    output [1:0] alu_1_sel, alu_2_sel, st_data_sel;

    always @(*) begin
        if (wb_en_MEM) begin
            if (reg_dest_MEM == reg_rs && reg_rs != 5'b0) begin
                alu_1_sel <= 2'd1;
            end else if (reg_dest_MEM == reg_rt && reg_rt != 5'b0) begin
                alu_2_sel <= 2'd1;
            end else if (reg_dest_MEM == reg_dest && reg_dest != 5'b0) begin
                st_data_sel <= 2'd1;
            end else begin
                {alu_1_sel, alu_2_sel, st_data_sel} <= 0;
            end
        end else if (wb_en_WB) begin
            if (reg_dest_WB == reg_rs && reg_rs != 5'b0) begin
                alu_1_sel <= 2'd2;
            end else if (reg_dest_WB == reg_rt && reg_rt != 5'b0) begin
                alu_2_sel <= 2'd2;
            end else if (reg_dest_WB == reg_dest && reg_dest != 5'b0) begin
                st_data_sel <= 2'd2;
            end else begin
                {alu_1_sel, alu_2_sel, st_data_sel} <= 0;
            end
        end else begin
            {alu_1_sel, alu_2_sel, st_data_sel} <= 0;
        end
    end


endmodule //forward