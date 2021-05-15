`include "constants.v"

module reg_mux (
    sel, ra, in1, in2, out
);
    input sel, ra;
    input [4:0] in1, in2;
    output [4:0] out;

    assign out = (ra) ? 5'b11111 : (sel == 0) ? in1 : in2;

endmodule //ID_stage

module data_mux (
    sel, in1, in2, out
);
    input sel;
    input [`WORD-1:0] in1, in2;
    output [`WORD-1:0] out;

    assign out = (sel == 0) ? in1 : in2;

endmodule //ID_stage

module data_mux_3 (
    sel, in1, in2, in3, out
);
    input [1:0]sel;
    input [`WORD-1:0] in1, in2, in3;
    output [`WORD-1:0] out;

    assign out = (sel == 2'd0) ? in1 : 
                    (sel == 2'd1) ? in2 : in3;
endmodule //mux

module data_mux_4 (
    sel, in1, in2, in3, in4, out
);
    input [1:0]sel;
    input [`WORD-1:0] in1, in2, in3, in4;
    output [`WORD-1:0] out;

    assign out = (sel == 2'd0) ? in1 : 
                    (sel == 2'd1) ? in2 : 
                    (sel == 2'd2) ? in3 : in4;
endmodule //mux