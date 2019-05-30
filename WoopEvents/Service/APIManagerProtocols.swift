//
//  APIManagerProtocols.swift
//  WoopEvents
//
//  Created by Felipe Dias Pereira on 2019-05-29.
//  Copyright © 2019 FelipeP. All rights reserved.
//

import Foundation
import Alamofire

public protocol APIManagerProtocol: AnyObject {
    func getObjectArrayFailable<T: Decodable>(with config: RequestConfig, completion: @escaping (Result<[T], Error>) -> Void)
}

public struct RequestConfig {
    var path: String
    var method: APIMethod
    var encoding: APIEncoding
    var parameters: [String : Any]
    var headers: [String : String]
    var dateDecodeStrategy: JSONDecoder.DateDecodingStrategy?

    public init(path: String,
                method: APIMethod = .get,
                encoding: APIEncoding = .default,
                parameters: [String: Any] = [:],
                headers: [String : String] = [:],
                dateDecodeStrategy: JSONDecoder.DateDecodingStrategy? = nil) {
        self.path = path
        self.method = method
        self.encoding = encoding
        self.parameters = parameters
        self.headers = headers
        self.dateDecodeStrategy = dateDecodeStrategy
    }
}

public enum APIMethod: String {
    case options, get, head, post, put, patch, delete, trace, connect

    public func getAlamofireHttpMethod() -> HTTPMethod {
        switch self {
        case .get:
            return HTTPMethod.get

        case .options:
            return HTTPMethod.options

        case .head:
            return HTTPMethod.head

        case .post:
            return HTTPMethod.post

        case .patch:
            return HTTPMethod.patch

        case .delete:
            return HTTPMethod.delete

        case .trace:
            return HTTPMethod.trace

        case .connect:
            return HTTPMethod.connect

        case .put:
            return HTTPMethod.put
        }
    }
}

public enum APIEncoding: String {
    case `default`
    case url

    public func getAlamofireEnconding() -> ParameterEncoding {
        switch self {
        case .url:
            return URLEncoding.default

        case .default:
            return JSONEncoding.default
        }
    }
}

protocol APIRoute {
    var config: RequestConfig { get }
}
