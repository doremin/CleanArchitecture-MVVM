//
//  Logger.swift
//  ImageSearch
//
//  Created by doremin on 1/7/24.
//

import Foundation
import os

protocol Loggable {
  var subsystem: String { get }
  var category: String { get }
  var osLog: OSLog { get }
  
  func log(message: String, type: OSLogType)
}

final class Logger: Loggable {
  let subsystem: String
  let category: String
  let osLog: OSLog
  
  init(
    subsystem: String,
    category: String)
  {
    self.subsystem = subsystem
    self.category = category
    self.osLog = OSLog(subsystem: subsystem, category: category)
  }

  func log(message: String, type: OSLogType) {
    os_log("%@", log: osLog, type: type, message)
  }
}
