//
//  Requests.swift
//  Letras
//
//  Created by Alejandro Agudelo on 10/05/21.
//  Copyright © 2021 Alejandro Agudelo. All rights reserved.
//

import Foundation

enum RequestMethod: String {
    case get = "GET"
}

protocol Request {
    associatedtype Response: Codable
    associatedtype Body: Codable
    
    var endpoint: String { get }
    var method: RequestMethod { get }
    var params: [String] { get }
    var body: Body? { get }
    var bodyEncoder: JSONEncoder { get }
    var responseDecoder: JSONDecoder { get }
}

extension Request {
    var path: String {
        get {
            return String(format: self.endpoint, arguments: params)
        }
    }
    
    var bodyEncoder: JSONEncoder {
        get {
            return JSONEncoder()
        }
    }
    
    var responseDecoder: JSONDecoder {
        get {
            return JSONDecoder()
        }
    }
}
