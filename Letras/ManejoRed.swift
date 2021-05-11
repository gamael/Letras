//
//  ManejoRed.swift
//  Letras
//
//  Created by Alejandro Agudelo on 10/05/21.
//  Copyright © 2021 Alejandro Agudelo. All rights reserved.
//

import Foundation


protocol ManejadorRed {
    func hayConexión() -> Bool
}

class ManejadorRedImpl: ManejadorRed {
    func hayConexión() -> Bool {
        // Tomado de: https://stackoverflow.com/questions/30743408/check-for-internet-connection-with-swift
        do {
            let reachability: Reachability = try Reachability()
            let networkStatus = reachability.connection
            
            switch networkStatus {
            case .unavailable:
                return false
            case .wifi, .cellular:
                return true
            }
        }
        catch {
            return false
        }
    }
}
