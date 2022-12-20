//
//  ContentView.swift
//  Timer
//
//  Created by 土橋正晴 on 2022/12/19.
//

import SwiftUI


enum Status: String {
    case Start
    case Pause
    case Resume
}

struct ContentView: View {
    
    @State var progresValue: CGFloat = 0.0
    @State var timer :Timer?
    @State var setMin: Int = 0
    @State var displayMin: Int = 0
    @State var displaySec: Int = 0
    @State var status = Status.Start
    @State var sec = 0
    
    var body: some View {
        VStack {
            ZStack {
                Circle()
                    .stroke(lineWidth: 10.0)
                    .opacity(0.2)
                    .foregroundColor(.blue)
                    .frame(width: 200, height: 200)
                
                Circle()
                    .trim(from: 0.0, to: progresValue)
                    .stroke(style: StrokeStyle(lineWidth: 10.0, lineCap: .round, lineJoin: .round))
                    .foregroundColor(.blue)
                    .frame(width: 200, height: 200)
                    .rotationEffect(Angle(degrees: -90))
                    .animation(.linear(duration: 1))
                
                Text("\(displayMin)min \(displaySec)sec")
                    .dynamicTypeSize(.large)
                    .font(.headline)
                
            }
            .padding()
            
            Form() {
                Section {
                    Picker(selection: $setMin) {
                        ForEach(0..<61) {
                            Text("\($0)")
                        }
                    } label: {
                        Text("min")
                    }
                }
                
                Section {
                    HStack(alignment: .center) {
                        Button("Cancel") {
                            timer?.invalidate()
                            displayMin = setMin
                            displaySec = 0
                            progresValue = 0
                            status = .Start
                        }
                        .buttonStyle(.borderedProminent)
                        .disabled(status == .Start)
                        
                        Spacer()
                        
                        Button("\(status.rawValue)") {
                            switch status {
                            case .Start, .Resume:
                                startTimer()
                            case .Pause:
                                timer?.invalidate()
                                status = .Resume
                            }
                        }
                        .buttonStyle(.borderedProminent)
                        .disabled(setMin == 0)
                    }
                }
            }
        }
    }
    
    
    func startTimer() {
        if setMin == 0 {
            return
        }
        
        timer?.invalidate()
        
        if status == .Start {
            displayMin = setMin
            displaySec = 0
            progresValue = 0
            sec = 0
        }
        status = .Pause
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            if displaySec == 0 {
                displayMin -= 1
                displaySec = 59
            } else {
                displaySec -= 1
            }
            progresValue += 1 / CGFloat((60 * setMin))
            self.sec += 1
            if sec == (60 * setMin) {
                timer.invalidate()
                status = .Start
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
