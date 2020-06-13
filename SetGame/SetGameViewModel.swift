//
//  SetGameViewModel.swift
//  SetGame
//
//  Created by Evgeniy Kurapov on 12.06.2020.
//  Copyright © 2020 Evgeniy Kurapov. All rights reserved.
//

import SwiftUI

class SetGameViewModel: ObservableObject {
    
    @Published private var setGame: SetGameModel = SetGameViewModel.newGame()
    
    private static func newGame() -> SetGameModel<CardContent> {
        var contents = [CardContent]()
        for number in CardContent.Number.allCases {
            for shape in CardContent.Shape.allCases {
                for shading in CardContent.Shading.allCases {
                    for color in CardContent.Color.allCases {
                        contents.append(CardContent(numberOfShapes: number, shape: shape, shading: shading, color: color))
                    }
                }
            }
        }
        return SetGameModel(numberOfCardsInDeck: contents.count) { index in contents[index] }
    }
    
    // MARK: Access to the model
    
    var table: [SetGameModel<CardContent>.Card] { setGame.table }
    var score: Int { setGame.score }
    
    func color(for cardColor: CardContent.Color) -> Color {
        switch cardColor {
        case .red: return .red
        case .green: return .green
        case .purple: return .purple
        }
    }
    
    // MARK: Intents
    
    func newGame() {
        setGame = SetGameViewModel.newGame()
    }
    
    func select(card: SetGameModel<CardContent>.Card) {
        setGame.select(card: card)
    }
    
    func dealMore() {
        setGame.deal(cards: 3)
    }
    
}
