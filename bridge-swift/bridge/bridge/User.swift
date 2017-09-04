//
//  User.swift
//  switcharoo
//
//  Created by Konstantin Yurchenko on 12/3/15.
//  Copyright © 2015 Play Entertainment LLC. All rights reserved.
//

import UIKit
import MapKit

class User: NSObject {
    var id: Int = 0
    var email: String
    var auth_token: String
    var is_student: Bool
    var is_instructor: Bool
    var profile_id: Int = 0
    var location: CLLocation
    
    var facebook_first_name: String = ""
    var facebook_last_name: String = ""
    var facebook_picture_url: String = ""
    
    init(id: Int, email: String, auth_token: String, is_student: Bool, is_instructor: Bool, location: CLLocation) {
        self.id = id
        self.email = email
        self.auth_token = auth_token
        self.is_student = is_student
        self.is_instructor = is_instructor
        self.location = location
    }
    
    func destroy() {
        self.id = 0
        self.email = ""
        self.auth_token = ""
        self.is_student = false
        self.is_instructor = false
    }
}
