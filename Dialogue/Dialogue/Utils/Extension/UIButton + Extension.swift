import UIKit

extension UIButton {
    
    static func createButton(target: Any?, action: Selector) -> UIButton {
        let button = UIButton()
        button.backgroundColor = CellColorType.pink.chatViewMainColor
        button.layer.cornerRadius = 30
        button.addTarget(target, action: action, for: .touchUpInside)
        return button
    }
    
    static func createStartButton(target: Any?, action: Selector) -> UIButton {
        let button = UIButton()
        button.backgroundColor = .clear
        button.setImage(#imageLiteral(resourceName: "start").withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .white.withAlphaComponent(0.8)
        button.contentEdgeInsets = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        button.addTarget(target, action: action, for: .touchUpInside)
        return button
    }
    
    static func createTextButton(target: Any?, action: Selector, title: String) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .senobiBold(size: 18)
        button.backgroundColor = .clear
        button.layer.cornerRadius = 30
        button.addTarget(target, action: action, for: .touchUpInside)
        return button
    }
    
    static func createImageButton(target: Any?, action: Selector, image: UIImage, isFrame: Bool, inset: UIEdgeInsets) -> UIButton {
        let button = UIButton()
        button.backgroundColor = .clear
        button.setImage(image, for: .normal)
        button.layer.borderWidth = isFrame ? 2 : 0
        button.layer.borderColor = isFrame ? UIColor.white.cgColor : UIColor.clear.cgColor
        button.layer.cornerRadius = isFrame ? 25 : 0
        button.imageEdgeInsets = inset
        button.addTarget(target, action: action, for: .touchUpInside)
        return button
    }
}
