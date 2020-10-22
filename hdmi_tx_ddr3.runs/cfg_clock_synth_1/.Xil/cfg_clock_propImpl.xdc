set_property SRC_FILE_INFO {cfile:/home/andy/workdir/hdmi_tx_ddr3_1pcs_1920_1080_dual_ov5640_640_480_32bit_128burst/hdmi_tx_ddr3.srcs/sources_1/ip/cfg_clock/cfg_clock.xdc rfile:../../../hdmi_tx_ddr3.srcs/sources_1/ip/cfg_clock/cfg_clock.xdc id:1 order:EARLY scoped_inst:inst} [current_design]
current_instance inst
set_property src_info {type:SCOPED_XDC file:1 line:57 export:INPUT save:INPUT read:READ} [current_design]
set_input_jitter [get_clocks -of_objects [get_ports clk_in1]] 0.05
