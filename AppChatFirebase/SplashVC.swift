//
//  ViewController.swift
//  AppChatFirebase
//
//  Created by QTS Coder on 9/11/17.
//  Copyright © 2017 David. All rights reserved.
//

import UIKit
import Firebase

class SplashVC: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageview2: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
//        userDefault.set(false, forKey: "isloggedin")
//        try! Auth.auth().signOut()
        
        print(userDefault.bool(forKey: "isloggedin"))
        print(Auth.auth().currentUser)
        
        
                
        if #available(iOS 10.0, *) {
            Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { (time) in
                
                if userDefault.bool(forKey: "isloggedin")
                {
                    self.gotoHome()
                    
                }
                else
                {
                    self.gotoSignIn()
                    
                }
                
            }
        } else {
            imageview2.alpha = 0
            UIView.animate(withDuration: 2, delay: 1, options: .allowAnimatedContent, animations: { 
                self.imageview2.alpha = 1
            }, completion: { (done) in
                if userDefault.bool(forKey: "isloggedin")
                {
                    self.gotoHome()
                    
                }
                else
                {
                    self.gotoSignIn()
                    
                }
            })
        }
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}



