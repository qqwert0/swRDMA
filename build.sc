import mill._, scalalib._, publish._
import mill.scalalib._
import mill.scalalib.scalafmt.ScalafmtModule
import scala.util._
import mill.bsp._

object Setting{
	def scalacOptions = Seq(
		"-Xsource:2.11",
		"-language:reflectiveCalls",
		"-deprecation",
		"-feature",
		"-Xcheckinit",
		"-P:chiselplugin:useBundlePlugin"
	)
	def scalacPluginIvyDeps = Agg(
		ivy"edu.berkeley.cs:::chisel3-plugin:3.4.4",
		ivy"org.scalamacros:::paradise:2.1.1"
	)
}

object common extends ScalaModule{
	override def scalaVersion = "2.12.13"
	override def scalacOptions = Setting.scalacOptions
	override def scalacPluginIvyDeps = Setting.scalacPluginIvyDeps
	override def ivyDeps = Agg(
		ivy"edu.berkeley.cs::chisel3:3.4.4",
	)
  
	def mainClass = Some("common.elaborate")
}

object qdma extends ScalaModule{
	override def scalaVersion = "2.12.13"
	override def scalacOptions = Setting.scalacOptions
	override def scalacPluginIvyDeps = Setting.scalacPluginIvyDeps
	override def ivyDeps = Agg(
		ivy"edu.berkeley.cs::chisel3:3.4.4",
	)
	def moduleDeps = Seq(common)
	def mainClass = Some("qdma.elaborate")
}

object hbm extends ScalaModule{
	override def scalaVersion = "2.12.13"
	override def scalacOptions = Setting.scalacOptions
	override def scalacPluginIvyDeps = Setting.scalacPluginIvyDeps
	override def ivyDeps = Agg(
		ivy"edu.berkeley.cs::chisel3:3.4.4",
	)
  
	def moduleDeps = Seq(common)
	def mainClass = Some("hbm.elaborate")
}

object cmac extends ScalaModule{
	override def scalaVersion = "2.12.13"
	override def scalacOptions = Setting.scalacOptions
	override def scalacPluginIvyDeps = Setting.scalacPluginIvyDeps
	override def ivyDeps = Agg(
		ivy"edu.berkeley.cs::chisel3:3.4.4",
	)
  
	def moduleDeps = Seq(common)
	def mainClass = Some("cmac.elaborate")
}

object ddr extends ScalaModule{
	override def scalaVersion = "2.12.13"
	override def scalacOptions = Setting.scalacOptions
	override def scalacPluginIvyDeps = Setting.scalacPluginIvyDeps
	override def ivyDeps = Agg(
		ivy"edu.berkeley.cs::chisel3:3.4.4",
	)
  
	def moduleDeps = Seq(common)
	def mainClass = Some("ddr.elaborate")
}

object static extends ScalaModule{
	override def scalaVersion = "2.12.13"
	override def scalacOptions = Setting.scalacOptions
	override def scalacPluginIvyDeps = Setting.scalacPluginIvyDeps
	override def ivyDeps = Agg(
		ivy"edu.berkeley.cs::chisel3:3.4.4",
	)
	def moduleDeps = Seq(common, qdma, cmac, hbm, ddr)
	override def mainClass = Some("static.elaborate")
}

object swrdma extends ScalaModule{
	override def scalaVersion = "2.12.13"
	override def scalacOptions = Setting.scalacOptions
	override def scalacPluginIvyDeps = Setting.scalacPluginIvyDeps
	override def ivyDeps = Agg(
		ivy"edu.berkeley.cs::chisel3:3.4.4",
	)
	def moduleDeps = Seq(common,qdma, cmac)
	def mainClass = Some("swrdma.elaborate")
}

object demo extends ScalaModule{
	override def scalaVersion = "2.12.13"
	override def scalacOptions = Setting.scalacOptions
	override def scalacPluginIvyDeps = Setting.scalacPluginIvyDeps
	override def ivyDeps = Agg(
		ivy"edu.berkeley.cs::chisel3:3.4.4",
	)
	def moduleDeps = Seq(common,qdma, cmac, hbm, ddr)
	def mainClass = Some("demo.elaborate")
}