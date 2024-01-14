//
//  PhotoResponseDTO.swift
//  ImageSearch
//
//  Created by doremin on 1/8/24.
//

import Foundation

struct PhotoResponseDTO: Decodable {
  private enum CodingKeys: String, CodingKey {
    case page
    case totalResults = "total_results"
    case photos
    case perPage = "per_page"
  }
  
  let page: Int
  let totalResults: Int
  let perPage: Int
  let photos: [PhotoDTO]
}

extension PhotoResponseDTO {
  struct PhotoDTO: Decodable {
    private enum CodingKeys: String, CodingKey {
      case id
      case liked
      case photographer
      case source = "src"
      case alt
    }
    
    let id: Int
    let alt: String
    let liked: Bool
    let photographer: String
    let source: PhotoSourceDTO
  }
}

extension PhotoResponseDTO.PhotoDTO {
  struct PhotoSourceDTO: Decodable {
    let original: String?
    let large: String?
    let medium: String?
    let small: String?
    let tiny: String?
  }
}

// MARK: - Mapping to Domain
extension PhotoResponseDTO {
  var domain: PhotosPage {
    .init(
      totalPages: page,
      photos: photos.map { $0.domain })
  }
}

extension PhotoResponseDTO.PhotoDTO {
  var domain: Photo {
    .init(
      id: id,
      photographer: photographer,
      alt: alt,
      imagePath: source.small,
      liked: liked)
  }
}
