// MenuInterlocutor.swift Created by mason on 2017-02-08. 

import Foundation


/// Routines to talk to the user. In the intial implementation, at least, both Menu and MenuItem may need to do this.

protocol MenuInterlocutor {
    
}


extension MenuInterlocutor {
    
    var inputPrompt: String {
        return "\n→ "
    }
    
    public func messageAcceptOrManuallyChangeValue(name: String, value:String) -> String {
        // FIXME rename promptXXX
        return "\(name): \(value)\nPress ↩︎ to accept, or else enter a new value:\(inputPrompt)"
    }
    
    public func messageBadInputPleaseTryAgain(input: String) -> String {
        return "⚠️  SORRY: '\(input)' is not something I understand. Please try again."
    }
    
    public func messageValueChanged(name: String, newValue: String) -> String {
        return "New value for \(name): \(newValue)"
    }
    
    public func messageNoChangeMade() -> String {
        return "No change made.\n\n"
    }
    
    public func menuTitleForEditing(name: String) -> String {
        return name
    }
    
    public func promptChooseOrEnterValue() -> String {
        return "Choose a value from the list, or enter a value, and press ↩︎ to confirm:\(inputPrompt)"
    }
    
    
    public func promptChooseFromMenuOrAcceptCurrent(name: String, value: String) -> String {
        return "Choose a value from the list, or press ↩︎ to accept current value:\(inputPrompt)"
    }
    
    public func promptManuallyEnterNewValueOrAcceptCurrent(name: String, value: String) -> String {
        return "\(name): Enter a new value, or press ↩︎ to accept current value (\(value)):\(inputPrompt)"
    }
}
