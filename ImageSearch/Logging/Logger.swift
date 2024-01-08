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
  
  func log(message: String, type: OSLogType, file: StaticString, line: UInt)
}

extension Loggable {
  func log(message: String, type: OSLogType, file: StaticString = #file, line: UInt = #line) {
    let log = "\(file):\(line) ".appending(message)
    os_log("%@", log: osLog, type: type, log)
  }
}

protocol NetworkLoggable {
  func log(request: URLRequest)
  func log(error: Error)
  func log(responseData data: Data?, response: URLResponse?)
}

final class NetworkLogger: Loggable, NetworkLoggable {
  var subsystem: String
  var category: String
  var osLog: OSLog
  
  init(
    subsystem: String = Bundle.main.bundleIdentifier!,
    category: String = "Network")
  {
    self.subsystem = subsystem
    self.category = category
    self.osLog = OSLog(subsystem: subsystem, category: category)
  }
  
  func log(request: URLRequest) {
    #if DEBUG
    log(message: "request: \(request.url!)", type: .debug)
    log(message: "headers: \(request.allHTTPHeaderFields!)", type: .debug)
    log(message: "method: \(request.httpMethod!)", type: .debug)
    #endif
  }
  
  func log(error: Error) {
    #if DEBUG
    log(message: "error: \(error.localizedDescription)", type: .debug)
    #endif
  }
  
  func log(responseData data: Data?, response: URLResponse?) {
    #if DEBUG
    guard let data = data else { return }
    guard let dataDict = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else { return }
    log(message: "response data: \(String(describing: dataDict))", type: .debug)
    #endif
  }
}
