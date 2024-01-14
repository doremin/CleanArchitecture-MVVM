//
//  APIEndpoints.swift
//  ImageSearch
//
//  Created by doremin on 1/14/24.
//

import Foundation

enum APIEndpoints { }

extension APIEndpoints {
  static func getPhotos(with photoRequestDTO: PhotoRequestDTO) -> Endpoint {
    return Endpoint(
      method: .get,
      path: "v1/search",
      queryParameters: [
        "query": photoRequestDTO.query,
        "per_page": "\(photoRequestDTO.perPage)",
        "page": "\(photoRequestDTO.page)"
      ]
    )
  }
}
