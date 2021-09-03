//
//  LoadingRouter.swift
//  secant-testnet
//
//  Created by Francisco Gindre on 9/2/21.
//

import Foundation
import SwiftUI

class LoadingRouter: Router {
    
    // MARK: - Published vars
    // Put published vars here
    
    // MARK: - Private vars
    
    // MARK: - Internal vars
    var services: Services
        
    // MARK: - Initialization

    init(services: Services) {
        self.services = services
    }
    
    // MARK: - Methods
    
    func rootView() -> some View {
        // Add your content here
        NavigationView {
            Text("Hello Word")
        }
    }
    
}

