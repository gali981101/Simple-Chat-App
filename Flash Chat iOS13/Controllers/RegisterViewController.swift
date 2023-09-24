//
//  RegisterViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit
import FirebaseAuth

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    
    @IBAction func registerPressed(_ sender: UIButton) {
        register()
    }
    
}


// MARK: - Auth

extension RegisterViewController {
    
    private func register() {
        Auth.auth().createUser(withEmail: emailTextfield.text!, password: passwordTextfield.text!) { [self] authResult, error in
            errorCheck(error: error)
        }
    }
    
    private func errorCheck(error: Error?) {
        if let error = error {
            print(error.localizedDescription)
        } else {
            performSegue(withIdentifier: Contants.registerSegue, sender: self)
        }
    }
    
}
