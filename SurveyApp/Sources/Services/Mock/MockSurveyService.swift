//
//  MockSurveyService.swift
//  SurveyApp
//
//  Created by Sergey Teryokhin on 10/12/2023.
//

import Foundation

/// A mock implementation of the `SurveyServiceProtocol` that provides dummy survey data and simulates network requests.
final class MockSurveyService: SurveyServiceProtocol {
    private var postAnswerCallCount = 0

    func getSurvey() async -> Result<GetQuestionsRequest.Model, Network.RequestError> {
        try? await Task.sleep(nanoseconds: 2 * 1_000_000_000)

        let questions = [
            GetQuestionsRequest.Question(id: 1, question: "Very long string to check how it fit to the screen. Some more lines and \n\n and two new lines"),
            GetQuestionsRequest.Question(id: 2, question: "Q2?"),
            GetQuestionsRequest.Question(id: 3, question: "Q3?"),
            GetQuestionsRequest.Question(id: 4, question: "Q4?"),
            GetQuestionsRequest.Question(id: 5, question: "Q5?"),
        ]
        return .success(questions)
    }

    func postAnswer(id: Int, answer: String) async -> Result<EmptyResponse, Network.RequestError> {
        try? await Task.sleep(nanoseconds: 2 * 1_000_000_000)

        postAnswerCallCount += 1
        if postAnswerCallCount % 2 == 1 {
            return .success(EmptyResponse())
        } else {
            return .failure(.urlRequestError(.wrongURL)) // or any other error you wish to simulate
        }
    }
}
