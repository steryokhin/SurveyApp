//
//  QuestionViewModel.swift
//  SurveyApp
//
//  Created by Sergey Teryokhin on 09/12/2023.
//

import Foundation
import Combine

/// The protocol for the QuestionViewModel.
protocol QuestionViewModelProtocol: ObservableObject {
    var question: SurveyViewModel.Item { get }
    var currentAnswer: String { get set }
    var answeredQuestions: Int { get }
    var currentQuestionNumber: Int { get }
    var totalQuestions: Int { get }
    var isLast: Bool { get }
    var isFirst: Bool { get }
    var isLoading: Bool { get }
    var lastResult: Result<EmptyResponse, Network.RequestError>? { get }

    func onSuccess()
    func goNext()
    func goPrevious()
    func answeredQuestionCount() -> Int
    func postSurvey()
}

/// The view model for a question in the survey flow.
final class QuestionViewModel: QuestionViewModelProtocol {
    @Published var question: SurveyViewModel.Item
    @Published var currentAnswer: String
    @Published var answeredQuestions: Int
    @Published var currentQuestionNumber: Int
    @Published var totalQuestions: Int
    var isLast: Bool
    var isFirst: Bool
    @Published var isLoading: Bool = false
    @Published var lastResult: Result<EmptyResponse, Network.RequestError>? = nil

    let service: SurveyServiceProtocol

    var goToNextQuestion: () -> Void
    var goToPreviousQuestion: () -> Void
    var updateQuestion: (SurveyViewModel.Item) -> Void

    init(
        service: SurveyServiceProtocol,
        question: SurveyViewModel.Item,
        answeredQuestions: Int,
        currentQuestionNumber: Int,
        totalQuestions: Int,
        isLast: Bool,
        isFirst: Bool,
        goToNextQuestion: @escaping () -> Void,
        goToPreviousQuestion: @escaping () -> Void,
        updateQuestion: @escaping (SurveyViewModel.Item) -> Void
    ) {
        self.service = service
        self.question = question
        self.currentAnswer = question.answer ?? ""
        self.answeredQuestions = answeredQuestions
        self.currentQuestionNumber = currentQuestionNumber
        self.totalQuestions = totalQuestions
        self.isLast = isLast
        self.isFirst = isFirst
        self.goToNextQuestion = goToNextQuestion
        self.goToPreviousQuestion = goToPreviousQuestion
        self.updateQuestion = updateQuestion
    }

    /// Called when the question is successfully answered.
    func onSuccess() {
        question.isSynchronised = true
    }

    /// Indicates whether the "Next" button should be disabled.
    var isNextDisabled: Bool {
        isLast
    }

    /// Indicates whether the "Previous" button should be disabled.
    var isPreviousDisabled: Bool {
        isFirst
    }

    /// Moves to the next question.
    func goNext() {
        if case .success = lastResult {
            updateQuestion(question)
        }
        goToNextQuestion()
    }

    /// Moves to the previous question.
    func goPrevious() {
        if case .success = lastResult {
            updateQuestion(question)
        }
        goToPreviousQuestion()
    }

    /// Returns the count of answered questions.
    func answeredQuestionCount() -> Int {
        if case .success = lastResult {
            return answeredQuestions + 1
        } else {
            return answeredQuestions
        }
    }

    /// Posts the survey answer to the server.
    func postSurvey() {
        isLoading = true
        Task {
            let result = await service.postAnswer(
                id: question.id,
                answer: currentAnswer
            )

            await MainActor.run {
                isLoading = false
                question.answer = currentAnswer
                lastResult = result
                if case .success = result {
                    onSuccess()
                }
            }
        }
    }
}
