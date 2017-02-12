import Foundation

public typealias DeployPhase = MenuItemList

/// `"Description forthcoming." ;-D`

public class Derployer {
    
    /// Create a new Derployer.
    ///
    /// - Parameter identifier: The identifier for the deployer. Will be used for settings persistent, so should be reasonably unique.
    
    public init(identifier: String? = nil) {
        
        if let identifier = identifier {
            self.identifier = identifier
        }
    }
    
    public var menuInterface: MenuInterface = DefaultMenuInterface()

    public var title = "Derployer Menu"
    
    public var identifier = "Deployer Demo"
    
    public var introMenu: Menu? = DerployerDemo.introMenu
    
    public var deployPhases: [DeployPhase] = DerployerDemo.deployPhases
    
    public func run() {
        
        presentIntroduction()
        
        confirmTargetHostValues()
        
        configureDeployPhases()
        
        confirmPermissionToProceed()
        
        performDeploy()
        
        presentResults()        
    }
    
    
    internal func presentIntroduction() {
        
        let intro = introMenu ?? DerployerDemo.introMenu
        intro.interface = menuInterface
        _ = intro.run()
    }
    
    
    internal func confirmTargetHostValues() {
        
        let targetMenu = Menu(targetHostValues: targetHostValues)
        targetMenu.interface = menuInterface
        
        guard let targetHostValues = targetMenu.run() as? TargetHostValues else {
            return
            // FIXME, IN PROG fatalError("could not confirm target host values")
        }
        targetHostValues.write(url: urlOfStoredTargetHostValues)
    }
    
   
    internal func configureDeployPhases() {
        
        for phase in deployPhases {
            let deployValueMenu = Menu(title: phase.title, content: phase)
            deployValueMenu.interface = menuInterface
            _ = deployValueMenu.run() // FIXME
        }
    }
    
    
    internal func confirmPermissionToProceed() {
        
        let menu = Menu(title: "Are you sure you want to proceed?")
        menu.headers = [
            "Cancel command is not yet implemented, so you need to press Ctrl-C to cancel."
        ]
        
        menu.interface = menuInterface
        
        _ = menu.run() // for now we just rely on ctrl-c to quit
        
    }
    
    
    internal func performDeploy() {
        
    }
    
    
    internal func presentResults() {
        
    }
    
    
    internal var urlOfStoredTargetHostValues: URL {
        return settingsPath(name: "target_host_values")
    }
    
    
    internal var targetHostValues: TargetHostValues {
        
        return TargetHostValues(url: urlOfStoredTargetHostValues) ?? TargetHostValues()
    }

    

    
    

    // MARK: - Settings
    
    /// Returns the default settings path (which is `pathToDefaultPersistenceLocation` + a filename that includes the receiver's identity.
    
    
    /// Returns the settings path, constructed from the `name` (which should be unique among settings files). 
    
    public func settingsPath(name: String) -> URL {
        
        let initial  = type(of: self).pathToDefaultPersistenceLocation ?? "~"
        let parent   = URL(fileURLWithPath: NSString(string: initial).expandingTildeInPath).resolvingSymlinksInPath()
        let url      = parent.appendingPathComponent("\(identifier).\(name)")
        
        do {
            try FileManager.default.createDirectory(at: parent, withIntermediateDirectories: true, attributes: nil) // (it's OK if dir exists)
        } catch  {
            fatalError("Failed to create settings directory at: \(parent)")
        }
        
        return url
    }
    
    
    /// Controls where settings are saved when persisted to disk. By default the current user's home directory is used. If this property is nil or the empty string, the default value will be used. Any ~ in the path will be expanded, so you can do home-relative paths that way. The main purpose of this property is to allow automated tests to override the default save location so as not to pollute the user home dir with junk files.
    
    public static var pathToDefaultPersistenceLocation: String? = nil
}
