//
//  LogInResponse.swift
//  On the Map
//
//  Created by Laxman Nyamagouda on 5/23/20.
//  Copyright © 2020 Laxman Nyamagouda. All rights reserved.
//

import Foundation

// MARK: - LogInResponse
class LogInResponse: Codable {
    var account: Account?
    var session: Session?

    init(account: Account?, session: Session?) {
        self.account = account
        self.session = session
    }
}

// MARK: - Account
class Account: Codable {
    var registered: Bool?
    var key: String?

    init(registered: Bool?, key: String?) {
        self.registered = registered
        self.key = key
    }
}

// MARK: - Session
class Session: Codable {
    var id, expiration: String?

    init(id: String?, expiration: String?) {
        self.id = id
        self.expiration = expiration
    }
}
