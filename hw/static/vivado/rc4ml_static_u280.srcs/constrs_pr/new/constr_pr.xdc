set_property CONFIG_VOLTAGE 1.8 [current_design]
set_property BITSTREAM.CONFIG.CONFIGFALLBACK Enable [current_design]
set_property BITSTREAM.GENERAL.COMPRESS TRUE [current_design]
set_property CONFIG_MODE SPIx4 [current_design]
set_property BITSTREAM.CONFIG.SPI_BUSWIDTH 4 [current_design]
set_property BITSTREAM.CONFIG.CONFIGRATE 63.8 [current_design]
set_property BITSTREAM.CONFIG.EXTMASTERCCLK_EN disable [current_design]
set_property BITSTREAM.CONFIG.SPI_FALL_EDGE YES [current_design]
set_property BITSTREAM.CONFIG.UNUSEDPIN Pullup [current_design]
set_property BITSTREAM.CONFIG.SPI_32BIT_ADDR Yes [current_design]

set_false_path -to [get_pins -hier {*sync_reg[0]/D}]

set_false_path -from [get_cells -hier -regexp -filter {NAME =~ .*/axil2reg/reg_control_[0-9]*_reg\[.*]}]
set_false_path -to [get_cells -hier -regexp -filter {NAME =~ .*/axil2reg/reg_status_[0-9]*_reg\[.*]}]

# From CMAC Module (Disable it if you're using no CMAC)

set_false_path -from [get_clocks -of_objects [get_pins -hier -filter {NAME =~ */phy_clk_i/bufg_gt_userclk/O}]] -to [get_clocks -of_objects [get_pins -hier -filter {NAME =~ */gtye4_channel_gen.gen_gtye4_channel_inst[*].GTYE4_CHANNEL_PRIM_INST/TXOUTCLK}]]
set_false_path -from [get_clocks -of_objects [get_pins -hier -filter {NAME =~ */gtye4_channel_gen.gen_gtye4_channel_inst[*].GTYE4_CHANNEL_PRIM_INST/RXOUTCLK}]] -to [get_clocks -of_objects [get_pins -hier -filter {NAME =~ */gtye4_channel_gen.gen_gtye4_channel_inst[*].GTYE4_CHANNEL_PRIM_INST/TXOUTCLK}]]
set_false_path -from [get_clocks -of_objects [get_pins -hier -filter {NAME =~ */gtye4_channel_gen.gen_gtye4_channel_inst[*].GTYE4_CHANNEL_PRIM_INST/TXOUTCLK}]] -to [get_clocks -of_objects [get_pins -hier -filter {NAME =~ */phy_clk_i/bufg_gt_userclk/O}]]

# From HBM Module (Disable it if you're using no HBM)

set_false_path -from [get_clocks -of_objects [get_pins -hier -filter {NAME =~ */mmcmAxi/mmcm4_adv/CLKOUT0}]] -to [get_clocks -of_objects [get_pins -hier -filter {NAME =~ */mmcmGlbl/mmcm4_adv/CLKOUT0}] -filter {IS_GENERATED && MASTER_CLOCK == sysclk2}]
set_false_path -from [get_pins -hier apb_complete_0_r_reg/C] -to [get_pins -hier apb_complete_0_reg/D]
set_false_path -from [get_pins -hier apb_complete_1_r_reg/C] -to [get_pins -hier apb_complete_1_reg/D]

set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores core/dbgBridge/inst/xsdbm]
set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores core/dbgBridge/inst/xsdbm]
set_property C_USER_SCAN_CHAIN 1 [get_debug_cores core/dbgBridge/inst/xsdbm]
connect_debug_port core/dbgBridgeInst/inst/xsdbm/clk [get_nets -hier -filter {NAME =~ */mmcmGlbl/mmcmGlbl_io_CLKOUT0}]
