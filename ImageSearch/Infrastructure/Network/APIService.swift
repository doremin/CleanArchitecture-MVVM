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
  case generic(statusCode: Int)
  case castingFail
}

extension APIError: LocalizedError {
  var errorDescription: String? {
    switch self {
    case .invalidURL:
      return NSLocalizedString("Invalid URL", comment: "Invalid URL")
    case .jsonDecodeFail:
      return NSLocalizedString("JSON Decode Fail", comment: "JSON Decode Fail")
    default:
      return NSLocalizedString("Generic error", comment: "Generic error")
    }
  }
}

class APIService {
  
  let session: URLSession
  let config: RequestConfigurable
  let logger: NetworkLoggable
  
  init(
    session: URLSession = .shared,
    config: RequestConfigurable,
    logger: NetworkLoggable = NetworkLogger())
  {
    self.session = session
    self.config = config
    self.logger = logger
  }
  
  func request<T: Decodable>(endpoint: Endpoint) async throws -> T {
    let request = try endpoint.urlRequest(config: config)
    logger.log(request: request)
    let (data, response) = try await session.data(for: request)
    
    guard let httpResponse = response as? HTTPURLResponse else {
      let error = APIError.castingFail
      logger.log(error: error)
      throw error
    }
    
    try validateStatusCode(statusCode: httpResponse.statusCode)
    
    let decodedData: T = try jsonDecode(data: data)
    
    return decodedData
  }
  
  private func validateStatusCode(statusCode: Int) throws {
    switch statusCode {
    case (200 ..< 300):
      return
    default:
      throw APIError.generic(statusCode: statusCode)
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
