//
//  BaseViewController.swift
//  ImageSearch
//
//  Created by doremin on 1/15/24.
//

import UIKit

import RxSwift

class BaseViewController: UIViewController {
  
  // MARK: Initializing
  
  init() {
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  // MARK: Rx
  
  var disposeBag = DisposeBag()
  
  
  // MARK: Life Cycle
  
  private(set) var didSetupConstraints = false
  
  override func viewDidLoad() {
    self.view.setNeedsUpdateConstraints()
  }
  
  override func updateViewConstraints() {
    if !didSetupConstraints {
      setupConstraints()
      didSetupConstraints = true
    }
    
    super.updateViewConstraints()
  }
  
  func setupConstraints() {
    
  }
}
