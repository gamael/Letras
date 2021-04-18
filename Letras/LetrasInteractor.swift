//
//  LetrasInteractor.swift
//  Letras
//
//  Created by Alejandro Agudelo on 17/04/21.
//  Copyright © 2021 Alejandro Agudelo. All rights reserved.
//

import Foundation

protocol LetrasInteractor {
    func hayInternet() -> Bool
    func buscarLetra(de artista: String, llamada: String, completion: @escaping (ResultadoPeticion<Canción>) -> Void) -> Void
}


