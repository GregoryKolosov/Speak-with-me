//
//  MainViewModel.swift
//  MacronWillCall
//
//  Created by Grigoriy Kolosov on 24.03.2022.
//

import Foundation
import Combine

final class MainViewModel: ObservableObject {
    // MARK: - Input
    @Published var question: String = ""
    @Published var sendRequestTrigger: Void? = nil
    
    // MARK: - Output
    @Published var answer: String? = nil
    
    // MARK: - Properties
    private var cancellables = [AnyCancellable]()
    
    // MARK: - Lifecycle
    init() {
        subscribe()
    }
    
    // MARK: - Functions
    private func subscribe() {
        $sendRequestTrigger
            .compactMap { $0 }
            .combineLatest($question, { _, question -> String in
                return question
            })
            .flatMap { question in
                openApiClient.dispatch(OpenApiCompletionRequest(question: question))
            }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { result in },
                  receiveValue: { value in
                    self.answer = value.choices.first?.text
                    self.sendRequestTrigger = nil
            })
            .store(in: &cancellables)
    }
}
