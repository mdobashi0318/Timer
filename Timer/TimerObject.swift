//
//  TimerObject.swift
//  Timer
//
//  Created by 土橋正晴 on 2022/12/21.
//

import Foundation

class TimerObject: ObservableObject {

    enum Status: String {
        case Start
        case Pause
        case Resume
    }
    
    @Published var progresValue: CGFloat = 0.0
    @Published var displayMin: Int = 0
    @Published var displaySec: Int = 0
    @Published var status = Status.Start
    
    private var timer :Timer?
    private var sec = 0
    
    func startTimer(setMin: Int) {
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
            if self.displaySec == 0 {
                self.displayMin -= 1
                self.displaySec = 59
            } else {
                self.displaySec -= 1
            }
            self.progresValue += 1 / CGFloat((60 * setMin))
            self.sec += 1
            if self.sec == (60 * setMin) {
                self.invalidate()
                self.status = .Start
            }
        }
    }
    
    func invalidate() {
        timer?.invalidate()
    }
}
