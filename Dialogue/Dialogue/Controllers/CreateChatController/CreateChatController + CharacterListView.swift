import UIKit

extension CreateChatController: CharacterListViewDelegate {
    func selectCharacter(character: Character) {
        selectedCharacter = character
        updateDialogues(character: character)
        dialogueListDescription.isHidden = true
        addDialogueButton.isHidden = false
        
        for i in 0 ..< selectedDialogues.count {
            guard let cell = dialogueListView.cellForRow(at: IndexPath(row: i, section: 0)) as? CreateChatCell else { return }
            cell.bottomBorder.isHidden = false
        }
    }
    
    func showRegisterViewController() {
        let vc = RegisterViewController()
        vc.completion = { newInfo in
            self.updateCharacter(newInfo: newInfo)
        }
        
        navigationController?.pushViewController(vc, animated: true)
    }
}
