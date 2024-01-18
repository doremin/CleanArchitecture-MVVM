//
//  PhotoRespository.swift
//  ImageSearch
//
//  Created by doremin on 1/14/24.
//

import Foundation

final class PhotosRepositoryImpl {
  
  private let service: APIService
  
  init(service: APIService) {
    self.service = service
  }
  
}

extension PhotosRepositoryImpl: PhotosRepository {
  func fetchPhotos(query: PhotoQuery, page: Int) async throws -> PhotosPage {
    let requestDTO = PhotoRequestDTO(query: query.query, page: page, perPage: 7)
    
    let endpoint = APIEndpoints.getPhotos(with: requestDTO)
    let response: PhotoResponseDTO = try await service.request(endpoint: endpoint)
    
    return response.domain
  }
}
