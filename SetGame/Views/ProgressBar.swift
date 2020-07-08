//
//  ProgressBarView.swift
//  SetGame
//
//  Created by Eugene Kurapov on 08.07.2020.
//  Copyright © 2020 Evgeniy Kurapov. All rights reserved.
//

import SwiftUI

struct ProgressBar: View {
    
    @Binding var animatedBonustPartRemaining: Double
    
    var isBonusConsuming: Bool
    var bonusPartRemaining: Double
    var bonusTimeRemaining: Double
    var size: CGSize

    var body: some View {
        Group {
            if isBonusConsuming {
                RoundedRectangle(cornerRadius: 3)
                    .fill(Color.blue)
                    .frame(width: size.width * CGFloat(animatedBonustPartRemaining),
                           alignment: Alignment.leading)
            } else if bonusPartRemaining > 0 {
                RoundedRectangle(cornerRadius: 3)
                .fill(Color.blue)
                .frame(width: size.width * CGFloat(bonusPartRemaining),
                       alignment: Alignment.leading)
            }
        }
    }
    
}
