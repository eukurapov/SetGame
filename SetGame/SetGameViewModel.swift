//
//  SetGameViewModel.swift
//  SetGame
//
//  Created by Evgeniy Kurapov on 12.06.2020.
//  Copyright © 2020 Evgeniy Kurapov. All rights reserved.
//

import SwiftUI

class SetGameViewModel: ObservableObject {
    
    @Published private var setGame: SetGameModel<CardContent> = SetGameViewModel.newGame()
    
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
    
    var table: [SetGameModel<CardContent>.Card] { setGame.table }
    var deck: [SetGameModel<CardContent>.Card] { setGame.deck }
    var score: Int { setGame.score }
    var isReadyToMatch: Bool { return setGame.isReadyToMatch }
    var isDeckEmpty: Bool { return setGame.deck.isEmpty }
    var isBonusConsuming: Bool { return setGame.isBonusConsuming }
    var bonusPartRemaining: Double { return setGame.bonusPartRemaining }
    var bonusTimeRemaining: Double { return setGame.bonusTimeRemaining }
    var cheatCount: Int { return setGame.cheatCout }
    
    // MARK: Intents
    
    func newGame() {
        if !setGame.table.isEmpty {
            setGame = SetGameViewModel.newGame()
        }
        setGame.deal(cards: 12)
    }
    
    func select(card: SetGameModel<CardContent>.Card) {
        setGame.select(card: card)
    }
    
    func dealMore() {
        setGame.deal(cards: 3)
    }
    
    func cheat() {
        setGame.cheat()
    }
    
    var timer: Timer?
    func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: setGame.bonusTimeRemaining, repeats: false) { _ in
            self.setGame.updateSpentTime()
        }
    }
    
}

extension CardContent {
    
    var uiColor: UIColor {
        switch self.color {
            case .red: return #colorLiteral(red: 1, green: 0.4932718873, blue: 0.4739984274, alpha: 1)
            case .green: return #colorLiteral(red: 0.4508578777, green: 0.9882974029, blue: 0.8376303315, alpha: 1)
            case .purple: return #colorLiteral(red: 0.8446564078, green: 0.5145705342, blue: 1, alpha: 1)
        }
    }
    
}
