import UIKit

protocol CharacterListViewDelegate {
    func showRegisterViewController()
    func selectCharacter(character: Character)
}

class CharacterListView: UIView {
    
    // MARK: - Properties
    
    public var delegate: CharacterListViewDelegate?
    private let identifier = "identifier"
    
    public lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.scrollDirection = .horizontal
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.dataSource = self
        cv.delegate = self
        cv.backgroundColor = CellColorType.pink.cellColor
        cv.register(CharacterListCell.self, forCellWithReuseIdentifier: identifier)
        cv.contentInset = UIEdgeInsets(top: 0, left: 103, bottom: 0, right: 10)
        cv.showsHorizontalScrollIndicator = false
        return cv
    }()
    
    private lazy var addButton2: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(didTapAddButton), for: .touchUpInside)
        button.setImage(#imageLiteral(resourceName: "user"), for: .normal)
        button.layer.cornerRadius = 30
        return button
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .senobiMedium(size: 16)
        label.textColor = .white
        label.backgroundColor = CellColorType.pink.cellColor
        label.text = "追加"
        return label
    }()
    
    public let addButton = Character(dictionary: ["":""])
    public lazy var characters: [Character] = [] {
        didSet { collectionView.reloadData() }
    }
    
    private var isFirstRunning = true
    
    // MARK: - LifeCycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Actions
    
    @objc func didTapAddButton() {
        delegate?.showRegisterViewController()
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        backgroundColor = CellColorType.pink.cellColor
        
        addSubview(collectionView)
        collectionView.anchor(top: safeAreaLayoutGuide.topAnchor,
                              left: leftAnchor,
                              right: rightAnchor,
                              height: 110)
        
        addSubview(addButton2)
        addButton2.anchor(top: safeAreaLayoutGuide.topAnchor,
                          left: leftAnchor,
                          paddingTop: 10,
                          paddingLeft: 20)
        addButton2.setDimensions(height: 60, width: 60)
        
        let plusViewBaseView = UIImageView()
        plusViewBaseView.backgroundColor = .white
        addSubview(plusViewBaseView)
        plusViewBaseView.anchor(bottom: addButton2.bottomAnchor,
                        right: addButton2.rightAnchor,
                        paddingBottom: -5, paddingRight: -5)
        plusViewBaseView.setDimensions(height: 25, width: 25)
        plusViewBaseView.layer.cornerRadius = 12.5
        
        let plusView = UIImageView(image: #imageLiteral(resourceName: "plus-pink"))
        plusViewBaseView.addSubview(plusView)
        plusView.fillSuperview()
        
        addSubview(nameLabel)
        nameLabel.anchor(top: addButton2.bottomAnchor,
                         paddingTop: 10)
        nameLabel.centerX(inView: addButton2)
    }
}

// MARK: - UICollectionViewDataSource

extension CharacterListView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return characters.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! CharacterListCell
        cell.viewModal = CharacterViewModel(character: characters[indexPath.row], cellNumber: indexPath.row)
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension CharacterListView: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? CharacterListCell else { return }
        guard let character = cell.viewModal?.character else { return }
        delegate?.selectCharacter(character: character)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension CharacterListView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = frame.height - Dimension.safeAreatTopHeight
        return CGSize(width: height - 30, height: height)
    }
}

