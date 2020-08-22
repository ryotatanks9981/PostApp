import UIKit
import FirebaseFirestore
import FirebaseAuth

class MakePostViewController: UIViewController { 
    
    @IBOutlet weak var makePostTextView: UITextView!
    @IBOutlet weak var postButton: UIButton!
    weak var delegate: MakePostViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        makePostTextView.delegate = self
        setUpViews()
    }
    
    private func setUpViews() {
        let cancelButton = UIBarButtonItem(title: "キャンセル", style: .plain, target: self, action: #selector(tappedCancelButton))
        cancelButton.tintColor = .black
        navigationItem.leftBarButtonItem = cancelButton
        navigationController?.navigationBar.backgroundColor = .rgb(30, 150, 255)
        postButton.isEnabled = false
        postButton.layer.cornerRadius = 15
        postButton.backgroundColor = .rgb(179, 196, 255)
        postButton.addTarget(self, action: #selector(tappedPostButton), for: .touchUpInside)
    }
    
    @objc private func tappedCancelButton() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func tappedPostButton() {
        guard let content = makePostTextView.text else { return }
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        Firestore.firestore().collection("users").document(uid).getDocument { (snapshot, err) in
            if let err = err {
                print("fail to fetch userData from Firestore", err)
            }
            guard let dic = snapshot?.data() else { return }
            let user = User(dic: dic)
            let data: [String: Any] = [
                "uid" : uid,
                "username" : user.username,
                "content" : content,
                "createdAt": Timestamp()
            ]
            
            self.makePostDataToFirestore(data: data)
        }
        
        navigationController?.popViewController(animated: true)
    }
    
    private func makePostDataToFirestore(data: [String : Any]) {
        let uid = UUID().uuidString
        Firestore.firestore().collection("posts").document(uid).setData(data) { (err) in
            if let err = err {
                print("add Document err : ", err)
            }
            print("Add Document successful")
            self.delegate?.reloadData()
        }
    }
}

protocol MakePostViewControllerDelegate: class {
    func reloadData()
}
