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
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var txt_Email: UITextField!
    @IBOutlet weak var txt_password: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        txt_Email.delegate = self
        txt_password.delegate = self
        
        createTapGestureScrollview(withscrollview: scrollView)
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func signInAction(_ sender: Any) {
        self.view.endEditing(true)
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
                        print(user_curr)
                        let uid = user_curr.uid
                        let email = user_curr.email
                        let fullname = user_curr.displayName
                        let avatarLink = user_curr.photoURL
                        let online = "yes"
                        
                        let currentUser = User(id: uid, email: email!, fullname: fullname!, linkAvatar: "\(avatarLink!)",online : online)
                        userDefault.set(true, forKey: "isloggedin")
                        userDefault.set(currentUser.id, forKey: "currentuser")
                        userDefault.synchronize()
                        
                        DispatchQueue.main.async(execute: {
                            SVProgressHUD.dismiss()
                            self.gotoHome()
                        })
                    }
                    
                    
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


extension SignInViewController: UITextFieldDelegate
{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        switch textField.tag {
            
        case 1:
            txt_password.becomeFirstResponder()
            
        default:
            textField.resignFirstResponder()
        }
        
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        scrollView.setContentOffset(CGPoint(x: 0, y: 50), animated: true)
        
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
}





