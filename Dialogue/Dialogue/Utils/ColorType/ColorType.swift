import UIKit

enum CellColorType: String, CaseIterable {
    case pink = "pink"
    case yellow = "yellow"
    case green = "green"
    case blue = "blue"
    case orange = "orange"
    case purple = "purple"

    var cellColor: UIColor {
        switch self {
        case .purple:
            return .customColor(red: 112, green: 46, blue: 113)
        case .pink:
            return .customColor(red: 209, green: 45, blue: 67)
        case .orange:
            return .customColor(red: 214, green: 91, blue: 38)
        case .yellow:
            return .customColor(red: 242, green: 169, blue: 59)
        case .green:
            return .customColor(red: 87, green: 142, blue: 40)
        case .blue:
            return .customColor(red: 48, green: 112, blue: 181)
        }
    }
    
    var chatViewMainColor: UIColor {
        switch self {
        case .purple:
            return .customColor(red: 75, green: 30, blue: 75)
        case .pink:
            return .customColor(red: 160, green: 32, blue: 51)
        case .orange:
            return .customColor(red: 164, green: 69, blue: 27)
        case .yellow:
            return .customColor(red: 218, green: 152, blue: 52)
        case .green:
            return .customColor(red: 58, green: 95, blue: 24)
        case .blue:
            return .customColor(red: 36, green: 86, blue: 139)
        }
    }
}
