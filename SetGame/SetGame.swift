//
//  SetGame.swift
//  SetGame
//
//  Created by Evgeniy Kurapov on 12.06.2020.
//  Copyright © 2020 Evgeniy Kurapov. All rights reserved.
//

import Foundation

struct SetGameModel<CardContent> where CardContent: Matchable {
    
    private var cards: [Card]!
    private var deck: [Card] { cards.filter { !$0.isDealt && !$0.isDiscarded } }
    var table: [Card] { cards.filter { $0.isDealt && !$0.isDiscarded } }
    private var selectedCards: [Int] { cards.indices.filter { cards[$0].isSelected && !cards[$0].isDiscarded } }
    private var isReadyToMatch: Bool { selectedCards.count == numberOfCardsToMatch }
    
    private(set) var score: Int = 0
    
    private var firstSelected: Int? { !selectedCards.isEmpty ? selectedCards[0] : nil }
    private var secondSelected: Int? { selectedCards.count > 1 ? selectedCards[1] : nil }
    private var thirdSelected: Int? { selectedCards.count > 2 ? selectedCards[2] : nil }
    
    // TODO: Update to take it as init parameter
    let numberOfCardsToMatch = 3
    let numberOfCardsToStart = 12
    
    init(numberOfCardsInDeck: Int, cardContentFactory: (Int) -> CardContent) {
        cards = []
        for index in 0..<numberOfCardsInDeck {
            cards.append(Card(id: index, content: cardContentFactory(index)))
        }
        cards.shuffle()
        deal(numberOfCardsToStart)
    }
    
    mutating func deal(_ numberToDeal: Int = 1) {
        for _ in 0..<numberToDeal {
            if !deck.isEmpty {
                if let index = cards.firstIndexOf(deck[0]) {
                    cards[index].isDealt = true
                }
            }
        }
    }
    
    mutating func select(card: Card) {
        if let selectedIndex = cards.firstIndexOf(card) {
            if isReadyToMatch {
                for index in selectedCards {
                    cards[index].isSelected = false
                    if cards[index].isMatched {
                        cards[index].isDiscarded = true
                        deal()
                    }
                }
            }
            cards[selectedIndex].isSelected = !cards[selectedIndex].isSelected
            tryMatching()
        }
    }
    
    private mutating func tryMatching() {
        if isReadyToMatch {
            let matched = CardContent.match(items: selectedCards.map { cards[$0].content })
            if matched {
                for index in selectedCards {
                    cards[index].isMatched = true
                }
                score += 1
            }
        }
    }
    
    struct Card: Identifiable {
        
        var id: Int
        var content: CardContent
        
        // card state
        var isFaceUp: Bool = true
        var isDealt: Bool = false
        var isSelected: Bool = false
        var isMatched: Bool = false
        var isDiscarded: Bool = false
        
    }
    
}
