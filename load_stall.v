`include "constants.v"

module load_stall (
    mem_r_EX, reg_dest_EX, reg_rt_ID, reg_rs_ID, stall
);
    input mem_r_EX;
    input [4:0] reg_dest_EX, reg_rt_ID, reg_rs_ID;
    output stall;

    assign stall = (mem_r_EX && (reg_dest_EX == reg_rt_ID || reg_dest_EX == reg_rs_ID)) ? 1 : 0;

endmodule //load_stall