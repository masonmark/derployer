// DerpSerializable.swift Created by mason on 2017-01-29. 

import Foundation


/// Adopting DerpSerializable gives objects some routines for going to/from string/data/file, by just implementing get/set serializationValues (which means going to/from [String:Any?] dict.

public protocol DerpSerializable {
    init()
    var serializationValues: DerpSerializationValues {get set}
}


public typealias DerpSerializationValues = [String:Any?]


public extension DerpSerializable {
    
    // Objects that adopt DerpSerializable should be initializable with just `init()` — classes will also have to either implement init() themselves or be marked `final` due to Swift compiler requirements (as of 3.0.2 anyway).
    
    public init() {
        self.init()
    }
    
    
    public init(serializationValues: DerpSerializationValues) {
        self.init()
        self.serializationValues = serializationValues
    }
    
    
    init?(json: Data) {
        
        guard let obj = try? JSONSerialization.jsonObject(with: json, options: []) else {
            return nil
        }
        guard let serializationValues = obj as? DerpSerializationValues else {
            return nil
        }
        self.init(serializationValues: serializationValues)
    }
    
    
    public var JSONData: Data {
        
        guard let result = try? JSONSerialization.data(withJSONObject: serializationValues, options: .prettyPrinted) else {
            
            fatalError("\(self): JSON encode error: unencodable source values: \(serializationValues)")
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
}
