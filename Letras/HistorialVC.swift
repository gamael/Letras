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
        let sortDescriptor = NSSortDescriptor(key: "fechaCreacion", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]

        // Initialize Fetched Results Controller
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.coreDataManager.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)

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
        let cell = tableView.dequeueReusableCell(withIdentifier: "rid", for: indexPath)

        // Obtener Canción
        let cdcancion = fetchedResultsController.object(at: indexPath)

        // Configurar Celda
        cell.textLabel?.text = cdcancion.nombre
        cell.detailTextLabel?.text = cdcancion.artista

        return cell
    }
}
