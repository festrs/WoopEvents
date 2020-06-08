//
//  APIManager.swift
//  Networking
//
//  Created by Felipe Dias Pereira on 2019-05-29.
//  Copyright © 2019 FelipeP. All rights reserved.
//
import UIKit
import Combine

public protocol NetworkEngine {
    typealias Handler = (Data?, URLResponse?, Error?) -> Void

    func performRequest(for urlRequest: URLRequest, completionHandler: @escaping Handler)
    @available(iOS 13.0, *)
    func dataTaskPublisher(for request: URLRequest) -> URLSession.DataTaskPublisher
}

extension URLSession: NetworkEngine {
    public typealias Handler = NetworkEngine.Handler

    public func performRequest(for urlRequest: URLRequest, completionHandler: @escaping Handler) {
        let task = dataTask(with: urlRequest, completionHandler: completionHandler)
        task.resume()
    }
}

// MARK: DataRequestable

public protocol DataRequestable: AnyObject {
    func request<T: Decodable>(_ request: Request, completion: @escaping (Result<T, Error>) -> Void)
    @available(iOS 13.0, *)
    func request<T>(_ request: Request) -> AnyPublisher<T, Error> where T: Decodable
}

public class Service {
    private let engine: NetworkEngine
    private let decoder = JSONDecoder()

    enum Errors: Error {
        case dataObjectNil
        case noInternetError
        case network(description: String)
        case parsing(description: String)
        case unknown

        var errorDescription: String? {
            switch self {
            case .network(let errorMsg):
                return "network error = \(errorMsg)"

            case .parsing(let errorMsg):
                return "parsing error = \(errorMsg)"

            case .dataObjectNil:
                return ""

            case .noInternetError:
                return ""

            case .unknown:
                return ""
            }
        }
    }

    // MARK: - Initialization
    public init(engine: NetworkEngine = URLSession.shared) {
        self.engine = engine
    }
}

private extension Service {
    @available(iOS 13.0, *)
    func decode<T: Decodable>(_ data: Data, and decoder: JSONDecoder) -> AnyPublisher<T, Error> {
        Just(data)
            .decode(type: T.self, decoder: decoder)
            .mapError { error in
                Errors.parsing(description: error.localizedDescription)
        }
        .eraseToAnyPublisher()
    }
}

extension Service: DataRequestable {
    @available(iOS 13.0, *)
    public func request<T>(_ request: Request) -> AnyPublisher<T, Error> where T: Decodable {
        guard let urlRequest = request.urlRequest else {
            preconditionFailure("urlRequest malformed : \(String(describing: request.urlRequest))")
        }

        let decoder = JSONDecoder()
        if let dateDecodingStrategy = request.dateDecodeStrategy {
            decoder.dateDecodingStrategy = dateDecodingStrategy
        }

        return engine.dataTaskPublisher(for: urlRequest)
            .mapError { error in
                if error.code == .notConnectedToInternet {
                    return Errors.noInternetError
                } else {
                    return Errors.network(description: error.localizedDescription)
                }
        }
        .flatMap(maxPublishers: .max(1)) { pair in
            self.decode(pair.data, and: decoder)
        }
        .eraseToAnyPublisher()
    }

    public func request<T>(_ request: Request,
                           completion: @escaping (Result<T, Error>) -> Void) where T : Decodable {
        guard let urlRequest = request.urlRequest else {
            preconditionFailure("urlRequest malformed : \(String(describing: request.urlRequest))")
        }

        engine.performRequest(for: urlRequest) { (data, _, error) in
            if let error = error {
                if let nsError = error as? URLError,
                    nsError.code == .notConnectedToInternet {
                    completion(.failure(Errors.noInternetError))
                } else {
                    completion(.failure(error))
                }
            } else if let data = data {

                do {
                    if let dateDecodingStrategy = request.dateDecodeStrategy {
                        self.decoder.dateDecodingStrategy = dateDecodingStrategy
                    }
                    let object = try self.decoder.decode(T.self, from: data)
                    completion(Result.success(object))
                } catch let error {
                    completion(Result.failure(error))
                }
            } else {

                completion(.failure(Errors.dataObjectNil))
            }
        }
    }
}
