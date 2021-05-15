`include "constants.v"

module adder (
    a, b, out
);
    input [`WORD-1:0] a, b;
    output [`WORD-1:0] out;

    assign out = a + b;

endmodule //IF_stage

module register (
    clk, in, en, rst, 
    out
);
    input clk, en, rst;
    input [`WORD-1:0] in;
    output [`WORD-1:0] out;

    always @(posedge clk) begin
        if (rst) out <= 0;
        else if (en) out <= in;
    end

endmodule //IF_stage

module IF_stage (
    clk, rst, branch_taken, jump_taken, branch_offset, stall, new_addr,
    PC, instruction
);
    input clk, rst, stall, branch_taken, jump_taken;
    input [`WORD-1:0] branch_offset, new_addr;
    output [`WORD-1:0] PC, instruction;

    wire [`WORD-1:0] offset_times_4, add_input, add_result;

    assign offset_times_4 = branch_offset << 2;

    always @(jump_taken) begin
        if (jump_taken == 1) PC <= new_addr;
    end

    data_mux is_branch (
        .sel(branch_taken),
        .in1(31'd4),
        .in2(offset_times_4),
        .out(add_input)
    );

    adder add_pc (
        .a(add_input),
        .b(PC),
        .out(add_result)
    );

    register pc_reg(
        .clk(clk),
        .in(add_result),
        .rst(rst),
        .en(~stall),
        .out(PC)
    );

    InstructionRAM insRAM(
        .rst(0),
        .address(PC),
        .mem_out(instruction)
    );


endmodule //IF_stage