import UIKit

protocol TopCellViewDelegate {
    func didTapStartButton(cell: TopCellContents)
}

class TopCellContents: UIView {
    
    // MARK: - Properties
    
    public var viewModel: TopViewModel? {
        didSet {
            guard let viewModal = viewModel else { return }
            membersView = MembersView(frame: .zero, conversation: viewModal.conversation)
            configureUI()
        }
    }
    
    public var delegate: TopCellViewDelegate?
    
    public let baseView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 25
        view.layer.shadowColor = UIColor.lightGray.cgColor
        view.layer.shadowOffset = CGSize(width: 12, height: 12)
        view.layer.shadowOpacity = 0.8
        view.layer.shadowRadius = 8
        return view
    }()
    
    public let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .senobiMedium(size: 20)
        label.textColor = .white
        return label
    }()
    
    public lazy var startButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "start"), for: .normal)
        button.backgroundColor = .clear
        button.contentEdgeInsets = UIEdgeInsets(top: 15, left: 20, bottom: 15, right: 15)
        button.layer.cornerRadius = 30
        button.layer.borderWidth = 3
        button.layer.borderColor = UIColor.white.cgColor
        button.addTarget(self, action: #selector(didTapStartButton), for: .touchUpInside)
        return button
    }()
    
    public lazy var membersView = MembersView(frame: .zero, conversation: Conversation(dictionary: [:]))
    private var didShowChatView = false
    
    // MARK: - LifeCycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Actions
    
    @objc func didTapStartButton() {
        didShowChatView = true
        delegate?.didTapStartButton(cell: self)
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        guard let viewModel = viewModel else { return }
        
        addSubview(baseView)
        baseView.anchor(top: topAnchor,
                        left: leftAnchor,
                        bottom: bottomAnchor,
                        right: rightAnchor,
                        paddingTop: 10,
                        paddingLeft: 15,
                        paddingBottom: 15,
                        paddingRight: 15)
        baseView.backgroundColor = viewModel.cellColor
        
        addSubview(startButton)
        startButton.anchor(right: rightAnchor,
                           paddingRight: 30)
        startButton.setDimensions(height: 60, width: 60)
        startButton.centerY(inView: self)
        
        titleLabel.text = viewModel.titile
        titleLabel.textColor = viewModel.titileTextColor
        
        let stackView = UIStackView(arrangedSubviews: [titleLabel, membersView])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        
        addSubview(stackView)
        stackView.anchor(top: baseView.topAnchor,
                         left: baseView.leftAnchor,
                         bottom: baseView.bottomAnchor,
                         right: startButton.leftAnchor,
                         paddingTop: 10,
                         paddingLeft: 20,
                         paddingBottom: 20,
                         paddingRight: 20)
    }
}
