import UIKit

class BubbleTail: UIView {
    
    // MARK: - Properties
    
    private let color: UIColor
    
    // MARK: - LifeCycle
    
    init(frame: CGRect, color: UIColor) {
        self.color = color
        
        super.init(frame: frame)
        backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let startPoint = CGPoint(x: frame.width, y: 0)
        let tailPoint = CGPoint(x: 0, y: frame.height / 3)
        let endPoint = CGPoint(x: frame.width, y: frame.height)
        
        let path = UIBezierPath()
        path.move(to: startPoint)
        
        path.addCurve(to: tailPoint,
                      controlPoint1: CGPoint(x: frame.width / 3 * 2, y: frame.height / 6),
                      controlPoint2: CGPoint(x: frame.width / 3, y: frame.height / 6 * 2))
        
        path.addCurve(to: endPoint,
                      controlPoint1: CGPoint(x: frame.width / 3, y: frame.height),
                      controlPoint2: CGPoint(x: frame.width / 3 * 2, y: frame.height))
        
        path.addLine(to: startPoint)
        path.close()
        
        color.setFill()
        path.fill()
    }
}
