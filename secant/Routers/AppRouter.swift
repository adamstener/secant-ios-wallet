//
//  AppRouterRouter.swift
//  secant
//
//  Created by Francisco Gindre on 8/6/21.
//

import Foundation
import SwiftUI

enum AppRouterScreen {
    case appLoading
    case createRestoreWallet
    case home
}

class AppRouter: Router {
    
    // MARK: - Published vars
    @Published var screen: AppRouterScreen = .appLoading
    
    // MARK: - Private vars
   
    // MARK: - Internal vars
    var services: Services
        
    // MARK: - Initialization

    init(services: Services) {
        self.services = services
    }
    
    // MARK: - Methods
    
    @ViewBuilder func rootView() -> some View {
        // Add your content here
        NavigationView {
            AppRouterView(router: self)
        }
    }
    
    @ViewBuilder func createNew() -> some View {
        Text("Create New")
    }
    
    @ViewBuilder func home() -> some View {
        Text("Home Screen")
    }
    
    @ViewBuilder func loadingScreen() -> some View {
        LoadingScreen(router: self, viewModel: LoadingScreenViewModel(services: self.services))
    }
}


struct AppRouterView: View {
    @StateObject var router: AppRouter
    
    @ViewBuilder func viewForScreen(_ screen: AppRouterScreen) -> some View {
        switch screen {
        case .appLoading:
            self.router.loadingScreen()
        case .createRestoreWallet:
            self.router.createNew()
        case .home:
            self.router.home()
        }
    }
    
    var body: some View {
        viewForScreen(router.screen)
    }
}


extension AppRouter: LoadingScreenRouter {
    func proceedToWelcome() {
        
    }
    
    func proceedToHome() {
        self.screen = .home
    }
    
    func failWithError() {
        
    }
    
    
}
