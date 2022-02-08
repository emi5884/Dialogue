import UIKit

class CreateChatCell: UITableViewCell {
    
    // MARK: - Properties
    
    public var label: UILabel = {
        let label = UILabel()
        label.font = .senobi(size: 18)
        label.textAlignment = .center
        label.backgroundColor = .clear
        label.textColor = .white
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()
    
    public var bottomBorder = UIView()
    
    // MARK: - LifeCycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        addSubview(label)
        label.anchor(top: topAnchor,
                     left: leftAnchor,
                     bottom: bottomAnchor,
                     right: rightAnchor,
                     paddingTop: 10,
                     paddingLeft: 10,
                     paddingBottom: 10,
                     paddingRight: 10)
        
        bottomBorder.backgroundColor = .white.withAlphaComponent(0.3)
        addSubview(bottomBorder)
        bottomBorder.anchor(left: leftAnchor,
                    bottom: bottomAnchor,
                    right: rightAnchor,
                    paddingLeft: 10,
                    paddingRight: 10,
                    height: 1)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
