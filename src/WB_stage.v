`include "constants.v"

module WB_stage (
    mem_r, mem_result, alu_result, terminate,
    wb_data
);
    input mem_r, terminate;
    input [`WORD-1:0] mem_result, alu_result;
    output [`WORD-1:0] wb_data;
    initial begin
        $display("init wb");
    end
    data_mux wb_data_sel(
        .sel(mem_r),
        .in1(alu_result),
        .in2(mem_result),
        .out(wb_data)
    );

    always @(terminate) begin
        if (terminate == 1) begin
            $display("finished");
            $finish;
        end
    end

endmodule //WB_stage