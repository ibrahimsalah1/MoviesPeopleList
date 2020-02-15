//
//  Person.swift
//  MoviesPeopleList
//
//  Created by Ibrahim Salah on 2/15/20.
//  Copyright © 2020 Ibrahim Salah. All rights reserved.
//

import Foundation
struct Person: Codable {
    let id:Int
    let department:String
    let name:String
    var profilePath:String?
    let gender: Int
    var popularity: Double?
    
    enum CodingKeys: String, CodingKey {
        case id, department = "known_for_department", name, profilePath = "profile_path", gender, popularity
    }
}
