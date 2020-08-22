import UIKit
import FirebaseFirestore
class PostListViewController: UIViewController {
    
    @IBOutlet weak var postListTableView: UITableView!
    
    let cellId = "cell"
    var posts = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        postListTableView.reloadData()
        setupView()
        getPostInformationFromFirestore()
        
    }
    
    private func setupView() {
        postListTableView.delegate = self
        postListTableView.dataSource = self
        postListTableView.register(UINib(nibName: "PostListTavleViewCell", bundle: nil), forCellReuseIdentifier: cellId)
        postListTableView.tableFooterView = UIView()
        postListTableView.tableFooterView?.backgroundColor = .rgb(30, 150, 255)
        self.view.backgroundColor = .rgb(30, 150, 255)
        postListTableView.register(UINib(nibName: "PostListTableViewCell", bundle: nil), forCellReuseIdentifier: cellId)
        
        let makePostViewController = MakePostViewController()
        makePostViewController.delegate = self
    }
    
    private func getPostInformationFromFirestore() {
        
        Firestore.firestore().collection("posts").getDocuments { (snapshots, err) in
            if let err = err {
                print("fail to get posts information form Firestore", err)
            }
            
            snapshots?.documents.forEach({ (snapshot) in
                let data = snapshot.data()
                let post = Post(data: data)
                self.posts.append(post)
                self.postListTableView.reloadData()
            })
        }
        
    }
}

