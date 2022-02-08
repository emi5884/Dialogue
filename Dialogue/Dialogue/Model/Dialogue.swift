import UIKit
import Firebase

struct Dialogue {
    let dialogue: String
    let audioUrl: String
    let timeStamp: Timestamp
    let dialogueID: String
    let character: String
    let imageUrl: String
    let characterID: String
    
    init(dictionary: [String: Any]) {
        self.dialogue = dictionary["dialogue"] as? String ?? ""
        self.audioUrl = dictionary["audioUrl"] as? String ?? ""
        self.timeStamp = dictionary["timeStamp"] as? Timestamp ?? Timestamp()
        self.dialogueID = dictionary["dialogueID"] as? String ?? ""
        self.character = dictionary["character"] as? String ?? ""
        self.imageUrl = dictionary["imageUrl"] as? String ?? ""
        self.characterID = dictionary["characterID"] as? String ?? ""
    }
}
