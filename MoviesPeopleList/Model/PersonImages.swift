//
//  Image.swift
//  MoviesPeopleList
//
//  Created by Ibrahim Salah on 2/17/20.
//  Copyright © 2020 Ibrahim Salah. All rights reserved.
//

import Foundation
struct PersonImages:Codable {
    let profiles: [Image]
}

struct Image:Codable {
    let imagePath:String
    enum CodingKeys: String, CodingKey {
        case imagePath = "file_path"
    }
}
