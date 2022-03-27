//
//  OpenApi.swift
//  MacronWillCall
//
//  Created by Grigoriy Kolosov on 27.03.2022.
//

import Foundation
import Combine

struct APIClient {
    var baseURL: String!
    var networkDispatcher: NetworkService!
    init(
        baseURL: String,
        networkDispatcher: NetworkService = NetworkService()
    ) {
        self.baseURL = baseURL
        self.networkDispatcher = networkDispatcher
    }

    func dispatch<R: Request>(_ request: R) -> AnyPublisher<R.ReturnType, NetworkRequestError> {
        guard let urlRequest = request.asURLRequest(baseURL: baseURL) else {
            return Fail(
                outputType: R.ReturnType.self,
                failure: NetworkRequestError.badRequest
            )
            .eraseToAnyPublisher()
        }
        typealias RequestPublisher = AnyPublisher<R.ReturnType, NetworkRequestError>
        let requestPublisher: RequestPublisher = networkDispatcher.dispatch(request: urlRequest)
        return requestPublisher.eraseToAnyPublisher()
    }
}
