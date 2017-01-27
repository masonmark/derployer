// CoreUtilities.swift Created by mason on 2017-01-27. 

import Foundation

extension Collection where Indices.Iterator.Element == Index {
    
    /// Returns the element at the specified index if it is within bounds, otherwise nil.
    
    subscript (safe index: Index) -> Generator.Element? {
        return indices.contains(index) ? self[index] : nil
    }
    // Thanks, Obama: http://stackoverflow.com/a/30593673/164017
}
