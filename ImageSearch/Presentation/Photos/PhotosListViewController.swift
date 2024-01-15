//
//  PhotosListViewController.swift
//  ImageSearch
//
//  Created by doremin on 1/15/24.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit

final class PhotosListViewController: BaseViewController {
  
  private let tableView = UITableView()
  private let searchBar = UISearchBar()
  private let indicator = UIActivityIndicatorView()
  
  private let viewModel: PhotosListViewModel
  
  init(viewModel: PhotosListViewModel) {
    self.viewModel = viewModel
    super.init()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupTableView()
    setupRx()
  }
  
  private func setupTableView() {
    tableView.rowHeight = 170
    tableView.register(PhotosListTableViewCell.self, forCellReuseIdentifier: PhotosListTableViewCell.identifier)
  }
  
  private func setupRx() {
    let didSelectPhoto = tableView.rx.modelSelected(Photo.self).asDriver()
    let didReachBottom = didReachBottom(offset: 150)
    let query = searchBar.rx.text
      .orEmpty
      .changed
      .asDriver()
    
    let input = PhotosListViewModel.Input(
      didSelectPhoto: didSelectPhoto,
      didReachBottom: didReachBottom, 
      searchButtonClicked: searchBar.rx.searchButtonClicked.asObservable(),
      query: query)
    
    let output = viewModel.transform(input: input)
    
    output.photosPages
      .map {
        $0.flatMap { $0.photos }
      }
      .bind(to: tableView.rx.items(
        cellIdentifier: PhotosListTableViewCell.identifier,
        cellType: PhotosListTableViewCell.self)) { row, element, cell in
          let url = URL(string: element.imagePath ?? "")
          cell.config(url: url)
        }
      .disposed(by: disposeBag)
    
    output.isFetching
      .drive(indicator.rx.isAnimating)
      .disposed(by: disposeBag)
    
  }
  
  private func didReachBottom(offset: CGFloat = 0.0) -> Observable<Void> {
    return tableView.rx.contentOffset
      .withUnretained(self)
      .map { owner, contentOffset in
        let contentHegiht = owner.tableView.contentSize.height
        let height = owner.tableView.frame.height
        
        return contentOffset.y > (contentHegiht - height - offset)
      }
      .distinctUntilChanged()
      .filter { $0 }
      .map { _ in () }
  }
  
  override func setupConstraints() {
    view.addSubview(searchBar)
    view.addSubview(tableView)
    view.addSubview(indicator)
    
    indicator.center = view.center
    indicator.color = .blue
    indicator.hidesWhenStopped = true
    
    searchBar.snp.makeConstraints { make in
      make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
      make.left.right.equalToSuperview()
      make.height.equalTo(50)
    }
    
    tableView.snp.makeConstraints { make in
      make.top.equalTo(searchBar.snp.bottom)
      make.left.right.bottom.equalToSuperview()
    }
  }
}
