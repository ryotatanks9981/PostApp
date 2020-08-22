import UIKit

extension SignUpViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let email = emailTextField.text?.isEmpty else { return }
        guard let password = passwordTextField.text?.isEmpty else { return }
        guard let username = usernameTextField.text?.isEmpty else { return }
        
        if email || password || username {
            registerButton.isEnabled = false
            registerButton.backgroundColor = .rgb(230, 160, 130)
        } else {
            registerButton.isEnabled = true
            registerButton.backgroundColor = .rgb(234, 165, 64)
        }
    }
}

extension SignUpViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editImage = info[.editedImage] as? UIImage {
            profileImageView.image = editImage.withRenderingMode(.alwaysOriginal)
        } else if let originalImage = info[.originalImage] as? UIImage {
            profileImageView.image = originalImage.withRenderingMode(.alwaysOriginal)
        }
        
        dismiss(animated: true, completion: nil)
    }
}
