vlib work
vlib riviera

vlib riviera/xil_defaultlib
vlib riviera/xpm

vmap xil_defaultlib riviera/xil_defaultlib
vmap xpm riviera/xpm

vlog -work xil_defaultlib  -sv2k12 "+incdir+../../../ipstatic" \
"/opt/Xilinx/Vivado/2018.3/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \

vcom -work xpm -93 \
"/opt/Xilinx/Vivado/2018.3/data/ip/xpm/xpm_VCOMP.vhd" \

vlog -work xil_defaultlib  -v2k5 "+incdir+../../../ipstatic" \
"../../../../ddr3_an5642_hdmi_sobel.srcs/sources_1/ip/clk_200M/clk_200M_clk_wiz.v" \
"../../../../ddr3_an5642_hdmi_sobel.srcs/sources_1/ip/clk_200M/clk_200M.v" \

vlog -work xil_defaultlib \
"glbl.v"

