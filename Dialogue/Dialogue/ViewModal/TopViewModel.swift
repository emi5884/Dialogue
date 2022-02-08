import UIKit

struct TopViewModel {
    let conversation: Conversation
    let cellNumber: Int
    
    var titile: String {
        return conversation.title
    }
    
    var cellColor: UIColor {
        return returnCellColor()
    }
    
    var chatViewColor: UIColor {
        return returnChatViewColor()
    }
    
    var titileTextColor: UIColor {
        return .white
    }
    
    init(conversation: Conversation, cellNumber: Int) {
        self.conversation = conversation
        self.cellNumber = cellNumber
    }
    
    func returnCellColor() -> UIColor {
        
        switch conversation.color {
        case "pink", nil:
            return CellColorType.pink.cellColor
        case "yellow":
            return CellColorType.yellow.cellColor
        case "green":
            return CellColorType.green.cellColor
        case "blue":
            return CellColorType.blue.cellColor
        case "orange":
            return CellColorType.orange.cellColor
        case "purple":
            return CellColorType.purple.cellColor
        default:
            break
        }
        
        return CellColorType.pink.cellColor
    }
    
    func returnChatViewColor() -> UIColor {
        
        switch conversation.color {
        case "pink", nil:
            return CellColorType.pink.chatViewMainColor
        case "yellow":
            return CellColorType.yellow.chatViewMainColor
        case "green":
            return CellColorType.green.chatViewMainColor
        case "blue":
            return CellColorType.blue.chatViewMainColor
        case "orange":
            return CellColorType.orange.chatViewMainColor
        case "purple":
            return CellColorType.purple.chatViewMainColor
        default:
            break
        }
        
        return CellColorType.pink.chatViewMainColor
    }
}
