//
//  MotionHelper.swift
//  MyFirstSwiftGame
//
//  Created by Giuseppe Cosenza on 07/10/24.
//

import Foundation
import CoreMotion

class MotionHelper {
    let motionManager = CMMotionManager()
    
    init(){
    }
    
    func getAccelerometerData(
        interval: TimeInterval = 0.1,
        motionDataResult: ((_ x: Float, _ y: Float, _ z: Float) -> ())?
    ) {
        if motionManager.isAccelerometerAvailable {
            motionManager.accelerometerUpdateInterval = interval
            
            motionManager.startAccelerometerUpdates(to: OperationQueue()) { (data, error) in
                if(motionDataResult != nil) {
                    motionDataResult!(Float(data!.acceleration.x), Float(data!.acceleration.y), Float(data!.acceleration.z))
                }
            }
        }
    }
}
