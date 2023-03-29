//
//  ContentView.swift
//  edutainment
//
//  Created by Kevin Hernandez on 27/03/23.
//

import SwiftUI

struct ContentView: View {
    @State private var tablesValue: Double = 2.0
    @State private var questionsValue = 5
    @State private var submitResponse = false
    @State private var resultMult = 0
    
    let questionOptions = [5, 10, 20]
    var backGroundColor: some View {
        LinearGradient(colors: [.indigo, .clear, .blue], startPoint: .topLeading, endPoint: .bottomTrailing)
            .ignoresSafeArea()
    }
    var buttonStart: some View {
        withAnimation {
            Text("Start")
                .frame(width: 100, height: 100)
                .background(
                    Circle()
                        .foregroundColor(.indigo)
                )
                .foregroundColor(.white)
                .font(.headline)
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                backGroundColor
                VStack (spacing: 20) {
                    Spacer()
                    Section {
                        Text("Times tables up to")
                            .font(.title)
                        Text("\(Int(tablesValue))")
                            .font(.title)
                        Stepper("", value: $tablesValue, in: 2...12)
                            .labelsHidden()
                    }
                    Spacer()
                    Section {
                        Text("Number of questions")
                            .font(.title)
                        Picker("", selection: $questionsValue) {
                            ForEach(questionOptions, id: \.self) { option in
                                Text("\(option)").tag(option)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .padding()
                    }
                    Spacer()
                 
                    NavigationLink(destination: ContentGame(tablesValue: tablesValue, questionsValue: questionsValue)) {
                            buttonStart
                    }
                   
                }
            }
            .navigationTitle("Tables")
        }
    }
}


struct ContentGame: View {
    @State private var resultField = false
    @State private var numberResponse = ""
    @State private var score = 0
    @State private var shouldReset = false
    @State private var stateButton = true
    @State private var alertFinish = false
    @State private var numberQuestion = 0
    @State private var numRandom: Int
    @State private var numRandom2 = Int.random(in: 2...12)
    
    @State private var isEditing = true
    @State private var isSubmitted = false
    
    // Variables styles
    
    var backgroundGame: some View {
            if numberQuestion == 0 {
                return LinearGradient(colors: [.indigo, .clear, .blue], startPoint: .topLeading, endPoint: .bottomTrailing)
                    .ignoresSafeArea()
            } else if resultField {
                return LinearGradient(colors: [.green, .gray], startPoint: .topLeading, endPoint: .bottomTrailing)
                    .ignoresSafeArea()
            } else {
                return LinearGradient(colors: [.red, .gray], startPoint: .topLeading, endPoint: .bottomTrailing)
                    .ignoresSafeArea()
            }
    }
    
    // Varibles struct ContentView
    var tablesValue: Double
    var questionsValue: Int
    
    init(tablesValue: Double, questionsValue: Int) {
        self.tablesValue = tablesValue
        self.questionsValue = questionsValue
        _numRandom = State(initialValue: Int.random(in: 2...Int(tablesValue)))
    }
    
    var tablesUp: String {
        let operationMult = "\(numRandom) * \(numRandom2)"
    
        return operationMult
    }

    var resultado: String {
        let resultMult = "\(numRandom * numRandom2)"
        
        return resultMult
    }
    
