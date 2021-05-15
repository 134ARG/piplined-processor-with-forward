`include "constants.v"



module sign_extend (
    immd, signed_immd
);
    input [15:0] immd;
    output [`WORD-1:0] signed_immd;

    assign signed_immd = (immd[15] == 0) ? (32'h0 | immd) : (32'hffff0000 | immd);

endmodule //ID_stage

module unsign_extend (
    immd, unsigned_immd
);
    input [4:0] immd;
    output [`WORD-1:0] unsigned_immd;

    assign unsigned_immd = 32'h0 | immd;
endmodule

module ID_stage (
    clk, rst, instruction, stall,
    wb_dest, wb_en, wb_data,
    branch_a1_sel, branch_a2_sel,
    branch_a1_EX, branch_a1_MEM, branch_a2_EX, branch_a2_MEM,
    branch_a1_WB, branch_a2_WB,
    mem_w, mem_r, alu_op, forward_wb_en,
    branch_taken, jump_taken,
    reg_rs, reg_rt, reg_dest,
    alu_1_data, alu_2_data, st_data,
    branch_offset, jump_address,
    terminate, is_branch
);
    input clk, rst, stall, wb_en;
    input [4:0] wb_dest;
    input [`WORD-1:0] instruction, wb_data;

    input [1:0] branch_a1_sel, branch_a2_sel;
    input [`WORD-1:0] branch_a1_EX, branch_a1_MEM, branch_a1_WB, branch_a2_EX, branch_a2_MEM, branch_a2_WB;

    output mem_w, mem_r, branch_taken, jump_taken, forward_wb_en, terminate, is_branch;
    output [3:0] alu_op;
    output [4:0] reg_rs, reg_rt, reg_dest;
    output [`WORD-1:0] alu_1_data, alu_2_data, st_data, branch_offset, jump_address;

    wire is_immd, is_jal, is_jr;
    wire [`WORD-1:0] regd1, regd2, signed_immd, unsigned_immd, branch_a1, branch_a2;

    initial begin
        $display("init ID");
    end

    always @(instruction) begin
        $display("instruction op:%b, funct:%b, branch:%b", instruction[31:26], instruction[5:0], branch_taken);
    end

    data_mux_4 branch_a1_cond (
        .sel(branch_a1_sel),
        .in1(regd1),
        .in2(branch_a1_EX),
        .in3(branch_a1_MEM),
        .in4(branch_a1_WB),
        .out(branch_a1)
    );

    data_mux_4 branch_a2_cond (
        .sel(branch_a2_sel),
        .in1(regd2),
        .in2(branch_a2_EX),
        .in3(branch_a2_MEM),
        .in4(branch_a2_WB),
        .out(branch_a2)
    );

    always @(branch_a1_sel) begin
        if (branch_a1_sel == 2'd0) $display("1: forward: default.");
        else if (branch_a1_sel == 2'd1) $display("1; forward: EX: %b", branch_a1_EX);
        else $display("1; forward: MEM: %b", branch_a1_MEM);
    end

    always @(branch_a2_sel) begin
        if (branch_a2_sel == 2'd0) $display("2; forward: default.");
        else if (branch_a2_sel == 2'd1) $display("2; forward: MEM: %b", branch_a2_EX);
        else $display("2; forward: WB: %b", branch_a2_MEM);
    end

    control ctl (
        .op(instruction[31:26]),
        .funct(instruction[5:0]),
        .harzard(stall),
        .reg_rs_d(branch_a1),
        .reg_rt_d(branch_a2),
        .is_immd(is_immd),
        .only_shamt(only_shamt),
        .mem_w(mem_w),
        .mem_r(mem_r),
        .alu_op(alu_op),
        .wb_en(forward_wb_en),
        .branch_taken(branch_taken),
        .jump_taken(jump_taken),
        .terminate(terminate),
        .is_branch(is_branch),
        .is_jal(is_jal),u898
        .is_jr(is_jr)
    );

    assign jump_address = (is_jr) ? branch_a1 >> 2 : instruction[25:0];
    assign branch_offset = signed_immd;

    // mux for selecting dest reg for wb operation
    // and forwarding.
    reg_mux dest_sel (
        .sel(is_immd),
        .ra(is_jal),
        .in1(instruction[15:11]),   // rd
        .in2(instruction[20:16]),   // rt
        .out(reg_dest)
    );

    // fetch register value for rs & rt.
    // only edge-triggered when writing (negedge);
    // otherwise works without following clk signal.
    register_file regf (
        .clk(clk),
        .rst(rst),
        .write_en(wb_en),
        .reg1(instruction[25:21]),
        .reg2(instruction[20:16]),
        .write_data(wb_data),
        .write_reg(wb_dest),
        .regd1(regd1),
        .regd2(regd2)
    );

    // rt value for memory write (sw)
    assign st_data = regd2;

    // sign / unsign ext for immd and shamt
    sign_extend s_ext (
        .immd(instruction[15:0]),
        .signed_immd(signed_immd)
    );

    unsign_extend u_ext (
        .immd(instruction[10:6]),
        .unsigned_immd(unsigned_immd)
    );

    // mux for selecting val1 and val2 for ALU
    data_mux alu2_select (
        .sel(is_immd),
        .in1(regd2),
        .in2(signed_immd),
        .out(alu_2_data)
    );

    data_mux alu1_select (
        .sel(only_shamt),
        .in1(regd1),
        .in2(unsigned_immd),
        .out(alu_1_data)
    );

    // used by forwarding unit
    reg_mux rt_sel (
        .sel(is_immd),
        .in1(instruction[20:16]),
        .in2(5'b0),
        .out(reg_rt)
    );

    reg_mux rs_sel (
        .sel(only_shamt),
        .in1(instruction[25:21]),
        .in2(5'b0),
        .out(reg_rs)
    );

endmodule //ID_stage