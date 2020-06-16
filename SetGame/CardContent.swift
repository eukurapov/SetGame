//
//  CardContent.swift
//  SetGame
//
//  Created by Evgeniy Kurapov on 13.06.2020.
//  Copyright © 2020 Evgeniy Kurapov. All rights reserved.
//

import SwiftUI

struct CardContent: Matchable {
    
    // card features
    var numberOfShapes: NumberOfShapes
    var shape: ContentShape
    var shading: ContentShading
    var color: ContentColor
    
    enum NumberOfShapes: Int, CaseIterable { case one = 1, two, three }
    enum ContentShape: CaseIterable { case diamond, squiggle, oval }
    enum ContentShading: CaseIterable { case solid, striped, open }
    enum ContentColor: CaseIterable { case red, green, purple }
    
    static func match(items: [CardContent]) -> Bool {
        let colorMatched = featureMatch(items: items) { $0.color }
        let shapeMatched = featureMatch(items: items) { $0.shape }
        let shadingMatched = featureMatch(items: items) { $0.shading }
        let numberMatched = featureMatch(items: items) { $0.numberOfShapes }
        return colorMatched && shapeMatched && shadingMatched && numberMatched
    }
    
    private static func featureMatch<T>(items: [CardContent], transform: (CardContent) -> T) -> Bool where T: Hashable {
        return [1,items.count].contains(Set(items.map { transform($0) }).count)
    }
    
}
