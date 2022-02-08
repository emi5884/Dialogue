import UIKit
import SDWebImage

class CharacterListCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    public var viewModal: CharacterViewModel? {
        didSet { configureUI() }
    }
    
    private lazy var imageView: UIImageView = {
        let iv = UIImageView()
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 30
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .senobiMedium(size: 16)
        label.textColor = .white
        return label
    }()
    
    private let commentView: UIImageView = {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "message")
        iv.isHidden = true
        return iv
    }()
    
    override var isSelected: Bool {
        didSet { commentView.isHidden = isSelected ? false : true }
    }
    
    // MARK: - LifeCycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(imageView)
        imageView.anchor(top: topAnchor, paddingTop: 10)
        imageView.setDimensions(height: 60, width: 60)
        imageView.centerX(inView: self)
        
        addSubview(commentView)
        commentView.anchor(top: topAnchor,
                           right: rightAnchor,
                           paddingTop: -4,
                           paddingRight: -13)
        commentView.setDimensions(height: 30, width: 30)
        
        addSubview(nameLabel)
        nameLabel.anchor(top: imageView.bottomAnchor,
                         left: leftAnchor,
                         bottom: bottomAnchor,
                         right: rightAnchor,
                         paddingTop: 10,
                         paddingBottom: 10,
                         height: 20)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        guard let viewModal = viewModal else { return }
        imageView.sd_setImage(with: viewModal.imageUrl, completed: nil)
        nameLabel.text = viewModal.name
    }
}
