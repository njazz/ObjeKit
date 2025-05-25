//
//  MXOBundler.swift
//  MaxAPIKit
//
//  Created by alex on 25/05/2025.
//


import PackagePlugin
import Foundation

@main
struct MXOBundler: BuildToolPlugin {
  func createBuildCommands(context: PluginContext, target: Target) throws -> [Command] {
    // Find the compiled dylib in context.buildDirectory
    let name = target.name
    let dylib = context.pluginWorkDirectory.appending("lib\(name).dylib")
    let mxo   = context.pluginWorkDirectory.appending("\(name).mxo")
    // Copy & rename
    return [
      .prebuildCommand(
        displayName: "Bundling \(name).mxo",
        executable: Path("bash"),
        arguments: [
          context.package.directory.appending("Plugins/MXOBundler/mxo.sh").string,
          dylib.string,
          mxo.string
        ],
        inputFiles: [dylib],
        outputFiles: [mxo]
      )
    ]
  }
}
