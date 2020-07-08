//
//  ContentView.swift
//  SetGame
//
//  Created by Evgeniy Kurapov on 12.06.2020.
//  Copyright © 2020 Evgeniy Kurapov. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var setGameViewModel: SetGameViewModel
    @State var animatedBonustPartRemaining: Double = 0
    
    var canCheat: Bool {
        setGameViewModel.bonusTimeRemaining <= 0 && setGameViewModel.cheatCount > 0 && !setGameViewModel.isReadyToMatch
    }
    
    private func startBonusTimeAnimation() {
        animatedBonustPartRemaining = setGameViewModel.bonusPartRemaining
        withAnimation(.linear(duration: setGameViewModel.bonusTimeRemaining)) {
            animatedBonustPartRemaining = 0
        }
        setGameViewModel.startTimer()
    }
    
    var body: some View {
        VStack {
            HStack {
                Button("New Game") {
                    withAnimation {
                        self.setGameViewModel.newGame()
                        self.startBonusTimeAnimation()
                    }
                }
                Spacer()
                Text("Score: \(setGameViewModel.score)")
                Spacer()
                Button("Deal More") {
                    withAnimation {
                        self.setGameViewModel.dealMore()
                        self.startBonusTimeAnimation()
                    }
                }
                .disabled(setGameViewModel.isDeckEmpty)
            }
                .padding(5)
            HStack {
                GeometryReader { geo in
                    ProgressBar(animatedBonustPartRemaining: self.$animatedBonustPartRemaining,
                                isBonusConsuming: self.setGameViewModel.isBonusConsuming,
                                bonusPartRemaining: self.setGameViewModel.bonusPartRemaining,
                                bonusTimeRemaining: self.setGameViewModel.bonusTimeRemaining,
                                size: geo.size)
                        .onAppear {
                            self.startBonusTimeAnimation()
                        }
                    Spacer()
                }.frame(height: 10, alignment: Alignment.center).padding(.horizontal)
                Button("Cheat (\(self.setGameViewModel.cheatCount))") {
                    withAnimation {
                        self.setGameViewModel.cheat()
                    }
                }
                .disabled(!canCheat)
                .padding(.horizontal, 5)
            }
            Grid(setGameViewModel.table) { card in
                CardView(card: card, shadowColor: self.highlightColor)
                    .transition(.offset(CGSize(width: Int.random(in: -500...1000), height: Int.random(in: -500...1000))))
                    .animation(.easeInOut(duration: 0.45))
                    .onTapGesture {
                        withAnimation {
                            self.setGameViewModel.select(card: card)
                        }
                    }
            }
                .padding(5)
        }
        .onAppear {
            if self.setGameViewModel.table.isEmpty {
                withAnimation {
                    self.setGameViewModel.newGame()
                }
            }
        }
    }
    
    private func highlightColor(card: SetGameModel<CardContent>.Card) -> Color? {
        var color: Color? = nil
        if card.isSelected {
            if card.isMatched {
                color = Color(#colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1))
            } else if setGameViewModel.isReadyToMatch {
                color = Color(#colorLiteral(red: 1, green: 0.4932718873, blue: 0.4739984274, alpha: 1))
            } else {
                color = Color(#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1))
            }
        }
        return color
    }
    
}





















struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let setGameViewModel = SetGameViewModel()
        setGameViewModel.newGame()
        setGameViewModel.select(card: setGameViewModel.table[0])
        return ContentView(setGameViewModel: setGameViewModel)
    }
}
