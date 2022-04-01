//
//  NetworkService.swift
//  MacronWillCall
//
//  Created by Grigoriy Kolosov on 02.04.2022.
//

import Combine
import Foundation

struct NetworkService: APIService {
    func request<T>(with builder: RequestBuilder) -> AnyPublisher<T, APIError> where T: Decodable {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        return URLSession.shared
            .dataTaskPublisher(for: builder.urlRequest)
            .receive(on: DispatchQueue.main)
            .mapError { _ in .unknown }
            .flatMap { data, response -> AnyPublisher<T, APIError> in
                if let response = response as? HTTPURLResponse {
                    if (200...299).contains(response.statusCode) {
                        
                    return Just(data)
                        .decode(type: T.self, decoder: decoder)
                        .mapError {_ in .decodingError}
                        .eraseToAnyPublisher()
                    } else {
                        return Fail(error: APIError.httpError(response.statusCode))
                            .eraseToAnyPublisher()
                    }
                }
                return Fail(error: APIError.unknown)
                        .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
}

protocol OpenApiService {
    var networService: APIService { get }
    
    func completion() -> AnyPublisher<OpenApiCompletion, APIError>
}

extension OpenApiService {
    func completion() -> AnyPublisher<OpenApiCompletion, APIError> {
        return networService.request(with: OpenApi.completion)
            .eraseToAnyPublisher()
    }
}
