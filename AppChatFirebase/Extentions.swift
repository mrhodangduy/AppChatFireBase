//
//  Extentions.swift
//  AppChatFirebase
//
//  Created by QTS Coder on 9/11/17.
//  Copyright © 2017 David. All rights reserved.
//

import Foundation
import UIKit

extension UITableView {
    func scrollToBottom(animated: Bool) {
        let y = contentSize.height - frame.size.height
        setContentOffset(CGPoint(x: 0, y: (y<0) ? 0 : y), animated: animated)
    }
}

extension UIViewController
{
    func alertMissingText(mess: String, textField: UITextField?)
        
    {
        let alert = UIAlertController(title: "ATAX", message: mess, preferredStyle: .alert)
        let btnOK = UIAlertAction(title: "OK", style: .default) { (action) in
            textField?.becomeFirstResponder()
        }
        
        alert.addAction(btnOK)
        self.present(alert, animated: true, completion: nil)
    }
    
    func checkValidateTextField(tf1: UITextField? ,tf2: UITextField?,tf3: UITextField?,tf4: UITextField?) -> Int
    {
        
        if tf1?.text?.characters.count == 0
        {
            return 1
        }
        else if tf2?.text?.characters.count == 0
        {
            return 2
        }
        else if tf3?.text?.characters.count == 0
        {
            return 3
        }
        else if tf4?.text?.characters.count == 0
        {
            return 4
        }
        else
        {
            return 0
            
        }
    }
    
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let result = emailTest.evaluate(with: testStr)
        return result
    }
    
    func gotoHome()
    {
        let homeVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "homeVC") as! Navi_ViewController
        self.present(homeVC, animated: false, completion: nil)
    }
    
    func gotoSignIn()
    {
        let SignInVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "signinVC") as! SignInViewController
        self.present(SignInVC, animated: false, completion: nil)  
    }
    
    func tapToClose()
    {
        view.endEditing(true)
    }
    
    func createTapGestureScrollview(withscrollview scrollView:UIScrollView)
    {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(UIViewController.tapToClose))
        
        scrollView.addGestureRecognizer(tapGesture)
    }
    
}

let imageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView
{
    func loadImageCachedWithUrlString(urlString: String)
    {
        if let cachedImage = imageCache.object(forKey: urlString as AnyObject) as? UIImage
        {
            self.image = cachedImage
            return
        }
        let url = URL(string: urlString)
        URLSession.shared.dataTask(with: url!) { (data, respone, err) in
            
            if err != nil
            {
                print(err!.localizedDescription)
                return
            }
            DispatchQueue.main.async(execute: { 
                if let downloadImage = UIImage(data: data!)
                {
                    imageCache.setObject(downloadImage, forKey: urlString as AnyObject)
                    self.image = downloadImage
                }
            })
            
            }.resume()
        
    }
}







