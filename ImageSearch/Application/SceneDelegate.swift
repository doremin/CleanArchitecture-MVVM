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
    
    let window = UIWindow(windowScene: windowScene)
    
    let navigationController = UINavigationController()
    
    window.rootViewController = UINavigationController()
    
  }
}
