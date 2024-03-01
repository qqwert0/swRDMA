# RC4ML Static

I'm tired of the unstable Xilinx's (okay, okay, I have knew it's called AMD Embedded now) unstable QDMA module which crashes my machine for 90% of the cases. I want to find a way to get rid of this annoying issue, both for me and the whole lab. And now introducing this repo which may help you as well.  

# What's This Repo For?

This is a repo which leverages Vivado's partial reconfiguration ability. A U280 board here is split into 2 parts: *static part* and *reconfigurable part*. Static part places global clocks and QDMA, which will be completely fixed when you first run implementation, and dynamic part can place any of your logics, like CMAC, HBM and other modules.

Besides, this project can also regarded as an example of partial reconfiguration. You can learn how to use this functionality by the repo.

Currently, the repo supports the following Vivado version(s):
- 2021.1

The repo supports the following FPGA board(s):
- Alveo U280

Feel free contribute to this repo if you have other boards and Vivado versions.

# Repo Structure

This repo consists the following files:

- **static**: Main project folder
  - **src**: Chisel code of the static parts.
     - **Static&lt;board&gt;Top.scala**: Top module of the static part.
	 - **&lt;board&gt;DynamicGrayBox.scala**: Top module of the base configuration of the reconfigurable part.
	 - **AlveoDynamicTop.scala**: Reconfigurable part are regarded as a blackbox module for static part, and this file defines the blackbox module for Alveo FPGA cards.
	 - **AlveoStaticIO.scala**: Port definition of reconfigurable part for Alveo cards.
	 - **Elaborate.scala**: Elaborate file.
  - **vivado**: Files to build template vivado projects.
- **build.sc**: Scala module definition file.
- **config.json**: Edit this to define your project path. You need to create the file yourself.
- **instant.py**: A script aims to generate some basic testbench content automatically, same to the one in [chisel template repo](https://github.com/RC4ML/chisel_template).
- **postElaborating.py**: A script which generates systemVerilog code and tcl commands. The one in this repo is an edited version, which enables auto-renaming for base configuration files.

# Steps to Use

Please refer to [Step-By-Step Tutorial to Build a Project](./docs/HOWTOUSE.md)

## Tips for Using Vivado
    
  - Steps to add your own modules/IPs to the project:
    
    - To add a source file, just open "Partition Definitions" tab of the Vivado, right click on "U280CoreReconfig" and choose "Edit Reconfigurable Module". 
    - To add an IP file, you need to add source to the static part, right click on the IP in "Hierarchy" tab and choose to "Move to Reconfigurable Module". In this case, your base implementation run might be outdated. You can simply choose "Force Up-to-Date" to these runs to prevent repeatitive runs.

  - To generate bitstream of your own configurations, just right click on the `impl_reconfig` and choose "Launch Step To > write_bitstream". That might be the simplest.