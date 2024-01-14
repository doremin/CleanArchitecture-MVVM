//
//  Endpoint.swift
//  ImageSearch
//
//  Created by doremin on 1/14/24.
//

import Foundation

enum EndpointError: Error {
  case generationFail
}

extension EndpointError: LocalizedError {
  var errorDescription: String? {
    switch self {
    default: NSLocalizedString("Endpoint Error", comment: "Endpoint Error")
    }
  }
}

struct Endpoint {
  let method: HTTPMethod
  let path: String
  let bodyParameters: [String: Any]
  let queryParameters: [String: String]?
  
  init(
    method: HTTPMethod,
    path: String,
    bodyParameters: [String: Any] = [:],
    queryParameters: [String: String]? = nil)
  {
    self.method = method
    self.path = path
    self.bodyParameters = bodyParameters
    self.queryParameters = queryParameters
  }
  
  func url(config: RequestConfigurable) throws -> URL {
    let baseURLString = config.baseURLString.last == "/"
    ? config.baseURLString
    : config.baseURLString + "/"
    
    let endpoint = baseURLString.appending(path)
    guard var urlComponents = URLComponents(string: endpoint) else {
      throw EndpointError.generationFail
    }
    
    urlComponents.queryItems = self.queryParameters?
      .map { URLQueryItem(name: $0, value: $1) }
    
    guard let url = urlComponents.url else {
      throw EndpointError.generationFail
    }
    
    return url
  }
  
  func urlRequest(config: RequestConfigurable) throws -> URLRequest {
    let url = try self.url(config: config)
    var request = URLRequest(url: url)
    request.allHTTPHeaderFields = config.headers
    request.timeoutInterval = config.timeoutInterval
    request.httpMethod = method.rawValue
    
    if !bodyParameters.isEmpty {
      request.httpBody = try? JSONSerialization.data(withJSONObject: bodyParameters)
    }
    
    return request
  }
}

protocol RequestConfigurable {
  var baseURLString: String { get }
  var timeoutInterval: TimeInterval { get }
  var headers: [String: String] { get }
  
}

struct RequestConfig: RequestConfigurable{
  let baseURLString: String
  let timeoutInterval: TimeInterval
  let headers: [String : String]
  
  init(
    baseURLString: String,
    timeoutInterval: TimeInterval = 30,
    headers: [String : String])
  {
    self.baseURLString = baseURLString
    self.timeoutInterval = timeoutInterval
    self.headers = headers
  }
}
