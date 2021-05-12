//
//  BusquedaVC.swift
//  Letras
//
//  Created by Alejandro Agudelo on 17/04/21.
//  Copyright © 2021 Alejandro Agudelo. All rights reserved.
//

import UIKit

typealias canciónBuscada = (nombre: String, artista: String)

class BusquedaVC: UIViewController {
    
    enum CasosError: String {
        case camposInvalidos = "Los campos están vacios"
        case sinResultados = "No se encontraron resultados"
        case sinInternet = "No hay conexión a internet"
        case errorPetición = "Hubo un error al descargar datos"
        case ninguno
    }
    
    @IBOutlet weak var artistaTextField: UITextField!
    @IBOutlet weak var cancionTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var cancionUltimaBusquedaLabel: UILabel!
    @IBOutlet weak var artistaUltimaBusquedaLabel: UILabel!
    @IBOutlet weak var ultimaBusquedaStackView: UIStackView!
    var interactor: LetrasInteractor!
    
    var ultimaCancion: Canción? {
        didSet {
            if ultimaCancion != nil {
                actualizarUltimaBusquedaCon(cancion: ultimaCancion!)
            }
        }
    }
    
    struct Constantes {
        static let letraSegue = "mostrarLetraSegue"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        interactor = LetrasInteractorImpl()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        shouldMostrarUltimaBusqueda()
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
        ejecutarBusqueda(canc: (nombre: cancion, artista: artista))
    }
    
    @IBAction func didTapUltimaBusqueda(_ sender: UITapGestureRecognizer) {
        ejecutarSegue(Constantes.letraSegue, con: ultimaCancion)
    }
    private func shouldMostrarUltimaBusqueda() {
        guard let cancion = interactor.getUltimaBusqueda() else {
            shouldMostrarUltimaBusqueda(false)
            return
        }
        ultimaCancion = cancion
    }
    
    private func actualizarUltimaBusquedaCon(cancion: Canción) {
        DispatchQueue.main.async {
            self.cancionUltimaBusquedaLabel.text = cancion.nombre
            self.artistaUltimaBusquedaLabel.text = cancion.artista
            self.shouldMostrarUltimaBusqueda(true)
        }
    }
    
    private func shouldMostrarUltimaBusqueda(_ mostrar: Bool) {
        ultimaBusquedaStackView.isHidden = !mostrar
    }
    
    private func updateError(caso: CasosError) {
        DispatchQueue.main.async {
            switch caso {
            case .camposInvalidos, .sinResultados, .sinInternet, .errorPetición:
                self.errorLabel.text = caso.rawValue
                self.errorLabel.isHidden = false
            case .ninguno:
                self.errorLabel.isHidden = true
            }
        }
    }
    
    private func ejecutarBusqueda(canc: canciónBuscada) {
        interactor.buscarLetra(canc: canc) { [weak self] (resultado) in
            switch resultado {
            case .exito(let letra):
                self?.handleResultadoDe(letra)
            case .fallo:
                self?.updateError(caso: .errorPetición)
            }
        }
    }
    
    private func handleResultadoDe(_ letra: Letra) {
        DispatchQueue.main.async {
            let artista = self.artistaTextField.text!
            let nombreCanción = self.cancionTextField.text!
            let canción = Canción(artista: artista, nombre: nombreCanción, letra: letra)
            self.interactor.guardar(canción: canción)
            self.ejecutarSegue(Constantes.letraSegue, con: canción)
        }
    }
    
    private func ejecutarSegue(_ segueID: String, con parametros: Any?) {
        performSegue(withIdentifier: segueID, sender: parametros)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constantes.letraSegue {
            guard let canción = sender as? Canción else {
                return
            }
            let vc = segue.destination as? LetraVC
            vc?.canción = canción
        }
    }
}

