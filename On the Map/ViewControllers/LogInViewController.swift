//
//  ViewController.swift
//  On the Map
//
//  Created by Laxman Nyamagouda on 4/25/20.
//  Copyright © 2020 Laxman Nyamagouda. All rights reserved.
//

import UIKit

class LogInViewController: UIViewController {

    //MARK:- IBOutlets
    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var userNameTxField: UITextField!
    @IBOutlet weak var passwordTxField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    
    
    
    //MARK:- Variables
    var viewModel = LogInViewModel()
    
    //MARK:- Lify cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func signUpClicked(_ sender: Any) {
        if let url = URL(string: "https://www.udacity.com/account/auth#!/signup") {
            UIApplication.shared.open(url, options: [:])
        }
    }
    
    @IBAction func logInClciked(_ sender: Any) {
        
        let email = userNameTxField.text?.trimmingCharacters(in: CharacterSet.whitespaces)
        let password = passwordTxField.text?.trimmingCharacters(in: CharacterSet.whitespaces)
        
        let (valid, message) = viewModel.validateLogInCredentials(email: email, password: password)
        if !valid {
            showLogInAlert("LogIn", message: message)
            return
        }
        viewModel.callLogInService(email, password) { (data, error) in
            guard data?.session != nil else {
                DispatchQueue.main.async {
                    self.showLogInAlert("Log In Failed", message: "Log in failed. Please retry after sometime!")
                }
                return
            }
            print("Success log in")
            DispatchQueue.main.async {   
                if let mapAndTableController = self.storyboard?.instantiateViewController(withIdentifier: "MapAndTableController") {
                    self.present(mapAndTableController, animated: true, completion: nil)
                }
            }
        }
    }
    
    // MARK: - UI
     fileprivate func showLogInAlert(_ str: String, message: String) {
         
         let alertController = UIAlertController(title: "Udacity", message: "\(message)", preferredStyle:UIAlertController.Style.alert)
         
         alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
         { action -> Void in
             
         })
         self.present(alertController, animated: true, completion: nil)
     }
    
}

