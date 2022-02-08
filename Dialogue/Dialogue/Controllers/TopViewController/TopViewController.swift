import UIKit
import Hero

class TopViewController: UIViewController {
    
    // MARK: - Properties
    
    private let identifier = "identifier"
    
    private lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.dataSource = self
        tv.register(TopCell.self, forCellReuseIdentifier: identifier)
        tv.rowHeight = 170
        tv.allowsSelection = false
        tv.separatorStyle = .none
        tv.backgroundColor = UIColor.customColor(red: 240, green: 240, blue: 240)
        return tv
    }()
    
    private let buttonBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .customColor(red: 240, green: 240, blue: 240)
        view.layer.cornerRadius = 90
        view.layer.shadowColor = UIColor.lightGray.cgColor
        view.layer.shadowOffset = CGSize(width: 12, height: 12)
        view.layer.shadowOpacity = 0.8
        view.layer.shadowRadius = 8
        return view
    }()
    
    private let moveToCreateChatViewPlus = UIImageView(image: #imageLiteral(resourceName: "add-line"))
    
    private lazy var moveToCreateChatViewButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 30
        button.addTarget(self, action: #selector(didTapCreateButton), for: .touchUpInside)
        button.setImage(#imageLiteral(resourceName: "question-answer-line"), for: .normal)
        button.contentEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        return button
    }()
    
    public let searchBar = CustomSearchBar()
    private var searchedConversations: [Conversation] = [] {
        didSet { tableView.reloadData() }
    }
    
    private var conversations: [Conversation] = []
    private let createChatController = CreateChatController()
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchConversations()
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        Dimension.safeAreatTopHeight = view.safeAreaInsets.top
        Dimension.safeAreatBottomHeight = view.safeAreaInsets.bottom
    }
    
    // MARK: - API
    
    func fetchConversations() {
        ChatService.fetchConversation { conversations in
            self.conversations = conversations
            self.tableView.reloadData()
            
            self.createChatController.dismiss(animated: true, completion: nil)
        }
    }
    
    // MARK: - Actions
    
    @objc func didTapCreateButton() {
        createChatController.defaultUI()
        buttonBackgroundView.hero.id = "moveToCreateChatView"
        moveToCreateChatViewButton.hero.id = "moveToCreateChatViewButton"
        
        
        createChatController.view.hero.id = "moveToCreateChatView"
        createChatController.backButton.hero.id = "moveToCreateChatViewButton"
        
        createChatController.completion = { didRegister in
            if didRegister { self.fetchConversations() }
        }
        
        let nav = UINavigationController(rootViewController: createChatController)
        nav.modalPresentationStyle = .fullScreen
        nav.isHeroEnabled = true
        
        present(nav, animated: true, completion: nil)
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        view.backgroundColor = UIColor.customColor(red: 240, green: 240, blue: 240)
        
        searchBar.delegate = self
        view.addSubview(searchBar)
        searchBar.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                              left: view.leftAnchor,
                              right: view.rightAnchor,
                              height: 50)
        
        view.addSubview(tableView)
        tableView.anchor(top: searchBar.bottomAnchor,
                         left: view.leftAnchor,
                         bottom: view.bottomAnchor,
                         right: view.rightAnchor,
                         paddingTop: 25)
        
        view.addSubview(buttonBackgroundView)
        buttonBackgroundView.anchor(bottom: view.bottomAnchor,
                                    right: view.rightAnchor,
                                    paddingBottom: -60,
                                    paddingRight: -60)
        buttonBackgroundView.setDimensions(height: 180, width: 180)
        
        buttonBackgroundView.addSubview(moveToCreateChatViewButton)
        moveToCreateChatViewButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor,
                                          right: view.rightAnchor,
                                          paddingBottom: -10,
                                          paddingRight: 25)
        moveToCreateChatViewButton.setDimensions(height: 60, width: 60)
        
        buttonBackgroundView.addSubview(moveToCreateChatViewPlus)
        moveToCreateChatViewPlus.anchor(top: moveToCreateChatViewButton.topAnchor,
                                        right: moveToCreateChatViewButton.rightAnchor,
                                        paddingTop: -10,
                                        paddingRight: -10)
        moveToCreateChatViewPlus.setDimensions(height: 30, width: 30)
    }
}

// MARK: - UITableViewDataSource

extension TopViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchedConversations.count == 0 ? conversations.count : searchedConversations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! TopCell
        cell.topCellView.delegate = self
        
        let conversations = searchedConversations.count == 0 ? conversations[indexPath.row] : searchedConversations[indexPath.row]
        cell.topCellView.viewModel = TopViewModel(conversation: conversations,
                                                  cellNumber: indexPath.row)
        return cell
    }
}

// MARK: - TopCellViewDelegate

extension TopViewController: TopCellViewDelegate {
    
    func didTapStartButton(cell: TopCellContents) {
        
        guard let viewModel = cell.viewModel else { return }
        guard let cell = tableView.cellForRow(at: IndexPath(row: viewModel.cellNumber, section: 0)) as? TopCell else { return }
        cell.topCellView.baseView.hero.id = "openChatView"
        
        let vc = ChatViewController(conversation: conversations[viewModel.cellNumber],
                                    colors: ChatViewColors(topColor: viewModel.cellColor,
                                                           mainColor: viewModel.chatViewColor),
                                    selectedCell: cell.topCellView)
        vc.topView.hero.id = "openChatView"
        vc.isHeroEnabled = true
        vc.modalPresentationStyle = .fullScreen
        
        present(vc, animated: true, completion: nil)
    }
}

// MARK: - CustomSearchBarDelegate

extension TopViewController: CustomSearchBarDelegate {
    func didCancel() {
        view.endEditing(true)
    }
    
    func didChangeText(text: String) {
        searchedConversations = []
        searchedConversations = conversations.filter { $0.title.contains(text) }
    }
}
