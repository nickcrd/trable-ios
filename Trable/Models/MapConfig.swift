//
//  MapConfig.swift
//  Trable
//
//  Created by nc on 27.09.20.
//

import Foundation

struct MapConfig: Codable {
    var mapImageUrl: String
    
    var mapBounds: [[Double]]
    
    var minZoom: Int
    var maxZoom: Int
    
    var markers: [MapMarker]
}

struct MapMarker: Codable {
    var displayName: String
    var location: [Double]
}
