import UIKit

extension PostListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = postListTableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! PostListTableViewCell
        cell.post = posts[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        tableView.estimatedRowHeight = 50
        return 80
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard.init(name: "DetailPost", bundle: nil)
        let detailPostViewController = storyboard.instantiateViewController(withIdentifier: "DetailPostViewController")
        navigationController?.pushViewController(detailPostViewController, animated: true)
    }
}

extension PostListViewController: MakePostViewControllerDelegate {
    func reloadData() {
        postListTableView.reloadData()
    }
}
