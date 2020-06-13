//
//  Matchable.swift
//  SetGame
//
//  Created by Evgeniy Kurapov on 13.06.2020.
//  Copyright © 2020 Evgeniy Kurapov. All rights reserved.
//

import Foundation

protocol Matchable {
    
    static func match(items: [Self]) -> Bool
    
}
