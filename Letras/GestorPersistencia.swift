//
//  PersistanceManager.swift
//  Letras
//
//  Created by Alejandro Agudelo on 12/05/21.
//  Copyright © 2021 Alejandro Agudelo. All rights reserved.
//

import Foundation
import CoreData

protocol GestorPersistencia {
    func guardarCancion(_ cancion: Canción)
    func getUltimaBusqueda() -> Canción?
}

class GestorPersistenciaImpl: GestorPersistencia {
    fileprivate let coreDataManager = CoreDataManager(modelName: "Model")
    fileprivate lazy var fetchedResultsController: NSFetchedResultsController<CDCancion> = {
        // Initialize Fetch Request
        let fetchRequest: NSFetchRequest<CDCancion> = CDCancion.fetchRequest()

        // Add Sort Descriptors
        let sortDescriptor = NSSortDescriptor(key: "fechaCreacion", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]

        // Initialize Fetched Results Controller
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.coreDataManager.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        

        return fetchedResultsController
    }()
    
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
    
    func getUltimaBusqueda() -> Canción? {
        do {
            try fetchedResultsController.performFetch()
        } catch {
            let fetchError = error as NSError
            print("No se pudo obtener datos")
            print("\(fetchError), \(fetchError.localizedDescription)")
        }
        guard let cdcancion =  fetchedResultsController.fetchedObjects?.last else {
            return nil
        }
        return Canción(cancion: cdcancion)
    }
}
