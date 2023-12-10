//
//  RequestBody.swift
//  SurveyApp
//
//  Created by Sergey Teryokhin on 09/12/2023.
//

import Foundation

/// A protocol that defines the requirements for a request body.
public protocol RequestBody {
    /// Encodes the request body into the specified URL request.
    /// - Parameter urlRequest: The URL request to encode the body into.
    func encode(to urlRequest: inout URLRequest) throws
}

/// A struct that represents an encodable request body.
struct EncodableBody {
    /// The body data to be encoded.
    var body: [String: Any]?

    /// Initializes an `EncodableBody` with the specified body data.
    /// - Parameter body: The body data to be encoded.
    init(_ body: [String: Any]) {
        self.body = body
    }

    /// Encodes the body data into the specified URL request.
    /// - Parameter urlRequest: The URL request to encode the body into.
    /// - Throws: An error if the encoding process fails.
    func encode(to urlRequest: inout URLRequest) throws {
        guard let body else {
            return
        }

        urlRequest.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
    }
}
