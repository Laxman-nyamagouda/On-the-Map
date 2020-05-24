//
//  StringExtension.swift
//  On the Map
//
//  Created by Laxman Nyamagouda on 5/23/20.
//  Copyright © 2020 Laxman Nyamagouda. All rights reserved.
//

import Foundation

extension String {
    
    //regex validations
    func isValid(pattern: String, options: NSRegularExpression.Options = .caseInsensitive) -> Bool {
        do {
            let regex = try NSRegularExpression.init(pattern: pattern, options: options)
            let matches = regex.matches(in: self, options: .reportProgress, range: NSRange.init(location: 0, length: count))
            return matches.count > 0
        } catch {
            print("error = \(error)")
        }
        return false
    }
    
    func isValidEmail() -> Bool {
        if self.count == 0 {
            return false
        }
        let isValidEmail = isValid(pattern: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}")
        return isValidEmail
    }
}
