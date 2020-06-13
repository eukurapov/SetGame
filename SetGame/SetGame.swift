//
//  SetGame.swift
//  SetGame
//
//  Created by Evgeniy Kurapov on 12.06.2020.
//  Copyright © 2020 Evgeniy Kurapov. All rights reserved.
//

import Foundation

struct SetGameModel {
    
    private var cards: [Card]!
    private var deck: [Card] { cards.filter { !$0.isDealt && !$0.isDiscarded } }
    var table: [Card] { cards.filter { $0.isDealt && !$0.isDiscarded } }
    private var selectedCards: [Int] { cards.indices.filter { cards[$0].isSelected && !cards[$0].isDiscarded } }
    
    private(set) var score: Int = 0
    
    private var firstSelected: Int? { !selectedCards.isEmpty ? selectedCards[0] : nil }
    private var secondSelected: Int? { selectedCards.count > 1 ? selectedCards[1] : nil }
    private var thirdSelected: Int? { selectedCards.count > 2 ? selectedCards[2] : nil }
    
    init() {
        self.cards = []
        var cardId = 0
        for number in Card.Number.allCases {
            for shape in Card.Shape.allCases {
                for shading in Card.Shading.allCases {
                    for color in Card.Color.allCases {
                        cards.append(Card(id: cardId, numberOfShapes: number, shape: shape, shading: shading, color: color))
                        cardId += 1
                    }
                }
            }
        }
        cards.shuffle()
        deal(cards: 12)
    }
    
    mutating func deal(cards numberToDeal: Int) {
        for i in 0..<numberToDeal {
            if !deck.isEmpty {
                if let index = cards.firstIndexOf(deck[i]) {
                    cards[index].isDealt = true
                }
            }
        }
    }
    
    mutating func select(card: Card) {
        if let selectedIndex = cards.firstIndexOf(card) {
            if selectedCards.count == 3 {
                for index in selectedCards {
                    cards[index].isSelected = false
                    if cards[index].isMatched {
                        cards[index].isDiscarded = true
                        deal(cards: 1)
                    }
                }
            }
            cards[selectedIndex].isSelected = !cards[selectedIndex].isSelected
            tryMatching()
        }
    }
    
    private mutating func tryMatching() {
        if let first = firstSelected, let second = secondSelected, let third = thirdSelected {
            var matched = false

            let colorMatched = Set(selectedCards.map { cards[$0].color }).count != 2 // Set([table[first].color, table[second].color, table[third].color]).count != 2
            let shapeMatched = Set(selectedCards.map { cards[$0].shape }).count != 2
            let shadingMatched = Set(selectedCards.map { cards[$0].shading }).count != 2
            let numberMatched = Set(selectedCards.map { cards[$0].numberOfShapes }).count != 2
            matched = colorMatched && shapeMatched && shadingMatched && numberMatched
            
            cards[first].isMatched = matched
            cards[second].isMatched = matched
            cards[third].isMatched = matched
            score += matched ? 1 : 0
        }
    }
    
    struct Card: Identifiable {
        
        var id: Int
        
        // card state
        var isFaceUp: Bool = true
        var isDealt: Bool = false
        var isSelected: Bool = false
        var isMatched: Bool = false
        var isDiscarded: Bool = false
        
        // card features
        var numberOfShapes: Number
        var shape: Shape
        var shading: Shading
        var color: Color
        
        enum Number: Int, CaseIterable { case one = 1, two, three }
        
        enum Shape: CaseIterable { case diamond, squiggle, oval }
        
        enum Shading: CaseIterable { case solid, striped, open }
        
        enum Color: CaseIterable { case red, green, purple }
    
    }
    
}
