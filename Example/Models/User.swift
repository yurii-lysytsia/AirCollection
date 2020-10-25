//
//  User.swift
//  AirCollection
//
//  Created by Lysytsia Yurii on 04.10.2020.
//  Copyright © 2020 Lysytsia Yurii. All rights reserved.
//

import Foundation

class User {
    
    var name: String
    var birthdate: Date?
    var gender: Gender?
    
    init(name: String) {
        self.name = name
    }
    
    enum Gender: String, CaseIterable {
        case male
        case female
        case other
    }
    
}
