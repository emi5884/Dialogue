import UIKit

protocol ChatViewDelegate {
    func didTapCreateButton(view: ChatView)
}

class ChatView: UIView {
    
    // MARK: - Properties
    
    public var delegate: ChatViewDelegate?
    
    private let identifier = "identifier"
    
    public lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.delegate = self
        cv.dataSource = self
        cv.register(ChatViewCell.self, forCellWithReuseIdentifier: identifier)
        cv.contentInset = UIEdgeInsets(top: 30, left: 0, bottom: 15, right: 0)
        return cv
    }()
    
    public var chat: Chat? {
        didSet { collectionView.reloadData() }
    }
    
    // MARK: - LifeCycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        configureUI()
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        
        addSubview(collectionView)
        collectionView.anchor(top: topAnchor,
                              left: leftAnchor,
                              bottom: bottomAnchor,
                              right: rightAnchor)
    }
}

// MARK: - UICollectionViewDataSource

extension ChatView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return chat?.conversation.dialogs.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! ChatViewCell
        
        if let chat = chat {
            cell.viewModel = ChatViewModel(chat: chat, cellNumber: indexPath.row)
        }
        
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension ChatView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let frame = CGRect(x: 0, y: 0, width: frame.width, height: 50)
        let estimatedSizeCell = ChatViewCell(frame: frame)
        estimatedSizeCell.textView.text = chat?.conversation.dialogs[indexPath.row]
        estimatedSizeCell.layoutIfNeeded()

        let targetSize = CGSize(width: frame.width, height: 1000)
        let estimatedSize = estimatedSizeCell.systemLayoutSizeFitting(targetSize)

        return .init(width: frame.width, height: estimatedSize.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
}
