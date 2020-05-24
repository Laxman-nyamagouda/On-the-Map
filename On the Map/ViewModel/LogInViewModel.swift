//
//  LogInViewModel.swift
//  On the Map
//
//  Created by Laxman Nyamagouda on 5/23/20.
//  Copyright © 2020 Laxman Nyamagouda. All rights reserved.
//

import Foundation


class LogInViewModel {
    
    
    // MARK: - Log In Service
      func callLogInService(_ email: String?, _ password: String?, completion:@escaping (_ result: LogInResponse?, _ error: Error?) -> Void) {
        NetworkMananger.shared.logInWithUdacityCredentials(email!, password!) { (logInResponse, error) in
            if let logInResponse = logInResponse, let _ = logInResponse.session {
                completion(logInResponse, nil)
            } else {
                completion(nil, error)
            }
        }
      }
    
    //Validate email and password
      func validateLogInCredentials(email: String?, password: String?) -> (Bool, String) {
          
          if let email = email, !email.isValidEmail() {
              return (false, "Invalid email. Please enter valid email")
          } else if let password = password, password.count <= 0 {
              return (false, "Invalid password. Please enter valid password")
          }
          return (true, "")
      }
    
}
