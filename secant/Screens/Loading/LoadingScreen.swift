//
//  LoadingScreen.swift
//  secant-testnet
//
//  Created by Francisco Gindre on 9/2/21.
//

import SwiftUI

protocol LoadingScreenRouter: AnyObject {
    func proceedToHome()
    func failWithError()
    func proceedToWelcome()
}

struct LoadingScreen: View {
    @State var router: LoadingScreenRouter?
    
    @StateObject var viewModel: LoadingScreenViewModel
    
    var body: some View {
        Text("Loading")
            .onReceive(viewModel.$loadingResult, perform: { r in
                
                guard let r = r,
                      let router = self.router else { return }
                viewModel.callRouter(router, with: r)
            })
            .onAppear() {
                DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                    viewModel.loadAsync()
                }
            }
    }

}

// MARK: Routing

extension LoadingScreenViewModel {
    func callRouter(_ router: LoadingScreenRouter, with loadingResult: Result<LoadingScreenViewModel.LoadingResult,Error>) {
        
        switch loadingResult {
        case .success(let r):
            switch r {
            case .credentialsFound:
                router.proceedToHome()
            case .newWallet:
                router.proceedToWelcome()
            }
        case .failure(let e):
            router.failWithError()
        }
    }
}

struct LoadingScreenPreviews: PreviewProvider {
    static var previews: some View {
        LoadingScreen(viewModel: LoadingScreenViewModel(services: MockServices()))
    }
}
