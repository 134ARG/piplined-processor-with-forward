`include "constants.v"

module IF_to_ID (
    clk, rst, flush, freeze, PC_in, insturction_in,
    PC_out, instruction_out
);
    input clk, rst, flush, freeze;
    input [`WORD-1:0] PC_in, insturction_in;
    output [`WORD-1:0] PC_out, insturction_out;

    always @(posedge clk) begin
        if (rst) begin
            PC_out <= 0;
            instruction_out <= 0;
        end else begin
            if (~freeze) begin
                if (flush) begin
                    PC_out <= 0;
                    instruction_out <= 0;
                end else begin
                    PC_out <= PC_in;
                    instruction_out <= insturction_in;
                end
            end
        end

    end
endmodule //IF_to_ID