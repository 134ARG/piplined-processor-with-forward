`include "constants.v"

module control (
    op, funct, harzard, reg_rs_d, reg_rt_d,
    is_immd, only_shamt, mem_w, mem_r, alu_op,
    wb_en, branch_taken, jump_taken, terminate
);
    input [5:0] op, funct;
    input [`WORD-1:0] reg_rs_d, reg_rt_d;
    input harzard;
    output reg is_immd, mem_w, mem_r, wb_en, branch_taken, only_shamt, jump_taken, terminate;
    output reg [3:0] alu_op;

    initial begin
        $display("init control");
        // $monitor("tem:%b", terminate);
        {is_immd, mem_w, mem_r, wb_en, branch_taken, only_shamt, jump_taken, terminate, alu_op} <= 0;
    end
    always @(*) begin
        if (harzard == 0) begin
            {is_immd, mem_w, mem_r, wb_en, branch_taken, only_shamt, jump_taken, terminate, alu_op} <= 0;
            if (op == 6'b111111 && funct == 6'b111111) terminate <= 1;
            else terminate <= 0;
            case(op)
            `SW_OPCODE: begin alu_op <= `ADD; wb_en <= 0; is_immd <= 1; mem_w <= 1; end
            `LW_OPCODE: begin alu_op <= `ADD; wb_en <= 1; is_immd <= 1; mem_r <= 1; end
            `ADDI_OPCODE: begin alu_op <= `ADD; wb_en <= 1; is_immd <= 1; end
            `ADDIU_OPCODE: begin alu_op <= `ADD; wb_en <= 1; is_immd <= 1; end
            `ANDI_OPCODE: begin alu_op <= `AND; wb_en <= 1; is_immd <= 1; end
            `ORI_OPCODE: begin alu_op <= `OR; wb_en <= 1; is_immd <=1; end
            `XORI_OPCODE: begin alu_op <= `XOR; wb_en <= 1; is_immd <= 1; end
            `BEQ_OPCODE: begin
                if (reg_rs_d == reg_rt_d) branch_taken <= 1;
                else branch_taken <= 0;
            end
            `BNE_OPCODE: begin 
                if (reg_rs_d == reg_rt_d) branch_taken <= 0;
                else branch_taken <= 1;
            end
            `J_OPCODE: begin alu_op <= `NO_OP; jump_taken <= 1; end
            0: begin
                case(funct)
                `ADD_FUN: begin alu_op <= `ADD; wb_en <= 1; end
                `ADDU_FUN: begin alu_op <= `ADDU; wb_en <= 1; end
                `SUB_FUN: begin alu_op <= `SUBU; wb_en <= 1; end
                `SUBU_FUN: begin alu_op <= `SUB; wb_en <= 1; end
                `AND_FUN: begin alu_op <= `AND; wb_en <= 1; end
                `NOR_FUN: begin alu_op <= `NOR; wb_en <= 1; end
                `OR_FUN: begin alu_op <= `OR; wb_en <= 1; end
                `XOR_FUN: begin alu_op <= `XOR; wb_en <= 1; end
                `SLL_FUN: begin alu_op <= `SHL; wb_en <= 1; only_shamt <= 1; end
                `SLLV_FUN: begin alu_op <= `SHL; wb_en <= 1; end
                `SRL_FUN: begin alu_op <= `SHR; wb_en <= 1; only_shamt <= 1; end
                `SRLV_FUN: begin alu_op <= `SHR; wb_en <= 1; end
                `SRA_FUN: begin alu_op <= `SHRA; wb_en <= 1; only_shamt <= 1; end
                `SRAV_FUN: begin alu_op <= `SHRA; wb_en <= 1; end
                `JAL_FUN: begin alu_op <= `NO_OP; jump_taken <= 1; end
                `SLT_FUN: begin alu_op <= `LE; wb_en <= 1; end
                default: {is_immd, mem_w, mem_r, wb_en, branch_taken, only_shamt, jump_taken, terminate, alu_op} <= 0;
                endcase
            end
        endcase
        end else begin
            {alu_op, mem_w, wb_en} <= 0;
        end
    end

endmodule //control