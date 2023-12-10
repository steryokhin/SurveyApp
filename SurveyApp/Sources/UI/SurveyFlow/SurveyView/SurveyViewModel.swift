//
//  SurveyViewModel.swift
//  SurveyApp
//
//  Created by Sergey Teryokhin on 10/12/2023.
//

import SwiftUI

enum Survey {
    /// Represents a question in the survey.
    struct Item {
        let id: Int
        let question: String
        var isSynchronised: Bool = false
        var answer: String? = nil
    }
}

protocol SurveyStarter {
    /// Starts the survey by loading the questions from the service.
    func startSurvey()
}

/// The protocol that defines the requirements for a survey view model.
protocol SurveyViewModelProtocol: ObservableObject, SurveyStarter {
    typealias Item = Survey.Item

    var items: [Item] { get }
    var isLoading: Bool { get }
    var error: UIError? { get }
    var currentItem: Item? { get }

    /// Moves to the next question in the survey.
    func goToNextQuestion()

    /// Moves to the previous question in the survey.
    func goToPreviousQuestion()

    /// Updates the answer for a specific question.
    /// - Parameter question: The question to be updated.
    func updateQuestion(_ question: Item)

    /// Creates a question view model for the current question.
    /// - Returns: The question view model.
    func createQuestionViewModel() -> QuestionViewModel
}

/// The view model for the survey view.
class SurveyViewModel: SurveyViewModelProtocol {
    @Published var items: [Item] = []
    @Published var isLoading = false
    @Published var error: UIError? = nil
    @Published var currentItem: Item? = nil

    var router: SurveyRouter
    let service: SurveyServiceProtocol

    init(
        router: SurveyRouter,
        service: SurveyServiceProtocol
    ) {
        self.router = router
        self.service = service
    }

    // MARK: - Survey Actions

    func goToNextQuestion() {
        guard let currentItem = currentItem,
              let currentIndex = items.firstIndex(where: { $0.id == currentItem.id }),
              currentIndex + 1 < items.count else {
            return
        }
        self.currentItem = items[currentIndex + 1]
    }

    func goToPreviousQuestion() {
        guard let currentItem = currentItem,
              let currentIndex = items.firstIndex(where: { $0.id == currentItem.id }),
              currentIndex > 0 else {
            return
        }
        self.currentItem = items[currentIndex - 1]
    }

    var answeredQuestionsCount: Int {
        items.compactMap { $0.answer }.count
    }

    func updateQuestion(_ question: Item) {
        if let index = items.firstIndex(where: { $0.id == question.id }) {
            items[index] = question
        }
    }

    func createQuestionViewModel() -> QuestionViewModel {
        let index = items.firstIndex {
            $0.id == currentItem?.id
        }
        let currentQuestionNumber = items.firstIndex {
            $0.id == currentItem?.id
        } ?? 0
        let totalQuestions = items.count
        let isLast = index == (items.count - 1)
        let isFirst = index == 0

        return QuestionViewModel(
            service: service,
            question: currentItem ?? .init(id: 0, question: ""),
            answeredQuestions: answeredQuestionsCount,
            currentQuestionNumber: currentQuestionNumber + 1,
            totalQuestions: totalQuestions,
            isLast: isLast,
            isFirst: isFirst,
            goToNextQuestion: { [weak self] in
                self?.goToNextQuestion()
            },
            goToPreviousQuestion: { [weak self] in
                self?.goToPreviousQuestion()
            },
            updateQuestion: { [weak self] question in
                self?.updateQuestion(question)
            }
        )
    }

    func startSurvey() {
        isLoading = true
        Task {
            let result = await service.getSurvey()
            await MainActor.run {
                isLoading = false
                switch result {
                    case .success(let questions):
                        self.items = questions.map { .init(id: $0.id, question: $0.question) }
                        self.currentItem = self.items.first
                        if questions.isEmpty {

                        } else {
                            router.navigate(to: .question)
                        }
                    case .failure(let error):
                        switch error {
                            case .urlRequestError:
                                self.error = .environmentError
                            case .deserializationError, .sendRequestError:
                                self.error = .backendError
                        }
                }
            }
        }
    }
}

