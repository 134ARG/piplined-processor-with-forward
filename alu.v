`include "constants.v"

module alu (
    data1, data2, alu_op,
    result
);
    input [`WORD-1:0] data1, data2;
    input [3:0] alu_op;
    output reg [`WORD-1:0] result;

    always @(*) begin
        case (alu_op)
        `ADD: begin result <= data1 + data2; end
        `ADDU: begin result <= data1 + data2; end
        `AND: begin result <= data1 & data2; end
        `OR: begin result <= data1 | data2; end
        `XOR: begin result <= data1 ^ data2; end
        `NO_OP: begin result <= 0; end
        `SUB: begin result <= data1 - data2; end
        `SUBU: begin result <= data1 - data2; end
        `NOR: begin result <= !(data1 | data2); end
        `SHL: begin result <= data2 << data1; end
        `SHR: begin result <= data2 >> data1; end
        `SHRA: begin result <= data2 >> data1; end
        default : begin result <= 0; end
        endcase
    end

endmodule //alu