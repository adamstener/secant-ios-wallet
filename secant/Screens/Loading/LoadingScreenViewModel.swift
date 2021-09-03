//
//  LoadingScreenViewModel.swift
//  secant-testnet
//
//  Created by Francisco Gindre on 9/2/21.
//

import Foundation
import Combine

class LoadingScreenViewModel: BaseViewModel<Services>, ObservableObject {
    enum LoadingResult {
        case newWallet
        case credentialsFound
    }
    
    @Published var loadingResult: Result<LoadingResult,Error>? = nil
    
    func loadAsync () {
        // TODO: Make a special queue for the app
        DispatchQueue.global(qos: .userInitiated)
            .async { [weak self] in
                guard let r = self?.load() else { return }
                DispatchQueue.main.async {
                    self?.loadingResult = r
                }
            }
    }
    
    internal func load() -> Result<LoadingResult,Error> {
        do {
            return (try services.keyStorage.areKeysPresent()) ? .success(.credentialsFound) : .success(.newWallet)
        } catch {
            return .failure(error)
        }
    }
}
