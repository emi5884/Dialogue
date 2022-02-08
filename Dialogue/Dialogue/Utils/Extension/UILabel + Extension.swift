import UIKit

extension UILabel {
    
    static func createLabel(size: CGFloat, color: CellColorType? = nil, text: String? = nil) -> UILabel {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .senobiBold(size: size)
        label.text = text
        label.numberOfLines = 0
        
        if color == .yellow {
            label.textColor = .customColor(red: 190, green: 128, blue: 24)
        } else {
            label.textColor = color == nil ? .white : color?.chatViewMainColor
        }
        
        return label
    }
}
