//
//  Squiggle.swift
//  SetGame
//
//  Created by Eugene Kurapov on 07.07.2020.
//  Copyright © 2020 Evgeniy Kurapov. All rights reserved.
//

import SwiftUI

struct Squiggle: Shape {
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let points = [
            CGPoint(x: rect.minX + rect.width*8/24,  y: rect.minY), // 0, starting, top left
            CGPoint(x: rect.minX + rect.width*11/24, y: rect.minY), // 1
            CGPoint(x: rect.minX + rect.width*13/24, y: rect.minY + rect.height/3), // 2
            CGPoint(x: rect.minX + rect.width*15/24, y: rect.minY + rect.height/3), // 3, top mid
            CGPoint(x: rect.minX + rect.width*18/24, y: rect.minY + rect.height/3), // 4
            CGPoint(x: rect.minX + rect.width*17/24, y: rect.minY), // 5
            CGPoint(x: rect.minX + rect.width*20/24, y: rect.minY), // 6, top right
            CGPoint(x: rect.minX + rect.width*23/24, y: rect.minY), // 7
            CGPoint(x: rect.maxX,                    y: rect.minY + rect.height*5/24), // 8
            CGPoint(x: rect.maxX,                    y: rect.minY + rect.height/3), // 9, right
            CGPoint(x: rect.maxX,                    y: rect.minY + rect.height*20/24), // 10
            CGPoint(x: rect.maxX - rect.width*6/24,  y: rect.maxY), // 11
            CGPoint(x: rect.maxX - rect.width*8/24,  y: rect.maxY), // 12, bottom right
            CGPoint(x: rect.maxX - rect.width*11/24, y: rect.maxY), // 13
            CGPoint(x: rect.maxX - rect.width*13/24, y: rect.maxY - rect.height/3), // 14
            CGPoint(x: rect.maxX - rect.width*15/24, y: rect.maxY - rect.height/3), // 15, bottom mid
            CGPoint(x: rect.maxX - rect.width*18/24, y: rect.maxY - rect.height/3), // 16
            CGPoint(x: rect.maxX - rect.width*17/24, y: rect.maxY), // 17
            CGPoint(x: rect.maxX - rect.width*20/24, y: rect.maxY), // 18, bottom left
            CGPoint(x: rect.maxX - rect.width*23/24, y: rect.maxY), // 19
            CGPoint(x: rect.minX,                    y: rect.maxY - rect.height*5/24), // 20
            CGPoint(x: rect.minX,                    y: rect.maxY - rect.height/3), // 21, left
            CGPoint(x: rect.minX,                    y: rect.maxY - rect.height*20/24), // 22
            CGPoint(x: rect.minX + rect.width*6/24,  y: rect.minY) // 23
            
        ]
        
        path.move(to: points[0])
        path.addCurve(to: points[3],  control1: points[1],  control2: points[2])
        path.addCurve(to: points[6],  control1: points[4],  control2: points[5])
        path.addCurve(to: points[9],  control1: points[7],  control2: points[8])
        path.addCurve(to: points[12], control1: points[10], control2: points[11])
        path.addCurve(to: points[15], control1: points[13], control2: points[14])
        path.addCurve(to: points[18], control1: points[16], control2: points[17])
        path.addCurve(to: points[21], control1: points[19], control2: points[20])
        path.addCurve(to: points[0],  control1: points[22], control2: points[23])
        path.closeSubpath()
        
        return path
    }
    
}
