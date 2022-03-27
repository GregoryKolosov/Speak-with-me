//
//  NetworkService.swift
//  MacronWillCall
//
//  Created by Grigoriy Kolosov on 24.03.2022.
//

import Combine
import UIKit

struct NetworkService {
    let urlSession: URLSession!
    static let shared = NetworkService()
    
    public init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }
    
    func dispatch<ReturnType: Codable>(request: URLRequest) -> AnyPublisher<ReturnType, NetworkRequestError> {
        return urlSession
            .dataTaskPublisher(for: request)
            .print()
            .tryMap({ data, response in
                if let response = response as? HTTPURLResponse,
                   !(200...299).contains(response.statusCode) {
                    throw httpError(response.statusCode)
                }

                return data
            })
            .decode(type: ReturnType.self, decoder: JSONDecoder())
            .mapError { error in
                handleError(error)
            }
            .eraseToAnyPublisher()
    }
}

extension NetworkService {
    private func httpError(_ statusCode: Int) -> NetworkRequestError {
        switch statusCode {
        case 400: return .badRequest
        case 401: return .unauthorized
        case 403: return .forbidden
        case 404: return .notFound
        case 402, 405...499: return .error4xx(statusCode)
        case 500: return .serverError
        case 501...599: return .error5xx(statusCode)
        default: return .unknownError
        }
    }
    
    private func handleError(_ error: Error) -> NetworkRequestError {
        switch error {
        case is Swift.DecodingError:
            return .decodingError
        case let urlError as URLError:
            return .urlSessionFailed(urlError)
        case let error as NetworkRequestError:
            return error
        default:
            return .unknownError
        }
    }
}

// MARK: Api
let openApiClient = APIClient(baseURL: "https://api.openai.com/v1")

// Requests
struct OpenApiCompletionRequest: Request {
    typealias ReturnType = GPT3Completion
    
    var body: [String : Any]?
    
    var path: String = "/engines/text-davinci-002/completions"
    var headers: [String : String]? = [
        "Authorization": "Bearer \(ApiConstants.GPT3ApiKey)",
        "Content-Type": "Application/json"
    ]
    var method: HTTPMethod = .post
    
    init(question: String) {
        self.body = [
            "prompt": question,
            "temperature": 0.9,
        ] as [String : Any]
    }
}


