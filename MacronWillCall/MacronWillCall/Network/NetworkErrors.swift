//
//  NetworkErrors.swift
//  MacronWillCall
//
//  Created by Grigoriy Kolosov on 02.04.2022.
//

enum APIError: Error {
    case decodingError
    case httpError(Int)
    case unknown
}
