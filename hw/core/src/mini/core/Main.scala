// See LICENSE for license details.

package mini.core

import chisel3.stage.ChiselGeneratorAnnotation
import firrtl.options.TargetDirAnnotation

object Main extends App {
  val targetDirectory = args.head
  val config = MiniConfig()
  new chisel3.stage.ChiselStage().execute(
    args,
    Seq(
      ChiselGeneratorAnnotation(() =>
        new Tile(
          enable_hbm = config.enable_hbm,
          coreParams = config.core,
          bramParams = config.bram,
          nastiParams = config.nasti,
          cacheParams = config.cache
        )
      ),
      TargetDirAnnotation(targetDirectory)
    )
  )
}
