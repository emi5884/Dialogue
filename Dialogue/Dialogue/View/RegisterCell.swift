import UIKit

protocol RegisterCellDelegate {
    func didTapCharactorButton()
    func didChangeText(text: String)
}

class RegisterCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    public var delegate: RegisterCellDelegate?
    
    public var viewModel: RegisterViewModel? {
        didSet { configureViewModel() }
    }
    
    private let instructionLabel = UILabel.createLabel(size: 18)
    
    public lazy var nameTextField: CustomTextField = {
        let tf = CustomTextField()
        tf.addTarget(self, action: #selector(didChangeText), for: .editingChanged)
        tf.layer.cornerRadius = 25
        tf.backgroundColor = CellColorType.purple.chatViewMainColor
        return tf
    }()
    
    public lazy var charactorImage: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 60
        button.addTarget(self, action: #selector(didTapCharactorButton), for: .touchUpInside)
        button.setImage(#imageLiteral(resourceName: "user-circle-solid-240 (1)"), for: .normal)
        button.clipsToBounds = true
        return button
    }()
    
    public let nameLabel = UILabel.createLabel(size: 14, text: "なまえ")
    public var recordingView = RecordingView(frame: .zero, color: .purple, characterInfo: nil)
    
    // MARK: - LifeCycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(instructionLabel)
        
        addSubview(nameTextField)
        nameTextField.setDimensions(height: 50, width: frame.width - 50)
        nameTextField.centerX(inView: self)
        nameTextField.centerY(inView: self)
        
        addSubview(charactorImage)
        charactorImage.setDimensions(height: 120, width: 120)
        charactorImage.centerX(inView: self)
        charactorImage.centerY(inView: self)
        
        addSubview(nameLabel)
        nameLabel.anchor(top: charactorImage.bottomAnchor, paddingTop: 20)
        nameLabel.setDimensions(height: 20, width: 200)
        nameLabel.centerX(inView: charactorImage)
        
        addSubview(recordingView)
        recordingView.setDimensions(height: 260, width: frame.width - 40)
        recordingView.centerY(inView: self)
        recordingView.centerX(inView: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        endEditing(true)
    }
    
    // MARK: - Actions
    
    @objc func didTapCharactorButton() {
        delegate?.didTapCharactorButton()
    }
    
    @objc func didChangeText() {
        guard let text = nameTextField.text else { return }
        delegate?.didChangeText(text: text)
    }
    
    // MARK: - Helpers
    
    func configureViewModel() {
        guard let viewModel = viewModel else { return }
        
        nameTextField.isHidden = viewModel.shouldHideName
        charactorImage.isHidden = viewModel.shouldHideImage
        nameLabel.isHidden = viewModel.shouldHideNameLabel
        recordingView.isHidden = viewModel.shouldHideAudio
        instructionLabel.text = viewModel.instructionText
        
        switch viewModel.pageNumber {
        case 0:
            instructionLabel.anchor(left: leftAnchor,
                                    bottom: nameTextField.topAnchor,
                                    right: rightAnchor,
                                    paddingBottom: 20,
                                    height: 50)
        case 1:
            instructionLabel.anchor(left: leftAnchor,
                                    bottom: charactorImage.topAnchor,
                                    right: rightAnchor,
                                    paddingBottom: 20,
                                    height: 50)
        case 2:
            instructionLabel.anchor(left: leftAnchor,
                                    bottom: recordingView.topAnchor,
                                    right: rightAnchor,
                                    paddingBottom: 20,
                                    height: 50)
        default:
            break
        }
        
    }
}
