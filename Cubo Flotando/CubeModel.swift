//
//  CubeModel.swift
//  Cubo Flotando
//
//  Created by Adrian on 23/09/2018.
//  Copyright © 2018 Adrián Blázquez León. All rights reserved.
//

import Foundation

class CubeModel {
    
    var L = 30.0
    private var g = 9.8
    lazy var w = sqrt((2*g)/L) // It is found when neccesary.
    //   private var A = 1.0
    
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


