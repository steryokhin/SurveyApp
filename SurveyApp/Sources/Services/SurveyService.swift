//
//  SurveyService.swift
//  SurveyApp
//
//  Created by Sergey Teryokhin on 10/12/2023.
//

import Foundation

/// A protocol defining the methods for interacting with a survey service.
protocol SurveyServiceProtocol {
    
    /// Retrieves the survey questions.
    /// - Returns: A `Result` object containing either the survey questions or an error.
    func getSurvey() async -> Result<GetQuestionsRequest.Model, Network.RequestError>
    
    /// Submits an answer to a survey question.
    /// - Parameters:
    ///   - id: The ID of the question.
    ///   - answer: The answer to the question.
    /// - Returns: A `Result` object indicating the success or failure of the submission.
    func postAnswer(id: Int, answer: String) async -> Result<EmptyResponse, Network.RequestError>
}

/// A service for interacting with the survey API.
final class SurveyService: SurveyServiceProtocol {
    private var apiClient: APIClientProtocol

    init(apiClient: APIClientProtocol) {
        self.apiClient = apiClient
    }

    func getSurvey() async -> Result<GetQuestionsRequest.Model, Network.RequestError> {
        let request = GetQuestionsRequest.create()

        let response = await apiClient.sendRequest(request)
        return response
    }

    func postAnswer(id: Int, answer: String) async -> Result<EmptyResponse, Network.RequestError> {
        let request = PostQuestionSubmitRequest.create(id: id, answer: answer)

        let response = await apiClient.sendRequest(request)
        return response
    }
}
