import UIKit

extension UIFont {
    static func senobi(size: CGFloat) -> UIFont {
        return UIFont(name: "Senobi-Gothic-Regular", size: size) ?? .systemFont(ofSize: size)
    }
    
    static func senobiMedium(size: CGFloat) -> UIFont {
        return UIFont(name: "Senobi-Gothic-Medium", size: size) ?? .systemFont(ofSize: size)
    }
    
    static func senobiBold(size: CGFloat) -> UIFont {
        return UIFont(name: "Senobi-Gothic-Bold", size: size) ?? .systemFont(ofSize: size)
    }
}
