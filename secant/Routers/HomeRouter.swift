//
//  HomeRouter.swift
//  secant-testnet
//
//  Created by Francisco Gindre on 9/2/21.
//

import Foundation
import SwiftUI

class HomeRouter: Router {
    
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

//extension HomeRouter: HomeScreenRouter {
//    func homeScreenScanQrScreen() -> ScanQrScreen {
//        ScanQrScreen(router: nil, viewModel: ScanQrScreenViewModel(services: services))
//    }
//    
//    func homeScreenProfileScreen() -> ProfileScreen {
//        ProfileScreen(router: nil, viewModel: ProfileScreenViewModel(services: services))
//    }
//    
//    func homeScreenHistoryScreen() -> HistoryScreen {
//        
//    }
//    
//    func homeScreenBalanceScreen() -> BalanceScreen {
//        <#code#>
//    }
//    
//    func homeScreenRequestScreen() -> RequestZcashScreen {
//        <#code#>
//    }
//    
//    func homeScreenSendScreen() -> SendScreen {
//        <#code#>
//    }
//}
