import UIKit
import Firebase

struct Character {
    let character: String
    let imageUrl: String
    let timeStamp: Timestamp
    let characterID: String
    
    init(dictionary: [String: Any]) {
        self.character = dictionary["character"] as? String ?? ""
        self.imageUrl = dictionary["imageUrl"] as? String ?? ""
        self.timeStamp = dictionary["timeStamp"] as? Timestamp ?? Timestamp()
        self.characterID = dictionary["characterID"] as? String ?? ""
    }
}
