//
//  NetworkingService.swift
//  NetworkingService
//
//  Created by Evgeniy Petlitskiy on 11.03.21.
//

import UIKit


class NetworkingService {
    
    static var session = URLSession.shared
    
    //GET request methods
    static func getRequest(with url: URL, completion: @escaping (Data) -> ()) {
        
        session.dataTask(with: url) { (data, response, error) in
            
                   
            if let err = error {
                print("Data couldn't be retrieved: \(err)")
                return
            }
            
            guard
                let httpResponse = response as? HTTPURLResponse,
                (200...299).contains(httpResponse.statusCode)
            else { return }
            
            guard let data = data else { return }
            DispatchQueue.main.async {
                completion(data)
            }
        }.resume()
    }
    
    static func getRequest(with url: String, completion: @escaping (Data) -> ()) {
        
        guard let url = URL(string: url) else { return }
        getRequest(with: url) { (data) in
            completion(data)
        }
    }
    
    //Download image methods
    static func downloadImage(with url: URL, completion: @escaping (UIImage) -> ()) {
        
        getRequest(with: url) { (data) in
            guard let image = UIImage(data: data) else {
                print("Data couldn't be converted to image")
                return
            }
            completion(image)
        }
    }
    
    static func downloadImage(with url: String, completion: @escaping (UIImage) -> ()) {
        
        guard let url = URL(string: url) else { return }
        downloadImage(with: url) { (image) in
            completion(image)
        }
    }
    
    //POST request methods

    static func postRequest(to url: URL, data: Data, headers: [String : String]?, completion: @escaping(Data?) -> ()) {
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = data
        request.allHTTPHeaderFields = headers
        
        session.dataTask(with: request) { (data, response, error) in
            
            if let error = error {
                print(error)
                return
            }
            
            guard
                let httpResponse = response as? HTTPURLResponse,
                (200...299).contains(httpResponse.statusCode)
            else { return }
            
            guard let data = data else { return }
            DispatchQueue.main.async {
                completion(data)
            }
        }.resume()
    }
    
    static func postRequest(to url: String, data: Data, headers: [String : String]?, completion: @escaping(Data?) -> ()) {
        
        guard let url = URL(string: url) else { return }
        postRequest(to: url, data: data, headers: headers, completion: completion)
    }
    
    
}
