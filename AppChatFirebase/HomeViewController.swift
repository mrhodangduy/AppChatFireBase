//
//  HomeViewController.swift
//  AppChatFirebase
//
//  Created by QTS Coder on 9/11/17.
//  Copyright © 2017 David. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage

class HomeViewController: UIViewController {
    
    @IBOutlet weak var onlineStatusMe: UILabel!
    @IBOutlet weak var img_myAvatar: RoundImageView!
    @IBOutlet weak var lbl_myName: UILabel!
    @IBOutlet weak var listFriendTableView: UITableView!
    
    var listUser = [User]()
    let currentUserID = userDefault.object(forKey: "currentuser") as! String
    var currentUser = User()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(currentUserID)
        let user_curr = Auth.auth().currentUser
        if currentUserID == user_curr?.uid
        {
            let email = user_curr?.email
            let name = user_curr?.displayName
            let avatarLink = user_curr?.photoURL
            
            currentUser = User(id: currentUserID, email: email!, fullname: name!, linkAvatar: "\(avatarLink!)",online: "yes")
            
            ref.child("ListUser").child(currentUser.id).updateChildValues(["online": "yes"], withCompletionBlock: { (error, data) in
                
            })
           
        }
        
        listFriendTableView.delegate = self
        listFriendTableView.dataSource = self
        listFriendTableView.tableFooterView = UIView(frame: .zero)
        
        lbl_myName.text = currentUser.fullname + " - (Me)"
        img_myAvatar.sd_setImage(with: URL( string: currentUser.linkavatar), placeholderImage: #imageLiteral(resourceName: "avatar"), options: SDWebImageOptions.continueInBackground, completed: nil)
        
        getAllUser()
        
        onlineStatusMe.text = "Online"
        ref.child("ListUser").keepSynced(true)
        
        checkchangeUser()
        
        // Do any additional setup after loading the view.
    }
    
    func getAllUser()
    {
        
        let tableName = ref.child("ListUser")
        tableName.observe(.childAdded, with: { (snapShot) in
            
            let postDict = snapShot.value as? [String: AnyObject]
            if postDict != nil
            {
                
                let email = (postDict?["email"])! as! String
                let fullname = (postDict?["fullname"])! as! String
                let avatarLink = (postDict?["avatarLink"])! as! String
                let online = (postDict?["online"])! as! String
                
                let user:User = User(id: snapShot.key, email: email, fullname: fullname, linkAvatar: avatarLink, online: online)
                
                if user.id != self.currentUser.id
                {
                    self.listUser.append(user)
                }
            }
            self.listFriendTableView.reloadData()
        })
    }
    
    func checkchangeUser()
    {
        let tableName = ref.child("ListUser")
        tableName.observe(.childChanged, with: { (snapShot) in
            let postDict = snapShot.value as? [String: AnyObject]
            if postDict != nil
            {
                let email = (postDict?["email"])! as! String
                let fullname = (postDict?["fullname"])! as! String
                let avatarLink = (postDict?["avatarLink"])! as! String
                let online = (postDict?["online"])! as! String
                let userinfo = User(id: snapShot.key, email: email, fullname: fullname, linkAvatar: avatarLink, online: online)
                
                for i in 0...self.listUser.count-1
                {
                    if self.listUser[i].id == snapShot.key
                    {
                        self.listUser[i] = userinfo
                        self.listFriendTableView.reloadData()
                        print(self.listUser[i])
                    }
                }
            }
        })
    }
    
    @IBAction func signOutAction(_ sender: Any) {
        
        let currentREF = ref.child("ListUser").child(currentUser.id)
        currentREF.updateChildValues(["online": "no"]) { (err, dataref) in
            
            if err == nil
            {
                try! Auth.auth().signOut()
                userDefault.removeObject(forKey: "currentUser")
                userDefault.set(false, forKey: "isloggedin")
                userDefault.synchronize()
                self.gotoSignIn()
            }
            else
            {
                print((err?.localizedDescription)!)
            }
        }
    }
    
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listUser.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ListFriends_TableViewCell
        
        let userinfo = listUser[indexPath.row]
        
        cell.lbl_friendName.text = userinfo.fullname
        cell.img_avatarFriend.loadImageCachedWithUrlString(urlString:userinfo.linkavatar)
//        cell.img_avatarFriend.sd_setImage(with: URL( string: userinfo.linkavatar), placeholderImage: #imageLiteral(resourceName: "avatar"), options: SDWebImageOptions.continueInBackground, completed: nil)
        if userinfo.online == "yes"
        {
            cell.onlineStatus.text = "Online"
            cell.onlineStatus.textColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
            cell.signStatus.backgroundColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        }
        else
        {
            cell.onlineStatus.text = "Offline"
            cell.onlineStatus.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
            cell.signStatus.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            cell.signStatus.layer.borderWidth = 0.3
            cell.signStatus.layer.borderColor = #colorLiteral(red: 0.2431372549, green: 0.4274509804, blue: 1, alpha: 1).cgColor

        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        visitor = listUser[indexPath.row]
        
        let chatVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "chatVC") as! ChatScreenViewController
        
        self.navigationController?.pushViewController(chatVC, animated: true)
    }
    
    
}









