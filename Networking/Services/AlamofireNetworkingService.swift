//
//  AlamofireNetworkingService.swift
//  Networking
//
//  Created by Evgeniy Petlitskiy on 31.03.21.
//

import Foundation
import Alamofire

class AlamofireNetworkingService {
    
    static var completed: ((String) -> ())?
    static var onProgress: ((Double) -> ())?
    
    static func getRequest<T: Decodable>(with url: URL, of type: T.Type = T.self, completion: @escaping (T) -> ()) {
        
        AF.request(url).validate(statusCode: 200..<300).responseDecodable(of: type) { (response) in
            switch response.result {
            case .success(let value):
                DispatchQueue.main.async {
                    completion(value)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    static func getRequest<T: Decodable>(with url: String, of type: T.Type = T.self, completion: @escaping (T) -> ()) {
        guard let url = URL(string: url) else { return }
        getRequest(with: url, of: type, completion: completion)
    }
    
    static func getData(with url: URL, completion: @escaping (Data) -> ()) {
        
        AF.request(url).validate(statusCode: 200..<300).downloadProgress { (progress) in
            
            self.completed?(progress.localizedDescription)
            self.onProgress?(progress.fractionCompleted)
            
        }.responseData { (response) in
            switch response.result {
            case .success(let value):
                DispatchQueue.main.async {
                    completion(value)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    static func getData(with url: String, completion: @escaping (Data) -> ()) {
        guard let url = URL(string: url) else { return }
        getData(with: url, completion: completion)
    }
    
    static func postRequest(_ url: URL, data: [String : Any], headers: [String : String]?, completion: @escaping (Any?) -> ()) {
        var httpHeaders: HTTPHeaders? = nil
        if headers != nil { httpHeaders = HTTPHeaders(headers!) }

        AF.request(url, method: .post, parameters: data,
                   encoding: JSONEncoding.default,
                   headers: httpHeaders).validate(statusCode: 200..<300).responseJSON { (responseJSON) in
            
            switch responseJSON.result {
            case .success(let value):
                DispatchQueue.main.async {
                    completion(value)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    static func postRequest(_ url: String, data: [String : Any], headers: [String : String]?, completion: @escaping (Any?) -> ()) {
        guard let url = URL(string: url) else { return }
        postRequest(url, data: data, headers: headers, completion: completion)
    }
    
    static func putRequest(_ url: URL, data: [String : Any], headers: [String : String]?, completion: @escaping (Any?) -> ()) {
        var httpHeaders: HTTPHeaders? = nil
        if headers != nil { httpHeaders = HTTPHeaders(headers!) }
        
        AF.request(url, method: .put, parameters: data,
                   encoding: JSONEncoding.default,
                   headers: httpHeaders).validate(statusCode: 200..<300).responseJSON { (responseJSON) in
            switch responseJSON.result {
            case .success(let value):
                DispatchQueue.main.async {
                    completion(value)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    static func putRequest(_ url: String, data: [String : Any], headers: [String : String]?, completion: @escaping (Any?) -> ()) {
        guard let url = URL(string: url) else { return }
        putRequest(url, data: data, headers: headers, completion: completion)
    }
    
    static func uploadData(_ url: URL, data: [String : Data], headers: [String : String]?, completion: @escaping(Any?) -> ()) {
        var httpHeaders: HTTPHeaders? = nil
        if headers != nil { httpHeaders = HTTPHeaders(headers!) }
        
        AF.upload(multipartFormData: { (multipartFormData) in
            for (key, value) in data {
                multipartFormData.append(value, withName: key)
            }
        }, to: url, headers: httpHeaders).validate(statusCode: 200..<300).responseJSON { (responseJSON) in
            switch responseJSON.result {
            case .success(let value):
                DispatchQueue.main.async {
                    completion(value)
                }
            case .failure(let error):
                print(error)
            }
        }
    }

    static func uploadData(_ url: String, data: [String : Data], headers: [String : String]?, completion: @escaping(Any?) -> ()) {
        guard let url = URL(string: url) else { return }
        uploadData(url, data: data, headers: headers, completion: completion)
    }
}
