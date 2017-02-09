// MenuFormatter.swift Created by mason on 2017-01-20. 

public protocol MenuFormatter {
    
    func resultsMessage(_ resultsMessage: String) -> String
    
    func title(_ title: String) -> String
    
    func header(_ title: String) -> String
    
    func content(_ content:[MenuItem]) -> String
    
    func footer(_ footer: String) -> String
    
    func prompt(_ prompt: String) -> String
}



extension MenuFormatter {
    
    // Formattings things may add trailing space, but should never add leading space.
    
    public var characterWidth: Int {
        return 93
    }
    
    public func resultsMessage(_ resultsMessage: String) -> String {
        
        return resultsMessage + "\n\n"
    }
    
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
        return "\(header)\n"
    }
    
    public func content(_ content:[MenuItem]) -> String {
        // FIXME: someday we should calculate the widest with, and use it to format more attractively (which is why this method takes the whole content array as param)
        
        var result = ""
        
        guard content.count > 0 else {
            return result
        }
        
        var number = 1
        
        for item in content {
            result += "[\(number)] \(item.description)\n"
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
