set_property IOSTANDARD LVCMOS18 [get_ports qdmaPin_sys_rst_n]
set_property PACKAGE_PIN BH26 [get_ports qdmaPin_sys_rst_n]

set_property PACKAGE_PIN G31 [get_ports sysClkP]
set_property PACKAGE_PIN F31 [get_ports sysClkN]
set_property IOSTANDARD DIFF_SSTL12 [get_ports sysClkP]
set_property IOSTANDARD DIFF_SSTL12 [get_ports sysClkN]

set_property PACKAGE_PIN D32 [get_ports hbmCattrip]
set_property IOSTANDARD LVCMOS18 [get_ports hbmCattrip]

create_clock -period 10.000 -name sysclk2 [get_ports sysClkP]
create_clock -period 10.000 -name pcie_ref_clk0 [get_ports qdmaPin_sys_clk_p]

# From QDMA Module

set_false_path -from [get_ports qdmaPin_sys_rst_n]
set_property PULLUP true [get_ports qdmaPin_sys_rst_n]

set_property PACKAGE_PIN AR14 [get_ports qdmaPin_sys_clk_n]
set_property PACKAGE_PIN AR15 [get_ports qdmaPin_sys_clk_p]

set_false_path -to [get_pins -hier {*sync_reg[0]/D}]

set_false_path -from [get_cells -hier -regexp -filter {NAME =~ .*/axil2reg/reg_control_[0-9]*_reg\[.*]}]
set_false_path -to [get_cells -hier -regexp -filter {NAME =~ .*/axil2reg/reg_status_[0-9]*_reg\[.*]}]

# From CMAC Module (Disable it if you're using no CMAC)

set_false_path -from [get_clocks -of_objects [get_pins -hier -filter {NAME =~ */phy_clk_i/bufg_gt_userclk/O}]] -to [get_clocks -of_objects [get_pins -hier -filter {NAME =~ */gtye4_channel_gen.gen_gtye4_channel_inst[*].GTYE4_CHANNEL_PRIM_INST/TXOUTCLK}]]
set_false_path -from [get_clocks -of_objects [get_pins -hier -filter {NAME =~ */gtye4_channel_gen.gen_gtye4_channel_inst[*].GTYE4_CHANNEL_PRIM_INST/RXOUTCLK}]] -to [get_clocks -of_objects [get_pins -hier -filter {NAME =~ */gtye4_channel_gen.gen_gtye4_channel_inst[*].GTYE4_CHANNEL_PRIM_INST/TXOUTCLK}]]
set_false_path -from [get_clocks -of_objects [get_pins -hier -filter {NAME =~ */gtye4_channel_gen.gen_gtye4_channel_inst[*].GTYE4_CHANNEL_PRIM_INST/TXOUTCLK}]] -to [get_clocks -of_objects [get_pins -hier -filter {NAME =~ */phy_clk_i/bufg_gt_userclk/O}]]

# From HBM Module (Disable it if you're using no HBM)

# set_false_path -from [get_clocks -of_objects [get_pins -hier -filter {NAME =~ */mmcmAxi/mmcm4_adv/CLKOUT0}]] -to [get_clocks -of_objects [get_pins -hier -filter {NAME =~ */mmcmGlbl/mmcm4_adv/CLKOUT0}] -filter {IS_GENERATED && MASTER_CLOCK == sysclk2}]
# set_false_path -from [get_pins -hier apb_complete_0_r_reg/C] -to [get_pins -hier apb_complete_0_reg/D]
# set_false_path -from [get_pins -hier apb_complete_1_r_reg/C] -to [get_pins -hier apb_complete_1_reg/D]
# connect_debug_port core/dbgBridgeInst/inst/xsdbm/clk [get_nets -hier -filter {NAME =~ */mmcmGlbl/mmcmGlbl_io_CLKOUT0}]

# From DDR Module (DDR 0) (Disable it if you're using no DDR0)

set_property PACKAGE_PIN BJ43 [get_ports ddrPin_ddr0_sys_100M_p]
set_property PACKAGE_PIN BJ44 [get_ports ddrPin_ddr0_sys_100M_n]
set_property IOSTANDARD  DIFF_SSTL12 [get_ports ddrPin_ddr0_sys_100M_p]
set_property IOSTANDARD  DIFF_SSTL12 [get_ports ddrPin_ddr0_sys_100M_n]
create_clock -name ddr0_sys_clock -period 10 [get_ports ddrPin_ddr0_sys_100M_p]

# From DDR Module (DDR 1) (Disable it if you're using no DDR1)

