//
//  APIManagerProtocols.swift
//  Networking
//
//  Created by Felipe Dias Pereira on 2019-05-29.
//  Copyright © 2019 FelipeP. All rights reserved.
//

import Foundation

public struct Request {
    public let endpoint: Endpoint
    public let method: Method
    public let headers: [String : String]
    public let bodyParameters: [String : Any]
    public let dateDecodeStrategy: JSONDecoder.DateDecodingStrategy?

    // MARK: Method

    public enum Method: String {
        case post = "POST"
        case get = "GET"
        case put = "PUT"
        case patch = "PATCH"
        case delete = "DELETE"
    }

    public init(endpoint: Endpoint,
         method: Method = .get,
         headers: [String: String] = [:],
         bodyParameters: [String : Any] = [:],
         dateDecodeStrategy: JSONDecoder.DateDecodingStrategy? = nil) {
        self.endpoint = endpoint
        self.method = method
        self.headers = headers
        self.bodyParameters = bodyParameters
        self.dateDecodeStrategy = dateDecodeStrategy
    }
}

extension Request {
    var urlRequest: URLRequest? {
        guard let url = endpoint.url else { return nil }

        var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData)

        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = method.rawValue

        if !bodyParameters.isEmpty,
            let httpBody = try? JSONSerialization.data(withJSONObject: bodyParameters, options: []) {
        	request.httpBody = httpBody
        }

        for header in headers {
            request.addValue(header.key, forHTTPHeaderField: header.value)
        }

        return request
    }
}

// MARK: Endpoint

public struct Endpoint {
    var baseUrl: URL
    let path: String
    let queryItems: [URLQueryItem] = []

  public init(path: String) {
    baseUrl = URL(fileURLWithPath: "")
    self.path = path
  }
}

extension Endpoint {
    var url: URL? {
        guard var components = URLComponents(url: baseUrl,
                                             resolvingAgainstBaseURL: true) else {
            preconditionFailure("Cannot load baseUrl: \(baseUrl)")
        }

        components.path = path
        components.queryItems = queryItems

        return components.url
    }
}
