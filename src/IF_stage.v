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
    output reg [`WORD-1:0] out;

    initial begin
        out <= 0;
    end

    always @(posedge clk) begin
        // $display("src:%b", in);
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

    initial begin
        $display("init if");
    end

    always @(branch_taken) begin
        if (branch_taken)
            $display("---branch: offset:%h", branch_offset);
    end

    data_mux is_branch (
        .sel(branch_taken),
        .in1(32'd4),
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
        .in(jump_taken ? new_addr : add_result),
        .rst(rst),
        .en(~stall),
        .out(PC)
    );

    InstructionRAM insRAM(
        .rst(rst),
        .address(PC),
        .mem_out(instruction)
    );


endmodule //IF_stage