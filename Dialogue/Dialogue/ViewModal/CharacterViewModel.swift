import UIKit

struct CharacterViewModel {
    let character: Character
    let cellNumber: Int
    
    var name: String {
        return character.character
    }
    
    var imageUrl: URL? {
        return URL(string: character.imageUrl)
    }
    
    init(character: Character, cellNumber: Int) {
        self.character = character
        self.cellNumber = cellNumber
    }
}
