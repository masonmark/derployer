// TargetHostValues.swift Created by mason on 2017-01-25.

/// Defines a target host that can be configured / deployed to. 

public class TargetHostValues: DerpSerializable {
    
    public var hostname:   String = "127.0.0.1"
    public var username:   String = "ubuntu"
    public var sshPort:    String = "22"
    public var sshKeyPath: String = "~/.ssh/path_to_key_file"
    
    public func serialize() throws -> DerpSerializationValues {
        
        return [
            "hostname"   : hostname,
            "username"   : username,
            "sshPort"    : sshPort,
            "sshKeyPath" : sshKeyPath,
        ]
    }
    
    public func deserialize(_ vals: DerpSerializationValues) throws {
        
        hostname   = vals["hostname"]    as? String ?? ""
        username   = vals["username"]    as? String ?? ""
        sshPort    = vals["sshPort"]     as? String ?? ""
        sshKeyPath = vals["sshKeyPath"]  as? String ?? ""

    }
    
    public required init() {
        // satisfy Swift compiler
    }

    
    convenience init(hostname: String? = nil, username: String? = nil, sshPort: String? = nil, sshKeyPath: String? = nil) {
        
        self.init()
        self.hostname   = hostname   ?? self.hostname
        self.username   = username   ?? self.username
        self.sshPort    = sshPort    ?? self.sshPort
        self.sshKeyPath = sshKeyPath ?? self.sshKeyPath
    }
}
