//
//  RequestFactory.swift
//  SurveyApp
//
//  Created by Sergey Teryokhin on 10/12/2023.
//

import Foundation

/// A request for getting a list of questions.
enum GetQuestionsRequest {
    typealias Model = [Question]
    
    /// Represents a question.
    struct Question: Decodable {
        var id: Int
        var question: String
    }

    /// Creates a request for getting questions.
    /// - Returns: A request object.
    static func create() -> Request<Model> {
        let path = ["questions"]
        let method = Network.Method.GET
        let headers: [String: String] = [:]
        let body: EncodableBody? = nil

        return Request(path: path, method: method, headers: headers, body: body)
    }
}

/// A request for submitting a question answer.
enum PostQuestionSubmitRequest {
    /// Creates a request for submitting a question answer.
    /// - Parameters:
    ///   - id: The ID of the question.
    ///   - answer: The answer to the question.
    /// - Returns: A request object.
    static func create(id: Int, answer: String) -> Request<EmptyResponse> {
        let path = ["question", "submit"]
        let method = Network.Method.POST
        let headers: [String: String] = [:]
        let body = EncodableBody([
            "id": id,
            "answer": answer
        ])

        return Request(path: path, method: method, headers: headers, body: body)
    }
}
