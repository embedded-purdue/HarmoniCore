// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2025 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2025.1 (win64) Build 6140274 Thu May 22 00:12:29 MDT 2025
// Date        : Sun Oct 26 14:21:48 2025
// Host        : LAPTOP-ECVP0FVU running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim {d:/School/Fall
//               2025/ESAP/Hcore/HarmoniCore/sv/HarmoniCore.gen/sources_1/ip/blk_mem_gen_0/blk_mem_gen_0_sim_netlist.v}
// Design      : blk_mem_gen_0
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7a25tcsg325-2
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "blk_mem_gen_0,blk_mem_gen_v8_4_11,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "blk_mem_gen_v8_4_11,Vivado 2025.1" *) 
(* NotValidForBitStream *)
module blk_mem_gen_0
   (clka,
    ena,
    wea,
    addra,
    dina,
    douta,
    clkb,
    enb,
    web,
    addrb,
    dinb,
    doutb);
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA CLK" *) (* x_interface_mode = "slave BRAM_PORTA" *) (* x_interface_parameter = "XIL_INTERFACENAME BRAM_PORTA, MEM_ADDRESS_MODE BYTE_ADDRESS, MEM_SIZE 8192, MEM_WIDTH 32, MEM_ECC NONE, MASTER_TYPE OTHER, READ_LATENCY 1" *) input clka;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA EN" *) input ena;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA WE" *) input [0:0]wea;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA ADDR" *) input [3:0]addra;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA DIN" *) input [17:0]dina;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA DOUT" *) output [17:0]douta;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTB CLK" *) (* x_interface_mode = "slave BRAM_PORTB" *) (* x_interface_parameter = "XIL_INTERFACENAME BRAM_PORTB, MEM_ADDRESS_MODE BYTE_ADDRESS, MEM_SIZE 8192, MEM_WIDTH 32, MEM_ECC NONE, MASTER_TYPE OTHER, READ_LATENCY 1" *) input clkb;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTB EN" *) input enb;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTB WE" *) input [0:0]web;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTB ADDR" *) input [3:0]addrb;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTB DIN" *) input [17:0]dinb;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTB DOUT" *) output [17:0]doutb;

  wire [3:0]addra;
  wire [3:0]addrb;
  wire clka;
  wire [17:0]dina;
  wire [17:0]dinb;
  wire [17:0]douta;
  wire [17:0]doutb;
  wire ena;
  wire enb;
  wire [0:0]wea;
  wire [0:0]web;
  wire NLW_U0_dbiterr_UNCONNECTED;
  wire NLW_U0_rsta_busy_UNCONNECTED;
  wire NLW_U0_rstb_busy_UNCONNECTED;
  wire NLW_U0_s_axi_arready_UNCONNECTED;
  wire NLW_U0_s_axi_awready_UNCONNECTED;
  wire NLW_U0_s_axi_bvalid_UNCONNECTED;
  wire NLW_U0_s_axi_dbiterr_UNCONNECTED;
  wire NLW_U0_s_axi_rlast_UNCONNECTED;
  wire NLW_U0_s_axi_rvalid_UNCONNECTED;
  wire NLW_U0_s_axi_sbiterr_UNCONNECTED;
  wire NLW_U0_s_axi_wready_UNCONNECTED;
  wire NLW_U0_sbiterr_UNCONNECTED;
  wire [3:0]NLW_U0_rdaddrecc_UNCONNECTED;
  wire [3:0]NLW_U0_s_axi_bid_UNCONNECTED;
  wire [1:0]NLW_U0_s_axi_bresp_UNCONNECTED;
  wire [3:0]NLW_U0_s_axi_rdaddrecc_UNCONNECTED;
  wire [17:0]NLW_U0_s_axi_rdata_UNCONNECTED;
  wire [3:0]NLW_U0_s_axi_rid_UNCONNECTED;
  wire [1:0]NLW_U0_s_axi_rresp_UNCONNECTED;

  (* C_ADDRA_WIDTH = "4" *) 
  (* C_ADDRB_WIDTH = "4" *) 
  (* C_ALGORITHM = "1" *) 
  (* C_AXI_ID_WIDTH = "4" *) 
  (* C_AXI_SLAVE_TYPE = "0" *) 
  (* C_AXI_TYPE = "1" *) 
  (* C_BYTE_SIZE = "9" *) 
  (* C_COMMON_CLK = "1" *) 
  (* C_COUNT_18K_BRAM = "1" *) 
  (* C_COUNT_36K_BRAM = "0" *) 
  (* C_CTRL_ECC_ALGO = "NONE" *) 
  (* C_DEFAULT_DATA = "0" *) 
  (* C_DISABLE_WARN_BHV_COLL = "0" *) 
  (* C_DISABLE_WARN_BHV_RANGE = "0" *) 
  (* C_ELABORATION_DIR = "./" *) 
  (* C_ENABLE_32BIT_ADDRESS = "0" *) 
  (* C_EN_DEEPSLEEP_PIN = "0" *) 
  (* C_EN_ECC_PIPE = "0" *) 
  (* C_EN_RDADDRA_CHG = "0" *) 
  (* C_EN_RDADDRB_CHG = "0" *) 
  (* C_EN_SAFETY_CKT = "0" *) 
  (* C_EN_SHUTDOWN_PIN = "0" *) 
  (* C_EN_SLEEP_PIN = "0" *) 
  (* C_EST_POWER_SUMMARY = "Estimated Power for IP     :     3.1193 mW" *) 
  (* C_FAMILY = "artix7" *) 
  (* C_HAS_AXI_ID = "0" *) 
  (* C_HAS_ENA = "1" *) 
  (* C_HAS_ENB = "1" *) 
  (* C_HAS_INJECTERR = "0" *) 
  (* C_HAS_MEM_OUTPUT_REGS_A = "1" *) 
  (* C_HAS_MEM_OUTPUT_REGS_B = "1" *) 
  (* C_HAS_MUX_OUTPUT_REGS_A = "0" *) 
  (* C_HAS_MUX_OUTPUT_REGS_B = "0" *) 
  (* C_HAS_REGCEA = "0" *) 
  (* C_HAS_REGCEB = "0" *) 
  (* C_HAS_RSTA = "0" *) 
  (* C_HAS_RSTB = "0" *) 
  (* C_HAS_SOFTECC_INPUT_REGS_A = "0" *) 
  (* C_HAS_SOFTECC_OUTPUT_REGS_B = "0" *) 
  (* C_INITA_VAL = "0" *) 
  (* C_INITB_VAL = "0" *) 
  (* C_INIT_FILE = "blk_mem_gen_0.mem" *) 
  (* C_INIT_FILE_NAME = "no_coe_file_loaded" *) 
  (* C_INTERFACE_TYPE = "0" *) 
  (* C_LOAD_INIT_FILE = "0" *) 
  (* C_MEM_TYPE = "2" *) 
  (* C_MUX_PIPELINE_STAGES = "0" *) 
  (* C_PRIM_TYPE = "1" *) 
  (* C_READ_DEPTH_A = "12" *) 
  (* C_READ_DEPTH_B = "12" *) 
  (* C_READ_LATENCY_A = "1" *) 
  (* C_READ_LATENCY_B = "1" *) 
  (* C_READ_WIDTH_A = "18" *) 
  (* C_READ_WIDTH_B = "18" *) 
  (* C_RSTRAM_A = "0" *) 
  (* C_RSTRAM_B = "0" *) 
  (* C_RST_PRIORITY_A = "CE" *) 
  (* C_RST_PRIORITY_B = "CE" *) 
  (* C_SIM_COLLISION_CHECK = "ALL" *) 
  (* C_USE_BRAM_BLOCK = "0" *) 
  (* C_USE_BYTE_WEA = "0" *) 
  (* C_USE_BYTE_WEB = "0" *) 
  (* C_USE_DEFAULT_DATA = "0" *) 
  (* C_USE_ECC = "0" *) 
  (* C_USE_SOFTECC = "0" *) 
  (* C_USE_URAM = "0" *) 
  (* C_WEA_WIDTH = "1" *) 
  (* C_WEB_WIDTH = "1" *) 
  (* C_WRITE_DEPTH_A = "12" *) 
  (* C_WRITE_DEPTH_B = "12" *) 
  (* C_WRITE_MODE_A = "WRITE_FIRST" *) 
  (* C_WRITE_MODE_B = "WRITE_FIRST" *) 
  (* C_WRITE_WIDTH_A = "18" *) 
  (* C_WRITE_WIDTH_B = "18" *) 
  (* C_XDEVICEFAMILY = "artix7" *) 
  (* downgradeipidentifiedwarnings = "yes" *) 
  (* is_du_within_envelope = "true" *) 
  blk_mem_gen_0_blk_mem_gen_v8_4_11 U0
       (.addra(addra),
        .addrb(addrb),
        .clka(clka),
        .clkb(1'b0),
        .dbiterr(NLW_U0_dbiterr_UNCONNECTED),
        .deepsleep(1'b0),
        .dina(dina),
        .dinb(dinb),
        .douta(douta),
        .doutb(doutb),
        .eccpipece(1'b0),
        .ena(ena),
        .enb(enb),
        .injectdbiterr(1'b0),
        .injectsbiterr(1'b0),
        .rdaddrecc(NLW_U0_rdaddrecc_UNCONNECTED[3:0]),
        .regcea(1'b1),
        .regceb(1'b1),
        .rsta(1'b0),
        .rsta_busy(NLW_U0_rsta_busy_UNCONNECTED),
        .rstb(1'b0),
        .rstb_busy(NLW_U0_rstb_busy_UNCONNECTED),
        .s_aclk(1'b0),
        .s_aresetn(1'b0),
        .s_axi_araddr({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arburst({1'b0,1'b0}),
        .s_axi_arid({1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arlen({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arready(NLW_U0_s_axi_arready_UNCONNECTED),
        .s_axi_arsize({1'b0,1'b0,1'b0}),
        .s_axi_arvalid(1'b0),
        .s_axi_awaddr({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awburst({1'b0,1'b0}),
        .s_axi_awid({1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awlen({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awready(NLW_U0_s_axi_awready_UNCONNECTED),
        .s_axi_awsize({1'b0,1'b0,1'b0}),
        .s_axi_awvalid(1'b0),
        .s_axi_bid(NLW_U0_s_axi_bid_UNCONNECTED[3:0]),
        .s_axi_bready(1'b0),
        .s_axi_bresp(NLW_U0_s_axi_bresp_UNCONNECTED[1:0]),
        .s_axi_bvalid(NLW_U0_s_axi_bvalid_UNCONNECTED),
        .s_axi_dbiterr(NLW_U0_s_axi_dbiterr_UNCONNECTED),
        .s_axi_injectdbiterr(1'b0),
        .s_axi_injectsbiterr(1'b0),
        .s_axi_rdaddrecc(NLW_U0_s_axi_rdaddrecc_UNCONNECTED[3:0]),
        .s_axi_rdata(NLW_U0_s_axi_rdata_UNCONNECTED[17:0]),
        .s_axi_rid(NLW_U0_s_axi_rid_UNCONNECTED[3:0]),
        .s_axi_rlast(NLW_U0_s_axi_rlast_UNCONNECTED),
        .s_axi_rready(1'b0),
        .s_axi_rresp(NLW_U0_s_axi_rresp_UNCONNECTED[1:0]),
        .s_axi_rvalid(NLW_U0_s_axi_rvalid_UNCONNECTED),
        .s_axi_sbiterr(NLW_U0_s_axi_sbiterr_UNCONNECTED),
        .s_axi_wdata({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_wlast(1'b0),
        .s_axi_wready(NLW_U0_s_axi_wready_UNCONNECTED),
        .s_axi_wstrb(1'b0),
        .s_axi_wvalid(1'b0),
        .sbiterr(NLW_U0_sbiterr_UNCONNECTED),
        .shutdown(1'b0),
        .sleep(1'b0),
        .wea(wea),
        .web(web));
endmodule
`pragma protect begin_protected
`pragma protect version = 1
`pragma protect encrypt_agent = "XILINX"
`pragma protect encrypt_agent_info = "Xilinx Encryption Tool 2025.1"
`pragma protect key_keyowner="Synopsys", key_keyname="SNPS-VCS-RSA-2", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
gydSV72FvW4hnoyUt6yZFJHfJqjRQWPUfYIuDKP0fpjrPOkLRbJGBr4Z9msYTvoIHRlYtXJ2YMY0
d1TIQb+FK4gKsTRru9wr397OxuFBsTRf4e+ZjpYZEdsnqYWcgMSzhN4yhPvO06GyZO15y/LKBxa8
3OKwxVlOLYXhv+sxdXg=

`pragma protect key_keyowner="Aldec", key_keyname="ALDEC15_001", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
WHB6Zbfa5Qi47krP9T4L8UnPOlr881dWx7UcYaZfNGIQQM0gadcoXbhucIpRaUuyOKxv6yhKveRN
h0l+N9+KX6rbZ6+TRhP9JAMuPhlpI7T42QtRv5zx9+m3ct5S0NMszbFaK8zeTAYra5BGP7BHmtkr
MpKfLK5sFyaTE/A7ACtAace9MwFTHDZdl9uUs4aY6KJlm6GaypKduiqkNugukJp5vlFPX/ZapJqG
KMtMhI6grhcuYb1FJrwRZ4jW7hs9HxddSdGLzsZ0HsBcO/qaCPTst+ZA0YIQfd5ULlFmPqq39FfO
p1P+2hEH2n+LycbMj5cn4Dxfqv2R8eucM78R3w==

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VELOCE-RSA", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
SmAzQA1VEuJXtJi5vXa2Jg7YvRqAJs6PX9HTZ1YqrJw4VfonBW3726gJ81BjlizpMkcf/Uk5sFIK
aPedVhEs4xCIZylz7gXYDshtytOA/pXUID2qV9nXr8qfI+FydSADUF3ScYDZmlkclFqlZrGq6DQ7
da3lJAzt2h/iR+cczrA=

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VERIF-SIM-RSA-2", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
iAph5JWb/chMQpLPX1UoLjQDxN5l2I8McM/k2xN5wRht7HXoE6F5yV8luDjn3zkI6vnfUYo7BaI1
mogRRx+R3XcwxvhHr+lngh4+/YLVex1TFncl+kiUMAsu3M/FjFSiqGMVMdKTNLDqr35DuZJVyuiF
lTwXob/KkbQDJiJjBEoxbt+968rKRKRyJGcqIjm4mqRBdqMcgo3HOJFG74SFsWAQrxvXfBhdLSG3
OfoLfls9XDojBjp7G83k0h82g1eeWgBfydm/OcX9o48Pst93NvI4ua8WShZL8MCvRWYqWZrrjrWi
cfUjXAF5SDACjq1/OU6arz/Idz6/a7AP/jmexw==

`pragma protect key_keyowner="Real Intent", key_keyname="RI-RSA-KEY-1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
BY49GZBxBT/gjZDPyaSWlti/sctckoR7jK6NuWdhnF9tiyNfVU7BqjjwxSnyMi0Uucv1BKHXC18h
8hQbFWnNtrq71ilURotXux7sssHlVJ2i1CsJWU18DOcBWxm2ai89uwvxDJh3TJkBJixB5KPvsDhL
lWOjTvZWPoR+Ixy+Tzo+U5Vx7z7SOakRwTrn3u7+c3vmCEBphE+HKeJExhBAoOEd0SXK5iwXaByW
D7Wb7zq6NNUmnCyaJ2BG9kGxLVsf+md7SlocuaFsYyaRZhwPyTucxIlz1tLYwcytKzx0ovoax3no
nYgzlzP/F0/PDWk9BqXgr/tuclc4EZYX0cf4ng==

`pragma protect key_keyowner="Xilinx", key_keyname="xilinxt_2025.1-2029.x", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
qGnCvL35qO7cbUEKCL50yDv1UvezcqBz601zctKop1954QlcjemzZWZHg1zJ00nJaToNdH2S8AKX
n8hNJvbQ+x5HEGL5DoSU9m5qjXd8xxocnZ0yzuZX/dGCT8kDn3gWJR2Gz13pT+w2LQUno1fX+MsC
ehgwvjBBT6GeYjdxHi+aybQUP9AblSxX/z3vh857SGCPohEWvghOgORCHAe45YD+ZWnL62FLxMM2
c+Ozq/Au/Q4q1Yzlzcfv8Mnsvg7OqOeEamQHbuYOfdkJUuYqOwsskEWW348u7FXtsf8m7P3pZyyz
IWyTDAW4igGguMPLHfbtK/twZx8ScJQmOKzglg==

`pragma protect key_keyowner="Metrics Technologies Inc.", key_keyname="DSim", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
Hz+6K8+wh5/fukU4ZWNDXGsq6hreSVCSPP67nA6kUz9Vpjy4TtTnOrrl1BWY0ivEC7Ldyw8VI60A
VO/WPlt409LdAZdMZGsEZ1JuTZ0m9LPcgu9CPCyoMECctmd8LHE+otY6etTmYABB9syY61rk2hrv
RgbcyT/HCK9TzWxSm+XMqvx2nvagCLkMDPh/JZv51fj2zcKaBPnxsz8rnDipaeo0fEyVRC3Y1F/V
U3RmXojBjIumPHSJkQ537dENJEIA0Ra65u8EM/+ItUn1bcryLcIbKy1xGadrHmHdHRUoRcAodO2C
B48bNVeL0VnGg8P9ACIB04lMNzn5p6A1tPOb4Q==

`pragma protect key_keyowner="Atrenta", key_keyname="ATR-SG-RSA-1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=384)
`pragma protect key_block
YDpb+UeT0rJ543Q8wCo2xSS3gpVAT+JoStgBlV5IMjJoUOWkiOPn691FGChmDi3BTq5NxC73KHHR
1galACCjeTGq6cv+0Zc2Ocm1oobdrnSPHp7TMDr5Zle8FX6WywJCiGdoWBODggZSlbOASIK/PVfY
cZM2z60M6RSvzsi3TnYHiKYHpju8THVoSgRd6r31GcbiSy9TjjARERXan0OVc79jGuAg90mmDEEq
91eqmn6NZ9yLI2fgBjFUZbtFCpmJ8WGxOL1h39niWnRK3ZXnk8jcpnZUlxLbYTPO0Z3vVr1zrvcn
RVQloU0OLqg7M95zSs7NtX5Vzvb6jGbMehWV+WMMyxWmxL2XOwsAwPSeX2dI2r77pioY7X6VzH7f
/JxMAnq9udra3WGPsUkD1G0CvPkCC3zdxjpVaflY37ztX9UONhKtzMQa8lJc1IL8GhXRY3R9Lg2c
HIeXSGkpNNuFDqKT6Khe/6Casq+SjFJq+IH9IUtz6RUZTkbFb0Xhgm2P

`pragma protect key_keyowner="Cadence Design Systems.", key_keyname="CDS_RSA_KEY_VER_1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
Q+63zFEYw/LeMgxa7g8g79GGvSyIKDKD8RvvC4DHDQuGObf6n9OGZX4e17v/E/+EDEwUhsWQHFDI
Lp/aH+6fNRmhu9BEWVjxq2WRrQSl4eQjfIaSOXu2dlYh3JjRJwiUp4LteVh8RFAf5t5sRQO4dRIK
x+h28yliSgibaWEAv5FaJQ1EFbNwmgedAaSYjgf2A3afBUcBh5Uy9VHbW/zRzdhhJdsVNBjZYcFy
CVLOcf1toCRp8J4U5FlnFMOzFegUbdXFQhq2VmIhPRxWjrfTk6iR4BcMEN9UMij/5IHRAeBdksyD
CqEKsyFxosbI5KVMRZ1Ln75Zipn0JdsGekHkxg==

`pragma protect key_keyowner="Synplicity", key_keyname="SYNP15_1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
DPUa5DLPYRWvbPnX0U412yoWvvvHyuq43DrYmDJGTK0cR5U4U6th8icYgizC1/hUAEzt19kM/hVa
zZh7bXSWACYLpcfhPY8dRTVGDZVjpbkraw0ceBryLP7jc6Jt5JdNw88tZtZpprCB7nQ25lUL82Hf
WTwL1ZqgGIvtfHhxO0JF5L5ES5giedwQ6u5ffXG3UB6ELcpQD1NvpW5lAz4mfXyvVDCAPZN581TF
tlAy79iKbPKlJ2zFn1BS2cuRIHHe2JRxwPo+0n5VD5CXVgg+lCYxTnCxI8CdyFaTumbs4IfAKwVI
wSN/btbwDUhW9hAHWHIRo+BpdJ4qeGcTDPKtsA==

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-PREC-RSA", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
mf5hcf6JE6yLm0jNCQnHMVmogjLlPz6re0FwG67yvOJ3FuEorru0emIeAKEwgOoxjUYNWvcM7QAH
/UEeB2EIdjLl6glPAUda0HjtaCU2rdncVdM8k6DSMBggc4yo18Qx5F+1TD/RoBgoo0jNkMdDy6wJ
JHjqlN+R01z3yYIMQ9f2z6ZaYncbBYEp4+YAb7g1D7CSMxP5cFRpQznRpYp0JwqJfT9CHzlKgdab
8B288NxeLM66iYodiTS+GSRGLGtDWXpz9yeiuiPe6kJxae2GJyHIMSfluO/0Slc3m24DQNdbojf8
jdc0G2UnrDe5mCUTfYiDmpOWTUJOdYo0FK0N2g==

`pragma protect data_method = "AES128-CBC"
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 19280)
`pragma protect data_block
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
eCAxDZ1XDLgXbHRKuPk=
`pragma protect end_protected
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
