import UIKit

struct ErrorModel {
    let message: String
    let actionText: String
    let action: () -> Void
}

protocol ErrorView {
    func showError(_ model: ErrorModel)
}

extension ErrorView where Self: UIViewController {

    func showError(_ model: ErrorModel) {
        let title = NSLocalizedString("Error.title", comment: "")
        let alert = UIAlertController(
            title: title,
            message: model.message,
            preferredStyle: .alert
        )
        let action = UIAlertAction(title: model.actionText, style: UIAlertAction.Style.default) {_ in
            model.action()
        }
        alert.addAction(action)
        present(alert, animated: true)
    }
    
    func showErrorWithCancel(_ model: ErrorModel) {
        let alert = UIAlertController(
            title: model.message,
            message: nil,
            preferredStyle: .alert
        )
        let action = UIAlertAction(title: model.actionText, style: UIAlertAction.Style.default) {_ in
            model.action()
        }
        let title = NSLocalizedString("Error.cancel", comment: "")
        let cancelAction = UIAlertAction(title: title, style: UIAlertAction.Style.cancel, handler: nil)
        alert.addAction(cancelAction)
        alert.addAction(action)
        present(alert, animated: true)
    }
}
