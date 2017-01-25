// DeployValues.swift Created by mason on 2017-01-25. 

import Foundation


/// A value list that contains values ultimately passed to Ansible to control the deploy.

public class DeployValues: SimpleValueList {
    
    convenience init(values: [String:Any]) {
        self.init()
        self.values = values
    }
    
    
    /// Defaults don't really make sense for deploy values (at least currently). So these are mainly for tests.
    
    public static var defaults: DeployValues {
        
        let defaultValues = [
            "java"   : "true",
            "scala"  : "true",
            "docker" : "true",
            "swift"  : "true"
        ]
        return DeployValues(values: defaultValues)
    }

}
