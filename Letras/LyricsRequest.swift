//
//  LyricsRequest.swift
//  Letras
//
//  Created by Alejandro Agudelo on 10/05/21.
//  Copyright © 2021 Alejandro Agudelo. All rights reserved.
//

import Foundation

fileprivate let version = "v1"

struct LyricsRequest: Request {
    typealias Response = Letra
    struct Body: Codable {}
    
    let endpoint: String = "\(ConstantesGlobales.apiURL)/\(version)/%@/%@"
    let method: RequestMethod = .get
    let params: [String]
    let body: Body? = nil
}