set_property PACKAGE_PIN BH6 [get_ports ddrPin2_ddr0_sys_100M_p]
set_property PACKAGE_PIN BJ6 [get_ports ddrPin2_ddr0_sys_100M_n]
set_property IOSTANDARD  DIFF_SSTL12 [get_ports ddrPin2_ddr0_sys_100M_p]
set_property IOSTANDARD  DIFF_SSTL12 [get_ports ddrPin2_ddr0_sys_100M_n]
create_clock -name ddr1_sys_clock -period 10 [get_ports ddrPin2_ddr0_sys_100M_p]

# PBlocks (No DDR, with HBM)

# create_pblock pblock_core
# add_cells_to_pblock [get_pblocks pblock_core] [get_cells -quiet [list core]]
# resize_pblock [get_pblocks pblock_core] -add {SLICE_X146Y0:SLICE_X232Y18 SLICE_X117Y660:SLICE_X145Y719 SLICE_X117Y360:SLICE_X145Y419}
# resize_pblock [get_pblocks pblock_core] -add {BLI_HBM_APB_INTF_X20Y0:BLI_HBM_APB_INTF_X31Y0}
# resize_pblock [get_pblocks pblock_core] -add {BLI_HBM_AXI_INTF_X20Y0:BLI_HBM_AXI_INTF_X31Y0}
# resize_pblock [get_pblocks pblock_core] -add {DSP48E2_X16Y258:DSP48E2_X19Y281 DSP48E2_X16Y138:DSP48E2_X19Y161}
# resize_pblock [get_pblocks pblock_core] -add {HPIOB_DCI_SNGL_X0Y24:HPIOB_DCI_SNGL_X0Y27}
# resize_pblock [get_pblocks pblock_core] -add {HPIO_RCLK_PRBS_X0Y6:HPIO_RCLK_PRBS_X0Y6}
# resize_pblock [get_pblocks pblock_core] -add {LAGUNA_X16Y480:LAGUNA_X19Y599}
# resize_pblock [get_pblocks pblock_core] -add {RAMB18_X10Y0:RAMB18_X13Y5 RAMB18_X8Y264:RAMB18_X9Y287 RAMB18_X8Y144:RAMB18_X9Y167}
# resize_pblock [get_pblocks pblock_core] -add {RAMB36_X10Y0:RAMB36_X13Y2 RAMB36_X8Y132:RAMB36_X9Y143 RAMB36_X8Y72:RAMB36_X9Y83}
# resize_pblock [get_pblocks pblock_core] -add {URAM288_X3Y0:URAM288_X4Y3 URAM288_X2Y176:URAM288_X2Y191 URAM288_X2Y96:URAM288_X2Y111}
# resize_pblock [get_pblocks pblock_core] -add {CLOCKREGION_X5Y11:CLOCKREGION_X7Y11 CLOCKREGION_X0Y11:CLOCKREGION_X3Y11 CLOCKREGION_X0Y7:CLOCKREGION_X7Y10 CLOCKREGION_X5Y6:CLOCKREGION_X7Y6 CLOCKREGION_X0Y6:CLOCKREGION_X3Y6 CLOCKREGION_X0Y4:CLOCKREGION_X7Y5 CLOCKREGION_X0Y1:CLOCKREGION_X3Y3 CLOCKREGION_X0Y0:CLOCKREGION_X4Y0}
# set_property CONTAIN_ROUTING 1 [get_pblocks pblock_core]
# set_property EXCLUDE_PLACEMENT 1 [get_pblocks pblock_core]
# set_property SNAPPING_MODE ON [get_pblocks pblock_core]

# PBlocks (1 DDR, with HBM)

