// See LICENSE for license details.

package mini.core

import mini.junctions.NastiBundleParameters
import mini.core.BramParameters

case class Config(enable_hbm : Boolean, core: CoreConfig, cache: CacheConfig, bram: BramParameters, nasti: NastiBundleParameters)

object MiniConfig {
  def apply(): Config = {
    val xlen = 32
    Config(
      enable_hbm = false,
      core = CoreConfig(
        xlen = xlen,
        makeAlu = new AluArea(_),
        makeBrCond = new BrCondArea(_),
        makeImmGen = new ImmGenWire(_)
      ),
      cache = CacheConfig(
        nWays = 1,
        nSets = 256,
        blockBytes = 32
      ),
      
      bram = BramParameters(
        inst_entries = 4096,
        i_offset = "x80000000",
        d_offset = "x80004000",
        data_entries = 4096,
        width = 32,
        staddr = "x80004000",
        edaddr = "x80008000"
      ),
      nasti = NastiBundleParameters(
        addrBits = 33,
        dataBits = 256,
        idBits = 6
      )
    )
  }
}
