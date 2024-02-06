import UIKit

class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func showError(_ error: Error) {
        var message = ""
        if let error = error as? MyError {
            message = error.localizedDescription
        } else {
            message = error.localizedDescription
        }
        let alert = UIAlertController(title: Constants.Error, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Constants.OK, style: .default))
        present(alert, animated: true)
    }
}
