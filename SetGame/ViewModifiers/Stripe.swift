//
//  Stripe.swift
//  SetGame
//
//  Created by Eugene Kurapov on 07.07.2020.
//  Copyright © 2020 Evgeniy Kurapov. All rights reserved.
//

import SwiftUI

struct Stripe: ViewModifier {
    
    func body(content: Content) -> some View {
        content.mask(StripesRect().stroke(lineWidth: 1))
    }
    
    private struct StripesRect: Shape {
        
        func path(in rect: CGRect) -> Path {
            var path = Path()
            let startPoint = CGPoint(x: rect.minX, y: rect.minY)
            let step = rect.width / 20 // add parameters to determine stripes width and frequency
            var x = rect.minX
            
            path.move(to: startPoint)
            while x <= rect.maxX {
                path.addLine(to: CGPoint(x: x, y: rect.maxY))
                path.closeSubpath()
                x += step
                path.move(to: CGPoint(x: x, y: rect.minY))
            }
            
            return path
        }
        
    }
    
}

extension View {
    
    func stripe() -> some View {
        self.modifier(Stripe())
    }
    
}


struct Stripe_Previews: PreviewProvider {
    static var previews: some View {
        Squiggle().stroke(lineWidth: 2).overlay(Squiggle().stripe())
    }
}
