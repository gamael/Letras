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
    func buscarLetra(canc: canciónBuscada, completion: @escaping (ResultadoPeticion<Letra>) -> Void) -> Void
}

class LetrasInteractorImpl: LetrasInteractor {
    
    struct Dependencias {
        let manejadorRed: ManejadorRed = ManejadorRedImpl()
        let networkManager = NetworkManager.shared
    }
    let dependencias: Dependencias = .init()
    
    func hayInternet() -> Bool {
        return dependencias.manejadorRed.hayConexión()
    }
    
    func buscarLetra(canc: canciónBuscada, completion: @escaping (ResultadoPeticion<Letra>) -> Void) {
        let petición = LyricsRequest(params: [canc.artista, canc.nombre])
        dependencias.networkManager.call(request: petición) { (resPet) in
            completion(resPet)
        }
    }
}
