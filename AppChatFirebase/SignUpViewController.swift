//
//  SignUpViewController.swift
//  AppChatFirebase
//
//  Created by QTS Coder on 9/11/17.
//  Copyright © 2017 David. All rights reserved.
//

import UIKit
import FirebaseStorage
import Firebase
import FirebaseAuth
import SVProgressHUD

let storage = Storage.storage()
let storageRef = storage.reference(forURL: "gs://appchatfirebase-79670.appspot.com/")
var ref = Database.database().reference()
var currentUser:User!
var visitor:User!

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var txt_Name: UITextField!
    @IBOutlet weak var txt_Email: UITextField!
    @IBOutlet weak var txt_Password: UITextField!
    @IBOutlet weak var txt_RetypePass: UITextField!
    @IBOutlet weak var img_Avatar: UIImageView!
    
    var imgData:Data?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imgData = UIImageJPEGRepresentation(#imageLiteral(resourceName: "avatar"), 1.0)
        
        // Do any additional setup after loading the view.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func alertChooseAvatar()
    {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let btnPhoto = UIAlertAction(title: "Photo", style: .default) { (UIAlertAction) in
            
            let imgPicker = UIImagePickerController()
            imgPicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
            imgPicker.delegate = self
            imgPicker.allowsEditing = false
            self.present(imgPicker, animated: true, completion: nil)
            
        }
        
        let btnCamera = UIAlertAction(title: "Camera", style: .default) { (UIAlertAction) in
            if UIImagePickerController.isSourceTypeAvailable(.camera)
            {
                let imgPicker = UIImagePickerController()
                imgPicker.sourceType = UIImagePickerControllerSourceType.camera
                imgPicker.delegate = self
                imgPicker.allowsEditing = false
                self.present(imgPicker, animated: true, completion: nil)
            } else
            {
                print("Khong co Camera")
            }
            
            
        }
        let btnCancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(btnPhoto)
        alert.addAction(btnCamera)
        alert.addAction(btnCancel)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func chooseAvatarAction(_ sender: Any) {
        alertChooseAvatar()
    }
    @IBAction func signUpAction(_ sender: Any) {
        
        signUpUser(txt_Email.text!, txt_Password.text!)
    }
    
    @IBAction func backToSignIn(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func signUpUser(_ email : String,_ password: String)
    {
        SVProgressHUD.show()
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        DispatchQueue.global(qos: .default).async {
            Auth.auth().createUser(withEmail: email, password: password) { (userinfo, error) in
                
                if error != nil
                {
                    print((error?.localizedDescription)!)
                    DispatchQueue.main.async(execute: {
                        SVProgressHUD.dismiss()
                        UIApplication.shared.isNetworkActivityIndicatorVisible = false
                        let errors = error?.localizedDescription
                        self.alertMissingText(mess: errors!, textField: nil)
                    })
                    
                    
                }
                else
                {
                    
                    Auth.auth().signIn(withEmail: email, password: password, completion: { (userinfo1, error) in
                        
                        if error != nil
                        {
                            print((error?.localizedDescription)!)
                            DispatchQueue.main.async(execute: {
                                SVProgressHUD.dismiss()
                                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                            })
                        }
                        else
                        {
                            
                            print((userinfo1?.email)!)
                            
                            let avatarRef = storageRef.child("avatar/\(email).jpg")
                            
                            let uploadtask = avatarRef.putData(self.imgData!, metadata: nil, completion: { (metadata, error) in
                                if error != nil
                                {
                                    print("Loi upload avatar")
                                    
                                } else
                                {
                                    let downloadURL = metadata?.downloadURL()
                                    
                                    if let user_curr = Auth.auth().currentUser
                                    {
                                        
                                        
                                        let changRequest = user_curr.createProfileChangeRequest()
                                        
                                        changRequest.displayName = self.txt_Name.text!
                                        
                                        changRequest.photoURL = downloadURL
                                        
                                        changRequest.commitChanges(completion: { (error) in
                                            
                                            if error == nil
                                            {
                                                
                                                DispatchQueue.main.async(execute: {
                                                    
                                                    let uid = user_curr.uid
                                                    let name = user_curr.displayName
                                                    let email = user_curr.email
                                                    let avatarLink = user_curr.photoURL
                                                    
                                                    currentUser = User(id: uid, email: email!, fullname: name!, linkAvatar: "\(avatarLink!)")
                                                    
                                                    let tableName = ref.child("ListUser")
                                                    let userid = tableName.child(currentUser.id)
                                                    let user: [String:String] = ["email":currentUser.email,"fullname":currentUser.fullname,"avatarLink":currentUser.linkavatar]
                                                    
                                                    userid.setValue(user)
                                                    UserDefaults.standard.set(currentUser, forKey: "currentUser")
                                                    UserDefaults.standard.set(true, forKey: "isLoggedIn")
                                                    UserDefaults.standard.synchronize()
                                                    
                                                    SVProgressHUD.dismiss()
                                                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                                                    self.gotoHome()
                                                    
                                                })
                                                
                                            } else
                                            {
                                                print("Loi update avatar")
                                            }
                                        })
                                        
                                    }
                                    
                                }
                                
                            })
                            uploadtask.resume()
                        }
                    })
                }
            }
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

extension SignUpViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let chooseImg = info[UIImagePickerControllerOriginalImage] as! UIImage
        let imgValue = max(chooseImg.size.width, chooseImg.size.height)
        
        if imgValue > 3000
        {
            imgData = UIImageJPEGRepresentation(chooseImg, 0.1)
            
        } else if imgValue > 2000
        {
            imgData = UIImageJPEGRepresentation(chooseImg, 0.3)
            
        } else
        {
            imgData = UIImagePNGRepresentation(chooseImg)
        }
        
        img_Avatar.image = UIImage(data: imgData!)
        
        dismiss(animated: true, completion: nil)
        
    }
}
