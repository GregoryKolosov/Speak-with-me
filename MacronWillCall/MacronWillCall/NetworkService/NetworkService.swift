//
//  NetworkService.swift
//  MacronWillCall
//
//  Created by Grigoriy Kolosov on 24.03.2022.
//

import Combine
import UIKit

enum NetworkService {}

extension NetworkService {
    static func answer(with question: String) -> AnyPublisher<String?, Never> {
        guard let url = URL(string: "https://api.openai.com/v1/answers") else {
          return Just("error").eraseToAnyPublisher()
        }
        
        let parameters = [
            "documents": ["I'm human", "I don't know"],
            "question" : question,
            "model": "curie",
            "examples_context": "test",
            "examples": [["and u", "test"]]
        ] as [String : Any]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(ApiConstants.GPT3ApiKey)", forHTTPHeaderField: "Authorization")
        
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else {
            return Just("error").eraseToAnyPublisher()
        }
        request.httpBody = httpBody

        
        return URLSession.shared.dataTaskPublisher(for: request)
            .print()
            .map(\.data)
            .decode(type: GPT3Answer.self, decoder: JSONDecoder())
            .map(\.answers)
            .map(\.first)
            .map { $0?.components(separatedBy: "\n").first }
            .replaceError(with: "error")
            .eraseToAnyPublisher()
    }
}

struct GPT3Answer: Decodable {
    let answers: [String]
}

/*
 {
   "answers": [
     "puppy A."
   ],
   "completion": "cmpl-2euVa1kmKUuLpSX600M41125Mo9NI",
   "model": "curie:2020-05-03",
   "object": "answer",
   "search_model": "ada",
   "selected_documents": [
     {
       "document": 0,
       "text": "Puppy A is happy. "
     },
     {
       "document": 1,
       "text": "Puppy B is sad. "
     }
   ]
 }
 */
