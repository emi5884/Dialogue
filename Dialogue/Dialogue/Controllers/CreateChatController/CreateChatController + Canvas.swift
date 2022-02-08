import UIKit

class TriangleView: UIView {
    
    // MARK: - Properties
    
    private let triangleColor: UIColor
    
    // MARK: - LifeCycle
    
    init(frame: CGRect, triangleColor: UIColor, backGroundColor: UIColor) {
        self.triangleColor = triangleColor
        
        super.init(frame: frame)
        backgroundColor = backGroundColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        let triangle = UIBezierPath()
        triangle.move(to: CGPoint(x: frame.width, y: 0))
        triangle.addLine(to: CGPoint(x: frame.width / 2, y: frame.height))
        triangle.addLine(to: CGPoint(x: 0, y: 0))
        triangle.close()
        
        triangleColor.setFill()
        triangle.fill()
    }
}

extension CreateChatController {
    
    func createTriangle() {
        let safeAreaTopHeight = Dimension.safeAreatTopHeight
        let safeareaBottomHeight = Dimension.safeAreatBottomHeight
        
        let characterListHeight: CGFloat = 110
        let registerAreaHeight: CGFloat = 100
        let bottomChatHeight: CGFloat = 130
        let triangleHeight: CGFloat = 50
        
        let charaacterListTriangleY: CGFloat = safeAreaTopHeight + characterListHeight
        let bottomChatTriangleY: CGFloat = view.frame.height - (safeareaBottomHeight + registerAreaHeight + triangleHeight)
        let tableViewTriangleY: CGFloat = bottomChatTriangleY - bottomChatHeight - triangleHeight
        
        let charaacterListTriangle = TriangleView(frame: .zero,
                                                triangleColor: CellColorType.pink.cellColor,
                                                backGroundColor: .clear)
        view.addSubview(charaacterListTriangle)
        charaacterListTriangle.frame = CGRect(x: 0,
                                              y: charaacterListTriangleY,
                                              width: view.frame.width,
                                              height: triangleHeight)
        
        let bottomChatTriangle = TriangleView(frame: .zero,
                                              triangleColor: CellColorType.green.cellColor,
                                              backGroundColor: CellColorType.blue.cellColor)
        view.addSubview(bottomChatTriangle)
        bottomChatTriangle.frame = CGRect(x: 0,
                                          y: bottomChatTriangleY,
                                          width: view.frame.width,
                                          height: triangleHeight)
        
        let tableViewTriangle = TriangleView(frame: .zero,
                                           triangleColor: CellColorType.yellow.cellColor,
                                           backGroundColor: CellColorType.green.cellColor)
        view.addSubview(tableViewTriangle)
        tableViewTriangle.frame = CGRect(x: 0,
                                         y: tableViewTriangleY,
                                         width: view.frame.width,
                                         height: triangleHeight)
    }
}
