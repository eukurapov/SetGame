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
                    .cardify(isFaceUp: card.isFaceUp,
                             shadowColor: self.highlightColor(card: card))
                    .padding(5)
                    .aspectRatio(0.75, contentMode: .fit)
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
            }
        }
            .padding(10)
            .foregroundColor(cardColor)
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
        setGameViewModel.newGame()
        setGameViewModel.select(card: setGameViewModel.table[0])
        return ContentView(setGameViewModel: setGameViewModel)
    }
}
