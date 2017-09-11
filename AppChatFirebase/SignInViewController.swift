//
//  SignInViewController.swift
//  AppChatFirebase
//
//  Created by QTS Coder on 9/11/17.
//  Copyright © 2017 David. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class SignInViewController: UIViewController {

    @IBOutlet weak var txt_Email: UITextField!
    @IBOutlet weak var txt_password: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

        
    @IBAction func signInAction(_ sender: Any) {
        
        SVProgressHUD.show(withStatus: "Sign in...")
        DispatchQueue.global(qos: .default).async { 
            Auth.auth().signIn(withEmail: self.txt_Email.text!, password: self.txt_password.text!) { (userinfo, error) in
                
                if error != nil
                {
                    print((error?.localizedDescription)!)
                    DispatchQueue.main.async(execute: {
                        let err = (error?.localizedDescription)!
                        self.alertMissingText(mess: err, textField: nil)
                        SVProgressHUD.dismiss()
                    })
                    
                }
                    
                else
                {
                    if let user_curr = Auth.auth().currentUser
                    {
                        let uid = user_curr.uid
                        let email = user_curr.email
                        let fullname = user_curr.displayName
                        let avatarLink = user_curr.photoURL
                        
                         let currentUser = User(id: uid, email: email!, fullname: fullname!, linkAvatar: "\(avatarLink!)")
                        UserDefaults.standard.set(currentUser, forKey: "currentUser")
                        UserDefaults.standard.set(true, forKey: "isLoggedIn")
                        UserDefaults.standard.synchronize()
                    }
                    
                    DispatchQueue.main.async(execute: {
                        SVProgressHUD.dismiss()
                        self.gotoHome()
                    })
                }
            }
        }
        
    }
    
    @IBAction func forgotPassAction(_ sender: Any) {
    }
    
    @IBAction func signUpAction(_ sender: Any) {
        
        let signupVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "signupVC") as! SignUpViewController
        self.present(signupVC, animated: true, completion: nil)
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
