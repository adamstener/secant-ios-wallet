//
//  RecoveryPhraseTestPreambleView.swift
//  secant-testnet
//
//  Created by Lukáš Korba on 03/01/22.
//

import SwiftUI
import ComposableArchitecture

struct RecoveryPhraseTestPreambleView: View {
    var store: RecoveryPhraseValidationStore

    var body: some View {
        WithViewStore(store) { viewStore in
            GeometryReader { proxy in
                VStack {
                    VStack(alignment: .center, spacing: 20) {
                        Text("recoveryPhraseTestPreamble.title")
                            .titleText()
                            .multilineTextAlignment(.center)
                            
                        Text("recoveryPhraseTestPreamble.paragraph1")
                            .paragraphText()
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 44)
                            .opacity(0.53)
                    }
                    .padding(.bottom, 20)

                    CircularFrame()
                        .backgroundImage(
                            Asset.Assets.Backgrounds.calloutBackupFlow1.image
                        )
                        .frame(
                            width: circularFrameUniformSize(width: proxy.size.width, height: proxy.size.height),
                            height: circularFrameUniformSize(width: proxy.size.width, height: proxy.size.height)
                        )
                        .badgeIcon(.person)

                    Spacer()

                    VStack(alignment: .center, spacing: 40) {
                        VStack(alignment: .center, spacing: 20) {
                            Text("recoveryPhraseTestPreamble.paragraph2")
                                .paragraphText()
                                .multilineTextAlignment(.center)
                                .opacity(0.53)

                            Text("recoveryPhraseTestPreamble.paragraph3")
                                .paragraphText()
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 10)
                                .opacity(0.53)
                        }

                        Button(
                            action: { viewStore.send(.updateRoute(.validation)) },
                            label: { Text("recoveryPhraseTestPreamble.button.goNext") }
                        )
                        .activeButtonStyle
                        .frame(
                            minWidth: 0,
                            maxWidth: .infinity,
                            minHeight: 64,
                            maxHeight: .infinity,
                            alignment: .center
                        )
                        .fixedSize(horizontal: false, vertical: true)
                    }
                    .padding()
                    
                    Spacer()
                }
                .frame(width: proxy.size.width)
                .scrollableWhenScaledUp()
                .navigationLinkEmpty(
                    isActive: viewStore.bindingForValidation,
                    destination: {
                        RecoveryPhraseBackupValidationView(store: store)
                    }
                )
            }
            .padding()
            .navigationBarHidden(true)
            .applyScreenBackground()
        }
    }
}

/// Following computations are necessary to handle properly sizing and positioning of elements
/// on different devices (apects). iPhone SE and iPhone 8 are similar aspect family devices
/// while iPhone X, 11, etc are different family devices, capable to use more of the space.
extension RecoveryPhraseTestPreambleView {
    func circularFrameUniformSize(width: CGFloat, height: CGFloat) -> CGFloat {
        var deviceMultiplier = 1.0
        
        if width > 0.0 {
            let aspect = height / width
            deviceMultiplier = 1.0 + (((aspect / 1.51) - 1.0) * 2.8)
        }
        
        return width * 0.4 * deviceMultiplier
    }
}

struct RecoveryPhraseTestPreambleView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationView {
                RecoveryPhraseTestPreambleView(store: .demo)
            }

            RecoveryPhraseTestPreambleView(store: .demo)
                .preferredColorScheme(.dark)

            RecoveryPhraseTestPreambleView(store: .demo)
                .previewDevice(PreviewDevice(rawValue: "iPhone SE (2nd generation)"))

            RecoveryPhraseTestPreambleView(store: .demo)
                .environment(\.sizeCategory, .accessibilityLarge)
        }
    }
}
