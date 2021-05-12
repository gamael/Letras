//
//  LetraVC.swift
//  Letras
//
//  Created by Alejandro Agudelo on 17/04/21.
//  Copyright © 2021 Alejandro Agudelo. All rights reserved.
//

import UIKit

class LetraVC: UIViewController {
    
    @IBOutlet weak var tituloCanciónLabel: UILabel!
    @IBOutlet weak var artistaCanciónLabel: UILabel!
    @IBOutlet weak var letraCanciónTextView: UITextView!
    var canción: Canción?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupIU()
    }
    
    private func setupIU() {
        tituloCanciónLabel.text = canción?.nombre
        artistaCanciónLabel.text = canción?.artista
        letraCanciónTextView.text = canción?.letra.lyrics
    }
    @IBAction func atras(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
