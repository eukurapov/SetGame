//
//  ContentView.swift
//  SetGame
//
//  Created by Evgeniy Kurapov on 12.06.2020.
//  Copyright © 2020 Evgeniy Kurapov. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var setGameViewModel: SetGameViewModel
    
    var body: some View {
        VStack {
            HStack {
                Button("New Game") {
                    withAnimation {
                        self.setGameViewModel.newGame()
                    }
                }
                Spacer()
                Text("Score: \(setGameViewModel.score)")
                Spacer()
                Button("Deal More") {
                    withAnimation {
                        self.setGameViewModel.dealMore()
                    }
                }
                .disabled(setGameViewModel.isDeckEmpty)
            }
                .padding(5)
            Grid(setGameViewModel.table) { card in
                CardView(card: card)
                    .foregroundColor(self.setGameViewModel.cardColor(card: card))
                    .cardify(isFaceUp: card.isFaceUp,
                             shadowColor: self.highlightColor(card: card))
                    .padding(5)
                    .aspectRatio(0.75, contentMode: .fit)
                    .rotationEffect(card.isMatched ? Angle(degrees: 360) : Angle(degrees: 0))
                    .transition(.offset(CGSize(width: Int.random(in: -500...1000), height: Int.random(in: -500...1000))))
                    .animation(.easeInOut(duration: 0.45))
                    .onTapGesture {
                        withAnimation {
                            self.setGameViewModel.select(card: card)
                        }
                    }
            }
                .padding(5)
        }
        .onAppear {
            if self.setGameViewModel.table.isEmpty {
                withAnimation {
                    self.setGameViewModel.newGame()
                }
            }
        }
    }
    
    private func highlightColor(card: SetGameModel<CardContent>.Card) -> Color? {
        var color: Color? = nil
        if card.isSelected {
            if card.isMatched {
                color = Color(#colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1))
            } else if setGameViewModel.isReadyToMatch {
                color = Color(#colorLiteral(red: 1, green: 0.4932718873, blue: 0.4739984274, alpha: 1))
            } else {
                color = Color(#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1))
            }
        }
        return color
    }
    
}

struct CardView: View {
    
    var card: SetGameModel<CardContent>.Card
    
    var body: some View {
        VStack {
            ForEach(0..<card.content.numberOfShapes.rawValue) { index in
                self.shapeView()
            }
        }
            .padding(10)
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





















struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let setGameViewModel = SetGameViewModel()
        setGameViewModel.newGame()
        setGameViewModel.select(card: setGameViewModel.table[0])
        return ContentView(setGameViewModel: setGameViewModel)
    }
}
