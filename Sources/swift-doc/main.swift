import ArgumentParser
import Foundation
import IndexStoreDB

let fileManager = FileManager.default
let fileAttributes: [FileAttributeKey : Any] = [.posixPermissions: 0o744]

var standardOutput = FileHandle.standardOutput
var standardError = FileHandle.standardError

struct SwiftDoc: ParsableCommand {
    static var configuration = CommandConfiguration(
        abstract: "A utility for generating documentation for Swift code.",
        subcommands: [Generate.self, Coverage.self, Diagram.self],
        defaultSubcommand: Generate.self
    )
}


let libIndexStorePath = "/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/libIndexStore.dylib"
let library = try IndexStoreLibrary(dylibPath: libIndexStorePath)

let storePath = "/Users/mattt/Code/swiftdoc/SwiftSemantics/.build/debug/index/store"
let databasePath = NSTemporaryDirectory() + "index_\(getpid())"

let db = try! IndexStoreDB(storePath: storePath, databasePath: databasePath, library: library, waitUntilDoneInitializing: true)

//db.pollForUnitChangesAndWait()
//print(db.allSymbolNames())

//print(db.mainFilesContainingFile(path: "/Users/mattt/Code/swiftdoc/SwiftSemantics/Sources/SwiftSemantics/Declaration.swift"))


let symbolNames = db.allSymbolNames()


db.forEachSymbolOccurrence(byKind: .class) { occurrence in
    guard occurrence.location.moduleName == "SwiftSemantics" else { return true }



    print(occurrence.relations.first)
    return true
}
