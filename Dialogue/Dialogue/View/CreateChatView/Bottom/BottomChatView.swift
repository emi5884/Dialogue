import UIKit

protocol BottomChatViewDelegate {
    func moreThanTwoConversations()
}

class BottomChatView: UIView {
    
    // MARK: - Properties
    
    public var delegate: BottomChatViewDelegate?
    
    private var identifier = "identifier"
    
    public lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.delegate = self
        cv.dataSource = self
        cv.register(BottomChatCell.self, forCellWithReuseIdentifier: identifier)
        cv.isPagingEnabled = true
        cv.backgroundColor = CellColorType.green.cellColor
        cv.showsHorizontalScrollIndicator = true
        cv.showsHorizontalScrollIndicator = false
        return cv
    }()
    
    public var dialogues: [Dialogue] = [] {
        didSet {
            collectionView.reloadData()
            collectionView.scrollToItem(at: IndexPath(item: dialogues.count - 1, section: 0),
                                        at: .centeredHorizontally, animated: true)
            
            if dialogues.count >= 2 { delegate?.moreThanTwoConversations() }
        }
    }
    
    // MARK: - LifeCycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        addSubview(collectionView)
        collectionView.fillSuperview()
    }
}

// MARK: - UICollectionViewDataSource

extension BottomChatView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dialogues.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! BottomChatCell
        cell.viewModal = DialogueViewModel(dialogue: dialogues[indexPath.row], cellNumber: indexPath.row)
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension BottomChatView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width, height: frame.height)
    }
}
