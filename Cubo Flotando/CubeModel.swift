//
//  CubeModel.swift
//  Cubo Flotando
//
//  Created by Adrian on 23/09/2018.
//  Copyright © 2018 Adrián Blázquez León. All rights reserved.
//

import Foundation

class CubeModel {
    
    // As the view can change the model, they must be in alert
    
    var interestT : Double = 0.0
    // No need of chanign it?
//    {
//        didSet{
//            setNeedsDisplay()
//        }
//    }
    
    var L : Double = 100.0{
        didSet {
            updateW()
        }
    }
    
    private var g = 9.8
    var w = 6.0 // It is found when neccesary.
    //   private var A = 1.0
    
    //Update the value of w that change due to actions to the view.
    private func updateW() {
        w = sqrt((2*g)/L)
    }
    // This methods must be public so it can be acceced to them from the viewCOntroller
    /**
     Give the position of the cube at time t.
     
     parameter t
     
     return pos
     */
    func posAtTime(_ t: Double) -> (Double) {
        return (1/2)*L*cos(w*t)
    }
    
    /**
     Give the speed at time t
     
     parameter t
     
     return speed
     */
    func speedAtTime(_ t: Double) -> (Double) {
        return -(1/2)*L*w*sin(w*t)
    }
    
    /**
     Give the speed at time t
     
     parameter t
     
     return speed
     */
    func accAtTime(_ t: Double) -> (Double) {
        return -g*cos(w*t)
    }
    
}


