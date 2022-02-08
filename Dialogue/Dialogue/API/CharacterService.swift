import UIKit
import Firebase

struct NewInfo {
    let characters: [Character]
    let dialogues: [Dialogue]
}

struct CharacterService {
    
    static func uploadCharacter(character: CharacterItem, completion: @escaping (NewInfo) -> Void) {
        
        let characterRef = COLLECTION_CHARACTER.document()
        let characterID = characterRef.documentID
        
        DataUploader.FistUploadDialogue(dialogueItem: character) { downloadURLs in
            let characterName = character.name
            let imageUrl = downloadURLs.image
            let audioUrl = downloadURLs.audio
            
            let characterData: [String: Any] = ["characterID": characterID,
                                                "character": characterName,
                                                "imageUrl": imageUrl,
                                                "timeStamp": Timestamp()]
            
            characterRef.setData(characterData) { _ in
                
                let dialogueRef = COLLECTION_DIALOGUES.document()
                let dialogueID = dialogueRef.documentID
                
                let dialogueData: [String: Any] = ["characterID": characterID,
                                                   "dialogueID": dialogueID,
                                                   "dialogue": character.text,
                                                   "audioUrl": audioUrl,
                                                   "character": character.name,
                                                   "imageUrl": imageUrl,
                                                   "timeStamp": Timestamp()]
                
                dialogueRef.setData(dialogueData) { _ in
                    fetchCharacter { characters in
                        DialogueService.fetchDialogue { dialogues in
                            completion(NewInfo(characters: characters, dialogues: dialogues))
                        }
                    }
                }
            }
        }
    }
    
    static func fetchCharacter(completion: @escaping([Character]) -> Void) {
        COLLECTION_CHARACTER.order(by: "timeStamp", descending: true).getDocuments { snapshot, _ in
            guard let documents = snapshot?.documents else { return }
            let characters = documents.map { Character(dictionary: $0.data()) }
            completion(characters)
        }
    }
}
