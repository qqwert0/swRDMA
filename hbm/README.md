# chisel_hbm
HBM wrapped in Chisel

## How to Add this Module in Your Chisel Project:
```bash
$ git submodule add git@github.com:RC4ML/chisel_hbm hbm
$ git clone git@github.com:RC4ML/chisel_hbm hbm
```

## Port Description
`axi_hbm`: 32 AXI ports used to access HBM. User logic is the master side.  
`hbm_clk`: Output clock for AXI ports.  
`hbm_rstn`: Output reset for AXI ports.  
If you want to use your own clock to drive AXI ports, use XConverter.

## Parameter Description
`WITH_RAMA`: Whether to attach RAMA IP to each AXI ports.  
RAMA IPs help to reorder AXI transactions thus to speedup random HBM I/Os, but will introduce extra latency.  
Recommended to turn on for random HBM access, vice versa.  
`IP_CORE_NAME`: Use this to rename the HBM IP name, which might be helpful in partial reconfiguration.
`RAMA_CORE_NAME`: Use this to rename the RAMA IP name, which might be helpful in partial reconfiguration. Effective only when RAMA is enabled.