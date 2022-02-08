import UIKit
import Firebase

class Conversation {
    let audioUrls: [String]
    let caracterImageUrls: [String]
    let topCaracterImageUrls: [String]
    let dialogs: [String]
    let title: String
    let timeStamp: Timestamp
    var color: String
    
    init(dictionary: [String: Any]) {
        self.audioUrls = dictionary["audioUrls"] as? [String] ?? [""]
        self.caracterImageUrls = dictionary["caracterImageUrls"] as? [String] ?? [""]
        self.topCaracterImageUrls = dictionary["topCaracterImageUrls"] as? [String] ?? [""]
        self.dialogs = dictionary["dialogs"] as? [String] ?? [""]
        self.title = dictionary["title"] as? String ?? ""
        self.timeStamp = dictionary["timeStamp"] as? Timestamp ?? Timestamp()
        self.color = dictionary["color"] as? String ?? ""
    }
}
