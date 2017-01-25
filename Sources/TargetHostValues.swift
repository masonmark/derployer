// TargetHostValues.swift Created by mason on 2017-01-25.

/// Defines a target host that can be configured / deployed to. Also provides a simple example for how to conform to the ValueList protocol while using regular Swift instance properties to store the data.

public class TargetHostValues: ValueList {
    
    public var hostname:   String = ""
    public var username:   String = ""
    public var sshPort:    String = ""
    public var sshKeyPath: String = ""
    
    
    public var values: [String:Any] {
        get {
            return [
                "hostname"   : hostname,
                "username"   : username,
                "sshPort"    : sshPort,
                "sshKeyPath" : sshKeyPath,
            ]
        }
        set {
            hostname   = newValue["hostname"]    as? String ?? ""
            username   = newValue["username"]    as? String ?? ""
            sshPort    = newValue["sshPort"]     as? String ?? ""
            sshKeyPath = newValue["sshKeyPath"]  as? String ?? ""
        }
    }
    
    
    public required init() {
        // satisfy Swift compiler
    }

    
    convenience init(hostname: String = "", username: String = "", sshPort: String = "", sshKeyPath: String = "") {
        
        var values: [String:String] = [:]
        
        values["hostname"]   = hostname
        values["username"]   = username
        values["sshPort"]    = sshPort
        values["sshKeyPath"] = sshKeyPath
        
        self.init(values: values)
    }
    
    
    public static var defaults: TargetHostValues {
        
        return TargetHostValues(
            hostname: "127.0.0.1", username: "ubuntu", sshPort: "22", sshKeyPath: "~/.ssh/path_to_key_file"
        )
    }
}
