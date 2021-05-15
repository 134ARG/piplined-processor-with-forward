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
    integer i;

    initial begin
        $monitor("%h:%h:%h:%h:%h:%h:%h:%h:%h:%h:%h:%h:%h:%h:%h:%h:%h:%h:%h:%h:%h:%h:%h:%h:%h:%h:%h:%h:%h:%h:%h:%h:", 
        REG_FILE[0],REG_FILE[1],REG_FILE[2],REG_FILE[3],REG_FILE[4],REG_FILE[5],REG_FILE[6],REG_FILE[07],
        REG_FILE[8],REG_FILE[9],REG_FILE[10],REG_FILE[11],REG_FILE[12],REG_FILE[13],REG_FILE[14],REG_FILE[15],
        REG_FILE[16],REG_FILE[17],REG_FILE[18],REG_FILE[19],REG_FILE[20],REG_FILE[21],REG_FILE[22],REG_FILE[23],
        REG_FILE[24],REG_FILE[25],REG_FILE[26],REG_FILE[27],REG_FILE[28],REG_FILE[29],REG_FILE[30],REG_FILE[31]);
        for (i = 0; i < `REG_NUM; i = i + 1)
                REG_FILE[i] <= 0;
    end

    always @(negedge clk) begin
        if (write_en) REG_FILE[write_reg] <= write_data;
        if (rst) begin
            for (i = 0; i < `REG_NUM; i = i + 1)
                REG_FILE[i] <= 0;
        end
    end

    assign regd1 = REG_FILE[reg1];
    assign regd2 = REG_FILE[reg2];

endmodule //register_file