//
//  WelcomeView.swift
//  secant-testnet
//
//  Created by Francisco Gindre on 1/6/22.
//

import SwiftUI
import ComposableArchitecture

struct WelcomeView: View {
    var store: WelcomeStore
    
    enum DragState {
        case inactive
        case pressing
        case dragging(translation: CGSize)
    }
    
    let topPaddingRatio: Double = 0.18
    let horizontalPaddingRatio: Double = 0.07

    @GestureState var dragState = DragState.inactive
    
    var body: some View {
        let longPressDrag = LongPressGesture(minimumDuration: 0.75)
            .sequenced(before: DragGesture())
            .updating($dragState) { value, state, _ in
                switch value {
                    // Long press begins.
                case .first(true):
                    state = .pressing
                    // Long press confirmed, dragging may begin.
                case .second(true, let drag):
                    state = .dragging(translation: drag?.translation ?? .zero)
                    // Dragging ended or the long press cancelled.
                default:
                    state = .inactive
                }
            }
            .onEnded { value in
                guard case .second(true, let drag?) = value else { return }
                
                if drag.translation.height < 0 {
                    ViewStore(store).send(.debugMenuHome)
                } else {
                    ViewStore(store).send(.debugMenuStartup)
                }
            }
        
        return GeometryReader { proxy in
            ZStack(alignment: .top) {
                VStack(alignment: .center, spacing: 80) {
                    let diameter = proxy.size.width - 40
                    ZcashBadge()
                        .frame(
                            width: diameter,
                            height: diameter
                        )
                        .gesture(longPressDrag)

                    VStack {
                        Text("welcomeScreen.title")
                            .titleText()

                        Text("welcomeScreen.subtitle")
                            .captionText()
                    }
                }
            }
            .frame(alignment: .center)
            .applyScreenBackground()
            .animation(.easeInOut, value: 3)
        }
    }
}

struct ZcashBadge: View {
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        ZStack {
            GeometryReader { proxy in
                let outterPadding = proxy.size.height * 0.015
                let firstPadding = proxy.size.height * 0.075 + outterPadding
                let secondRingPadding = firstPadding * 1.5
                let outerShadowDrop = proxy.size.height * 0.14
                let outerShadowOffset = proxy.size.height * 0.055

                Circle()
                    .fill(
                        LinearGradient(
                            colors: [
                                Asset.Colors.ZcashBadge.outerRingGradientStart.color,
                                Asset.Colors.ZcashBadge.outerRingGradientEnd.color
                            ],
                            startPoint: UnitPoint(x: 0.5, y: 0),
                            endPoint: UnitPoint(x: 0.5, y: 1)
                        )
                    )
                    .if(colorScheme == .light) { view in
                        view.shadow(
                            color: Asset.Colors.ZcashBadge.shadowColor.color,
                            radius: outerShadowDrop,
                            x: outerShadowOffset,
                            y: outerShadowOffset
                        )
                    }

                Circle()
                    .foregroundColor(Asset.Colors.ZcashBadge.thickRing.color)
                    .padding(outterPadding)

                Circle()
                    .foregroundColor(Asset.Colors.ZcashBadge.thinRing.color)
                    .padding(firstPadding)

                Circle()
                    .foregroundColor(Asset.Colors.ZcashBadge.innerCircle.color)
                    .padding(secondRingPadding)

                ZcashSymbol()
                    .fill(Asset.Colors.ZcashBadge.zcashLogoFill.color)
                    .padding(firstPadding + secondRingPadding)
            }
        }
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static let squarePreviewSize: CGFloat = 360

    static var previews: some View {
        ZcashBadge()
            .applyScreenBackground()
            .previewLayout(
                .fixed(
                    width: squarePreviewSize,
                    height: squarePreviewSize
                )
            )
            .preferredColorScheme(.dark)

        ZStack {
            ZcashBadge()
        }
        .padding()
        .applyScreenBackground()
        .previewLayout(
            .fixed(
                width: squarePreviewSize,
                height: squarePreviewSize
            )
        )
        .preferredColorScheme(.light)

        Group {
            WelcomeView(store: .demo)
                .preferredColorScheme(.dark)

            WelcomeView(store: .demo)
                .previewDevice("iPhone SE (2nd generation)")
        }
    }
}
