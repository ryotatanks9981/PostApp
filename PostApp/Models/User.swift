import UIKit
import Firebase

class User {
    var profileImageUrl: String?
    let username: String
    let email: String
    let createdAt: Timestamp
    
    init(dic: [String: Any]) {
        self.profileImageUrl = dic[""] as? String ?? ""
        self.email = dic["email"] as? String ?? ""
        self.createdAt = dic["createdAt"] as? Timestamp ?? Timestamp()
        self.username = dic["username"] as? String ?? ""
    }
}
