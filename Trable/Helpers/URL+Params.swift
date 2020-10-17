//
//  URL+Params.swift
//  Trable
//
//  Created by nc on 19.09.20.
//

import Foundation

// From: http://www.seanbehan.com/how-to-parse-url-parameters-in-swift/
extension URL {
  func params() -> [String:Any] {
    var dict = [String:Any]()

    if let components = URLComponents(url: self, resolvingAgainstBaseURL: false) {
      if let queryItems = components.queryItems {
        for item in queryItems {
          dict[item.name] = item.value!
        }
      }
      return dict
    } else {
      return [:]
    }
  }
}
