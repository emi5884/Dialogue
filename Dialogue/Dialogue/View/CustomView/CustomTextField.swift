import UIKit

class CustomTextField: UITextField {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let leftPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: frame.height))
        leftView = leftPaddingView
        leftViewMode = .always
        layer.cornerRadius = 5
        textColor = .white
        font = .senobi(size: 18)
        tintColor = .lightGray
        
        let attributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.lightGray,
                                                         .font: UIFont.senobi(size: 14)]
        attributedPlaceholder = NSAttributedString(string: "", attributes: attributes)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
