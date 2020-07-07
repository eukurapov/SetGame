//
//  Cardify.swift
//  Memorize
//
//  Created by Evgeniy Kurapov on 07.06.2020.
//  Copyright © 2020 Evgeniy Kurapov. All rights reserved.
//

import SwiftUI

struct Cardify: AnimatableModifier {
    var isFaceUp: Bool {
        get { rotation < 90 }
    }
    var shadowColor: Color?
    var coverGradient: Gradient?
    private var rotation: Double
    
    init(isFaceUp: Bool, shadowColor: Color?, coverGradient: Gradient?) {
        rotation = isFaceUp ? 0 : 180
        self.coverGradient = coverGradient
        self.shadowColor = shadowColor
    }
    
    var animatableData: Double {
        get { rotation }
        set { rotation = newValue }
    }

    func body(content: Content) -> some View {
        ZStack {
            if shadowColor != nil {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .shadow(
                        color: shadowColor!.opacity(1),
                        radius: 9)
            }
            
            Group {
                RoundedRectangle(cornerRadius: cornerRadius).stroke(lineWidth: strokeWidth)
                RoundedRectangle(cornerRadius: cornerRadius).fill().foregroundColor(.white)
                content
            }
            .opacity(isFaceUp ? 1 : 0)
            Group {
                if coverGradient != nil {
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .fill(LinearGradient(gradient: coverGradient!, startPoint: .topLeading, endPoint: .bottomTrailing))
                } else {
                    RoundedRectangle(cornerRadius: cornerRadius).fill()
                }
            }
            .opacity(isFaceUp ? 0 : 1)
        }
        .rotation3DEffect(Angle(degrees: rotation), axis: (0,1,0))
    }
    
    private let cornerRadius: CGFloat = 10
    private let strokeWidth: CGFloat = 1
}

extension View {
    func cardify(isFaceUp: Bool,
                 shadowColor: Color? = nil,
                 with gradient: Gradient? = nil) -> some View {
        self.modifier(Cardify(isFaceUp: isFaceUp,
                              shadowColor: shadowColor,
                              coverGradient: gradient))
    }
}
