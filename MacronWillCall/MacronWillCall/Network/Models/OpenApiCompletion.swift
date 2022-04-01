//
//  OpenApiCompletion.swift
//  MacronWillCall
//
//  Created by Grigoriy Kolosov on 02.04.2022.
//

import Foundation

struct OpenApiCompletion: Codable {
    let choices: [Choice]
}

struct Choice: Codable {
    let text: String
}
