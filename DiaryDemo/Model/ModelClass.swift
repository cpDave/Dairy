//
//  ModelClass.swift
//  MY DAIRY
//
//  Created by Cp on 29/05/20.
//  Copyright © 2020 Cp. All rights reserved.
//

import Foundation
struct notesModel: Codable {
    let id: String
    let title: String
    let content: String
    let date: String
    private enum CodingKeys: String, CodingKey {
        case id
        case title
        case content
        case date
    }
}
