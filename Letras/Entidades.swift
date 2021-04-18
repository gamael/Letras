//
//  Entidades.swift
//  Letras
//
//  Created by Alejandro Agudelo on 17/04/21.
//  Copyright © 2021 Alejandro Agudelo. All rights reserved.
//

import Foundation

enum ResultadoPeticion<T: Codable> {
    case exito(T)
    case fallo(String)
}

struct Canción: Codable {
    let artista: String
    let nombre: String
    let letra: String
}
