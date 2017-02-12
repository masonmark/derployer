// TargetHostValues.swift Created by mason on 2017-01-25.

/// Defines a target host that can be configured / deployed to. 

public class TargetHostValues: MenuItemList {
    
//    private let _hostname   = MenuItem("hostname", value: "127.0.0.1")
//    private let _username   = MenuItem("username", value: "ubuntu")
//    private let _sshPort    = MenuItem("sshPort", value: "22", validator: { stringValue in Int(stringValue) != nil })
//    private let _sshKeyPath = MenuItem("sshKeyPath", value: "~/.ssh/path_to_key_file")

    // FIXME: dont use literal string keys if this works
    
    // FIXME: also this all just sucks in general; was hasty retrofit when I changed the design of Menu and friends, needs a re-think at some point maybe

    
    public required init() {
        
        super.init()
        menuItems = [
            MenuItem("hostname", value: "127.0.0.1"),
            MenuItem("username", value: "ubuntu"),
            MenuItem("sshPort", value: "22", validator: { stringValue in Int(stringValue) != nil }),
            MenuItem("sshKeyPath", value: "~/.ssh/path_to_key_file")
        ]
    }
    
    convenience init(hostname: String? = nil, username: String? = nil, sshPort: String? = nil, sshKeyPath: String? = nil) {
        
        self.init()
        
        if let hostname = hostname {
            self.hostname = hostname
        }
        if let username = username {
            self.username = username
        }
        if let sshPort = sshPort {
            self.sshPort = sshPort
        }
        if let sshKeyPath = sshKeyPath {
            self.sshKeyPath = sshKeyPath
        }
    }
    
    var hostname: String {
        get {
            guard let item = self["hostname"] else {
                return "ERROR: NO HOSTNAME VALUE EXISTS"
            }
            return item.stringValue
        }
        set {
            guard let item = self["hostname"] else {
                let item = MenuItem("hostname", value: "127.0.0.1")
                if !item.value.updateFrom(string: newValue) {
                    fatalError()
                }
                self.append(item)
                return
            }
            if !item.value.updateFrom(string: newValue) {
                fatalError()
            }
        }
    }
    
    
    var username: String {
        get {
            guard let item = self["username"] else {
                return "ERROR: NO username VALUE EXISTS"
            }
            return item.stringValue
        }
        set {
            guard let item = self["username"] else {
                let item = MenuItem("username", value: "ubuntu")
                if !item.value.updateFrom(string: newValue) {
                    fatalError()
                }
                self.append(item)
                return
            }
            if !item.value.updateFrom(string: newValue) {
                fatalError()
            }
        }
    }
    
    
    var sshPort: String {
        get {
            guard let item = self["sshPort"] else {
                return "ERROR: NO sshPort VALUE EXISTS"
            }
            return item.stringValue
        }
        set {
            guard let item = self["sshPort"] else {
                let item = MenuItem("sshPort", value: "22", validator: { stringValue in Int(stringValue) != nil })
                if !item.value.updateFrom(string: newValue) {
                    fatalError()
                }
                self.append(item)
                return
            }
            if !item.value.updateFrom(string: newValue) {
                fatalError()
            }
        }
    }
    
    
    var sshKeyPath: String {
        get {
            guard let item = self["sshKeyPath"] else {
                return "ERROR: NO sshKeyPath VALUE EXISTS"
            }
            return item.stringValue
        }
        set {
            guard let item = self["sshKeyPath"] else {
                let item = MenuItem("sshKeyPath", value: "~/.ssh/path_to_key_file")
                if !item.value.updateFrom(string: newValue) {
                    fatalError()
                }
                self.append(item)
                return
            }
            if !item.value.updateFrom(string: newValue) {
                fatalError()
            }
        }
    }
    
    
    public override func toString() -> String {
        return self.JSON
    }
    
    
    public override func updateFrom(string: String) -> Bool {
        return true
    }
}


extension Menu {
    
    /// Initializes a Menu instance from a TargetHostValues instance.
    
    public convenience init(targetHostValues: TargetHostValues) {
        
        self.init(title: "TARGET HOST VALUES", content: targetHostValues)
        self.headers = [
            "The target host values specify the machine to be configured."
        ]
    }
}
