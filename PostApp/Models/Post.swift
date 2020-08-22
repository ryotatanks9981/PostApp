import UIKit
import Firebase

class Post {
    let uid: String
    let username: String
    let content: String
    let createdAt: Timestamp
    
    init(data: [String: Any]) {
        uid = data["uid"] as? String ?? ""
        username = data["username"] as? String ?? ""
        content = data["content"] as? String ?? ""
        createdAt = data["createdAt"] as? Timestamp ?? Timestamp()
    }
}
