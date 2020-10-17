//
//  ClientEnrollmentResponse.swift
//  Trable
//
//  Created by nc on 20.09.20.
//

import Foundation

struct ClientEnrollmentResponse: Codable {
    let clientId: String
    let bleAdvertisementId: String
    let apiKey: String
}
