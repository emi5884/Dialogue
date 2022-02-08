import UIKit

struct DialogueViewModel {
    let dialogue: Dialogue
    let cellNumber: Int
    
    var name: String {
        return dialogue.character
    }
    
    var imageUrl: URL? {
        return URL(string: dialogue.imageUrl)
    }
    
    init(dialogue: Dialogue, cellNumber: Int) {
        self.dialogue = dialogue
        self.cellNumber = cellNumber
    }
}