    var body: some View {
        ZStack {
            backgroundGame
            VStack {
                Section {
                    Text(tablesUp)
                        .frame(width: 100)
                        .background(.regularMaterial)
                        .opacity(0.6)
                        .font(.largeTitle)
                        .fixedSize(horizontal: false, vertical: true)
                        .frame(height: 100)
                    TextField("Insert response", text: $numberResponse)
                        .multilineTextAlignment(.center)
                        .disabled(isSubmitted)
                        .keyboardType(.numberPad)
                        .frame(width: 200, height: 50)
                        .background(Color.clear)
                        .font(.title)
                    
                    if stateButton {
                        Button("Sent") {
                            if Int(resultado) == Int(numberResponse) {
                                buttonSubmmit()
                                resultField = true
                                score += 1
                            } else {
                                buttonSubmmit()
                                resultField = false
                            }
                        }
                        .frame(width: 100, height: 70)
                        .background(.blue)
                        .foregroundColor(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .disabled(numberResponse == "")
                    } else {
                        Button("Refresh") {
                            restGame()
                        }
                        .frame(width: 100, height: 70)
                        .background(.indigo)
                        .foregroundColor(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                       .disabled(numberResponse == "")
                    }
                }
                
                Spacer()
                
                Section {
                    if shouldReset {
                        Section {
                            Text(Int(resultado) == Int(numberResponse) ? "Correcto \(tablesUp) = \(resultado)" : "Incorrecto el resultado deberia ser = \(resultado)")
                        }
                    }

                    Spacer()
                    Text("SCORE")
                        .padding()
                        .font(.largeTitle)
                    Text("\(score)")
                        .padding()
                        .font(.title)
                }
            }
            .alert("Finish Game", isPresented: $alertFinish) {
                Button("Ok") {
                   finishGame()
                }
            } message: {
                Text("Your score is: \(score)")
            }
        }
    }
        
        func buttonSubmmit () {
          shouldReset = true
          stateButton = false
          numberQuestion += 1
        }
        
        func restGame () {
            if questionsValue == numberQuestion {
                alertFinish = true
            }
            numRandom = Int.random(in: 2...Int(tablesValue))
            numRandom2 = Int.random(in: 1...12)
            shouldReset = false
            stateButton = true
            numberResponse = ""
            isEditing = true
            isSubmitted = false
        }
        
        func finishGame () {
            numberQuestion = 0
            score = 0
            alertFinish = false
            numRandom = Int.random(in: 2...Int(tablesValue))
            numRandom2 = Int.random(in: 1...12)
            shouldReset = false
            stateButton = true
            numberResponse = ""
    }
}
/*
            VStack {
                Section {
                    Text(tablesUp)
                        .frame(width: 100)
                        .background(.regularMaterial)
                        .opacity(0.6)
                        .font(.largeTitle)
                        .fixedSize(horizontal: false, vertical: true)
                        .frame(height: 100)
                    TextField("Insert response", value: $numberResponse, formatter: NumberFormatter())
                        .multilineTextAlignment(.center)
                       // .disabled(isSubmitted)
                        .keyboardType(.numberPad)
                        .frame(width: 200, height: 50)
                        .background(Color.clear)
                        .font(.title)
                    
                    if stateButton {
                        Button("Sent") {
                            if Int(resultado) == numberResponse {
                                //buttonSubmmit()
                                buttonSubmmit()
                                resultField = true
                                score += 1
                            } else {
                                //buttonSubmmit()
                                buttonSubmmit()
                                resultField = false
                            }
                        }
                        .frame(width: 100, height: 70)
                        .background(.blue)
                        .foregroundColor(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                       // .disabled(numberResponse == nil)
                    } else {
                        Button("Refresh") {
                            restGame()
                        }
                        .frame(width: 100, height: 70)
                        .background(.indigo)
                        .foregroundColor(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                       // .disabled(numberResponse == nil)
                    }
                }
                /*
                .onAppear {
                    isSubmitted = true
                    isEditing = false
                }
                 */
                Spacer()
                Section {
                    if shouldReset {
                        Section {
                            Text(Int(resultado) == numberResponse ? "Correcto \(tablesUp) = \(resultado)" : "Incorrecto el resultado deberia ser = \(resultado)")
                        }
                    }

                    Spacer()
                    Text("SCORE")
                        .padding()
                        .font(.largeTitle)
                    Text("\(score)")
                        .padding()
                        .font(.title)
                   
                }
            }
            .alert("Finish Game", isPresented: $alertFinish) {
                Button("Ok") {
                    finishGame()
                }
            } message: {
                Text("Your score is: \(score)")
            }
        }
    }
    
    func buttonSubmmit () {
      shouldReset = true
      stateButton = false
      numberQuestion += 1
    }
    
    func restGame () {
        if questionsValue == numberQuestion {
            alertFinish = true
        }
        numRandom = Int.random(in: 2...Int(tablesValue))
        numRandom2 = Int.random(in: 1...12)
        shouldReset = false
        stateButton = true
        numberResponse = nil
        //isEditing = true
        //isSubmitted = false
    }
    
    func finishGame () {
        score = 0
        alertFinish = false
        numRandom = Int.random(in: 2...Int(tablesValue))
        numRandom2 = Int.random(in: 1...12)
        shouldReset = false
        stateButton = true
        numberResponse = nil
    }
}
*/
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

