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
            }
                .padding(5)
            Grid(setGameViewModel.table) { card in
                CardView(card: card)
                    .onTapGesture {
                        withAnimation {
                            self.setGameViewModel.select(card: card)
                        }
                }
            }
                .padding(5)
        }
    }
    
}

struct CardView: View {
    
    var card: SetGameModel.Card
    private var cardColor: Color {
        // TODO: Replace with theme.color(for card.color)
        switch card.color {
            case .red: return .red
            case .green: return .green
            case .purple: return .purple
        }
    }
    private var fillColor: Color {
        switch card.shading {
        case .open: return .white
        case .solid: return cardColor
        case .striped: return cardColor.opacity(0.25)
        }
    }
    
    var body: some View {
        VStack {
            ForEach(0..<card.numberOfShapes.rawValue) { index in
                self.shapeView()
                    //.aspectRatio(1, contentMode: .fit)
            }
        }
        .padding(5)
        .foregroundColor(cardColor)
        .cardify(isFaceUp: card.isFaceUp,
                 isSelected: card.isSelected,
                 isMatched: card.isMatched)
        .padding(5)
    }
    
    
    private func shapeView() -> AnyView {
        switch self.card.shape {
        case .diamond: return AnyView(Rectangle().fill(fillColor).overlay(Rectangle().stroke())
                                .aspectRatio(1, contentMode: .fit))
        case .oval: return AnyView(Capsule().fill(fillColor).overlay(Capsule().stroke())
                                .aspectRatio(2, contentMode: .fit))
        case .squiggle: return AnyView(Circle().fill(fillColor).overlay(Circle().stroke()))
        }
    }
    
}





















struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let setGameViewModel = SetGameViewModel()
        setGameViewModel.select(card: setGameViewModel.table[0])
        return ContentView(setGameViewModel: setGameViewModel)
    }
}
