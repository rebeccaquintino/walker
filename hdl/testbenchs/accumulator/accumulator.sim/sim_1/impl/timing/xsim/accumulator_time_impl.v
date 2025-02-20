// Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2020.1 (win64) Build 2902540 Wed May 27 19:54:49 MDT 2020
// Date        : Thu Jan  9 17:07:57 2025
// Host        : DESKTOP-JUG9BUI running 64-bit major release  (build 9200)
// Command     : write_verilog -mode timesim -nolib -sdf_anno true -force -file
//               C:/Users/rebec/Desktop/Spacelab/brave/walker/testbenchs/accumulator/accumulator.sim/sim_1/impl/timing/xsim/accumulator_time_impl.v
// Design      : accumulator
// Purpose     : This verilog netlist is a timing simulation representation of the design and should not be modified or
//               synthesized. Please ensure that this netlist is used with the corresponding SDF file.
// Device      : xc7k70tfbv676-1
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps
`define XIL_TIMING

(* ECO_CHECKSUM = "ff47180f" *) (* p_INCREMENT = "1" *) (* p_INIT_DATA = "0" *) 
(* p_WIDTH = "8" *) 
(* NotValidForBitStream *)
module accumulator
   (i_CLK,
    i_RST,
    i_RST_CONTROL,
    i_ENABLE,
    o_DOUT);
  input i_CLK;
  input i_RST;
  input i_RST_CONTROL;
  input i_ENABLE;
  output [7:0]o_DOUT;

  wire i_CLK;
  wire i_CLK_IBUF;
  wire i_CLK_IBUF_BUFG;
  wire i_ENABLE;
  wire i_ENABLE_IBUF;
  wire i_RST;
  wire i_RST_CONTROL;
  wire i_RST_CONTROL_IBUF;
  wire i_RST_IBUF;
  wire [7:0]o_DOUT;
  wire [7:0]o_DOUT_OBUF;

initial begin
 $sdf_annotate("accumulator_time_impl.sdf",,,,"tool_control");
end
  BUFG i_CLK_IBUF_BUFG_inst
       (.I(i_CLK_IBUF),
        .O(i_CLK_IBUF_BUFG));
  IBUF i_CLK_IBUF_inst
       (.I(i_CLK),
        .O(i_CLK_IBUF));
  IBUF i_ENABLE_IBUF_inst
       (.I(i_ENABLE),
        .O(i_ENABLE_IBUF));
  IBUF i_RST_CONTROL_IBUF_inst
       (.I(i_RST_CONTROL),
        .O(i_RST_CONTROL_IBUF));
  IBUF i_RST_IBUF_inst
       (.I(i_RST),
        .O(i_RST_IBUF));
  OBUF \o_DOUT_OBUF[0]_inst 
       (.I(o_DOUT_OBUF[0]),
        .O(o_DOUT[0]));
  OBUF \o_DOUT_OBUF[1]_inst 
       (.I(o_DOUT_OBUF[1]),
        .O(o_DOUT[1]));
  OBUF \o_DOUT_OBUF[2]_inst 
       (.I(o_DOUT_OBUF[2]),
        .O(o_DOUT[2]));
  OBUF \o_DOUT_OBUF[3]_inst 
       (.I(o_DOUT_OBUF[3]),
        .O(o_DOUT[3]));
  OBUF \o_DOUT_OBUF[4]_inst 
       (.I(o_DOUT_OBUF[4]),
        .O(o_DOUT[4]));
  OBUF \o_DOUT_OBUF[5]_inst 
       (.I(o_DOUT_OBUF[5]),
        .O(o_DOUT[5]));
  OBUF \o_DOUT_OBUF[6]_inst 
       (.I(o_DOUT_OBUF[6]),
        .O(o_DOUT[6]));
  OBUF \o_DOUT_OBUF[7]_inst 
       (.I(o_DOUT_OBUF[7]),
        .O(o_DOUT[7]));
  \reg  u_REG
       (.i_CLK(i_CLK_IBUF_BUFG),
        .i_ENABLE(i_ENABLE_IBUF),
        .i_RST_CONTROL_IBUF(i_RST_CONTROL_IBUF),
        .i_RST_IBUF(i_RST_IBUF),
        .o_DOUT(o_DOUT_OBUF));
endmodule

module \reg 
   (o_DOUT,
    i_ENABLE,
    i_CLK,
    i_RST_IBUF,
    i_RST_CONTROL_IBUF);
  output [7:0]o_DOUT;
  input i_ENABLE;
  input i_CLK;
  input i_RST_IBUF;
  input i_RST_CONTROL_IBUF;

  wire i_CLK;
  wire i_ENABLE;
  wire i_RST_CONTROL_IBUF;
  wire i_RST_IBUF;
  wire [7:0]o_DOUT;
  wire [7:0]o_DOUT__0;
  wire \w_DOUT_REG[7]_i_3_n_0 ;
  wire w_RST_REGS;

  LUT1 #(
    .INIT(2'h1)) 
    \w_DOUT_REG[0]_i_1 
       (.I0(o_DOUT[0]),
        .O(o_DOUT__0[0]));
  (* SOFT_HLUTNM = "soft_lutpair2" *) 
  LUT2 #(
    .INIT(4'h6)) 
    \w_DOUT_REG[1]_i_1 
       (.I0(o_DOUT[0]),
        .I1(o_DOUT[1]),
        .O(o_DOUT__0[1]));
  (* SOFT_HLUTNM = "soft_lutpair2" *) 
  LUT3 #(
    .INIT(8'h78)) 
    \w_DOUT_REG[2]_i_1 
       (.I0(o_DOUT[0]),
        .I1(o_DOUT[1]),
        .I2(o_DOUT[2]),
        .O(o_DOUT__0[2]));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT4 #(
    .INIT(16'h7F80)) 
    \w_DOUT_REG[3]_i_1 
       (.I0(o_DOUT[1]),
        .I1(o_DOUT[0]),
        .I2(o_DOUT[2]),
        .I3(o_DOUT[3]),
        .O(o_DOUT__0[3]));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT5 #(
    .INIT(32'h7FFF8000)) 
    \w_DOUT_REG[4]_i_1 
       (.I0(o_DOUT[2]),
        .I1(o_DOUT[0]),
        .I2(o_DOUT[1]),
        .I3(o_DOUT[3]),
        .I4(o_DOUT[4]),
        .O(o_DOUT__0[4]));
  LUT6 #(
    .INIT(64'h7FFFFFFF80000000)) 
    \w_DOUT_REG[5]_i_1 
       (.I0(o_DOUT[3]),
        .I1(o_DOUT[1]),
        .I2(o_DOUT[0]),
        .I3(o_DOUT[2]),
        .I4(o_DOUT[4]),
        .I5(o_DOUT[5]),
        .O(o_DOUT__0[5]));
  (* SOFT_HLUTNM = "soft_lutpair1" *) 
  LUT2 #(
    .INIT(4'h6)) 
    \w_DOUT_REG[6]_i_1 
       (.I0(\w_DOUT_REG[7]_i_3_n_0 ),
        .I1(o_DOUT[6]),
        .O(o_DOUT__0[6]));
  (* SOFT_HLUTNM = "soft_lutpair1" *) 
  LUT3 #(
    .INIT(8'h78)) 
    \w_DOUT_REG[7]_i_1 
       (.I0(\w_DOUT_REG[7]_i_3_n_0 ),
        .I1(o_DOUT[6]),
        .I2(o_DOUT[7]),
        .O(o_DOUT__0[7]));
  LUT2 #(
    .INIT(4'hE)) 
    \w_DOUT_REG[7]_i_2 
       (.I0(i_RST_IBUF),
        .I1(i_RST_CONTROL_IBUF),
        .O(w_RST_REGS));
  LUT6 #(
    .INIT(64'h8000000000000000)) 
    \w_DOUT_REG[7]_i_3 
       (.I0(o_DOUT[5]),
        .I1(o_DOUT[3]),
        .I2(o_DOUT[1]),
        .I3(o_DOUT[0]),
        .I4(o_DOUT[2]),
        .I5(o_DOUT[4]),
        .O(\w_DOUT_REG[7]_i_3_n_0 ));
  FDCE #(
    .INIT(1'b0)) 
    \w_DOUT_REG_reg[0] 
       (.C(i_CLK),
        .CE(i_ENABLE),
        .CLR(w_RST_REGS),
        .D(o_DOUT__0[0]),
        .Q(o_DOUT[0]));
  FDCE #(
    .INIT(1'b0)) 
    \w_DOUT_REG_reg[1] 
       (.C(i_CLK),
        .CE(i_ENABLE),
        .CLR(w_RST_REGS),
        .D(o_DOUT__0[1]),
        .Q(o_DOUT[1]));
  FDCE #(
    .INIT(1'b0)) 
    \w_DOUT_REG_reg[2] 
       (.C(i_CLK),
        .CE(i_ENABLE),
        .CLR(w_RST_REGS),
        .D(o_DOUT__0[2]),
        .Q(o_DOUT[2]));
  FDCE #(
    .INIT(1'b0)) 
    \w_DOUT_REG_reg[3] 
       (.C(i_CLK),
        .CE(i_ENABLE),
        .CLR(w_RST_REGS),
        .D(o_DOUT__0[3]),
        .Q(o_DOUT[3]));
  FDCE #(
    .INIT(1'b0)) 
    \w_DOUT_REG_reg[4] 
       (.C(i_CLK),
        .CE(i_ENABLE),
        .CLR(w_RST_REGS),
        .D(o_DOUT__0[4]),
        .Q(o_DOUT[4]));
  FDCE #(
    .INIT(1'b0)) 
    \w_DOUT_REG_reg[5] 
       (.C(i_CLK),
        .CE(i_ENABLE),
        .CLR(w_RST_REGS),
        .D(o_DOUT__0[5]),
        .Q(o_DOUT[5]));
  FDCE #(
    .INIT(1'b0)) 
    \w_DOUT_REG_reg[6] 
       (.C(i_CLK),
        .CE(i_ENABLE),
        .CLR(w_RST_REGS),
        .D(o_DOUT__0[6]),
        .Q(o_DOUT[6]));
  FDCE #(
    .INIT(1'b0)) 
    \w_DOUT_REG_reg[7] 
       (.C(i_CLK),
        .CE(i_ENABLE),
        .CLR(w_RST_REGS),
        .D(o_DOUT__0[7]),
        .Q(o_DOUT[7]));
endmodule
`ifndef GLBL
`define GLBL
`timescale  1 ps / 1 ps