# create_pblock pblock_core
# add_cells_to_pblock [get_pblocks pblock_core] [get_cells -quiet [list core]]
# resize_pblock [get_pblocks pblock_core] -add {SLICE_X147Y0:SLICE_X232Y18 SLICE_X146Y0:SLICE_X146Y17 SLICE_X117Y660:SLICE_X145Y719 SLICE_X130Y240:SLICE_X137Y419}
# resize_pblock [get_pblocks pblock_core] -add {BLI_HBM_APB_INTF_X20Y0:BLI_HBM_APB_INTF_X31Y0}
# resize_pblock [get_pblocks pblock_core] -add {BLI_HBM_AXI_INTF_X20Y0:BLI_HBM_AXI_INTF_X31Y0}
# resize_pblock [get_pblocks pblock_core] -add {DSP48E2_X16Y258:DSP48E2_X19Y281}
# resize_pblock [get_pblocks pblock_core] -add {LAGUNA_X16Y480:LAGUNA_X19Y599}
# resize_pblock [get_pblocks pblock_core] -add {RAMB18_X8Y264:RAMB18_X9Y287 RAMB18_X10Y0:RAMB18_X13Y5}
# resize_pblock [get_pblocks pblock_core] -add {RAMB36_X8Y132:RAMB36_X9Y143 RAMB36_X10Y0:RAMB36_X13Y2}
# resize_pblock [get_pblocks pblock_core] -add {URAM288_X2Y176:URAM288_X2Y191 URAM288_X3Y0:URAM288_X4Y3}
# resize_pblock [get_pblocks pblock_core] -add {CLOCKREGION_X5Y11:CLOCKREGION_X7Y11 CLOCKREGION_X0Y11:CLOCKREGION_X3Y11 CLOCKREGION_X0Y7:CLOCKREGION_X7Y10 CLOCKREGION_X5Y4:CLOCKREGION_X7Y6 CLOCKREGION_X0Y1:CLOCKREGION_X3Y6 CLOCKREGION_X0Y0:CLOCKREGION_X4Y0}
# set_property CONTAIN_ROUTING 1 [get_pblocks pblock_core]
# set_property EXCLUDE_PLACEMENT 1 [get_pblocks pblock_core]
# set_property SNAPPING_MODE ON [get_pblocks pblock_core]

# PBlocks (2 DDRs, no HBM)

create_pblock pblock_core
add_cells_to_pblock [get_pblocks pblock_core] [get_cells -quiet [list core]]
resize_pblock [get_pblocks pblock_core] -add {SLICE_X117Y660:SLICE_X145Y719 SLICE_X130Y240:SLICE_X137Y419}
resize_pblock [get_pblocks pblock_core] -add {DSP48E2_X16Y258:DSP48E2_X19Y281}
resize_pblock [get_pblocks pblock_core] -add {LAGUNA_X16Y480:LAGUNA_X19Y599}
resize_pblock [get_pblocks pblock_core] -add {RAMB18_X8Y264:RAMB18_X9Y287}
resize_pblock [get_pblocks pblock_core] -add {RAMB36_X8Y132:RAMB36_X9Y143}
resize_pblock [get_pblocks pblock_core] -add {URAM288_X2Y176:URAM288_X2Y191}
resize_pblock [get_pblocks pblock_core] -add {CLOCKREGION_X5Y11:CLOCKREGION_X7Y11 CLOCKREGION_X0Y11:CLOCKREGION_X3Y11 CLOCKREGION_X0Y7:CLOCKREGION_X7Y10 CLOCKREGION_X5Y4:CLOCKREGION_X7Y6 CLOCKREGION_X0Y0:CLOCKREGION_X3Y6}
set_property CONTAIN_ROUTING 1 [get_pblocks pblock_core]
set_property EXCLUDE_PLACEMENT 1 [get_pblocks pblock_core]
set_property SNAPPING_MODE ON [get_pblocks pblock_core]

# PBlocks (Commonly used)

create_pblock pblock_qdmaInst
add_cells_to_pblock [get_pblocks pblock_qdmaInst] [get_cells -quiet [list core/qdmaInst]]
resize_pblock [get_pblocks pblock_qdmaInst] -add {SLICE_X0Y15:SLICE_X116Y239}
resize_pblock [get_pblocks pblock_qdmaInst] -add {CMACE4_X0Y0:CMACE4_X0Y1}
resize_pblock [get_pblocks pblock_qdmaInst] -add {DSP48E2_X0Y0:DSP48E2_X15Y89}
resize_pblock [get_pblocks pblock_qdmaInst] -add {PCIE4CE4_X0Y1:PCIE4CE4_X0Y1}
resize_pblock [get_pblocks pblock_qdmaInst] -add {RAMB18_X0Y6:RAMB18_X7Y95}
resize_pblock [get_pblocks pblock_qdmaInst] -add {RAMB36_X0Y3:RAMB36_X7Y47}
resize_pblock [get_pblocks pblock_qdmaInst] -add {URAM288_X0Y4:URAM288_X1Y63}
set_property SNAPPING_MODE NESTED [get_pblocks pblock_qdmaInst]

# User-constrained logic

set_property USER_SLR_ASSIGNMENT SLR0 [get_cells core/qdmaInst]
set_property CLOCK_DEDICATED_ROUTE BACKBONE [get_nets sysClk_pad_1_O]

# Debugging

set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores core/dbgBridge/inst/xsdbm]
set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores core/dbgBridge/inst/xsdbm]
set_property C_USER_SCAN_CHAIN 1 [get_debug_cores core/dbgBridge/inst/xsdbm]
set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]

# Debugging (no HBM) (Disable it if you're using HBM)

connect_debug_port core/dbgBridge/inst/xsdbm/clk [get_nets core/dbgBridge/inst/clk]