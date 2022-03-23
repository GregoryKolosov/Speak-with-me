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
    @Published var question: String = "Who are u?"
    
    // MARK: - Output
    @Published var answer: String? = nil
    
    // MARK: - Lifecycle
    init() {
        answerPublisher
            .assign(to: &$answer)
    }
    
    // MARK: - Publishers
    private lazy var answerPublisher: AnyPublisher<String?, Never> = {
        $question
            .flatMap { question in
                NetworkService.answer(with: question)
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }()
}
