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
    
    @IBOutlet weak var img_myAvatar: RoundImageView!
    @IBOutlet weak var lbl_myName: UILabel!
    @IBOutlet weak var listFriendTableView: UITableView!
    
    var listUser = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        listFriendTableView.delegate = self
        listFriendTableView.dataSource = self
        listFriendTableView.separatorStyle = .none
        listFriendTableView.tableFooterView = UIView(frame: .zero)
        
        lbl_myName.text = currentUser.fullname
        img_myAvatar.sd_setImage(with: URL( string: currentUser.linkavatar), placeholderImage: #imageLiteral(resourceName: "avatar"), options: SDWebImageOptions.continueInBackground, completed: nil)
        
        getAllUser()
        
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
                
                let user:User = User(id: snapShot.key, email: email, fullname: fullname, linkAvatar: avatarLink)
                
                if user.id != currentUser.id
                {
                    self.listUser.append(user)
                    print(self.listUser)
                }
            }
            self.listFriendTableView.reloadData()
        })
        
    }
    @IBAction func signOutAction(_ sender: Any) {
        do
        {
            try Auth.auth().signOut()
//            UserDefaults.standard.removeObject(forKey: "currentUser")
//            UserDefaults.standard.set(false, forKey: "isLoggedIn")
//            UserDefaults.standard.synchronize()
            
        }
        catch
        {
            print("Error")
        }
        self.gotoSignIn()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        
        cell.lbl_friendName.text = listUser[indexPath.row].fullname
        cell.img_avatarFriend.sd_setImage(with: URL( string: listUser[indexPath.row].linkavatar), placeholderImage: #imageLiteral(resourceName: "avatar"), options: SDWebImageOptions.continueInBackground, completed: nil)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        visitor = listUser[indexPath.row]
        
        let chatVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "chatVC")
        
        self.navigationController?.pushViewController(chatVC, animated: true)
    }
    
    

}









