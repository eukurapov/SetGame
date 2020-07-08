//
//  SetGameModel.swift
//  SetGame
//
//  Created by Evgeniy Kurapov on 12.06.2020.
//  Copyright © 2020 Evgeniy Kurapov. All rights reserved.
//

import Foundation

struct SetGameModel<CardContent> where CardContent: Matchable {
    
    private var cards: [Card]!
    var deck: [Card] { cards.filter { !$0.isDealt && !$0.isDiscarded } }
    var table: [Card] { cards.filter { $0.isDealt && !$0.isDiscarded } }
    private var selectedCards: [Int] { cards.indices.filter { cards[$0].isSelected && !cards[$0].isDiscarded } }
    var isReadyToMatch: Bool { selectedCards.count == numberOfCardsToMatch }
    
    private(set) var score: Int = 0
    
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
        if isReadyToMatch {
            for index in selectedCards {
                if cards[index].isMatched {
                    cards[index].isDiscarded = true
                }
            }
        }
        for _ in 0..<numberToDeal {
            if !deck.isEmpty {
                if let index = cards.firstIndexOf(deck[0]) {
                    cards[index].isDealt = true
                }
            }
        }
        if isBonusConsuming {
            penalizeBonusTime()
        } else {
            startUsingBonusTime()
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
                stopUsingBonusTime()
                
                for index in selectedCards {
                    cards[index].isMatched = true
                }
                
                score += bonusTimeRemaining > 0 ? 2 : 1
                //print("↑ score added: \(bonusTimeRemaining > 0 ? 2 : 1)")
                
                resetSpentTime()
            }
        }
    }
    
    struct Card: Identifiable {
        
        var id: Int
        var content: CardContent
        
        // card state
        var isFaceUp: Bool = false
        var isDealt: Bool = false {
            didSet {
                isFaceUp = isDealt
            }
        }
        var isSelected: Bool = false
        var isMatched: Bool = false
        var isDiscarded: Bool = false
        
    }
    
    // Time consuming to add bonus for quick match
    private var bonusTimeLimit = TimeInterval(20)
    private var bonusTimeSpent = TimeInterval(0)
    private var lastDealTime: Date!
    
    var isBonusConsuming: Bool {
        bonusTimeRemaining > 0 && lastDealTime != nil
    }
    
    var bonusTimeRemaining: TimeInterval {
        max(0, bonusTimeLimit - bonusTimeSpent)
    }
    
    var bonusPartRemaining: Double {
        bonusTimeRemaining > 0 ? bonusTimeRemaining / bonusTimeLimit : 0
    }
    
    private mutating func startUsingBonusTime() {
        if lastDealTime == nil, bonusTimeRemaining > 0 {
            lastDealTime = Date()
            //print("✓ start at \(lastDealTime!)")
        }
    }
    
    private mutating func stopUsingBonusTime() {
        if lastDealTime != nil {
            //print("× stop at \(lastDealTime!)")
            bonusTimeSpent += Date().timeIntervalSince(lastDealTime)
            lastDealTime = nil
        }
    }
    
    private mutating func resetSpentTime() {
        //print("+ reset bonus time from \(bonusTimeSpent)")
        bonusTimeSpent = 0
    }
    
    private mutating func penalizeBonusTime(for timeFee: Double = 5) {
        if lastDealTime != nil {
            bonusTimeSpent += timeFee + Date().timeIntervalSince(lastDealTime)
            //print("- charged bonus time to \(bonusTimeSpent)")
        }
    }
}
