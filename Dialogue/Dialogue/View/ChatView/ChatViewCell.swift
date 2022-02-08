import UIKit
import SDWebImage

class ChatViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    public var viewModel: ChatViewModel? {
        didSet { configureViewModel() }
    }
    
    private let iconImageView: UIImageView = {
        let iv = UIImageView()
        iv.layer.cornerRadius = 16
        iv.clipsToBounds = true
        return iv
    }()
    
    private lazy var iconImageBaseView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 21
        return view
    }()
    
    public let textView: UITextView = {
        let tv = UITextView()
        tv.isScrollEnabled = false
        tv.isUserInteractionEnabled = false
        tv.backgroundColor = .clear
        tv.font = .senobi(size: 18)
        return tv
    }()
    
    private let bubbleContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 12
        return view
    }()
    
    public lazy var pulseAnimationLayer = CAShapeLayer.createPulseAnimationForChat()
    
    private let bubbleTail = BubbleTail(frame: .zero, color: .white)
    
    // MARK: - LifeCycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        addSubview(bubbleTail)
        bubbleTail.frame = CGRect(x: 54, y: frame.height - 22, width: 18, height: 12)
        
        pulseAnimationLayer.position = CGPoint(x: iconImageBaseView.frame.width / 2,
                                               y: iconImageBaseView.frame.height / 2)
        pulseAnimationLayer.isHidden = true
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        addSubview(iconImageBaseView)
        iconImageBaseView.anchor(left: leftAnchor,
                             bottom: bottomAnchor,
                             paddingLeft: 10,
                             paddingBottom: -4)
        iconImageBaseView.setDimensions(height: 42, width: 42)
        
        pulseAnimationLayer.strokeColor = UIColor.white.withAlphaComponent(0.2).cgColor
        iconImageBaseView.layer.addSublayer(pulseAnimationLayer)
        
        iconImageBaseView.addSubview(iconImageView)
        iconImageView.centerY(inView: iconImageBaseView)
        iconImageView.centerX(inView: iconImageBaseView)
        iconImageView.setDimensions(height: 32, width: 32)
        
        addSubview(bubbleContainer)
        bubbleContainer.anchor(top: topAnchor,
                               left: iconImageView.rightAnchor,
                               bottom: bottomAnchor,
                               paddingLeft: 14)
        bubbleContainer.widthAnchor.constraint(lessThanOrEqualToConstant: frame.width - 66).isActive = true
        
        bubbleContainer.addSubview(textView)
        textView.anchor(top: bubbleContainer.topAnchor,
                        left: bubbleContainer.leftAnchor,
                        bottom: bubbleContainer.bottomAnchor,
                        right: bubbleContainer.rightAnchor,
                        paddingTop: 4,
                        paddingLeft: 12,
                        paddingBottom: 4,
                        paddingRight: 12)
    }
    
    func configureViewModel() {
        guard let viewModel = viewModel else { return }
        
        iconImageBaseView.backgroundColor = viewModel.textColor
        textView.text = viewModel.dialogue
        textView.textColor = viewModel.textColor
        iconImageView.sd_setImage(with: viewModel.imageUrl, completed: nil)
    }
}
