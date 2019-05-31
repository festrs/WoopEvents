//
//  APIManager.swift
//  WoopEvents
//
//  Created by Felipe Dias Pereira on 2019-05-29.
//  Copyright © 2019 FelipeP. All rights reserved.
//

import Foundation
import Alamofire

public class APIManager {
    private let baseUrl: String
    private let alamofireManager: Session

    enum APIManagerErrors: Error {
        case dataObjectNil
    }
    
    // MARK: - Initialization
    public init(_ baseUrl: String = Environment.baseUrl, timeoutInterval: TimeInterval = 60) {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = timeoutInterval
        self.alamofireManager = Alamofire.Session(configuration: configuration)
        self.baseUrl = baseUrl
    }
}

extension APIManager: APIManagerProtocol {
    public func requestObjectArrayFailable<T>(with config: RequestConfig,
                                          completion: @escaping (Result<[T], Error>) -> Void) where T: Decodable {
        guard let url = URL(string: "\(baseUrl)\(config.path)") else {
            fatalError("Url malformed")
        }
        alamofireManager.request(url,
                                 method: config.method.getAlamofireHttpMethod(),
                                 parameters: config.parameters,
                                 encoding: config.encoding.getAlamofireEnconding(),
                                 headers: HTTPHeaders(config.headers))
            .validate()
            .responseData(queue: DispatchQueue.global(qos: .userInitiated)) { response in
                if let error = response.error {
                    completion(Result.failure(error))
                } else {
                    guard let data = response.data else {
                        completion(Result.failure(APIManagerErrors.dataObjectNil))
                        return
                    }
                    do {
                        let decoder = JSONDecoder()
                        if let dateDecodingStrategy = config.dateDecodeStrategy {
                            decoder.dateDecodingStrategy = dateDecodingStrategy
                        }
                        let object = try decoder.decode([FailableDecodable<T>].self, from: data).compactMap { $0.base }
                        completion(Result.success(object))
                    } catch let error {
                        completion(Result.failure(error))
                    }
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
            .responseData(queue: DispatchQueue.global(qos: .userInitiated)) { response in
                if let error = response.error {
                    completion(Result.failure(error))
                } else {
                    guard let data = response.data else {
                        completion(Result.failure(APIManagerErrors.dataObjectNil))
                        return
                    }
                    do {
                        let decoder = JSONDecoder()
                        if let dateDecodingStrategy = config.dateDecodeStrategy {
                            decoder.dateDecodingStrategy = dateDecodingStrategy
                        }
                        let object = try decoder.decode(T.self, from: data)
                        completion(Result.success(object))
                    } catch let error {
                        completion(Result.failure(error))
                    }
                }
        }
    }
}
