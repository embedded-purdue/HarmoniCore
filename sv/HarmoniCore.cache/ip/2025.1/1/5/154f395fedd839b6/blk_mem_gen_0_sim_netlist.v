// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2025 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2025.1 (win64) Build 6140274 Thu May 22 00:12:29 MDT 2025
// Date        : Sun Oct 26 14:21:47 2025
// Host        : LAPTOP-ECVP0FVU running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim -rename_top decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix -prefix
//               decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_ blk_mem_gen_0_sim_netlist.v
// Design      : blk_mem_gen_0
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7a25tcsg325-2
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "blk_mem_gen_0,blk_mem_gen_v8_4_11,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "blk_mem_gen_v8_4_11,Vivado 2025.1" *) 
(* NotValidForBitStream *)
module decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix
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
  decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_blk_mem_gen_v8_4_11 U0
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
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 19296)
`pragma protect data_block
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
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
