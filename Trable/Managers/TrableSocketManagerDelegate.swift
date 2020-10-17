//
//  TrableSocketManagerDelegate.swift
//  Trable
//
//  Created by nc on 29.09.20.
//

import Foundation

protocol TrableSocketManagerDelegate {
    func socketManager(hasRecievedNewLocation location: TrableLocation)
}
