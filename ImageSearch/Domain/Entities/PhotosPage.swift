//
//  PhotosPage.swift
//  ImageSearch
//
//  Created by doremin on 1/8/24.
//

import Foundation

struct PhotosPage {
  let totalPages: Int
  let photos: [Photo]
}

struct Photo {
  let id: Int
  let photographer: String
  let alt: String
  let imagePath: String?
  let liked: Bool
}
