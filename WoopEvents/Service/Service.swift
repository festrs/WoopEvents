//
//  APIManager.swift
//  WoopEvents
//
//  Created by Felipe Dias Pereira on 2019-05-29.
//  Copyright © 2019 FelipeP. All rights reserved.
//
import UIKit

public protocol NetworkEngine {
    typealias Handler = (Data?, URLResponse?, Error?) -> Void

    func performRequest(for urlRequest: URLRequest, completionHandler: @escaping Handler)
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
}

public class Service {
    private let engine: NetworkEngine
    private let decoder = JSONDecoder()

    enum Errors: Error {
        case dataObjectNil
        case noInternetError
        case alamoFireError(String)
        case unknown

        var errorDescription: String? {
            switch self {
            case .dataObjectNil:
                return localized(by: "ErrorDataObjectNil")

            case .noInternetError:
                return localized(by: "ErrorNoInternetError")

            case .alamoFireError(let errorMsg):
                return "\(localized(by: "ErrorDefault")) \n \(errorMsg)"

            case .unknown:
                return localized(by: "ErrorDefault")
            }
        }
    }

    // MARK: - Initialization
    public init(engine: NetworkEngine = URLSession.shared) {
        self.engine = engine
    }
}

extension Service: DataRequestable {
    public func request<T>(_ request: Request,
                           completion: @escaping (Result<T, Error>) -> Void) where T : Decodable {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true

        guard let urlRequest = request.urlRequest else {
            preconditionFailure("urlRequest malformed : \(String(describing: request.urlRequest))")
        }

        engine.performRequest(for: urlRequest) { (data, _, error) in
            DispatchQueue.main.async {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
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
