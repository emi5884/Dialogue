import UIKit

protocol CustomSearchBarDelegate {
    func didChangeText(text: String)
    func didCancel()
}

class CustomSearchBar: UIView {
    
    // MARK: - Properties
    
    public var delegate: CustomSearchBarDelegate?
    
    private let searchBaseView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 25
        return view
    }()
    
    private let searchIcon = UIImageView (image: #imageLiteral(resourceName: "search-line"))
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.searchTextField.backgroundColor = .clear
        searchBar.searchTextField.textColor = .systemGray
        searchBar.backgroundImage = UIImage()
        searchBar.searchTextField.leftView = .none
        searchBar.tintColor = .lightGray
        searchBar.searchTextField.font = .senobi(size: 18)
        searchBar.delegate = self
        
        let attributes: [NSAttributedString.Key: Any] = [.font: UIFont.senobi(size: 18),
                                                         .foregroundColor: UIColor.lightGray]
        searchBar.searchTextField.attributedPlaceholder = NSAttributedString(string: "検索", attributes: attributes)
        return searchBar
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("cancel", for: .normal)
        button.setTitleColor(CellColorType.blue.cellColor, for: .normal)
        button.addTarget(self, action: #selector(didTapCancel), for: .touchUpInside)
        return button
    }()
    
    private var searchBaseViewWidthAnchor: NSLayoutConstraint?
    private var canncelButtonLeftAnchor: NSLayoutConstraint?
    
    private var shouldShowCancel = false
    
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
    
    // MARK: - Action
    
    @objc func didTapCancel() {
        delegate?.didCancel()
        didCanncel()
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        addSubview(searchBaseView)
        searchBaseView.anchor(top: topAnchor,
                              left: leftAnchor,
                              bottom: bottomAnchor,
                              paddingLeft: 20)
        searchBaseViewWidthAnchor = searchBaseView.widthAnchor.constraint(equalToConstant: frame.width - 40)
        searchBaseViewWidthAnchor?.isActive = true
        
        addSubview(searchIcon)
        searchIcon.anchor(left: searchBaseView.leftAnchor,
                          paddingLeft: 10)
        searchIcon.setDimensions(height: 30, width: 30)
        searchIcon.centerY(inView: searchBaseView)
        
        addSubview(searchBar)
        searchBar.anchor(left: searchIcon.rightAnchor, paddingLeft: -10)
        searchBar.setDimensions(height: 50, width: frame.width - 90)
        searchBar.centerY(inView: searchBaseView)
        
        addSubview(cancelButton)
        cancelButton.setDimensions(height: 50, width: 80)
        cancelButton.anchor(left: searchBaseView.rightAnchor, paddingLeft: 20)
        canncelButtonLeftAnchor = cancelButton.leftAnchor.constraint(equalTo: searchBaseView.rightAnchor, constant: 0)
        canncelButtonLeftAnchor?.isActive = false
    }
    
    func handleCanncelButton() {
        searchBaseViewWidthAnchor?.constant = frame.width - 100
        canncelButtonLeftAnchor?.isActive = true
        
        UIView.animate(withDuration: 0.25) {
            self.layoutIfNeeded()
        }
    }
    
    func didCanncel() {
        let attributes: [NSAttributedString.Key: Any] = [.font: UIFont.senobi(size: 18),
                                                         .foregroundColor: UIColor.lightGray]
        searchBar.searchTextField.attributedPlaceholder = NSAttributedString(string: "検索", attributes: attributes)
        
        searchBaseViewWidthAnchor?.constant = frame.width - 40
        canncelButtonLeftAnchor?.isActive = false
        
        UIView.animate(withDuration: 0.25) {
            self.layoutIfNeeded()
        }
    }
}

// MARK: - UISearchBarDelegate

extension CustomSearchBar: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.searchTextField.attributedPlaceholder = NSAttributedString(string: "", attributes: nil)
        handleCanncelButton()
    }
    
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        delegate?.didChangeText(text: text)
        return true
    }
}
