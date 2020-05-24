//
//  StudentLocationsResponse.swift
//  On the Map
//
//  Created by Laxman Nyamagouda on 4/25/20.
//  Copyright © 2020 Laxman Nyamagouda. All rights reserved.
//

import Foundation
import UIKit

struct StudentLocationsResponse : Codable {
    
    static var Location = [StudentLocationsResponse]()
    
    var createdAt : String?
    var firstName : String?
    var lastName : String?
    var latitude : Double?
    var longitude : Double?
    var mapString : String?
    var mediaURL : String?
    var objectId : String?
    var uniqueKey : String?
    var updatedAt : String?
    
}
extension StudentLocationsResponse {
    init(mapString: String, mediaURL: String) {
        self.mapString = mapString
        self.mediaURL = mediaURL
    }
}
