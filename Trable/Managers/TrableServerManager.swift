//
//  TrableServerManager.swift
//  Trable
//
//  Created by nc on 20.09.20.
//

import Foundation

class TrableServerManager {
    
    static let shared = TrableServerManager()
    private init() {}
  
    var manifest: TrableManifest?
    
    // MARK - Auth Variables
    @UserDefault(key: "baseUrl", defaultValue: "")
    var baseUrl: String
    
    @UserDefault(key: "clientId", defaultValue: "")
    var clientId: String
    
    @UserDefault(key: "bleAdvertisementId", defaultValue: "")
    var bleAdvertisementId: String
    
    @UserDefault(key: "apiKey", defaultValue: "")
    var apiKey: String
    
    // ---
    
    func handleManifestChange(to manifestUrl: String, completion: @escaping (Error?) -> Void) {
        TrableAPI.shared.get(requestUrl: manifestUrl, apiKey: nil, type: TrableManifest.self) { (result) in
            switch result {
                case .failure(let error):
                    completion(error)
                
                case .success(let manifest):
                    self.manifest = manifest
                    completion(nil)
            }
        }
    }
    
    func enrollClient(to server: TrableManifest, completion: @escaping (Error?) -> Void) {
        TrableAPI.shared.get(requestUrl: server.apiUrl + "api/v1/devices/enrollClient", apiKey: nil, type: ClientEnrollmentResponse.self) { result in
                switch result {
                    case .success(let response):
                        self.baseUrl = server.apiUrl
                        self.clientId = response.clientId
                        self.bleAdvertisementId = response.bleAdvertisementId
                        self.apiKey = response.apiKey
                        completion(nil)
                    case .failure(let error):
                        print("Error occurred while enrolling Client! \(error)")
                        completion(error)
                }
        }
    }
    
    func fetchMapConfig(completion: @escaping (MapConfig?, Error?) -> Void) {
        TrableAPI.shared.get(requestUrl: baseUrl + "api/v1/map/mapConfig", apiKey: apiKey, type: MapConfig.self) { result in
            switch result {
                case .success(let mapConfig):
                    completion(mapConfig, nil)
                    
                case .failure(let error):
                    completion(nil, error)
            }
        }
    }
    
    
}
