//
//  TrableManifest.swift
//  Trable
//
//  Created by nc on 19.09.20.
//

import Foundation

struct TrableManifest: Codable {
    var displayName: String
    var apiUrl: String
    var trableServerVersion: String
    var requiredClient: String
}
