//
//  TimerView.swift
//  Timer
//
//  Created by 土橋正晴 on 2022/12/19.
//

import SwiftUI

struct TimerView: View {
    
    @StateObject private var timer = TimerObject()
    
    @State private var setMin: Int = 0
    
    var body: some View {
        VStack {
            ZStack {
                Circle()
                    .stroke(lineWidth: 10.0)
                    .opacity(0.2)
                    .foregroundColor(.blue)
                    .frame(width: 200, height: 200)
                
                Circle()
                    .trim(from: 0.0, to: timer.progresValue)
                    .stroke(style: StrokeStyle(lineWidth: 10.0, lineCap: .round, lineJoin: .round))
                    .foregroundColor(.blue)
                    .frame(width: 200, height: 200)
                    .rotationEffect(Angle(degrees: -90))
                    .animation(.linear(duration: 1.0), value: timer.progresValue)
                
                Text("\(timer.displayMin)min \(timer.displaySec)sec")
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
                            timer.invalidate()
                            timer.displayMin = setMin
                            timer.displaySec = 0
                            timer.progresValue = 0
                            timer.status = .Start
                        }
                        .buttonStyle(.borderedProminent)
                        .disabled(timer.status == .Start)
                        
                        Spacer()
                        
                        Button("\(timer.status.rawValue)") {
                            switch timer.status {
                            case .Start, .Resume:
                                timer.startTimer(setMin: setMin)
                            case .Pause:
                                timer.invalidate()
                                timer.status = .Resume
                            }
                        }
                        .buttonStyle(.borderedProminent)
                        .disabled(setMin == 0)
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        TimerView()
    }
}
