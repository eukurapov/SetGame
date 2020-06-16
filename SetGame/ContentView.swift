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
                CardView(card: card, colorSet: self.setGameViewModel.colorSet)
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
    
    var card: SetGameModel<CardContent>.Card
    var colorSet: (red: Color, green: Color, purple: Color)
    
    private var cardColor: Color {
        // TODO: Replace with theme.color(for card.color)
        switch card.content.color {
            case .red: return colorSet.red
            case .green: return colorSet.green
            case .purple: return colorSet.purple
        }
    }
    
    private var fillColor: Color {
        switch card.content.shading {
        case .open: return .white
        case .solid: return cardColor
        case .striped: return cardColor.opacity(0.25)
        }
    }
    
    var body: some View {
        VStack {
            ForEach(0..<card.content.numberOfShapes.rawValue) { index in
                self.shapeView()
                    //.aspectRatio(1, contentMode: .fit)
            }
        }
        .padding(10)
        .foregroundColor(cardColor)
        .cardify(isFaceUp: card.isFaceUp,
                 isSelected: card.isSelected,
                 isMatched: card.isMatched)
        .padding(5)
    }
    
    private func shapeView() -> some View {
        Group {
            if card.content.shape == .diamond {
                Rectangle().fill(fillColor).overlay(Rectangle().stroke(lineWidth: shapeLineWidth))
                                    .aspectRatio(1, contentMode: .fit)
            }
            if card.content.shape == .oval {
                Capsule().fill(fillColor).overlay(Capsule().stroke(lineWidth: shapeLineWidth))
                                    .aspectRatio(2, contentMode: .fit)
            }
            if card.content.shape == .squiggle {
                Circle().fill(fillColor).overlay(Circle().stroke(lineWidth: shapeLineWidth))
            }
        }
    }
    
    let shapeLineWidth: CGFloat = 2
    
}





















struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let setGameViewModel = SetGameViewModel()
        setGameViewModel.select(card: setGameViewModel.table[0])
        return ContentView(setGameViewModel: setGameViewModel)
    }
}
