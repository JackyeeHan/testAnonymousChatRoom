//
//  Page2ViewController.swift
//  testAnonymousChatRoom
//
//  Created by 黃柏瀚 on 2022/6/17.
//

import UIKit
import Firebase
       

class Page2ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    
    var nickName = ""
    var keys:[String] = []
    var subject:[String] = []
    
    var selectedID:Int? = nil
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            switch segue.identifier {
            case "goChatPage":
                let nextVC = segue.destination as? Page3ViewController
                nextVC?.nickName = self.nickName
                nextVC?.key = keys[selectedID!]
                nextVC?.subJect = subject[selectedID!]
                
            default:
                break
            }
        }
    @IBOutlet weak var theTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        print(nickName)
        theTableView.dataSource = self
        theTableView.delegate = self
        self.title = "討論區列表"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //取得控制台內容的值
        let ref = Database.database().reference().child("forum")
        ref.observeSingleEvent(of: .value) { [self] snapshot in
            
            self.keys.removeAll()
            self.subject.removeAll()
            
            for item in snapshot.children {
   
                if let itemSnapshot = item as? DataSnapshot{
                    let theSubject = itemSnapshot.childSnapshot(forPath: "subject").value as! String
                    self.subject.append(theSubject)
                    let key = itemSnapshot.key
                    self.keys.append(key)
                }
   
            }
            self.theTableView.reloadData()
        }
}
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedID = indexPath.row
        self.performSegue(withIdentifier: "goChatPage", sender: self)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subject.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = subject[indexPath.row]
        return cell
    }
    
    }
