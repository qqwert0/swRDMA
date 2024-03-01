set_property PACKAGE_PIN BJ43 [get_ports ddr_pin_ddr0_sys_100M_p]
set_property PACKAGE_PIN BJ44 [get_ports ddr_pin_ddr0_sys_100M_n]
set_property IOSTANDARD  DIFF_SSTL12 [get_ports ddr_pin_ddr0_sys_100M_p]
set_property IOSTANDARD  DIFF_SSTL12 [get_ports ddr_pin_ddr0_sys_100M_n]

create_clock -name ddr0_sys_clock -period 10 [get_ports ddr_pin_ddr0_sys_100M_p]