module glbl ();

    parameter ROC_WIDTH = 100000;
    parameter TOC_WIDTH = 0;
    parameter GRES_WIDTH = 10000;
    parameter GRES_START = 10000;

//--------   STARTUP Globals --------------
    wire GSR;
    wire GTS;
    wire GWE;
    wire PRLD;
    wire GRESTORE;
    tri1 p_up_tmp;
    tri (weak1, strong0) PLL_LOCKG = p_up_tmp;

    wire PROGB_GLBL;
    wire CCLKO_GLBL;
    wire FCSBO_GLBL;
    wire [3:0] DO_GLBL;
    wire [3:0] DI_GLBL;
   
    reg GSR_int;
    reg GTS_int;
    reg PRLD_int;
    reg GRESTORE_int;

//--------   JTAG Globals --------------
    wire JTAG_TDO_GLBL;
    wire JTAG_TCK_GLBL;
    wire JTAG_TDI_GLBL;
    wire JTAG_TMS_GLBL;
    wire JTAG_TRST_GLBL;

    reg JTAG_CAPTURE_GLBL;
    reg JTAG_RESET_GLBL;
    reg JTAG_SHIFT_GLBL;
    reg JTAG_UPDATE_GLBL;
    reg JTAG_RUNTEST_GLBL;

    reg JTAG_SEL1_GLBL = 0;
    reg JTAG_SEL2_GLBL = 0 ;
    reg JTAG_SEL3_GLBL = 0;
    reg JTAG_SEL4_GLBL = 0;

    reg JTAG_USER_TDO1_GLBL = 1'bz;
    reg JTAG_USER_TDO2_GLBL = 1'bz;
    reg JTAG_USER_TDO3_GLBL = 1'bz;
    reg JTAG_USER_TDO4_GLBL = 1'bz;

    assign (strong1, weak0) GSR = GSR_int;
    assign (strong1, weak0) GTS = GTS_int;
    assign (weak1, weak0) PRLD = PRLD_int;
    assign (strong1, weak0) GRESTORE = GRESTORE_int;

    initial begin
	GSR_int = 1'b1;
	PRLD_int = 1'b1;
	#(ROC_WIDTH)
	GSR_int = 1'b0;
	PRLD_int = 1'b0;
    end

    initial begin
	GTS_int = 1'b1;
	#(TOC_WIDTH)
	GTS_int = 1'b0;
    end

    initial begin 
	GRESTORE_int = 1'b0;
	#(GRES_START);
	GRESTORE_int = 1'b1;
	#(GRES_WIDTH);
	GRESTORE_int = 1'b0;
    end

endmodule
`endif
