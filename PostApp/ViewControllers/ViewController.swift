import UIKit
import FirebaseAuth

class ViewController: UIViewController {
    
    @IBOutlet weak var moveToAddPostViewButton: UIButton!
    
    let cellId = "cell"
    var posts = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        if Auth.auth().currentUser?.uid == nil {
            callSignUpView()
        }
    }
    
    private func setupView() {
        moveToAddPostViewButton.layer.cornerRadius = moveToAddPostViewButton.frame.width / 2
        moveToAddPostViewButton.addTarget(self, action: #selector(tappedMoveToAddPostViewButton), for: .touchUpInside)
//        self.view.backgroundColor = .rgb(30, 150, 255)
        navigationController?.navigationBar.backgroundColor = .rgb(30, 150, 255)
        
    }
    
    private func callSignUpView() {
        let storyboard = UIStoryboard.init(name: "SignUp", bundle: nil)
        let signUpViewController = storyboard.instantiateViewController(withIdentifier: "SignUpViewController")
        
        
        signUpViewController.modalPresentationStyle = .fullScreen
        
        
        present(signUpViewController, animated: true, completion: nil)
    }
    
    @objc private func tappedMoveToAddPostViewButton() {
        let storyboard = UIStoryboard.init(name: "MakePost", bundle: nil)
        let makePostViewController = storyboard.instantiateViewController(withIdentifier: "MakePostViewController")
        navigationController?.pushViewController(makePostViewController, animated: true)
    }
    
}

