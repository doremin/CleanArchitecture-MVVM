//
//  ViewModel.swift
//  ImageSearch
//
//  Created by doremin on 1/16/24.
//

import RxSwift

protocol ViewModel {
  associatedtype Input
  associatedtype Output
  
  var disposeBag: DisposeBag { get set }
  
  func transform(input: Input) -> Output
}
