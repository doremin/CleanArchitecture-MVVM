//
//  PhotosRepository.swift
//  ImageSearch
//
//  Created by doremin on 1/8/24.
//

import Foundation

protocol PhotosRepository {
  func fetchPhotos(
    query: PhotoQuery,
    page: Int) 
  async throws -> PhotosPage
}
