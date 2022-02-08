import UIKit
import SDWebImage

class BottomChatCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    public var viewModal: DialogueViewModel? {
        didSet { configureUI() }
    }
    
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.layer.cornerRadius = 30
        iv.backgroundColor = .systemGreen
        iv.clipsToBounds = true
        iv.image = #imageLiteral(resourceName: "character")
        return iv
    }()
    
    private let dialogueLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = CellColorType.green.chatViewMainColor
        label.font = .senobi(size: 16)
        label.textColor = .white
        label.layer.cornerRadius = 10
        label.clipsToBounds = true
        label.numberOfLines = 0
        return label
    }()
    
    private let bubbleTail = BubbleTail(frame: .zero, color: CellColorType.green.chatViewMainColor)
    
    // MARK: - LifeCycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let bubbleContainer = UIView()
        bubbleContainer.backgroundColor = CellColorType.green.chatViewMainColor
        bubbleContainer.layer.cornerRadius = 15
        addSubview(bubbleContainer)
        bubbleContainer.anchor(top: topAnchor,
                               left: leftAnchor,
                               right: rightAnchor,
                               paddingTop: 45,
                               paddingLeft: 84,
                               paddingRight: 20,
                               height: 68)
        
        bubbleContainer.addSubview(dialogueLabel)
        dialogueLabel.anchor(top: bubbleContainer.topAnchor,
                             left: bubbleContainer.leftAnchor,
                             bottom: bubbleContainer.bottomAnchor,
                             right: bubbleContainer.rightAnchor,
                             paddingTop: 5,
                             paddingLeft: 10,
                             paddingBottom: 5,
                             paddingRight: 10)
        
        addSubview(imageView)
        imageView.anchor(left: leftAnchor,
                         paddingLeft: 10)
        imageView.setDimensions(height: 60, width: 60)
        imageView.centerY(inView: dialogueLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        addSubview(bubbleTail)
        bubbleTail.frame = CGRect(x: 72, y: 78, width: 22, height: 18)
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        guard let viewModal = viewModal else { return }
        
        imageView.sd_setImage(with: viewModal.imageUrl, completed: nil)
        dialogueLabel.text = viewModal.dialogue.dialogue
        
        if viewModal.dialogue.dialogue.count > 16 {
            dialogueLabel.textAlignment = .left
        } else {
            dialogueLabel.textAlignment = .center
        }
    }
}
