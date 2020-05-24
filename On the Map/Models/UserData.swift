//
//  Data.swift
//  On the Map
//
//  Created by Laxman Nyamagouda on 5/24/20.
//  Copyright © 2020 Laxman Nyamagouda. All rights reserved.
//

import Foundation

class UserData {
    static let shared = UserData()
    var usersData = [Any?]()
    private init() { }
}
