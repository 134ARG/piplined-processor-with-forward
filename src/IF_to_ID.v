`include "constants.v"

module IF_to_ID (
    clk, rst, flush, freeze, PC_in, instruction_in,
    PC_out, instruction_out
);
    input clk, rst, flush, freeze;
    input [`WORD-1:0] PC_in, instruction_in;
    output reg [`WORD-1:0] PC_out, instruction_out;

        initial begin
        $display("init if-to-id");
        // $monitor("ins:%b", instruction_in);
    end

    initial begin
        $display("init ift0id");
        instruction_out <= 0;
    end

    always @(posedge clk) begin
        if (rst == 1) begin
            PC_out <= 0;
            instruction_out <= 0;
            $display("rst");
        end else begin
            if (~freeze) begin
                if (flush) begin
                    PC_out <= 0;
                    instruction_out <= 0;
                    $display("flush");
                end else begin
                    PC_out <= PC_in;
                    instruction_out <= instruction_in;
                    $display("ins!:%b", instruction_in);
                end
            end else begin
                $display("freeze:%b", freeze);
            end
        end

    end
endmodule //IF_to_ID