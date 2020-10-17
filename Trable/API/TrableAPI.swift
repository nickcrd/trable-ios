//
//  TrableAPI.swift
//  Trable
//
//  Created by nc on 19.09.20.
//

import Foundation

enum RequestError: Error {
    case invalidResponse
    case invalidData
    case decodingError
    case serverError
}

class TrableAPI {
    
    static var shared: TrableAPI = TrableAPI()
    private init() {}
    
    private let urlSession = URLSession.shared
    
    func get<T: Decodable>(requestUrl: String, apiKey: String?, type: T.Type, completion: @escaping (Result<T, Error>) -> Void) {
        
        get(requestUrl: requestUrl, apiKey: apiKey) { (data, response, error) in
           
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                completion(.failure(RequestError.invalidResponse))
                return
            }
            
            if response.statusCode < 200 && response.statusCode > 299 {
                completion(.failure(RequestError.serverError))
                return
            }
            
            guard let data = data else {
                completion(.failure(RequestError.invalidData))
                return
            }
            
            do {
                let jsonDecoder = JSONDecoder()
                let data = try jsonDecoder.decode(T.self, from: data)
                completion(.success(data))
            } catch {
                completion(.failure(RequestError.decodingError))
            }
        }
    }
    
    func get(requestUrl: String, apiKey: String?, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        let url = URL(string: requestUrl)!
        var request = URLRequest(url: url)

        request.httpMethod = "GET"
        if (apiKey != nil) {
            request.setValue("Bearer \(apiKey!)", forHTTPHeaderField: "Authorization")
        }
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: completion)
        task.resume()
    }
    
    func post(requestUrl: String, requestBody: String, apiKey: String?, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        let url = URL(string: requestUrl)!
        var request = URLRequest(url: url)

        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if (apiKey != nil) {
            request.setValue("Bearer \(apiKey!)", forHTTPHeaderField: "Authorization")
        }
        
        request.httpBody = Data(requestBody.utf8)
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: completion)
        task.resume()
    }
}
