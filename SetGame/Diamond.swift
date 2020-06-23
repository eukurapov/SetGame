//
//  Diamond.swift
//  SetGame
//
//  Created by Evgeniy Kurapov on 23.06.2020.
//  Copyright © 2020 Evgeniy Kurapov. All rights reserved.
//

import SwiftUI

struct Diamond: Shape {
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let top = CGPoint(x: rect.midX, y: rect.midY - rect.height / 3)
        let left = CGPoint(x: rect.midX - rect.height / 2, y: rect.midY)
        let bottom = CGPoint(x: rect.midX, y: rect.midY + rect.height / 3)
        let right = CGPoint(x: rect.midX + rect.height / 2, y: rect.midY)
        
        path.move(to: top)
        path.addLine(to: left)
        path.addLine(to: bottom)
        path.addLine(to: right)
        path.addLine(to: top)
        
        return path
    }
    
}

struct Diamond_Preview: PreviewProvider {
    static var previews: some View {
        VStack {
            Diamond().stroke()
            Diamond().stroke()
            Diamond().stroke()
        }
    }
}
