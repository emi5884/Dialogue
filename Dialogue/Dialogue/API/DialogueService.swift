import UIKit
import Firebase

struct DialogueService {
    
    static func uploadDialogue(dialogue: DialogueItem, completion: @escaping([Dialogue]) -> Void) {
        
        let ref = COLLECTION_DIALOGUES.document()
        let dialogueID = ref.documentID
        
        DataUploader.uploadDialogue(audio: dialogue.audio) { audioURL in
            
            let data: [String: Any] = ["characterID": dialogue.id,
                                       "dialogueID": dialogueID,
                                       "dialogue": dialogue.text,
                                       "audioUrl": audioURL,
                                       "character": dialogue.character,
                                       "imageUrl": dialogue.imageUrl,
                                       "timeStamp": Timestamp()]
            
            ref.setData(data) { _ in
                fetchDialogue { dialogues in
                    completion(dialogues)
                }
            }
        }
    }
    
    static func fetchDialogue(completion: @escaping([Dialogue]) -> Void) {
        
        COLLECTION_DIALOGUES.order(by: "timeStamp", descending: true).getDocuments { snapshot, _ in
            guard let documents = snapshot?.documents else { return }
            let dialogues = documents.map { Dialogue(dictionary: $0.data()) }
            completion(dialogues)
        }
    }
}
