//
//  PersistanceManager.swift
//  Letras
//
//  Created by Alejandro Agudelo on 12/05/21.
//  Copyright © 2021 Alejandro Agudelo. All rights reserved.
//

import Foundation

protocol GestorPersistencia {
    func guardarCancion(_ cancion: Canción) 
}

class GestorPersistenciaImpl: GestorPersistencia {
    fileprivate let coreDataManager = CoreDataManager(modelName: "Model")
    
    func guardarCancion(_ cancion: Canción) -> Void {
        let cdcancion = CDCancion(context: coreDataManager.managedObjectContext)
        cdcancion.nombre = cancion.nombre
        cdcancion.artista = cancion.artista
        cdcancion.letra = cancion.letra.lyrics
        
        do {
            try cdcancion.managedObjectContext?.save()
        } catch {
            let saveError = error as NSError
            print("Unable to Save Note")
            print("\(saveError), \(saveError.localizedDescription)")
        }
    }
}
