import UIKit

class RegisterViewController: UIViewController {
    
    // MARK: - Properties
    
    private lazy var backButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        button.setImage(#imageLiteral(resourceName: "left-arrow"), for: .normal)
        button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        return button
    }()
    
    private var pageControl: UIPageControl = {
        let page = UIPageControl()
        page.currentPage = 0
        page.numberOfPages = 3
        page.pageIndicatorTintColor = .white.withAlphaComponent(0.9)
        page.currentPageIndicatorTintColor = CellColorType.yellow.cellColor
        return page
    }()
    
    private let identifier = "identifier"
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.delegate = self
        cv.dataSource = self
        cv.register(RegisterCell.self, forCellWithReuseIdentifier: identifier)
        cv.isPagingEnabled = true
        cv.backgroundColor = CellColorType.purple.cellColor
        cv.showsHorizontalScrollIndicator = false
        return cv
    }()
    
    private lazy var previousButton = createBottomButton(action: #selector(didTapPrevButton), title: "prev")
    private lazy var nextButton = createBottomButton(action: #selector(didTapNextButton), title: "next")
    
    private var selectedImage = UIImage()
    private var nameText: String = ""
    private var audioText: String = ""
    private var audioUrl: URL = URL(fileURLWithPath: "")
    
    public var completion: ((NewInfo) -> Void)?
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    // MARK: - API
    
    func uploadDialogue() {
        showLoader(true)
        
        let characterItem = CharacterItem(image: selectedImage, audio: audioUrl, text: audioText, name: nameText)
        CharacterService.uploadCharacter(character: characterItem) { newInfo in
            self.completion?(newInfo)
            self.showLoader(false)
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
    
    // MARK: - Actions
    
    @objc func didTapBackButton() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func didTapPrevButton() {
        let pageNumber = max(pageControl.currentPage - 1, 0)
        pageControl.currentPage = pageNumber
        
        collectionView.isPagingEnabled = false
        collectionView.scrollToItem(at: IndexPath(item: pageNumber, section: 0), at: .centeredHorizontally, animated: true)
        collectionView.isPagingEnabled = true
        
        nextButton.backgroundColor = .clear
        nextButton.setTitle("next", for: .normal)
        
        let titleColor: UIColor = pageNumber == 0 ? .clear : .white
        previousButton.setTitleColor(titleColor, for: .normal)
    }
    
    @objc func didTapNextButton() {
        previousButton.setTitleColor(.white, for: .normal)
        
        if pageControl.currentPage == 2 {
            uploadDialogue()
            
        } else {
            let pageNumber = min(pageControl.currentPage + 1, 2)
            pageControl.currentPage = pageNumber
            
            collectionView.isPagingEnabled = false
            collectionView.scrollToItem(at: IndexPath(item: pageNumber, section: 0), at: .centeredHorizontally, animated: true)
            collectionView.isPagingEnabled = true
            
            let buttonTitle = pageNumber == 2 ? "登録" : "next"
            let buttonBackgroundColor = pageNumber == 2 ? CellColorType.yellow.cellColor : .clear
            let nextButtonTitleColor: UIColor = pageControl.currentPage == 2 ? CellColorType.purple.chatViewMainColor : .white
            nextButton.setTitle(buttonTitle, for: .normal)
            nextButton.setTitleColor(nextButtonTitleColor, for: .normal)
            nextButton.backgroundColor = buttonBackgroundColor
            
            Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false) { _ in
                self.setupNaxtPageUI(pageNumber)
            }
        }
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        view.backgroundColor = CellColorType.purple.cellColor
        
        let stackView = UIStackView(arrangedSubviews: [previousButton, pageControl, nextButton])
        stackView.distribution = .fillEqually
        
        view.addSubview(stackView)
        stackView.anchor(left: view.leftAnchor,
                         bottom: view.safeAreaLayoutGuide.bottomAnchor,
                         right: view.rightAnchor,
                         paddingLeft: 10,
                         paddingBottom: 10,
                         paddingRight: 10,
                         height: 60)
        
        view.addSubview(collectionView)
        collectionView.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                              left: view.leftAnchor,
                              bottom: stackView.topAnchor,
                              right: view.rightAnchor)
        
        view.addSubview(backButton)
        backButton.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                          left: view.leftAnchor,
                          paddingLeft: 10)
        backButton.setDimensions(height: 60, width: 60)
    }
    
    func setupNaxtPageUI(_ pageNumber: Int) {
        guard let imageCell = collectionView.cellForItem(at: IndexPath(item: pageNumber, section: 0)) as? RegisterCell else { return }
        guard let recordCell = collectionView.cellForItem(at: IndexPath(item: pageNumber, section: 0)) as? RegisterCell else { return }
        let onImageCell = pageNumber == 1
        let onRecordCell = pageNumber == 2
        
        if onImageCell {
            imageCell.nameLabel.text = self.nameText
            
        } else if onRecordCell {
            recordCell.recordingView.iconImageView.image = self.selectedImage
            recordCell.recordingView.userNameLabel.text = self.nameText
        }
    }

    func createBottomButton(action: Selector, title: String) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = .senobiBold(size: 18)
        button.backgroundColor = .clear
        button.layer.cornerRadius = 30
        button.addTarget(target, action: action, for: .touchUpInside)
        
        let titleColor: UIColor = title == "prev" ? .clear : .white
        button.setTitleColor(titleColor, for: .normal)
        return button
    }
}

// MARK: - UICollectionViewDataSource

extension RegisterViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! RegisterCell
        cell.viewModel = RegisterViewModel(pageNumber: indexPath.row)
        cell.delegate = self
        cell.recordingView.delegate = self
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension RegisterViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height)
    }
}

// MARK: - UIScrollViewDelegate

extension RegisterViewController: UIScrollViewDelegate {
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        let offset = targetContentOffset.pointee.x
        pageControl.currentPage = Int(offset / view.frame.width)
        
        let nextButtonTitle = pageControl.currentPage == 2 ? "登録" : "next"
        let nextButtonTitleColor: UIColor = pageControl.currentPage == 2 ? CellColorType.purple.chatViewMainColor : .white
        nextButton.setTitle(nextButtonTitle, for: .normal)
        nextButton.setTitleColor(nextButtonTitleColor, for: .normal)
        nextButton.backgroundColor = pageControl.currentPage == 2 ? CellColorType.yellow.chatViewMainColor : .clear
        
        let prevButtonColor: UIColor = pageControl.currentPage == 0 ? .clear : .white
        previousButton.setTitleColor(prevButtonColor, for: .normal)
        
        let page = Int(offset / view.frame.width)
        setupNaxtPageUI(page)
    }
}

// MARK: - RegisterCellDelegate

extension RegisterViewController: RegisterCellDelegate {
    
    func didChangeText(text: String) {
        nameText = text
    }
    
    func didTapCharactorButton() {
        showLoader(true)
        
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        
        present(picker, animated: true) {
            self.showLoader(false)
        }
    }
}

// MARK: - RecordingViewDelegate

extension RegisterViewController: RecordingViewDelegate {
    
    func audioInfo(audioInfo: AudioInfo) {
        audioText = audioInfo.text
        audioUrl = audioInfo.audio
    }
}

// MARK: - UIImagePickerController

extension RegisterViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        selectedImage = image
        
        guard let cell = collectionView.cellForItem(at: IndexPath(item: 1, section: 0)) as? RegisterCell else { return }
        cell.charactorImage.setImage(image, for: .normal)
        
        dismiss(animated: true, completion: nil)
    }
}
