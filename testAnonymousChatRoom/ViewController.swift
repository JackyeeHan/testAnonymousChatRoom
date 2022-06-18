//
//  ViewController.swift
//  testAnonymousChatRoom
//
//  Created by 黃柏瀚 on 2022/6/17.
//

import UIKit
import Firebase

class ViewController: UIViewController {
    
    
    @IBOutlet weak var nickNameTF: UITextField!
    @IBOutlet weak var statusLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Auth.auth().signInAnonymously(completion: nil)
        Auth.auth().addStateDidChangeListener { auth, user in
            if let user = user{
                print("SignIned")
                self.statusLabel.text = "現在狀態:登入"
                print(user.uid)
            }else{
                print("SignOut")
                self.statusLabel.text = "現在狀態:登出"
            }
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            switch segue.identifier {
            case "goListPage":
                let nextVC = segue.destination as? Page2ViewController
                nextVC?.nickName = nickNameTF.text ?? ""
            default:
                break
            }
        }
    
    @IBAction func goNextPage(_ sender: Any) {
        let nickName = nickNameTF.text ?? ""
        if nickName.count < 1{
            self.showMsg(msg: "暱稱不能為空白")
            return
        }
        
        if let user = Auth.auth().currentUser {
            self.performSegue(withIdentifier: "goListPage", sender: self)
        }else{
            self.showMsg(msg: "尚未登入")
            
        }
        
        nickNameTF.text = ""
    }
    
}

