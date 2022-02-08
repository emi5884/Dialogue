import UIKit

class RegisterDialogueController: UIViewController {
    
    // MARK: - Properties
    
    private lazy var backButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        button.setImage(#imageLiteral(resourceName: "left-arrow"), for: .normal)
        button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        return button
    }()
    
    private lazy var registerButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(didTapRegisterButton), for: .touchUpInside)
        button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        button.layer.cornerRadius = 30
        button.backgroundColor = CellColorType.purple.chatViewMainColor.withAlphaComponent(0.6)
        
        let attributes: [NSAttributedString.Key: Any] = [.font: UIFont.senobiBold(size: 22), .foregroundColor: CellColorType.purple.chatViewMainColor]
        let attributeText = NSAttributedString(string: "登録", attributes: attributes)
        button.setAttributedTitle(attributeText, for: .normal)
        return button
    }()
    
    private let instructionLabel = UILabel.createLabel(size: 18)
    
    private var audioText: String = ""
    private var audioUrl: URL = URL(fileURLWithPath: "")
    
    private var recordingView: RecordingView?
    private let characterInfo: CharacterInfo?
    
    public var completion: (([Dialogue]) -> Void)?
    
    // MARK: - LifeCycle
    
    init(characterInfo: CharacterInfo) {
        self.recordingView = RecordingView(frame: .zero, color: .purple, characterInfo: characterInfo)
        self.characterInfo = characterInfo
        
        super.init(nibName: nil, bundle: nil)
        self.recordingView?.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
    // MARK: - API
    
    func uploadDialogue() {
        showLoader(true)
        
        guard let id = characterInfo?.id else { return }
        guard let imageUrl = characterInfo?.imageUrl.absoluteString else { return }
        guard let characterName = characterInfo?.name else { return }
        
        let dialogueItem = DialogueItem(id: id, imageUrl: imageUrl, audio: audioUrl, text: audioText, character: characterName)
        
        DialogueService.uploadDialogue(dialogue: dialogueItem) { dialogues in
            self.completion?(dialogues)
            self.showLoader(false)
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
    
    // MARK: - Actions
    
    @objc func didTapBackButton() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func didTapRegisterButton() {
        uploadDialogue()
    }
    
    // MARK: - Helper
    
    func configureUI() {
        view.backgroundColor = CellColorType.purple.cellColor
        
        view.addSubview(backButton)
        backButton.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                          left: view.leftAnchor,
                          paddingLeft: 10)
        backButton.setDimensions(height: 60, width: 60)
        
        guard let recordingView = recordingView else { return }
        view.addSubview(recordingView)
        recordingView.setDimensions(height: 260, width: view.frame.width - 40)
        recordingView.centerX(inView: view)
        recordingView.centerY(inView: view)
        
        view.addSubview(instructionLabel)
        instructionLabel.text = "音声を録音してください"
        instructionLabel.anchor(bottom: recordingView.topAnchor, paddingBottom: 50)
        instructionLabel.centerX(inView: view)
        
        view.addSubview(registerButton)
        registerButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor,
                              paddingBottom: 30)
        registerButton.setDimensions(height: 60, width: 150)
        registerButton.centerX(inView: view)
    }
}

// MARK: - RecordingViewDelegate

extension RegisterDialogueController: RecordingViewDelegate {
    
    func audioInfo(audioInfo: AudioInfo) {
        audioText = audioInfo.text
        audioUrl = audioInfo.audio
        
        if audioInfo.text.count == 0 {
            registerButton.backgroundColor = CellColorType.purple.chatViewMainColor.withAlphaComponent(0.6)
        } else {
            registerButton.backgroundColor = CellColorType.yellow.cellColor
        }
    }
}
