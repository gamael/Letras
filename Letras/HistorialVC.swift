//
//  HistorialVC.swift
//  Letras
//
//  Created by Alejandro Agudelo on 17/04/21.
//  Copyright © 2021 Alejandro Agudelo. All rights reserved.
//

import UIKit
import CoreData

class HistorialVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    fileprivate let coreDataManager = CoreDataManager(modelName: "Model")
    fileprivate lazy var fetchedResultsController: NSFetchedResultsController<CDCancion> = {
        // Initialize Fetch Request
        let fetchRequest: NSFetchRequest<CDCancion> = CDCancion.fetchRequest()

        // Add Sort Descriptors
        let sortDescriptor = NSSortDescriptor(key: "fechaCreacion", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]

        // Initialize Fetched Results Controller
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.coreDataManager.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        
        fetchedResultsController.delegate = self

        return fetchedResultsController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        do {
            try fetchedResultsController.performFetch()
        } catch {
            let fetchError = error as NSError
            print("No se pudo obtener datos")
            print("\(fetchError), \(fetchError.localizedDescription)")
        }
    }
}

extension HistorialVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = fetchedResultsController.sections else {
                return 0
            }

            let sectionInfo = sections[section]
            return sectionInfo.numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cancionCell", for: indexPath)
        
        configureCell(cell, at: indexPath)

        return cell
    }
    
    private func configureCell(_ cell: UITableViewCell, at indexPath: IndexPath) {
        // Obtener Canción
        let cdcancion = fetchedResultsController.object(at: indexPath)

        // Configurar Celda
        cell.textLabel?.text = cdcancion.nombre
        cell.detailTextLabel?.text = cdcancion.artista
    }
}

extension HistorialVC: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch (type) {
        case .insert:
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .fade)
            }
            break;
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            break;
        case .update:
            if let indexPath = indexPath, let cell = tableView.cellForRow(at: indexPath) {
                configureCell(cell, at: indexPath)
            }
            break;
        case .move:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }

            if let newIndexPath = newIndexPath {
                tableView.insertRows(at: [newIndexPath], with: .fade)
            }
            break;
        @unknown default:
            break
        }
    }
}
