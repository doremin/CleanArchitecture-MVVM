//
//  SceneDelegate.swift
//  ImageSearch
//
//  Created by doremin on 1/6/24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  
  var window: UIWindow?
  
  func scene(
    _ scene: UIScene,
    willConnectTo session: UISceneSession,
    options connectionOptions: UIScene.ConnectionOptions)
  {
    guard let windowScene = (scene as? UIWindowScene) else { return }
    
    window = UIWindow(windowScene: windowScene)
    
    let config = RequestConfig(
      baseURLString: "https://api.pexels.com",
      headers: [
        "Authorization": "UxK7zU4UqLID36VtnkvvJZZGdrHxAQzhKJ4HRFC9sLh0Pt5PnRDzkpiE"
      ])
    let service = APIService(config: config)
    let repository = PhotosRepositoryImpl(service: service)
    let usecase = SearchPhotosUseCaseImpl(photosRepository: repository)
    let viewModel = PhotosListViewModel(useCase: usecase)
    window?.rootViewController = PhotosListViewController(viewModel: viewModel)
    window?.makeKeyAndVisible()
  }
}
