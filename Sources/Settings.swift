// Settings.swift Created by mason on 2017-01-24.

import Foundation

let kFormatVersion    = "format_version"
let kIdentifier       = "identifier"
let kTargetHostValues = "target_host_values"
let kDeployValues     = "deploy_values"

class Settings: ValueList {
    
    // The identifier should be globally unique, because it is used to persist settings. Two programs using the same identifier could overwrite each other's settings. It may also used in user-visible files, however, so "app name plus UUID" is a decent choice (e.g. "my-super-cool-tool-C9AB7253-8040-492C-93B1-C5BEEA124532".
    
    public var identifier: String = "com.masonmark.derployer"
    
    
    var values: [String:Any] {
        
        get {
            return [
                kFormatVersion    : "1",
                kIdentifier       : identifier,
                kTargetHostValues : targetHostValues.values,
                kDeployValues     : deployValues.values,
            ]
        }
        set {
            let newTargetHostValues = newValue[kTargetHostValues] as? [String: Any]
            targetHostValues = TargetHostValues(values: newTargetHostValues ?? [:])
            
            let newDeployValues = newValue[kDeployValues] as? [String: Any]
            deployValues = DeployValues(values: newDeployValues ?? [:])
        }
    }


    /// This ValueList object defines the target host access parameters.
    
    var targetHostValues = TargetHostValues(values: [:])
    
    
    /// A value list to contain the set of deploy options (essentially, just extra variables that get passed to Ansible, to inform it what config is performed and and how it is done).

    var deployValues = DeployValues()
    
    
    /// Values must be valid (contain target_host_values and deploy_values value lists), or a fatalError() will occur, in this initial implementation. Use `init(defaultsWithIdentifier:)` to create a Settings instance with default values.
    
    public required init(values: [String:Any]) {
        
        guard let targetHostDict = values[kTargetHostValues] as? [String:String] else {
            fatalError("FIXME: make nil kTargetHostValues a nonfatal error")
        }
        guard let deployValuesDict = values[kDeployValues] as? [String:String] else {
            fatalError("FIXME: make nil deployValuesDict a nonfatal error")
        }
        
        targetHostValues = TargetHostValues(values: targetHostDict)
        deployValues     = DeployValues(values: deployValuesDict)
    }
    

    /// Exists only to satisfy Swift compiler.
    
    public required init() {
    }

    
    /// Values must be valid (contain target_host_values and deploy_values value lists), or a fatalError() will occur, in this initial implementation. Use `init(defaultsWithIdentifier:)` to create a Settings instance with default values.

    convenience init(values: [String:Any], identifier: String) {
        self.init(values: values)
        self.identifier = identifier
    }
    
    
    /// Returns a new Settings instance with default values and the supplied `identifier`,
    
    convenience init(defaultsWithIdentifier identifier: String) {
        let defaultValues: [String : Any] = [
            kIdentifier       : identifier,
            kTargetHostValues : TargetHostValues.defaults.values,
            kDeployValues     : DeployValues.defaults.values,
        ]
        self.init(values: defaultValues)
        self.identifier = identifier
    }
    

    /// Creates a Settings list with default values if no file exists on disk. If a file matching `identifier` **does** exist on disk, then that file is read, and the resulting Settings list is returned.

    convenience init?(identifier: String) {
        
        let myType       = type(of: self)
        let sourcePath   = myType.settingsPath(identifier: identifier)
        let sourceURL    = URL(fileURLWithPath: sourcePath)
        let existingData = try? Data(contentsOf: sourceURL)
        
        guard existingData != nil else {
            self.init(defaultsWithIdentifier: identifier)
            return
        }
        self.init(path: sourcePath)
        self.identifier = identifier
    }
    

    /// Write the settings list to `path`, or to the default settings path if `path` is nil. Overwrites any existing file.
    
    public func write(path: String? = nil) {
        
        let path   = path ?? settingsPath
        let child  = NSString(string: path)
        let parent = child.deletingLastPathComponent
        
        do {
            try FileManager.default.createDirectory(atPath: parent, withIntermediateDirectories: true)
        } catch {
            fatalError("\(self): could not create directory at '\(parent)': \(error)")
        }
        write(path: path)
    }
    
    
    /// Returns the default settings path (which is `pathToDefaultPersistenceLocation` + a filename that includes the receiver's identity.
    
    var settingsPath: String {
        let myType = type(of: self)
        return myType.settingsPath(identifier: identifier)
    }
    
    
    /// Returns the settings path, constructed from the identifier (which should be unique). This func is static because it is needed within some initializers. Normally you can just use the `settingsPath` instance property, though.
    
    public static func settingsPath(identifier: String) -> String {
        let parent = pathToDefaultPersistenceLocation ?? "~"
        let path = "\(parent)/.\(identifier).settings"
        let original = NSString(string: path) // the Linux-friendly syntax (2017-01-24)
        return original.expandingTildeInPath
    }
    
    
    /// Controls where settings are saved when persisted to disk. By default the current user's home directory is used. If this property is nil or the empty string, the default value will be used. Any ~ in the path will be expanded, so you can do home-relative paths that way. The main purpose of this property is to allow automated tests to override the default save location so as not to pollute the user home dir with junk files.
    
    public static var pathToDefaultPersistenceLocation: String? = nil
}
