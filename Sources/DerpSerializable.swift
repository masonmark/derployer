// DerpSerializable.swift Created by mason on 2017-01-29.

import Foundation


/// Adopting DerpSerializable gives objects some routines for going to/from string/data/file, by just implementing `serialize()` and `deserialize()` (which means going to/from [String:Any?] dict.

public protocol DerpSerializable {
    
    /// Adopters must implement this initializer, even if the implementation is just `{}`.
    init()
    
    /// Serializes the object to a generic dictionary. Implementations must take care to return a dictionary that NSJSONSerialization can encode — that responsibility lies entirely with this method. (NOTE: As of Swift 3.0.2 that is still hard on Linux... only seems to work well for simple cases, so lots of trial-and-error and tests are needed.)
    func serialize() throws -> DerpSerializationValues
    
    /// Read the NSJSONSerialization-compatible dictionary of simple types, and do whatever is needed to rehydrate the receiver.
    func deserialize(_: DerpSerializationValues) throws
}


public enum DerpSerializableError: Error {
    case DeserializationFailed(String)

}


public typealias DerpSerializationValues = [String:Any]


public extension DerpSerializable {
    
    // Objects that adopt DerpSerializable should be initializable with just `init()` — classes will also have to either implement init() themselves or be marked `final` due to Swift compiler requirements (as of 3.0.2 anyway).
    
    public init?(serializationValues: DerpSerializationValues) {
        self.init()
        do {
            try self.deserialize(serializationValues)
        } catch {
            handle(error: error)
            return nil
        }
    }
    
    
    public init?(json: Data) {
        
        guard let obj = try? JSONSerialization.jsonObject(with: json, options: []) else {
            return nil
        }
        guard let serializationValues = obj as? DerpSerializationValues else {
            return nil
        }
        self.init(serializationValues: serializationValues)
    }
    
    
    public var JSONData: Data {
        
        guard let serializationValues = try? serialize() else {
            fatalError("\(self): JSON encode error: serialize() failed")
        }

        //        do {
        //            _ = try JSONSerialization.data(withJSONObject: serializationValues, options: .prettyPrinted)
        //        } catch {
        //            print("\(self): JSON encode error: \(error) | source values: \(serializationValues)")
        //        }
        // Mason 2017-01-29: The above was an attempt to print the actual error thrown by NSJSONSerialization. However, when the above code is not commented out, the "swift test" run just abruptly exits before printing anything. Swift 3.1 is fairly imminent, so not trying to debug this for now... UPDATE 2017-02-13: it still fails the same way on Swift swift-3.1-DEVELOPMENT-SNAPSHOT-2017-02-11-a-ubuntu16.04
        ///
        // fatal error: Derployer.DerpValList: JSON encode error: cannot encode source values: ["values": Optional([["type": Optional("boolean"), "identifier": Optional("a bool"), "value": Optional(true), "helpInfo": nil, "predefinedValues": nil], ["type": Optional("predefined"), "identifier": Optional("only certain values"), "value": Optional("5"), "helpInfo": nil, "predefinedValues": Optional(["5", "🍜"])], ["type": Optional("string"), "identifier": Optional("anything allowed"), "value": Optional("5"), "helpInfo": nil, "predefinedValues": Optional(["apple", "banana", "cherry"])]])]: file /mnt/hgfs/Derployer/Sources/DerpSerializable.swift, line 67

        
        guard let result = try? JSONSerialization.data(withJSONObject: serializationValues, options: []) else {
            // Mason 2017-02-13: On Linux vs macOS, whitespace in generated JSON is different. Therefore, use `options: []` which is documented to produce the most compact possible JSON — this makes it a lot easier to write tests.

            fatalError("\(self): JSON encode error: cannot encode source values: \(serializationValues)")
        }
        return result
    }
    
    
    init?(json: String) {
        
        guard let jsonData = json.data(using: .utf8) else {
            return nil
        }
        self.init(json: jsonData)
    }
    
    
    public var JSON: String {
        
        guard let result = String(data: JSONData, encoding: String.Encoding.utf8) else {
            
            fatalError("\(self): JSON encode error: unencodable data:\(JSONData)")
        }
        return result
    }
    
    
    init?(path: String) {
        
        let url = URL(fileURLWithPath: path)
        self.init(url: url)
    }
    
    
    public func write(path: String) {
        
        write(url: URL(fileURLWithPath: path))
    }
    
    
    init?(url: URL) {
        
        guard let jsonData = try? Data(contentsOf: url) else {
            return nil
        }
        self.init(json: jsonData)
    }
    
    
    public func write(url: URL) {
        do {
            try JSONData.write(to: url)
        } catch {
            fatalError("\(self): file write error: \(error)")
        }
    }
    
    
    public func handle(error: Error) {
        
        print("deserialization failed: \(error)")
    }
}
