import Firebase

struct ConversationInfo {
    let conversations: [String]
    let members: [String]
    let dialogues: [String]
    let title: String
}

struct ChatService {
    
    static func uploadConversation(info: ConversationInfo, completion: @escaping((Error?) -> Void)) {
        
        var topMembers: [String] = []
        info.members.forEach { member in
            if !topMembers.contains(member) { topMembers.append(member) }
        }
        
        let data: [String: Any] = ["audioUrls": info.conversations,
                                   "caracterImageUrls": info.members,
                                   "topCaracterImageUrls": topMembers,
                                   "dialogs": info.dialogues,
                                   "title": info.title,
                                   "timeStamp": Timestamp(),
                                   "color": returnCellColor()]
        
        COLLECTION_CONVERSATIONS.addDocument(data: data, completion: completion)
    }
    
    static func fetchConversation(completion: @escaping(( [Conversation] ) -> Void)) {
        
        COLLECTION_CONVERSATIONS.order(by: "timeStamp", descending: true)
            .getDocuments { snapshot, _ in
                
            guard let documents = snapshot?.documents else { return }
            let conversations = documents.map { Conversation(dictionary: $0.data() )}
            completion(conversations)
        }
    }
    
    static func returnCellColor() -> String {
        let colorNumber = UserDefaults.standard.integer(forKey: "color")
        
        switch colorNumber {
        case 0, nil:
            UserDefaults.standard.set(1, forKey: "color")
            return CellColorType.purple.rawValue
        case 1:
            UserDefaults.standard.set(2, forKey: "color")
            return CellColorType.blue.rawValue
        case 2:
            UserDefaults.standard.set(3, forKey: "color")
            return CellColorType.green.rawValue
        case 3:
            UserDefaults.standard.set(4, forKey: "color")
            return CellColorType.yellow.rawValue
        case 4:
            UserDefaults.standard.set(5, forKey: "color")
            return CellColorType.orange.rawValue
        case 5:
            UserDefaults.standard.set(0, forKey: "color")
            return CellColorType.pink.rawValue
        default:
            break
        }
        
        return CellColorType.pink.rawValue
    }
}
