//
//  NetworkManager.swift
//  Letras
//
//  Created by Alejandro Agudelo on 11/05/21.
//  Copyright © 2021 Alejandro Agudelo. All rights reserved.
//

import Foundation

class NetworkManager {
    private enum HttpHeadersName: String {
        case authorization = "Authorization"
        case contentType = "Content-Type"
        case accept = "Accept"
        case acceptLanguage = "Accept-Language"
    }
    
   
    static let shared = NetworkManager()
    
    private init() {}

    func call<R : Request>(request: R, completion: @escaping (ResultadoPeticion<R.Response>) -> Void) {
        guard let urlRequest = createURLRequest(request) else {
            completion(.fallo("The request is not valid"))
            return
        }
        self.launchRequest(urlRequest, request.responseDecoder, completion)
        
    }
    
    
    private func createURLRequest<R : Request>(_ request: R) -> URLRequest? {
        
        guard let escapedString = request.path.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: escapedString) else {
            return nil
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.rawValue
        urlRequest.cachePolicy = .reloadIgnoringCacheData
        urlRequest.addValue("application/json", forHTTPHeaderField: HttpHeadersName.accept.rawValue)
        urlRequest.addValue("application/json", forHTTPHeaderField: HttpHeadersName.contentType.rawValue)
        
        return urlRequest
    }
    
    private func launchRequest<T : Codable>(
        _ request: URLRequest,
        _ responseDecoder: JSONDecoder,
        _ completion: @escaping (ResultadoPeticion<T>) -> Void
    ) {
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                completion(.fallo(error!.localizedDescription))
                return
            }
            
            guard let  data = data else {
                completion(.fallo("No data"))
                return
            }
            
            guard let dataString = String(data: data, encoding: .utf8), !dataString.contains("No lyrics found") else {
                completion(.fallo("No hay resultados para la busqueda"))
                return
            }
                
            do {
                let response = try responseDecoder.decode(T.self, from: data)
                completion(.exito(response))
            } catch let error {
                completion(.fallo("There was a problem while parsing the data: \(error)"))
            }
            return
        }
        task.resume()
    }
}
