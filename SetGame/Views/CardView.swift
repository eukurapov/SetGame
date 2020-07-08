//
//  CardView.swift
//  SetGame
//
//  Created by Eugene Kurapov on 08.07.2020.
//  Copyright © 2020 Evgeniy Kurapov. All rights reserved.
//

import SwiftUI

struct CardView: View {
    
    var card: SetGameModel<CardContent>.Card
    var shadowColor: (SetGameModel<CardContent>.Card) -> Color?
    
    var body: some View {
        VStack {
            ForEach(0..<card.content.numberOfShapes.rawValue) { index in
                self.shapeView()
            }
        }
        .padding(10)
        .foregroundColor(Color(self.card.content.uiColor))
            .cardify(isFaceUp: self.card.isFaceUp,
                     shadowColor: self.shadowColor(self.card))
        .padding(5)
        .aspectRatio(0.75, contentMode: .fit)
    }
    
    private func shapeView() -> some View {
        cardShape(contentShape: card.content.shape)
            .stroke(lineWidth: shapeLineWidth)
            .overlay(fillView(with: card.content.shading, for: card.content.shape))
            .aspectRatio(2, contentMode: .fit)
    }
    
    private func fillView(with shading: CardContent.ContentShading, for shape: CardContent.ContentShape) -> some View {
        Group {
            if shading == .striped {
                cardShape(contentShape: shape).stripe(angle: stripeAngle, frequency: stripeFrequency)
            } else if shading == .solid {
                cardShape(contentShape: shape).fill()
            }
        }
    }
    
    struct cardShape: Shape {
        var contentShape: CardContent.ContentShape
        
        func path(in rect: CGRect) -> Path {
            switch contentShape {
            case .diamond: return Diamond().path(in: rect)
            case .oval: return Capsule().path(in: rect)
            case .squiggle: return Squiggle().path(in: rect)
            }
        }
    }
    
    private let shapeLineWidth: CGFloat = 2
    private let stripeAngle: Angle = Angle(degrees: 20)
    private let stripeFrequency: CGFloat = 20
    
}
