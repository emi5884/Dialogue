import UIKit
import AVFoundation

class ChatViewController: UIViewController {
    
    // MARK: - Properties
    
    private lazy var closebutton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "down-arrow"), for: .normal)
        button.contentEdgeInsets = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        button.addTarget(self, action: #selector(didTapCloseButton), for: .touchUpInside)
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .senobiBold(size: 30)
        label.textColor = .white
        return label
    }()
    
    public lazy var topView: TopCellContents = {
        let view = TopCellContents()
        view.baseView.layer.shadowOpacity = 0
        view.startButton.setImage(#imageLiteral(resourceName: "square"), for: .normal)
        view.startButton.contentEdgeInsets = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        view.backgroundColor = .clear
        view.delegate = self
        return view
    }()
    
    public let chatView = ChatView()
    public let selectedCell: TopCellContents?
    
    public var audio: AVAudioPlayer?
    public var audioUrls: [URL]
    public var playNum = 0
    
    public var isPlaying = false
    
    // MARK: - LifeCycel
    
    init(conversation: Conversation, colors: ChatViewColors, selectedCell: TopCellContents) {
        self.selectedCell = selectedCell
        audioUrls = conversation.audioUrls.map { URL(string: $0)! }
        
        chatView.collectionView.backgroundColor = colors.mainColor
        chatView.chat = Chat(conversation: conversation,
                             color: colors)
        
        super.init(nibName: nil, bundle: nil)
        
        view.backgroundColor = colors.topColor
        
        titleLabel.text = conversation.title
        topView.viewModel = TopViewModel(conversation: conversation,
                                         cellNumber: 0)
        
        
        Timer.scheduledTimer(withTimeInterval: 0.25, repeats: false) { _ in
            if self.prepareAudio(num: self.playNum) {
                self.startPulseAnimation()
                self.audio?.play()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    // MARK: - Actions
    
    @objc func didTapCloseButton() {
        audio?.stop()
        dismiss(animated: true) {
            self.selectedCell?.baseView.hero.id = ""
        }
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        
        view.addSubview(topView)
        topView.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                       left: view.leftAnchor,
                       right: view.rightAnchor,
                       height: 170)
        
        topView.addSubview(titleLabel)
        titleLabel.anchor(top: topView.topAnchor,
                          left: topView.leftAnchor,
                          right: topView.rightAnchor,
                          paddingLeft: 20,
                          height: 50)
        
        view.addSubview(chatView)
        chatView.anchor(top: topView.bottomAnchor,
                        left: view.leftAnchor,
                        bottom: view.bottomAnchor,
                        right: view.rightAnchor)
        
        view.addSubview(closebutton)
        closebutton.anchor(top: view.topAnchor,
                           right: topView.rightAnchor,
                           paddingTop: 20,
                           paddingRight: 20)
        closebutton.setDimensions(height: 60, width: 60)
    }
    
    func startPulseAnimation() {
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.toValue = 1.5
        animation.duration = 0.5
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        animation.autoreverses = true
        animation.repeatCount = Float.infinity
        
        guard let cell = chatView.collectionView.cellForItem(at: IndexPath(item: playNum, section: 0)) as? ChatViewCell else { return }
        cell.pulseAnimationLayer.add(animation, forKey: "pulsing")
        cell.pulseAnimationLayer.isHidden = false
    }
    
    func stopPulseAnimation() {
        guard let cell = chatView.collectionView.cellForItem(at: IndexPath(item: playNum, section: 0)) as? ChatViewCell else { return }
        cell.pulseAnimationLayer.removeAllAnimations()
        cell.pulseAnimationLayer.isHidden = true
    }
}
