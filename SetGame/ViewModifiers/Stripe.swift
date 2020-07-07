//
//  Stripe.swift
//  SetGame
//
//  Created by Eugene Kurapov on 07.07.2020.
//  Copyright © 2020 Evgeniy Kurapov. All rights reserved.
//

import SwiftUI

struct Stripe: ViewModifier {
    
    var lineWidth: CGFloat = 1.0
    var angle: Angle = Angle(degrees: 0)
    var frequency: CGFloat = 40
    
    init() {}
    
    init(lineWidth: CGFloat? = nil, angle: Angle? = nil, frequency: CGFloat? = nil) {
        self.init()
        self.lineWidth = lineWidth ?? self.lineWidth
        self.angle = angle ?? self.angle
        self.frequency = frequency ?? self.frequency
    }
    
    func body(content: Content) -> some View {
        GeometryReader { geo in
            self.stripedContent(content, with: geo.size)
        }
    }
    
    func stripedContent(_ content: Content, with size: CGSize) -> some View {
        let dimention = max(size.width, size.height)
        return content
            .mask(StripesRect(frequency: frequency)
                .stroke(lineWidth: lineWidth)
                .frame(width: dimention, height: dimention, alignment: Alignment.center)
                .scaledToFit()
                .rotationEffect(angle))
    }
    
    private struct StripesRect: Shape {
        
        var frequency: CGFloat
        
        func path(in rect: CGRect) -> Path {
            var path = Path()
            let step = rect.width / frequency
            var x = rect.minX
            let startPoint = CGPoint(x: rect.minX, y: rect.minY)
            
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
    
    func stripe(lineWidth: CGFloat? = nil,
                angle: Angle? = nil,
                frequency: CGFloat? = nil) -> some View {
        self.modifier(Stripe(lineWidth: lineWidth,
                             angle: angle,
                             frequency: frequency))
    }
    
}


struct Stripe_Previews: PreviewProvider {
    static var previews: some View {
        Squiggle().stroke(lineWidth: 2).overlay(Squiggle().stripe())
    }
}
