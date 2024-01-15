//
//  PhotosListTableViewCell.swift
//  ImageSearch
//
//  Created by doremin on 1/16/24.
//

import UIKit

final class PhotosListTableViewCell: UITableViewCell {
  static let identifier = NSStringFromClass(PhotosListTableViewCell.self)
  
  private let searchImageView = UIImageView()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    contentView.addSubview(searchImageView)
    searchImageView.snp.makeConstraints { make in
      make.width.height.equalTo(150)
      make.center.equalToSuperview()
    }
  }
  
  func config(url: URL?) {
    guard let url = url else { return }
    
    searchImageView.load(url: url)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    
    self.searchImageView.image = nil
  }
}
