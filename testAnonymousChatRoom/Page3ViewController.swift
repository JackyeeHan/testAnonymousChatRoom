//
//  Page3ViewController.swift
//  testAnonymousChatRoom
//
//  Created by 黃柏瀚 on 2022/6/17.
//

import UIKit
import Firebase

class Page3ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
 
    var nickName = ""
    var key = ""
    var subJect = ""
    var dbReference:DatabaseReference!
    var commentArray:[[String:String]] = []
    
    @IBOutlet weak var inputTextTF: UITextField!
    @IBOutlet weak var theTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("page3 nickName:\(nickName)")
        self.title = subJect
        
        dbReference = Database.database().reference().child("comment").child(key)
        theTableView.dataSource = self
        theTableView.delegate = self
        
        dbReference.observe(.value) { snapshot in
            print("newData")
            self.commentArray.removeAll()
            
            for item in snapshot.children{
                if let itemSnapshot = item as? DataSnapshot{
                    let comment = itemSnapshot.childSnapshot(forPath: "comment").value as? String ?? "不清楚"
                    let nickname = itemSnapshot.childSnapshot(forPath: "user").value as? String ?? "不知道"
                    let time:Double = (itemSnapshot.childSnapshot(forPath: "time").value as? Double ?? 0) / 1000
                    
                    let commentDate = Date(timeIntervalSince1970: time)
                    let dateFomater = DateFormatter()
                    dateFomater.dateFormat = "yyyy-MM-dd HH:mm"
                    let dateString = dateFomater.string(from: commentDate)
                    
                    let commentContent = ["comment":comment,
                                          "user":nickname,
                                          "time":dateString]
                    self.commentArray.append(commentContent)
                    
                    print("============")
                    print("\(comment)\n\(nickname)\n\(time)")
                }
                self.theTableView.reloadData()
                
            }
                    
            
        }
    
    }
    
    @IBAction func newComment(_ sender: Any) {
        let comment = inputTextTF.text ?? ""
        
        if comment.count < 1 {
            showMsg(msg: "內容不能為空白")
            return
        }
        let commentRef = dbReference.childByAutoId()
        
        let commentContent = ["comment":comment,
                              "user":nickName,
                              "time":ServerValue.timestamp()] as [String : Any]
        
        commentRef.setValue(commentContent)
        inputTextTF.text = ""
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commentArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "commentTableViewCell") as! CommentTableViewCell
//        cell.backgroundColor = UIColor.yellow
        cell.comment.text = commentArray[indexPath.row]["comment"]
        cell.nickName.text = commentArray[indexPath.row]["user"]
        cell.date.text = commentArray[indexPath.row]["time"]
        
        
        
        return cell
    }
    
}

