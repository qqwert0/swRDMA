set_property PACKAGE_PIN D32 [get_ports led]
set_property IOSTANDARD  LVCMOS18 [get_ports led]

create_clock -name sys_100M_clock_0 -period 10 -add [get_ports sys_100M_0_p]

set_property PACKAGE_PIN BJ43 [get_ports sys_100M_0_p]
set_property PACKAGE_PIN BJ44 [get_ports sys_100M_0_n]
set_property IOSTANDARD  DIFF_SSTL12 [get_ports sys_100M_0_p]
set_property IOSTANDARD  DIFF_SSTL12 [get_ports sys_100M_0_n]

set_false_path -from [get_clocks -of_objects [get_pins -hier -filter {NAME =~ */gtye4_channel_gen.gen_gtye4_channel_inst[*].GTYE4_CHANNEL_PRIM_INST/RXOUTCLK}]] -to [get_clocks -of_objects [get_pins -hier -filter {NAME =~ */gtye4_channel_gen.gen_gtye4_channel_inst[*].GTYE4_CHANNEL_PRIM_INST/TXOUTCLK}]]

# Enable if you import HBM and CMAC at the same time

# set_false_path -from [get_clocks -of_objects [get_pins -hier -filter {NAME =~ */gtye4_channel_gen.gen_gtye4_channel_inst[*].GTYE4_CHANNEL_PRIM_INST/TXOUTCLK}]] -to [get_clocks -of_objects [get_pins -hier -filter {NAME =~ */mmcmGlbl/mmcm4_adv/CLKOUT0}] -filter {IS_GENERATED && MASTER_CLOCK == sys_100M_clock_0}]

# Enable if you import QDMA and CMAC at the same time

# set_false_path -from [get_clocks -of_objects [get_pins -hier -filter {NAME =~ */phy_clk_i/bufg_gt_userclk/O}]] -to [get_clocks -of_objects [get_pins -hier -filter {NAME =~ */gtye4_channel_gen.gen_gtye4_channel_inst[*].GTYE4_CHANNEL_PRIM_INST/TXOUTCLK}]]
# set_false_path -from [get_clocks -of_objects [get_pins -hier -filter {NAME =~ */gtye4_channel_gen.gen_gtye4_channel_inst[*].GTYE4_CHANNEL_PRIM_INST/TXOUTCLK}]] -to [get_clocks -of_objects [get_pins -hier -filter {NAME =~ */phy_clk_i/bufg_gt_userclk/O}]]
