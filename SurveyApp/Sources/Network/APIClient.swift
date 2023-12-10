//
//  APIClient.swift
//  SurveyApp
//
//  Created by Sergey Teryokhin on 09/12/2023.
//

import Foundation

/// The network module for making API requests.
enum Network {
    /// The HTTP methods for API requests.
    enum Method: String {
        case GET
        case POST
    }

    /// Errors that can occur during API requests.
    enum RequestError: Swift.Error {
        case urlRequestError(URLRequestError)
        case deserializationError
        case sendRequestError
    }

    /// Errors related to URL requests.
    enum URLRequestError: Swift.Error {
        case noBaseURL
        case wrongURL
        case encodingFailure
    }
}

/// A factory for creating URLSession instances.
enum URLSessionFactory {
    /// Creates a URLSession instance with default configuration.
    static func create() -> URLSession {
        let configuration = URLSessionConfiguration.default
        
        return URLSession(
            configuration: configuration,
            delegate: nil,
            delegateQueue: nil
        )
    }
}

/// A factory for creating APIClient instances.
enum APIClientFactory {
    /// Creates an APIClient instance with the specified base URL and URLSession.
    static func create() -> APIClientProtocol {
        let urlSession = URLSessionFactory.create()

        return APIClient(
            baseURL: URL(string: AppConfig.baseURL),
            session: urlSession
        )
    }
}

/// A protocol for making API requests.
protocol APIClientProtocol {
    /// Sends an API request and returns the result.
    /// - Parameters:
    ///   - request: The request to be sent.
    /// - Returns: The result of the API request.
    func sendRequest<Model>(_ request: Request<Model>) async -> Result<Model, Network.RequestError>
}

/// An implementation of the APIClientProtocol.
final class APIClient: APIClientProtocol {
    let baseURL: URL?
    let session: URLSession

    /// Initializes an APIClient instance with the specified base URL and URLSession.
    /// - Parameters:
    ///   - baseURL: The base URL for API requests.
    ///   - session: The URLSession to be used for API requests.
    public init(
        baseURL: URL?,
        session: URLSession = .shared
    ) {
        self.baseURL = baseURL
        self.session = session
    }

    func sendRequest<Model>(_ request: Request<Model>) async -> Result<Model, Network.RequestError> {
        do {
            let urlRequest = try request.urlRequest(with: baseURL)
            let (data, response) = try await session.data(for: urlRequest)

            guard let httpResponse = response as? HTTPURLResponse else {
                throw Network.RequestError.deserializationError
            }

            let statusCode = httpResponse.statusCode

            if statusCode == 200 && data.isEmpty {
                if let emptyResponse = EmptyResponse() as? Model {
                    return .success(emptyResponse)
                } else {
                    throw Network.RequestError.deserializationError
                }
            } else {
                let model = try JSONDecoder().decode(Model.self, from: data)
                return .success(model)
            }
        } catch let error as Network.RequestError {
            return .failure(error)
        } catch {
            return .failure(.sendRequestError)
        }
    }
}
