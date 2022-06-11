import UIKit

/// `UIView` reuse identifier related extensions
extension UIView {
    /// Identifier for collections using reuse mechanics
    static var reuseIdentifier: String { String(describing: Self.self) }
}
