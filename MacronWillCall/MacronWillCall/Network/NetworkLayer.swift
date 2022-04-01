//
//  NetworkLayer.swift
//  MacronWillCall
//
//  Created by Grigoriy Kolosov on 02.04.2022.
//

import Foundation
import Combine

protocol APIService {
    func request<T: Decodable>(with builder: RequestBuilder) -> AnyPublisher<T, APIError>
}

protocol RequestBuilder {
    var urlRequest: URLRequest {get}
}
