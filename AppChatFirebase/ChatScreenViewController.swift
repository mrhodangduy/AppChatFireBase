//
//  ChatScreenViewController.swift
//  AppChatFirebase
//
//  Created by QTS Coder on 9/11/17.
//  Copyright © 2017 David. All rights reserved.
//

import UIKit
import Firebase

class ChatScreenViewController: UIViewController {
    
    @IBOutlet weak var bottonConstraint: NSLayoutConstraint!
    @IBOutlet weak var txt_Mess: RoundTextFiled!
    @IBOutlet weak var chatTableView: UITableView!
    
    var arrIDChat:Array<String> = Array<String>()
    var tableName:DatabaseReference!
    var arrtxtChat:Array<String> = Array<String>()
    var arruserChat: Array<User> = Array<User>()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        chatTableView.delegate = self
        chatTableView.dataSource = self
        chatTableView.estimatedRowHeight = 50
        chatTableView.rowHeight = UITableViewAutomaticDimension
        
        txt_Mess.delegate = self
        
        arrIDChat.append(currentUser.id)
        arrIDChat.append(visitor.id)
        arrIDChat.sort()
        let key:String = ("\(arrIDChat[0])\(arrIDChat[1])")
        
        tableName = ref.child("Chat").child(key)
        
        tableName.observe(DataEventType.childAdded, with: { (snapshot) in
            let postDict = snapshot.value as? [String:AnyObject]
            print(postDict!)
            if (postDict != nil)
            {
                if (postDict?["id"] as! String == currentUser.id)
                {
                    self.arruserChat.append(currentUser)
                }
                else
                {
                    self.arruserChat.append(visitor)
                }
                
                self.arrtxtChat.append(postDict?["message"] as! String)
                self.chatTableView.reloadData()
            }
        })
        
        self.navigationItem.title = visitor.fullname
        
        showHideKeyboard()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        chatTableView.scrollToBottom(animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func sendAction(_ sender: Any) {
        
        let mess:Dictionary<String,String> = ["id": currentUser.id, "message": txt_Mess.text!]
        tableName.childByAutoId().setValue(mess)
        txt_Mess.text = ""
        chatTableView.scrollToBottom(animated: true)
        
        if (arrtxtChat.count == 0)
        {
            addListChat(user1: currentUser, user2: visitor)
            addListChat(user1: visitor, user2: currentUser)
        }
        
    }
    
    func addListChat(user1:User, user2:User)
    {
        let tableName2 = ref.child("ListChat").child(user1.id).child(user2.id)
        let user:Dictionary<String,String> = ["email": user2.email,"fullname": user2.fullname,"linkAvatar": user2.linkavatar]
        tableName2.setValue(user)
    }
    
    func showHideKeyboard()
    {
        NotificationCenter.default.addObserver(self, selector: #selector(self.showKey(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.hideKey(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func showKey(_ notification: Notification)
    {
        let s:NSValue = (notification as NSNotification).userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        let rect:CGRect = s.cgRectValue
        self.bottonConstraint.constant = rect.size.height
        UIView.animate(withDuration: 1) { () -> Void in
            self.view.layoutIfNeeded()
        }
    }
    
    func hideKey(_ notification: Notification)
    {
        self.bottonConstraint.constant = 0
        UIView.animate(withDuration: 1) { () -> Void in
            self.view.layoutIfNeeded()
        }
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension ChatScreenViewController: UITableViewDataSource, UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrtxtChat.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if currentUser.id == arruserChat[indexPath.row].id
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath) as! Own_TableViewCell
            cell.lbl_OwnMess.text = arrtxtChat[indexPath.row]
            cell.img_Own.sd_setImage(with: URL(string: currentUser.linkavatar), placeholderImage: #imageLiteral(resourceName: "avatar"), options: .continueInBackground, completed: nil)
            return cell
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath) as! Visitor_TableViewCell
            cell.lbl_VisitorMess.text = arrtxtChat[indexPath.row]
            cell.img_Visitor.sd_setImage(with: URL(string:visitor.linkavatar), placeholderImage: #imageLiteral(resourceName: "avatar"), options: .continueInBackground, completed: nil)
            return cell
        }
        
    }
    
}

extension ChatScreenViewController: UITextFieldDelegate
{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        txt_Mess.resignFirstResponder()
        return true
    }
}








