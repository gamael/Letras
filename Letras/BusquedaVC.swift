//
//  BusquedaVC.swift
//  Letras
//
//  Created by Alejandro Agudelo on 17/04/21.
//  Copyright © 2021 Alejandro Agudelo. All rights reserved.
//

import UIKit

class BusquedaVC: UIViewController {
    
    enum CasosError: String {
        case camposInvalidos = "Los campos están vacios"
        case sinResultados = "No se encontraron resultados"
        case sinInternet = "No hay conexión a internet"
        case ninguno
    }
    
    @IBOutlet weak var artistaTextField: UITextField!
    @IBOutlet weak var cancionTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    var interactor: LetrasInteractor!

    override func viewDidLoad() {
        super.viewDidLoad()
        interactor = LetrasInteractorImpl()
    }

    @IBAction func buscarCanción() {
        guard interactor.hayInternet() else {
            updateError(caso: .sinInternet)
            return
        }
        guard let artista = artistaTextField.text, artista.count > 0, let cancion = cancionTextField.text, cancion.count > 0 else {
            updateError(caso: .camposInvalidos)
            return
        }
        updateError(caso: .ninguno)
        ejecutarBusqueda(artista: artista, cancion: cancion)
    }
    
    private func updateError(caso: CasosError) {
        DispatchQueue.main.async {
            switch caso {
            case .camposInvalidos:
                self.errorLabel.text = caso.rawValue
                self.errorLabel.isHidden = false
            case .sinResultados:
                self.errorLabel.text = caso.rawValue
                self.errorLabel.isHidden = false
            case .sinInternet:
                self.errorLabel.text = caso.rawValue
                self.errorLabel.isHidden = false
            case .ninguno:
                self.errorLabel.isHidden = true
            }
        }
    }
    
    private func ejecutarBusqueda(artista: String, cancion: String) {
        interactor.buscarLetra(de: artista, llamada: cancion) { [weak self] (resultado) in
            switch resultado {
            case .exito(let canción):
                self?.handleResultadoDe(canción: canción)
            case .fallo:
                self?.updateError(caso: .sinResultados)
            }
        }
    }
    
    private func handleResultadoDe(canción: Canción) {
        
    }
}

