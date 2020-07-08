//
//  SetGameViewModel.swift
//  SetGame
//
//  Created by Evgeniy Kurapov on 12.06.2020.
//  Copyright © 2020 Evgeniy Kurapov. All rights reserved.
//

import SwiftUI

class SetGameViewModel: ObservableObject {
    
    @Published private var setGame: SetGameModel<CardContent>?
    var colorSet = (
        red: Color(#colorLiteral(red: 1, green: 0.4932718873, blue: 0.4739984274, alpha: 1)),
        green: Color(#colorLiteral(red: 0.4508578777, green: 0.9882974029, blue: 0.8376303315, alpha: 1)),
        purple: Color(#colorLiteral(red: 0.8446564078, green: 0.5145705342, blue: 1, alpha: 1)))
    
    private static func newGame() -> SetGameModel<CardContent> {
        var contents = [CardContent]()
        for number in CardContent.NumberOfShapes.allCases {
            for shape in CardContent.ContentShape.allCases {
                for shading in CardContent.ContentShading.allCases {
                    for color in CardContent.ContentColor.allCases {
                        contents.append(CardContent(numberOfShapes: number, shape: shape, shading: shading, color: color))
                    }
                }
            }
        }
        return SetGameModel(numberOfCardsInDeck: contents.count) { index in contents[index] }
    }
    
    // MARK: Access to the model
    
    var table: [SetGameModel<CardContent>.Card] { setGame?.table ?? [] }
    var deck: [SetGameModel<CardContent>.Card] { setGame?.deck ?? [] }
    var score: Int { setGame?.score ?? 0 }
    var isReadyToMatch: Bool { return setGame?.isReadyToMatch ?? false }
    var isDeckEmpty: Bool { return setGame?.deck.isEmpty ?? true }
    var isBonusConsuming: Bool { return setGame?.isBonusConsuming ?? false }
    var bonusPartRemaining: Double { return setGame?.bonusPartRemaining ?? 0 }
    var bonusTimeRemaining: Double { return setGame?.bonusTimeRemaining ?? 0 }
    
    func cardColor(card: SetGameModel<CardContent>.Card) -> Color {
        switch card.content.color {
            case .red: return colorSet.red
            case .green: return colorSet.green
            case .purple: return colorSet.purple
        }
    }
    
    // MARK: Intents
    
    func newGame() {
        setGame = SetGameViewModel.newGame()
    }
    
    func select(card: SetGameModel<CardContent>.Card) {
        setGame?.select(card: card)
    }
    
    func dealMore() {
        setGame?.deal(3)
    }
    
}
