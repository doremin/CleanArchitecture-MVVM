//
//  SearchPhotosUseCase.swift
//  ImageSearch
//
//  Created by doremin on 1/15/24.
//

import Foundation

protocol SearchPhotosUseCase {
  func execute(request: SearchPhotosUseCaseRequest) async throws -> PhotosPage
}

final class SearchPhotosUseCaseImpl: SearchPhotosUseCase {
  private let photosRepository: PhotosRepository
  
  init(photosRepository: PhotosRepository) {
    self.photosRepository = photosRepository
  }
  
  func execute(request: SearchPhotosUseCaseRequest) async throws -> PhotosPage {
    return try await photosRepository.fetchPhotos(
      query: PhotoQuery(query: request.query),
      page: request.page)
  }
}

struct SearchPhotosUseCaseRequest {
  let query: String
  let page: Int
}
