import UIKit

struct ChatViewModel {
    let chat: Chat
    let cellNumber: Int
    
    var imageUrl: URL? {
        return URL(string: chat.conversation.caracterImageUrls[cellNumber])
    }
    
    var dialogue: String {
        return chat.conversation.dialogs[cellNumber]
    }
    
    var textColor: UIColor {
        return chat.color
    }

    init(chat: Chat, cellNumber: Int) {
        self.chat = chat
        self.cellNumber = cellNumber
    }
}
