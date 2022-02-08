import UIKit

protocol CustomAlertDelegate {
    func registerTitle(view: CustomAlert)
}

class CustomAlert: UIView {
    
    // MARK: - Properties
    
    public var delegate: CustomAlertDelegate?
    
    private let baseView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    public let textView = CustomTextField()
    
    private lazy var registerButton: UIButton = {
        let button = UIButton()
        button.setTitle("登録", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemGray
        button.addTarget(self, action: #selector(didTapRegisterButton), for: .touchUpInside)
        return button
    }()
    
    // MARK: - LifeCycel
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(baseView)
        baseView.fillSuperview()
        
        baseView.addSubview(textView)
        textView.anchor(top: topAnchor,
                        left: leftAnchor,
                        right: rightAnchor,
                        paddingTop: 20,
                        paddingLeft: 20,
                        paddingRight: 20,
                        height: 50)
        
        baseView.addSubview(registerButton)
        registerButton.anchor(top: textView.bottomAnchor,
                              left: leftAnchor,
                              right: rightAnchor,
                              paddingTop: 10,
                              paddingLeft: 20,
                              paddingRight: 20,
                              height: 50)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Actions
    
    @objc func didTapRegisterButton() {
        delegate?.registerTitle(view: self)
    }
}
