import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage

class SignUpViewController: UIViewController {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var alreadyHaveAccountUserButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
    }
    
    private func setUpViews() {
        let tappedGesture = UITapGestureRecognizer(target: self, action: #selector(tappedProfileImageView))
        profileImageView.layer.cornerRadius = profileImageView.frame.width/2
        profileImageView.layer.borderWidth = 1
        profileImageView.layer.borderColor = UIColor.rgb(136, 136, 136).cgColor
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.addGestureRecognizer(tappedGesture)
        registerButton.layer.cornerRadius = 20
        registerButton.isEnabled = false
        registerButton.backgroundColor = .rgb(230, 160, 130)
        emailTextField.delegate = self
        passwordTextField.delegate = self
        usernameTextField.delegate = self
        registerButton.addTarget(self, action: #selector(tappedRegisterButton), for: .touchUpInside)
    }
    
    @objc private func tappedProfileImageView() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        present(imagePickerController, animated: true, completion: nil)
    }
    
    @objc private func tappedRegisterButton() {
        putDataToFirestorage()
        dismiss(animated: true, completion: nil)
    }
    
    private func putDataToFirestorage() {
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        guard let username = usernameTextField.text else { return }
        guard let image = profileImageView.image else { return }
        guard let uploadImage = image.jpegData(compressionQuality: 0.3) else { return }
        
        let fileName = UUID().uuidString
        let storageRef = Storage.storage().reference().child("profile_image").child(fileName)
        
        storageRef.putData(uploadImage, metadata: nil) { (metaData, err) in
            if let err = err {
                print("error to save upload image to Firestorage (\(err)")
                return
            }
//            print("success to save upload image to Firestorage")
            
            storageRef.downloadURL { (url, err) in
                if let err = err {
                    print("error download url form firestorage (\(err))")
                    return
                }
                
                guard let urlString = url?.absoluteString else { return }
//                print("success download url form firestorage: ", urlString)
                self.createUser(email: email, password: password, username: username, profileImageurl: urlString)
            }
        }
    }
    
    private func createUser(email: String, password: String, username: String, profileImageurl: String) {
        Auth.auth().createUser(withEmail: email, password: password) { (res, err) in
            if let err = err {
                print("save Auth err: \(err)")
                return
            }

//            print("save Auth successful")
            guard let uid = res?.user.uid else { return }
            
            
            let documentData: [String : Any] = [
                "email" : email,
                "username" : username,
                "createdAt" : Timestamp(),
                "profileImageUrl" : profileImageurl
            ]
            
            self.saveUserInformationToFirestore(uid: uid, documentData: documentData)
        }
    }
    
    private func saveUserInformationToFirestore(uid: String, documentData: [String : Any]) {
        Firestore.firestore().collection("users").document(uid).setData(documentData) { (err) in
            if let err = err {
                print("save user information to firestore err: ",err)
                return
            }
            
            print("save user information to firestore successful")
        }
    }
}
