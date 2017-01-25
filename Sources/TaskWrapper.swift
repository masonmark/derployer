// ExternalTask.swift Created by mason on 2017-01-24. 
//
// Based on: TaskWrapper.swift　Created by mason on 2016-03-19.
// NOTE: This is a stripped down, simplified version of TaskWrapper, because my new project is targeting Linux,
// too, and the foundation support is pretty broken still. I had to delete a significant amount of code to get
// the build working on Linux. But this works for 

import Foundation

/// A convenience struct containing the results of running a task.

public struct TaskResult {
    public let terminationStatus: Int
    public let stdoutText: String
    public let stderrText: String
    public var combinedOutput: String {
        return stdoutText + stderrText
    }
}


/// A simple wrapper for NSTask, to synchronously run external commands.

public class TaskWrapper: CustomStringConvertible {
    
    public var launchPath          =  "/bin/ls"
    public var cwd: String?        = nil
    public var arguments: [String] = []
    public var stdoutData          = Data()
    public var stderrData          = Data()
    
    
    #if os(Linux)
    /// The result of `TaskWrapper.Process` is equivalent to `Foundation.Task()` on Linux, and to `Foundation.Process()` on Apple platforms.
    public static var Process: Foundation.Task {
        return Foundation.Task()
    }
    #else
    /// The result of `TaskWrapper.Process` is equivalent to `Foundation.Task()` on Linux, and to `Foundation.Process()` on Apple platforms.
    public static var Process: Foundation.Process {
        return Foundation.Process()
    }
    // Mason 2017-01-24: The swift-corelibs-foundation project is still raw and in flux, and the Task→Process renaming hasn't happened on Linux yet (as of Swift 3.0.2). Hence, this hack.
    #endif

    
    public var stdoutText: String {
        if let text = String(data: stdoutData as Data, encoding: .utf8) {
            return text
        } else {
            return ""
        }
    }
    
    public var stderrText: String {
        if let text = String(data: stderrData as Data, encoding: .utf8) {
            return text
        } else {
            return ""
        }
    }
    
    var task = TaskWrapper.Process
    
    /// The required initialize does nothing, so you must set up all the instance's values yourself.
    
    public required init() {
        // this exists just to satisfy the swift compiler
    }
    
    
    /// This convenience initializer is for when you want to construct a task instance and keep it around.
    
    public convenience init(_ launchPath: String, arguments: [String] = [], directory: String? = nil, launch: Bool = true) {
        self.init()
        
        self.launchPath = launchPath
        self.arguments  = arguments
        self.cwd        = directory
        if launch {
            self.launch()
        }
    }
    
    
    /// This convenience method is for when you just want to run an external command and get the results back. Use it like this:
    ///
    ///     let results = TaskWrapper.run("/bin/ping", arguments: ["-c", "10", "masonmark.com"])
    ///     print(results.stdoutText)
    ///
    /// NOTE: On Linux it seems to work without the full path to the external command, but on macOS that will crash your entire app with an Obj-C Exception. So using the full absolute path is recommended.
    
    public static func run (_ launchPath: String, arguments: [String] = [], directory: String? = nil) -> TaskResult {
        let t = self.init()
        // Can't use convenience init because: "Constructing an object... with a metatype value must use a 'required' initializer."
        
        t.launchPath = launchPath
        t.arguments  = arguments
        t.cwd        = directory
        t.launch()
        
        return TaskResult(terminationStatus: t.terminationStatus, stdoutText: t.stdoutText, stderrText: t.stderrText)
    }
    
    
    /// Synchronously launch the underlying NSTask and wait for it to exit.
    
    public func launch() {
        task = TaskWrapper.Process
        
        if let cwd = cwd {
            task.currentDirectoryPath = cwd
        }
        
        task.launchPath     = launchPath
        task.arguments      = arguments
        
        let stdoutPipe      = Pipe()
        let stderrPipe      = Pipe()
        
        task.standardOutput = stdoutPipe
        task.standardError  = stderrPipe
        
        let stdoutHandle    = stdoutPipe.fileHandleForReading
        let stderrHandle    = stderrPipe.fileHandleForReading
        
        task.launch()
        stdoutData.append(stdoutHandle.readDataToEndOfFile())
        stderrData.append(stderrHandle.readDataToEndOfFile())
        task.waitUntilExit()
    }
    
    
    /// Returns the underlying NSTask instance's `terminationStatus`. Note: NSTask will raise an Objective-C exception (on macOS, at least) if you call this before the task has actually terminated.
    
    public var terminationStatus: Int {
        return Int(task.terminationStatus)
    }
    
    
    public var description: String {
        var result = ">>++++++++++++++++++++++++++++++++++++++++++++++++++++>>\n"
        result    += "COMMAND: \(launchPath) \(arguments.joined(separator: " "))\n"
        result    += "TERMINATION STATUS: \(terminationStatus)\n"
        result    += "STDOUT: \(stdoutText)\n"
        result    += "STDERR: \(stderrText)\n"
        result    += "<<++++++++++++++++++++++++++++++++++++++++++++++++++++<<"
        
        return result
    }
    
}

