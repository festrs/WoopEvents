//
//  APIManager.swift
//  WoopEvents
//
//  Created by Felipe Dias Pereira on 2019-05-29.
//  Copyright © 2019 FelipeP. All rights reserved.
//

import Foundation
import Alamofire

enum APIManagerErrors: Error {
    case dataObjectNil
    case noInternetError
    case alamoFireError(String)
    case unknown
}

extension APIManagerErrors: LocalizedError {
    // Can be logged to an error handler service
    var errorDescription: String? {
        switch self {
        case .dataObjectNil:
            return String.localized(by: "ErrorDataObjectNil")

        case .noInternetError:
            return String.localized(by: "ErrorNoInternetError")

        case .alamoFireError(let errorMsg):
            return "\(String.localized(by: "ErrorDefault")) \n \(errorMsg)"

        case .unknown:
            return String.localized(by: "ErrorDefault")
        }
    }
}

public class APIManager {
    private let baseUrl: String
    private let alamofireManager: Session
    private let decoder = JSONDecoder()

    // MARK: - Initialization
    public init(_ baseUrl: String = Environment.baseUrl, timeoutInterval: TimeInterval = 60) {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = timeoutInterval
        self.alamofireManager = Alamofire.Session(configuration: configuration)
        self.baseUrl = baseUrl
    }

    private func handleError(_ error: Error) -> APIManagerErrors {
        if let error = error as? URLError, error.code == .notConnectedToInternet {
            return .noInternetError
        } else if let afError = error.asAFError {
            return .alamoFireError(afError.localizedDescription)
        }
        return .unknown
    }
}

extension APIManager: APIManagerProtocol {
    public func request(with config: RequestConfig, completion: @escaping (Result<Bool, Error>) -> Void) {
        guard let url = URL(string: "\(baseUrl)\(config.path)") else {
            fatalError("Url malformed")
        }
        alamofireManager.request(url,
                                 method: config.method.getAlamofireHttpMethod(),
                                 parameters: config.parameters,
                                 encoding: config.encoding.getAlamofireEnconding(),
                                 headers: HTTPHeaders(config.headers))
            .validate()
            .responseData(queue: DispatchQueue.global(qos: .userInitiated)) { [weak self] response in
                guard let self = self else { return }
                if let error = response.error {
                    completion(Result.failure(self.handleError(error)))
                } else {
                    completion(Result.success(true))
                }
            }
    }

    public func requestObject<T>(with config: RequestConfig, completion: @escaping (Result<T, Error>) -> Void) where T: Decodable {
        guard let url = URL(string: "\(baseUrl)\(config.path)") else {
            fatalError("Url malformed")
        }
        alamofireManager.request(url,
                                 method: config.method.getAlamofireHttpMethod(),
                                 parameters: config.parameters,
                                 encoding: config.encoding.getAlamofireEnconding(),
                                 headers: HTTPHeaders(config.headers))
        .validate()
        .responseData(queue: DispatchQueue.global(qos: .userInitiated)) { [weak self] response in
            guard let self = self else { return }
                if let error = response.error {
                    completion(Result.failure(self.handleError(error)))
                } else {
                    guard let data = response.data else {
                        completion(Result.failure(APIManagerErrors.dataObjectNil))
                        return
                    }
                    do {
                        if let dateDecodingStrategy = config.dateDecodeStrategy {
                            self.decoder.dateDecodingStrategy = dateDecodingStrategy
                        }
                        let object = try self.decoder.decode(T.self, from: data)
                        completion(Result.success(object))
                    } catch let error {
                        completion(Result.failure(error))
                    }
                }
        }
    }
}
