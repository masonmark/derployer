// ValueList.swift Created by mason on 2017-01-25.

import Foundation

/// The `ValueList` protocol+extensions makes it easy to implement JSON-serializable named-value lists. It provides:
///
/// - convenience initializers
/// - routines to convert to/from JSON (either `Data` or `String` or file)
/// - subscript get/set values, so can be used like a Dictionary
///
/// Such lists are used for internal settings, deploy settings, and the top-level object which comprises the tool's settings.
///
/// The concrete SimpleValueList class may be used as-is for simple lists, or subclassed. It is also possible to implement a standalone class that manages storage however desired (e.g. through simple instance properties), as long as it implements `get` and `set` for the `values` instance property, all of the free behavior implemented in the protocol will still work.  

public protocol ValueList {
    var values: [String:Any] {get set}
    init()
}


extension ValueList {
    
    init(values: [String:Any]) {
        self.init()
        self.values = values
    }
    
    
    init?(json: Data) {
        
        guard let obj = try? JSONSerialization.jsonObject(with: json, options: []) else {
            return nil
        }
        guard let dict = obj as? [String:String] else {
            return nil
        }
        self.init(values: dict)
    }
    
    
    init?(json: String) {
        
        guard let jsonData = json.data(using: .utf8) else {
            return nil
        }
        self.init(json: jsonData)
    }
    
    
    init?(path: String) {
        let url = URL(fileURLWithPath: path)
        self.init(url: url)
    }
    
    
    init?(url: URL) {
        
        guard let jsonData = try? Data(contentsOf: url) else {
            return nil
        }
        self.init(json: jsonData)
    }
    
    
    subscript(key: String) -> Any? {
        
        get {
            return values[key]
        }
        
        set(newValue) {
            values[key] = newValue
        }
    }
    
    
    public var JSONData: Data {
        
        guard let result = try? JSONSerialization.data(withJSONObject: values, options: .prettyPrinted) else {
            fatalError("\(self): JSON encode error: unencodable source values: \(values)")
        }
        return result
    }
    
    
    public var JSON: String {
        
        guard let result = String(data: JSONData, encoding: String.Encoding.utf8) else {
            fatalError("\(self): JSON encode error: unencodable data:\(JSONData)")
        }
        return result
    }
    
    
    public func write(path: String) {
        write(url: URL(fileURLWithPath: path))
    }
    
    
    public func write(url: URL) {
        do {
            try JSONData.write(to: url)
        } catch {
            fatalError("\(self): file write error: \(error)")
        }
        
    }
    
    
}


/// Simple concrete implementation of ValueList (appropriate for using as-is or subclassing).

public class SimpleValueList: ValueList {
    
    public var values: [String: Any] = [:]
    
    public required init() {
        // satisfy Swift compiler :-/
    }
}
