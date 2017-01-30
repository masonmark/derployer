// MenuFormatter.swift Created by mason on 2017-01-20. 

public protocol MenuFormatter {
    
    func title(_ title: String) -> String
    
    func header(_ title: String) -> String
    
    func content(_ content:[MenuItem]) -> String
    
    func footer(_ footer: String) -> String
    
    func prompt(_ prompt: String) -> String
}



public class DefaultMenuFormatter: MenuFormatter {
    
    // Formattings things may add trailing space, but should never add leading space.
    
    public var characterWidth = 93
    
    public func title(_ title: String) -> String{
        
        var result = "=====  " + title.uppercased()
        
        if (characterWidth - result.characters.count) > 1 {
            result += " "
        }
        if (characterWidth - result.characters.count) > 1 {
            result += " "
        }
        while characterWidth - result.characters.count > 1 {
            result += "="
        }
        result += "\n\n"
        return result
    }
    
    public func header(_ header: String) -> String {
        return "\(header)\n\n"
    }
    
    public func content(_ content:[MenuItem]) -> String {
        // FIXME: someday we should calculate the widest with, and use it to format more attractively (which is why this method takes the whole content array as param)
        
        var result = ""
        var number = 1
        let noValueRepresentation = ""
        
        for item in content {
            result += "[\(number)] \(item.name): \(item.value ?? noValueRepresentation)\n"
            number += 1
        }
        result += "\n"
        return result
    }
    
    public func footer(_ footer: String)  -> String {
        return "\(footer)\n\n"
    }
    
    public func prompt(_ prompt: String) -> String {
        return "\(prompt)"
    }

}
