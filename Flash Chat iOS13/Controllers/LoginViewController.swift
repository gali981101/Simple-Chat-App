//
//  LoginViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    
    
    @IBAction func loginPressed(_ sender: UIButton) {
        userLogIn()
    }
    
}


// MARK: - Log In

extension LoginViewController {
    
    private func userLogIn() {
        Auth.auth().signIn(withEmail: emailTextfield.text!, password: passwordTextfield.text!) { [self] authResult, error in
            errorHandler(error: error)
        }
    }
    
    private func errorHandler(error: Error?) {
        if let error = error {
            print(error)
        } else {
            performSegue(withIdentifier: Contants.loginSegue, sender: self)
        }
    }
    
}
