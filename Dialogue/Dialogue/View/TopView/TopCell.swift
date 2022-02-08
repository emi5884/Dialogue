import UIKit

class TopCell: UITableViewCell {
    
    // MARK: - Properties
    public lazy var topCellView = TopCellContents()
    
    // MARK: - LifeCycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = UIColor.customColor(red: 240, green: 240, blue: 240)
        contentView.addSubview(topCellView)
        topCellView.fillSuperview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
