import UIKit
import AudioToolbox

private let buttonLength: CGFloat = 72
private let ringLineWidth: CGFloat = 6
private let circleLength: CGFloat = 54
private let rectLength: CGFloat = 30
private let rectCornerRadius: CGFloat = 4
private let position = CGPoint(x: buttonLength / 2, y: buttonLength / 2)

@IBDesignable
public class ShutterButton: UIControl {
    
    var isRecording: Bool = false {
        didSet {
            self.sendActions(for: .valueChanged)
            
            if isRecording {
                recordingDidBegin()
            } else {
                recordingDidEnd()
            }
        }
    }
    
    private let ringLayer = CAShapeLayer()
    private let innerLayer = CAShapeLayer()
    
    private let feedbackGenerator = UISelectionFeedbackGenerator()
    
    public override var intrinsicContentSize: CGSize {
        return CGSize(width: buttonLength, height: buttonLength)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        self.layer.insertSublayer(ringLayer, at: 0)
        self.layer.insertSublayer(innerLayer, at: 1)
        
        setupRingLayer()
        setupInnerLayer()
        
        setupActions()
        setupCHCRPriorities()
    }
    
    private func setupRingLayer() {
        let length = buttonLength - ringLineWidth
        let size = CGSize(width: length, height: length)
        
        ringLayer.bounds.size = size
        ringLayer.position = position
        
        ringLayer.path = UIBezierPath(ovalIn: CGRect(origin: .zero, size: size)).cgPath
        ringLayer.strokeColor = UIColor.white.cgColor
        ringLayer.lineWidth = ringLineWidth
        ringLayer.fillColor = nil
    }
    
    private func setupInnerLayer() {
        innerLayer.position = position
        innerLayer.backgroundColor = UIColor(hex: 0xFF3333).cgColor
        
        transformInnerLayerToCircle()
    }
    
    private func setupActions() {
        self.addTarget(self, action: #selector(toggleRecordingState), for: .touchDown)
        self.addTarget(self, action: #selector(addPressedEffect), for: .touchDown)
        self.addTarget(self, action: #selector(removePressedEffect), for: [.touchUpInside, .touchUpOutside])
        self.addTarget(self, action: #selector(triggerFeedback), for: [.touchDown, .touchUpInside, .touchUpOutside, .touchDragEnter, .touchDragExit])
    }
    
    private func setupCHCRPriorities() {
        self.setContentHuggingPriority(.required, for: .horizontal)
        self.setContentHuggingPriority(.required, for: .vertical)
        self.setContentCompressionResistancePriority(.required, for: .horizontal)
        self.setContentCompressionResistancePriority(.required, for: .vertical)
    }
    
    private func recordingDidBegin() {
        transformInnerLayerToRect()
        playBeginVideoRecordSound()
    }
    
    private func recordingDidEnd() {
        transformInnerLayerToCircle()
        playEndVideoRecordSound()
    }
    
    private func transformInnerLayerToCircle() {
        innerLayer.bounds.size = CGSize(width: circleLength, height: circleLength)
        innerLayer.cornerRadius = circleLength / 2
    }
    
    private func transformInnerLayerToRect() {
        innerLayer.bounds.size = CGSize(width: rectLength, height: rectLength)
        innerLayer.cornerRadius = 4
    }
    
    private func playBeginVideoRecordSound() {
        let beginVideoRecordSoundID: SystemSoundID = 1117
        AudioServicesPlaySystemSound(beginVideoRecordSoundID)
    }
    
    private func playEndVideoRecordSound() {
        let endVideoRecordSoundID: SystemSoundID = 1118
        AudioServicesPlaySystemSound(endVideoRecordSoundID)
    }
    
    @objc private func toggleRecordingState() {
        CATransaction.begin()
        self.isRecording.toggle()
        CATransaction.commit()
    }
    
    @objc private func addPressedEffect() {
        CATransaction.begin()
        innerLayer.transform = CATransform3DMakeScale(0.9, 0.9, 1)
        CATransaction.commit()
    }
    @objc private func removePressedEffect() {
        CATransaction.begin()
        innerLayer.transform = CATransform3DIdentity
        CATransaction.commit()
    }
    
    @objc private func triggerFeedback() {
        feedbackGenerator.selectionChanged()
    }
}
