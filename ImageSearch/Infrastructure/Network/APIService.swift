//
//  APIService.swift
//  ImageSearch
//
//  Created by doremin on 1/9/24.
//

import Foundation

enum HTTPMethod: String {
  case get = "GET"
  case post = "POST"
  case put = "PUT"
  case delete = "DELETE"
  case patch = "PATCH"
}

enum APIError: Error {
  case invalidURL
  case jsonDecodeFail
  case generic
  case notFound
}

extension APIError: LocalizedError {
  var errorDescription: String? {
    switch self {
    case .invalidURL:
      return NSLocalizedString("Invalid URL", comment: "Invalid URL")
    case .jsonDecodeFail:
      return NSLocalizedString("JSON Decode Fail", comment: "JSON Decode Fail")
    case .notFound:
      return NSLocalizedString("Not Found", comment: "Not Found")
    default:
      return NSLocalizedString("Generic error", comment: "Generic error")
    }
  }
}

class APIService {
  
  let session: URLSession
  let config: URLSessionConfiguration
  let logger: NetworkLoggable
  
  init(
    session: URLSession = .shared,
    config: URLSessionConfiguration = .default,
    logger: NetworkLoggable = NetworkLogger())
  {
    self.session = session
    self.config = config
    self.logger = logger
  }
  
  func request<T: Decodable>(endpoint: Endpoint) async throws -> T {
    do {
      let request = try endpoint.urlRequest()
      let (data, response) = try await session.data(for: request)
      
      guard let httpResponse = response as? HTTPURLResponse else {
        throw APIError.generic
      }
      
      if (400 ..< 500).contains(httpResponse.statusCode) {
        throw APIError.notFound
      }
      
      let decodedData: T = try jsonDecode(data: data)
      
      return decodedData
    } catch {
      logger.log(error: error)
      throw error
    }
  }
  
  private func jsonDecode<T: Decodable>(data: Data) throws -> T {
    do {
      let decodedData = try JSONDecoder().decode(T.self, from: data)
      
      return decodedData
    } catch {
      throw APIError.jsonDecodeFail
    }
  }
}

struct Endpoint {
  let path: String
  let method: HTTPMethod
  let baseURL: URL
  
  func url() throws -> URL {
    let baseURLString = baseURL.absoluteString.last != "/"
    ? baseURL.absoluteString + "/"
    : baseURL.absoluteString
    
    let endpoint = baseURLString.appending(path)
    
    guard let url = URL(string: endpoint) else {
      throw APIError.invalidURL
    }
    
    return url
  }
  
  func urlRequest() throws -> URLRequest {
    let url = try self.url()
    var request = URLRequest(url: url)
    request.httpMethod = method.rawValue
    
    return request
  }
}
