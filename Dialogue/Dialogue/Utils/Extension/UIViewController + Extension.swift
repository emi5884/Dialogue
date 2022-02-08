import UIKit
import JGProgressHUD

extension UIViewController {
    static let hud = JGProgressHUD(style: .light)
    
    func showLoader(_ show: Bool) {
        view.endEditing(true)
        
        if show {
            UIViewController.hud.show(in: view)
        } else {
            UIViewController.hud.dismiss()
        }
    }
}
