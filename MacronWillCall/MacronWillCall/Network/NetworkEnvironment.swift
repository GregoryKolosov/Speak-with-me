//
//  OpenApi.swift
//  MacronWillCall
//
//  Created by Grigoriy Kolosov on 02.04.2022.
//

import Foundation

enum OpenApi {
    case completion
}

extension OpenApi: RequestBuilder {
    var urlRequest: URLRequest {
        switch self {
        case .completion:
            guard let url = URL(string: "https://api.openai.com/v1/completion")
            else { preconditionFailure("Invalid URL format") }
            
            let request = URLRequest(url: url)
            return request
        }
        
    }
}
