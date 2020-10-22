-makelib ies_lib/xil_defaultlib -sv \
  "/opt/Xilinx/Vivado/2018.3/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
-endlib
-makelib ies_lib/xpm \
  "/opt/Xilinx/Vivado/2018.3/data/ip/xpm/xpm_VCOMP.vhd" \
-endlib
-makelib ies_lib/xil_defaultlib \
  "../../../../ddr3_an5642_hdmi_sobel.srcs/sources_1/ip/clk_200M/clk_200M_clk_wiz.v" \
  "../../../../ddr3_an5642_hdmi_sobel.srcs/sources_1/ip/clk_200M/clk_200M.v" \
-endlib
-makelib ies_lib/xil_defaultlib \
  glbl.v
-endlib

