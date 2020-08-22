import UIKit

extension MakePostViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if makePostTextView.text.isEmpty {
            postButton.isEnabled = false
            postButton.backgroundColor = .rgb(179, 196, 255)
        } else {
            postButton.isEnabled = true
            postButton.backgroundColor = .rgb(220, 160, 255)
        }
    }
}
