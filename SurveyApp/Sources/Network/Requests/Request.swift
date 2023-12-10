//
//  Request.swift
//  SurveyApp
//
//  Created by Sergey Teryokhin on 09/12/2023.
//

import Foundation

/// A protocol that defines the parameters required for making a network request.
protocol RequestParameters {
    var path: [String] { get }
    var method: Network.Method { get }
    var headers: [String: String] { get }
    var body: EncodableBody? { get }
}

/// A protocol that defines a method for transforming a request into a URL request.
protocol URLTransformable {
    /// Transforms the request into a URL request.
    /// - Parameter baseURL: The base URL to be used for constructing the URL request.
    /// - Returns: A URL request representing the transformed request.
    /// - Throws: An error if the transformation fails.
    func urlRequest(with baseURL: URL?) throws -> URLRequest
}

/// A protocol that combines the `RequestParameters` and `URLTransformable` protocols.
protocol Requestable: RequestParameters, URLTransformable {

}

/// A struct that represents a network request.
struct Request<Model: Decodable>: Requestable {
    var path: [String]
    var method: Network.Method
    var headers: [String: String]
    var body: EncodableBody?

    /// Initializes a new network request.
    /// - Parameters:
    ///   - path: The path components of the request URL.
    ///   - method: The HTTP method of the request.
    ///   - headers: The headers to be included in the request.
    ///   - body: The body of the request, if any.
    init(path: [String], method: Network.Method, headers: [String: String] = [:], body: EncodableBody? = nil) {
        self.path = path
        self.method = method
        self.headers = headers
        self.body = body
    }
}

/// A struct that represents an empty response.
public struct EmptyResponse: Decodable {}

extension Request: URLTransformable {
    func urlRequest(with baseURL: URL?) throws -> URLRequest {
        guard var url = baseURL else {
            throw Network.URLRequestError.noBaseURL
        }

        for pathComponent in path {
            url.appendPathComponent(pathComponent)
        }

        var urlRequest = URLRequest(url: url)
        for (header, value) in headers {
            urlRequest.addValue(value, forHTTPHeaderField: header)
        }

        urlRequest.httpMethod = method.rawValue
        try body?.encode(to: &urlRequest)

        return urlRequest
    }
}
