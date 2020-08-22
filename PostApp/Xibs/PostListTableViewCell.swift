import UIKit
import Nuke
import Firebase

class PostListTableViewCell: UITableViewCell {

    var content: String? {
        didSet {
            guard let text = content else { return }
            let height = estimatedContentViewSize(text: text).height
            contentTextViewHeightConstraint.constant = height
            contentTextView.text = text
        }
    }
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var createdAtLabel: UILabel!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var contentTextViewHeightConstraint: NSLayoutConstraint!
    
    var post: Post? {
        didSet {
            usernameLabel.text = post?.username
            createdAtLabel.text = post?.createdAt.dateValue().description
            content = post?.content
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        userImageView.layer.cornerRadius = userImageView.frame.width / 2
        contentTextView.textContainer.lineFragmentPadding = .zero
        contentTextView.textContainerInset = UIEdgeInsets.zero
        getprofileImageFromFireStorage()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func estimatedContentViewSize(text: String) -> CGRect {
        let size = CGSize(width: 200, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 20)], context: nil)
    }
    
    private func getprofileImageFromFireStorage() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Firestore.firestore().collection("users").document(uid).getDocument { (snapshot, err) in
            if let err = err {
                print("fail to get user information from firestore err", err)
            }
            
            guard let dic = snapshot?.data() else { return }
            let user = User(dic: dic)
            if let url = URL(string: user.profileImageUrl ?? "") {
                print("imageurl", url)
                Nuke.loadImage(with: url, into: self.userImageView)
            }
        }
    }
    
}
