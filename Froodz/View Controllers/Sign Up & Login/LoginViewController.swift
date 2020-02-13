//
//  LoginViewController.swift
//  Froodz
//
//  Created by Justin Matsnev on 2/13/20.
//  Copyright © 2020 Justin Matsnev. All rights reserved.
//

import UIKit
import PMSuperButton
import FirebaseAuth

typealias FIRUser = FirebaseAuth.User

class LoginViewController: UIViewController {

    @IBOutlet var phoneTextfield : UITextField! {
           didSet {
               phoneTextfield.loginTextfieldStyle()
           }
       }
    @IBOutlet var usernameTextfield : UITextField! {
           didSet {
               usernameTextfield.loginTextfieldStyle()
           }
       }
    @IBOutlet var fullnameTextfield : UITextField! {
        didSet {
            fullnameTextfield.loginTextfieldStyle()
        }
    }
    @IBOutlet var confirmButton : PMSuperButton!
    
    var username : String?
    var fullname : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addDoneButtonOnKeyboard()

    }
   
    private func configureKeyboardResponses() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @IBAction func tappedConfirm(sender : UIButton) {
        self.confirmButton.setTitleColor(.clear, for: .normal)
        self.confirmButton.showLoader(userInteraction: false)
        
        guard let phoneNum = phoneTextfield.text?.trimmingCharacters(in: .whitespaces), phoneTextfield.text != "" else {
            //Create alert here for something wrong
            return
        }
        guard let username = usernameTextfield.text?.lowercased().trimmingCharacters(in: .whitespaces), usernameTextfield.text != "" else {
            //Create alert here for something wrong
            return
        }
        guard let fullname = fullnameTextfield.text?.trimmingCharacters(in: .whitespaces), fullnameTextfield.text != "" else {
            //Create alert here for something wrong
            return
        }

        UserService.checkForExistingUsername(username: username, completion: { (isTaken) in
            
            if isTaken {
                //Show alert for taken
            } else {
                //let phoneNumber = "+10000000000"
                PhoneAuthProvider.provider().verifyPhoneNumber(phoneNum, uiDelegate: nil) { (verificationID, error) in
                    if let err = error {
                        //Show error here
                        print(err.localizedDescription)
                    } else {
                        self.username = username
                        self.fullname = fullname
                        self.confirmButton.hideLoader()
                        self.confirmButton.setTitleColor(.white, for: .normal)
                        UserDefaults.standard.set(verificationID, forKey: "authVerifyID")
                        UserDefaults.standard.set(phoneNum, forKey: "phoneNum")
                        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                        if let vc = mainStoryboard.instantiateViewController(withIdentifier: "VerifyVC") as? VerificationViewController {
                            vc.username = username
                            vc.fullname = fullname
                            self.present(vc, animated: true, completion: nil)
                        }
                    }
                }
            }
        })
    }
  
}
