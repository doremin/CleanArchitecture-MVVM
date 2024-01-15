//
//  PhotosListViewModel.swift
//  ImageSearch
//
//  Created by doremin on 1/15/24.
//

import RxCocoa
import RxSwift

final class PhotosListViewModel: ViewModel {
  
  // MARK: State
  let isFetching = BehaviorRelay<Bool>(value: false)
  let photosPages = BehaviorSubject<[PhotosPage]>(value: [])
  let errorSubject = PublishSubject<Error>()
  var page = 1
  
  // MARK: Input
  struct Input {
    let didSelectPhoto: Driver<Photo>
    let didReachBottom: Observable<Void>
    let searchButtonClicked: Observable<Void>
    let query: Driver<String>
  }
  
  // MARK: Output
  struct Output {
    let photosPages: BehaviorSubject<[PhotosPage]>
    let isFetching: Driver<Bool>
    let selectedPhoto: Driver<Photo>
    let error: Driver<Error>
  }
  
  let useCase: SearchPhotosUseCase
  var disposeBag = DisposeBag()
  
  init(useCase: SearchPhotosUseCase) {
    self.useCase = useCase
  }
  
  func transform(input: Input) -> Output {
    
    input.didReachBottom
      .withLatestFrom(input.query)
      .subscribe(onNext: { query in
        self.fetchData(query: query)
      })
      .disposed(by: disposeBag)
    
    input.query
      .asObservable()
      .sample(input.searchButtonClicked)
      .subscribe(with: self, onNext: { owner, query in
        owner.fetchData(query: query)
      })
      .disposed(by: disposeBag)
    
    return Output(
      photosPages: photosPages,
      isFetching: isFetching.asDriver(),
      selectedPhoto: input.didSelectPhoto,
      error: errorSubject.asDriver(onErrorJustReturn: APIError.invalidURL))
  }
  
  func fetchData(query: String) {
    isFetching.accept(true)
    
    let request = SearchPhotosUseCaseRequest(query: query, page: page)
    
    Task {
      do {
        let response = try await useCase.execute(request: request)
        
        photosPages
          .take(1)
          .subscribe(with: self, onNext: { owner, pages in
            owner.photosPages.onNext(pages + [response])
            owner.page += 1
            owner.isFetching.accept(false)
          })
          .disposed(by: disposeBag)
          
      } catch {
        errorSubject.onNext(error)
      }
    }
  }
  
}
