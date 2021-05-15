`include "constants.v"

module load_stall (
    mem_r_EX, mem_r_MEM, reg_dest_EX, reg_rt_ID, reg_rs_ID, is_branch,
    stall
);

    initial begin
        $display("init loadstall");
    end
    input mem_r_EX, mem_r_MEM, is_branch;
    input [4:0] reg_dest_EX, reg_rt_ID, reg_rs_ID;
    output reg stall;

    always @(*) begin
        stall <= ((mem_r_EX) && (reg_dest_EX == reg_rt_ID || reg_dest_EX == reg_rs_ID)) || (stall && is_branch && mem_r_MEM) ? 1 : 0;
    end

    always @(stall) begin
        $display("stall change: %b, mem_r_EX:%b, mem_r_MEM:%b, is_branch:%b", stall, mem_r_EX, mem_r_MEM, is_branch);
    end
endmodule //load_stall