//
//  VerificationViewController.swift
//  Froodz
//
//  Created by Justin Matsnev on 2/13/20.
//  Copyright © 2020 Justin Matsnev. All rights reserved.
//

import UIKit
import PMSuperButton
import FirebaseAuth

class VerificationViewController: UIViewController {

    @IBOutlet var codeTextfield : UITextField!
    @IBOutlet var confirmButton : PMSuperButton!
    @IBOutlet var resendButton : PMSuperButton!

    var fullname : String?
    var username : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureKeyboardResponses()
    }
   
    private func configureKeyboardResponses() {
        addDoneButtonOnKeyboard()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @IBAction func resendTapped(sender : UIButton) {
           self.resendButton.showLoader(userInteraction: false)
           self.resendButton.setTitleColor(.clear, for: .normal)
           guard let phoneNum = UserDefaults.standard.string(forKey: "phoneNum") else {
               return
           }
           PhoneAuthProvider.provider().verifyPhoneNumber(phoneNum, uiDelegate: nil) { (verificationID, error) in
               
               if let err = error {
                   //Show Error
               } else {
                   self.resendButton.hideLoader()
                   self.resendButton.setTitleColor(UIColor.init(red: 255/255, green: 167/255, blue: 81/255, alpha: 1.0), for: .normal)
                   UserDefaults.standard.set(verificationID, forKey: "authVerifyID")
               }
           }
    }
    
    func authorizeUserWithCode(verifyID : String, fullname : String, username : String, code : String) {
        //let testVerificationCode = "123456"
        
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: verifyID, verificationCode: code)
        Auth.auth().signIn(with: credential) { (authResult, error) in
            if let _ = error {
                
                //Show error
                return
            }
            
            guard let user = authResult?.user else {
                //Show error
                return
            }
            UserService.create(user, username: username, fullName: fullname) { (user) in
                
                guard let user = user else {
                    //Show error
                    return
                }
                self.confirmButton.hideLoader()
                self.confirmButton.setTitleColor(.white, for: .normal)
                User.setCurrent(user, writeToUserDefaults: true)
                print("Created new user: \(user.username)")
                let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                if let vc = mainStoryboard.instantiateViewController(withIdentifier: "ActiveGroupsVC") as? ActiveGroupsViewController {
                    
                    self.present(vc, animated: true, completion: nil)
                }
                
            }
        }
    }
       
       @IBAction func confirmTapped(sender : UIButton) {
           confirmButton.setTitleColor(.clear, for: .normal)
           confirmButton.showLoader(userInteraction: false)
           guard let fullname = self.fullname else {
               //Show error
               return
           }
           guard let username = self.username else {
              //Show error
               return
           }
           guard let verifyID = UserDefaults.standard.string(forKey: "authVerifyID") else {
               return
           }
           
           if let code = codeTextfield.text, codeTextfield.text != "" {
               
               self.authorizeUserWithCode(verifyID: verifyID, fullname: fullname, username: username, code: code)
           } else {
               //Show error
           }
       }

}
