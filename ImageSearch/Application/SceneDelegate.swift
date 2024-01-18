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
    
    guard let baseURLString = stringFromInfo(key: "BaseURL") else { return }
    guard let apiKey = stringFromInfo(key: "APIKey") else { return }
    
    let config = RequestConfig(
      baseURLString: baseURLString,
      timeoutInterval: 5,
      headers: [
        "Authorization": apiKey
      ])
    let service = APIService(config: config)
    let repository = PhotosRepositoryImpl(service: service)
    let usecase = SearchPhotosUseCaseImpl(photosRepository: repository)
    let viewModel = PhotosListViewModel(useCase: usecase)
    window?.rootViewController = PhotosListViewController(viewModel: viewModel)
    window?.makeKeyAndVisible()
  }
  
  private func stringFromInfo(key: String) -> String? {
    guard let value = Bundle.main.object(forInfoDictionaryKey: key) as? String else {
      return nil
    }
    
    return value
  }
}
