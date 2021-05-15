`include "constants.v"

module register_file (
    clk, rst, write_en, write_reg, write_data,
    reg1, reg2,
    regd1, regd2
);
    //reg [`WORD-1:0] REG [0:`REG_NUM-1];
    input clk, write_en, rst;
    input [4:0] write_reg, reg1, reg2;
    input [`WORD-1:0] write_data;
    output [`WORD-1:0] regd1, regd2;

    reg [`WORD-1:0] REG_FILE [0:`REG_NUM-1];

    always @(negedge clk) begin
        if (write_en) REG_FILE[write_reg] <= write_data;
        if (rst) REG_FILE <= 0;
    end

    assign regd1 = REG_FILE[reg1];
    assign regd2 = REG_FILE[reg2];

endmodule //register_file