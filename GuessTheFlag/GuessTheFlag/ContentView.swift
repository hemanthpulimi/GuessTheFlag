//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Hemanth Pulimi on 17/12/21.
//

import SwiftUI

struct FlagImage: View {
    var country: String
    
    var body: some View {
        Image(country)
            .renderingMode(.original)
            .clipShape(Capsule())
            .shadow(radius: 5)
    }
}

struct ContentView: View {
    @State private var showingScore = false
    @State private var finalAlert = false
    @State private var scoreTitle = ""
    @State private var score = 0
    @State private var tapCount = 1
    
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    
    @State private var correctAnswer = Int.random(in: 0...2)
    
    @State private var animationAmount = 0.0
    @State private var opacity = 1.0
    @State private var tappedFlag = ""
    
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.black, .orange]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            VStack {
                Text("\(tapCount)")
                    .foregroundColor(.white)
                    .font(.title)
                Spacer()
                
                Text("Guess the Flag")
                    .font(.largeTitle.bold())
                    .foregroundColor(.white)
                
                VStack(spacing: 15) {
                    VStack {
                        Text("Tap the flag of")
                            .foregroundStyle(.secondary)
                            .font(.subheadline.weight(.heavy))
                        Text(countries[correctAnswer])
                            .font(.largeTitle.weight(.semibold))
                    }
                    
                    ForEach(0..<3) { number in
                        Button {
                            tappedFlag = countries[number]
                            flagTapped(number)
                            withAnimation {
                                animationAmount += 360
                                opacity = 0.50
                                
                            }
                        } label: {
                            FlagImage(country: countries[number])
                        }
                        .rotation3DEffect(
                            .degrees(tappedFlag == countries[number] ? animationAmount : 0),
                            axis: (x: 0, y: 1, z: 0)
                        )
                        .scaleEffect(tappedFlag != countries[number] ? opacity : 1.0)
                        .opacity(tappedFlag != countries[number] ? opacity : 1.0)
                        // 'opacity' property is used for both scaleEffect and opacity.
                        
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                
                Spacer()
                Spacer()
                
                Text("Score: \(score)")
                    .foregroundColor(.white)
                    .font(.title.bold())
                
                Spacer()
                
                Button("Reset", action: reset)
                    .buttonStyle(.borderedProminent)
                
            }
            .padding()
        }
        .alert(scoreTitle, isPresented: $showingScore) {
            Button("Continue", action: askQuestion)
        } message: {
            Text("Your score is \(score)")
        }
        .alert("Game Over!", isPresented: $finalAlert) {
            Button("OK", action: reset)
        } message: {
            Text("Your final score is \(score)")
        }
        
    }
    
    func flagTapped(_ number: Int) {
        if number == correctAnswer {
            scoreTitle = "Correct"
            score += 1
        } else {
            scoreTitle = "Wrong! That's the flag of \(countries[number])"
        }
        
        showingScore = true
    }
    
    func askQuestion() {
        if tapCount == 10 {
            finalAlert = true
        }
        
        opacity = 1.0
        
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        tapCount += 1
    }
    
    func reset() {
        score = 0
        tapCount = 1
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
