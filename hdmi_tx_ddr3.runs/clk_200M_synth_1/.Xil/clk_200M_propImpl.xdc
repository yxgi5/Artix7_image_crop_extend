set_property SRC_FILE_INFO {cfile:/home/andy/workdir/ddr3_an5642_hdmi_sobel_2018/ddr3_an5642_hdmi_sobel.srcs/sources_1/ip/clk_200M/clk_200M.xdc rfile:../../../ddr3_an5642_hdmi_sobel.srcs/sources_1/ip/clk_200M/clk_200M.xdc id:1 order:EARLY scoped_inst:inst} [current_design]
current_instance inst
set_property src_info {type:SCOPED_XDC file:1 line:57 export:INPUT save:INPUT read:READ} [current_design]
set_input_jitter [get_clocks -of_objects [get_ports clk_in1]] 0.2
