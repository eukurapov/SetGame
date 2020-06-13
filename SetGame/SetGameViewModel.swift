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
    
    private static func newGame() -> SetGameModel {
        return SetGameModel()
    }
    
    // MARK: Access to the model
    
    var table: [SetGameModel.Card] { setGame.table }
    var score: Int { setGame.score }
    
    func color(for cardColor: SetGameModel.Card.Color) -> Color {
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
    
    func select(card: SetGameModel.Card) {
        setGame.select(card: card)
    }
    
    func dealMore() {
        setGame.deal(cards: 3)
    }
    
}
