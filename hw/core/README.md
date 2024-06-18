
* `foo/`, which connects RISC-V mini core, QDMA and HBM. The top module of `foo` is in `Foo.scala`. 

    `foo/src/TestCSR.scala` is used for testing the CSR module in the RISC-V mini core, especially whether RDMA hardware interface is correct or not. You can also use `test_csr.v` to see the result.

* `mini/`, is the RISC-V mini core, modified from [ucb-bar/riscv-mini](https://github.com/ucb-bar/riscv-mini). The top module of `mini` is in `Tile.scala`. You can use the core like this:

    ``` scala
    val cpu_started = reg_control(222)(0)
	// riscv-mini
	val config = MiniConfig()
	val mini_core = withClockAndReset(userClk, cpu_started.asBool) { 
		Module(new Tile(
		coreParams = config.core, 
		bramParams = config.bram,
		nastiParams = config.nasti, 
		cacheParams = config.cache
		))
	}
    ```

    Here `cpu_started` is a signal to start the core. The parameters of the core (***e.g.*** bram range, cache configuration) is in `Config.scala`, you can use the object `MiniConfig` to directly get reserved parameters, or you can change some parameters as you need.
