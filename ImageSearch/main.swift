//
//  main.swift
//  ImageSearch
//
//  Created by doremin on 1/7/24.
//

import UIKit

private func isTesting() -> Bool {
  return NSClassFromString("XCTestCase") != nil
}

private func appDelegateClassName() -> String {
  return isTesting() ? "ImageSearchTests.StubAppDelegate" : NSStringFromClass(AppDelegate.self)
}

_ = UIApplicationMain(
  CommandLine.argc,
  CommandLine.unsafeArgv,
  NSStringFromClass(UIApplication.self),
  appDelegateClassName()
)

