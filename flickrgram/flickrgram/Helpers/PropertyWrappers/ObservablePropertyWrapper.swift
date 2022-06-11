import Foundation

/// Property wrapper that allows to track value change
@propertyWrapper final class Observable<Value> {
    var wrappedValue: Value {
        didSet {
            onValueChange?(wrappedValue)
        }
    }
    
    var projectedValue: Observable<Value> { self }
    
    /// Property value change event handler
    var onValueChange: ((Value) -> ())? = nil
    
    init(wrappedValue: Value) {
        self.wrappedValue = wrappedValue
    }
}
