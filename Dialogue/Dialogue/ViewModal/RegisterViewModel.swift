import UIKit

struct RegisterViewModel {
    let pageNumber: Int
    
    var shouldHideName: Bool {
        return pageNumber == 1 || pageNumber == 2
    }
    
    var shouldHideImage: Bool {
        return pageNumber == 0 || pageNumber == 2
    }
    
    var shouldHideNameLabel: Bool {
        return pageNumber == 0 || pageNumber == 2
    }
    
    var shouldHideAudio: Bool {
        return pageNumber == 0 || pageNumber == 1
    }
    
    var instructionText: String {
        switch pageNumber {
        case 0:
            return "名前を入力してください"
            
        case 1:
            return "画像を設定してください"
            
        case 2:
            return "音声を録音してください"
            
        default:
            break
        }
        
        return ""
    }
    
    init(pageNumber: Int) {
        self.pageNumber = pageNumber
    }
}
