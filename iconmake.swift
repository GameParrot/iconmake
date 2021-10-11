import Foundation
extension FileHandle : TextOutputStream {
  public func write(_ string: String) {
    guard let data = string.data(using: .utf8) else { return }
    self.write(data)
  }
}
var standardError = FileHandle.standardError
func error(_ theError: String) { // Function for printing to stderr and exiting
    print(theError,to:&standardError)
    exit(-1)
}
@discardableResult
func shell(_ args: String...) -> Int32 { // A function for running terminal commands
    let task = Process()
    task.launchPath = "/usr/bin/env"
    task.arguments = args
    let pipe = Pipe()
    task.standardOutput = pipe
    task.launch()
    task.waitUntilExit()
    if task.terminationStatus != 0 {
        error("An error occurred when making the icon")
    }
    return task.terminationStatus
}
var makeFolder = true
let argv = CommandLine.arguments
if argv.count > 2 {
    if FileManager.default.fileExists(atPath: argv[1]) {
        if FileManager.default.fileExists(atPath: argv[2]) {
            error("iconmake: " + argv[2] + ": File or folder already exists at this location") // Shows a file exists error
        }
        let subfolder = URL(fileURLWithPath: argv[2]).deletingLastPathComponent()
        if FileManager.default.fileExists(atPath: subfolder.path) == false {
            error("iconmake: " + subfolder.path + ": No such file or directory") // Shows a No such file or directory error
        }
        if FileManager.default.isWritableFile(atPath: subfolder.path) == false {
            error("iconmake: " + subfolder.path + ": Permission denied") // Shows a permission denied error
        }
        if FileManager.default.isReadableFile(atPath: argv[1]) == false {
            error("iconmake: " + argv[1] + ": Permission denied") // Shows a permission denied error
        }
        if argv[2].hasPrefix("-") {
            error("iconmake: output cannot start with the - symbol")
        }
        if argv[1].hasPrefix("-") {
            error("iconmake: input cannot start with the - symbol")
        }
        if argv.count > 3 {
            if argv[3] == "--icns" {
                makeFolder = false
            }
        }
        if makeFolder {
            do {
                try FileManager.default.createDirectory(atPath: argv[2], withIntermediateDirectories: true, attributes: nil)
            } catch {
                print(error)
                exit(-1)
            }
        } else {
            do {
                try FileManager.default.createDirectory(atPath: "/tmp/iconconvert.iconset", withIntermediateDirectories: true, attributes: nil)
            } catch {
                print(error)
                exit(-1)
            }
        }
        var folderDir = argv[2]
        if argv.count > 3 {
            if argv[3] == "--icns" {
                if URL(fileURLWithPath: argv[2]).pathExtension != "icns" {
                    print("iconmake: output extension must be icns if --icns is passed")
                    exit(-1)
                }
                folderDir = "/tmp/iconconvert.iconset"
            }
        }
        shell("sips", argv[1], "-z", "1024", "1024", "--out", folderDir + "/icon_512x512@2x.png") // Creates a 1024x1024 icon
        print("Created 1024x1024 icon")
        shell("sips", argv[1], "-z", "512", "512", "--out", folderDir + "/icon_512x512.png") // Creates a 512x512 icon
        print("Created 512x512 icon")
        shell("sips", argv[1], "-z", "256", "256", "--out", folderDir + "/icon_256x256.png") // Creates a 256x256 icon
        print("Created 256x256 icon")
        shell("sips", argv[1], "-z", "128", "128", "--out", folderDir + "/icon_128x128.png") // Creates a 128x128 icon
        print("Created 128x128 icon")
        shell("sips", argv[1], "-z", "64", "64", "--out", folderDir + "/icon_32x32@2x.png") // Creates a 64x64 icon
        print("Created 64x64 icon")
        shell("sips", argv[1], "-z", "32", "32", "--out", folderDir + "/icon_32x32.png") // Creates a 32x32 icon
        print("Created 32x32 icon")
        shell("sips", argv[1], "-z", "16", "16", "--out", folderDir + "/icon_16x16.png") // Creates a 16x16 icon
        print("Created 16x16 icon")
        shell("sips", argv[1], "-z", "32", "32", "--out", folderDir + "/icon_16x16@2x.png") // Creates a 32x32 icon
        print("Created 32x32 icon")
        shell("sips", argv[1], "-z", "256", "256", "--out", folderDir + "/icon_128x128@2x.png") // Creates a 256x256 icon
        print("Created 256x256 icon")
        shell("sips", argv[1], "-z", "512", "512", "--out", folderDir + "/icon_256x256@2x.png") // Creates a 512x512 icon
        print("Created 512x512 icon")
        if argv.count > 3 {
            if argv[3] == "--icns" {
                shell("iconutil", "--convert", "icns", "--output", argv[2], folderDir) // Converts to ICNS if --icns was passed
                print("Created ICNS icon")
                shell("rm", "-r", folderDir) // Cleans up temporary files
            }
        }
        print("Done!")
    } else {
        error("iconmake: " + argv[1] + ": No such file or directory")
    }
} else {
    if argv.count > 1 {
        if argv[1] == "--help" || argv[1] == "-h" {
            print("usage: iconmake input_image output_icon [--icns]. If --icns is not passed, then the output will be an iconset folder. If --icns is passed, then the output will be an ICNS image.\nExample: iconmake image.png icon.iconset or iconmake image.png icon.icns --icns") // Shows the help message
            exit(0)
        }
    }
    error("Error: not enough options\nusage: iconmake input_image output_icon [--icns]. If --icns is not passed, then the output will be an iconset folder. If --icns is passed, then the output will be an ICNS image.\nFor examples, use --help") // Shows the not enough options error message
}
