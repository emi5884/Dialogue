import UIKit
import AVFoundation
import Speech
import SDWebImage

struct AudioInfo {
    let text: String
    let audio: URL
}

struct CharacterInfo {
    let id: String
    let imageUrl: URL
    let name: String
}

protocol RecordingViewDelegate {
    func audioInfo(audioInfo: AudioInfo)
}

class RecordingView: UIView, AVAudioRecorderDelegate, SFSpeechRecognizerDelegate {
    
    // MARK: - Properties
    
    public var delegate: RecordingViewDelegate?
    
    private var recorderSession: AVAudioSession?
    private var audioRecorder: AVAudioRecorder?
    private var audioPlayer: AVAudioPlayer?
    
    private var audioEngine = AVAudioEngine()
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "ja-JP"))!
    private var recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
    private var task: SFSpeechRecognitionTask?
    
    public var numberOfRecords: Int = 0
    
    public lazy var iconImageView: UIImageView = {
        let iv = UIImageView()
        iv.layer.cornerRadius = 30
        iv.clipsToBounds = true
        
        if let imageUrl = characterInfo?.imageUrl {
            iv.sd_setImage(with: imageUrl, completed: nil)
        }
        
        return iv
    }()
    
    public lazy var userNameLabel = UILabel.createLabel(size: 12, text: characterInfo?.name)
    
    private lazy var dialogueTextView: UITextView = {
        let tv = UITextView()
        tv.backgroundColor = color.chatViewMainColor
        tv.layer.cornerRadius = 10
        tv.font = .senobiBold(size: 14)
        tv.textColor = .white
        tv.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        tv.tintColor = .lightGray
        tv.delegate = self
        return tv
    }()
    
    private lazy var bubbleTail = BubbleTail(frame: .zero, color: color.chatViewMainColor)
    
    private let recordButton = UIButton.createButton(target: self, action: #selector(didTapRecordButton))
    private let startButton = UIButton.createStartButton(target: self, action: #selector(didTapStartButton))
    private let pulseAnimationLayer = CAShapeLayer.createPulseAnimationForRegister()
    
    private var isStart = false
    
    private var color: CellColorType
    private var characterInfo: CharacterInfo?
    
    // MARK: - LifeCycle
    
    init(frame: CGRect, color: CellColorType, characterInfo: CharacterInfo? = nil) {
        if let characterInfo = characterInfo { self.characterInfo = characterInfo }
        self.color = color
        
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
    
    @objc func didTapRecordButton() {
        isStart.toggle()
        
        if isStart {
            startSpeech()
            startRecording()
            startPulseAnimation()
            
        } else {
            stopSpeech()
            stopRecording()
            stopPulseAnimation()
            
            guard let text = dialogueTextView.text else { return }
            delegate?.audioInfo(audioInfo: AudioInfo(text: text, audio: getDirectory(filename: "test")))
        }
    }
    
    @objc func didTapStartButton() {
        let fileName = getDirectory(filename: "test")
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: fileName)
            audioPlayer?.volume = 20
            audioPlayer?.play()
        } catch {
            print("audioPlayer Error")
        }
    }
    
    // MARK: - Helper
    
    func configureUI() {
        layer.addSublayer(pulseAnimationLayer)
        pulseAnimationLayer.position = CGPoint(x: frame.width / 2,
                                               y: frame.height - 30)
        
        addSubview(dialogueTextView)
        dialogueTextView.anchor(top: topAnchor,
                                right: rightAnchor)
        dialogueTextView.setDimensions(height: 150,
                                       width: frame.width - 80)
        
        addSubview(bubbleTail)
        bubbleTail.anchor(right: dialogueTextView.leftAnchor)
        bubbleTail.setDimensions(height: 10, width: 15)
        bubbleTail.centerY(inView: dialogueTextView)
        
        addSubview(startButton)
        startButton.anchor(bottom: dialogueTextView.bottomAnchor,
                           right: dialogueTextView.rightAnchor)
        startButton.setDimensions(height: 60, width: 60)
        startButton.isHidden = true
        
        addSubview(iconImageView)
        iconImageView.setDimensions(height: 60, width: 60)
        iconImageView.anchor(left: leftAnchor)
        iconImageView.centerY(inView: dialogueTextView)
        
        addSubview(userNameLabel)
        userNameLabel.anchor(top: iconImageView.bottomAnchor,
                             paddingTop: 10)
        userNameLabel.centerX(inView: iconImageView)
        
        addSubview(recordButton)
        recordButton.anchor(top: dialogueTextView.bottomAnchor,
                            paddingTop: 50)
        recordButton.centerX(inView: self)
        recordButton.setDimensions(height: 60, width: 60)
    }
    
    func startPulseAnimation() {
        recordButton.backgroundColor = CellColorType.pink.cellColor
        
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.toValue = 1.1
        animation.duration = 0.8
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        animation.autoreverses = true
        animation.repeatCount = Float.infinity
        
        pulseAnimationLayer.add(animation, forKey: "pulsing")
    }
    
    func stopPulseAnimation() {
        recordButton.backgroundColor = CellColorType.pink.chatViewMainColor
        pulseAnimationLayer.removeAllAnimations()
        startButton.isHidden = false
    }
    
    func getDirectory(filename: String) -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = paths[0]
        let fileName = documentDirectory.appendingPathComponent("\(filename).m4a")
        return fileName
    }
    
    func startSpeech() {
        speechRecognizer.delegate = self
        
        let node = audioEngine.inputNode
        let recordingFormat = node.outputFormat(forBus: 0)
        
        node.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
            self.recognitionRequest.append(buffer)
        }
        
        audioEngine.prepare()
        
        do {
            try audioEngine.start()
        } catch {
            print("audio engine error")
        }
        
        guard let myRecognition = SFSpeechRecognizer() else { return }
        
        if !myRecognition.isAvailable {
            print("not available")
        }
        
        task = speechRecognizer.recognitionTask(with: recognitionRequest, resultHandler: { response, _ in
            guard let response = response else { return }
            let dialogue = response.bestTranscription.formattedString
            self.dialogueTextView.text = dialogue
            
            guard let text = self.dialogueTextView.text else { return }
            self.delegate?.audioInfo(audioInfo: AudioInfo(text: text, audio: self.getDirectory(filename: "test")))
        })
    }
    
    func startRecording() {
        let fileName = getDirectory(filename: "test")
        
        let settings = [AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                        AVSampleRateKey: 12000,
                        AVNumberOfChannelsKey: 1,
                        AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue]
        do {
            audioRecorder = try AVAudioRecorder(url: fileName, settings: settings)
            audioRecorder?.delegate = self
            
            audioRecorder?.record()
            audioRecorder?.record()
            
        } catch {
            print("audioRecorder Error")
        }
    }
    
    func stopRecording() {
        audioRecorder?.stop()
        audioRecorder = nil
        recordButton.backgroundColor = .systemPink
    }
    
    func stopSpeech() {
        task?.finish()
        task?.cancel()
        task = nil
        
        recognitionRequest.endAudio()
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
    }
    
    func requestAuthorization() {
        SFSpeechRecognizer.requestAuthorization { authStatus in
            OperationQueue.main.addOperation {
                
                switch authStatus {
                    case .authorized:
                        print("authorized")
                        
                    case .denied:
                        print("authorized")
                        
                    case .restricted:
                        self.recordButton.isEnabled = false
                        self.recordButton.setTitle("Speech recognition restricted on this device", for: .disabled)

                    case .notDetermined:
                        self.recordButton.isEnabled = false
                        self.recordButton.setTitle("Speech recognition not yet authorized", for: .disabled)
                default:
                    break
                }
            }
        }
    }
}

// MARK: - UITextViewDelegate

extension RecordingView: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        guard let text = textView.text else { return }
        delegate?.audioInfo(audioInfo: AudioInfo(text: text, audio: getDirectory(filename: "test")))
    }
}
