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
    let letra: Letra
    
    init(cancion: CDCancion) {
        self.artista = cancion.artista!
        self.nombre = cancion.nombre!
        self.letra = Letra(lyrics: cancion.letra!) 
    }
    
    init(artista: String, nombre: String, letra: Letra) {
        self.artista = artista
        self.nombre = nombre
        self.letra = letra
    }
}

struct Letra: Codable {
    let lyrics: String
}

struct ConstantesGlobales {
    static let apiURL = "https://api.lyrics.ovh/"
}
