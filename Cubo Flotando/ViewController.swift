
//  ViewController.swift
//  Cubo Flotando
//
//  Created by Adrian on 27/09/2018.
//  Copyright © 2018 Adrián Blázquez León. All rights reserved.
//

import UIKit

// Each FunctionView of the screen has a certain name.



class ViewController: UIViewController, FunctionViewDataSource {
    
    @IBOutlet weak var posTimeFunctionView: FunctionView!
    
    @IBOutlet weak var speedTimeFunctionView: FunctionView!
    
    @IBOutlet weak var accTimeFunctionView: FunctionView!
    
    @IBOutlet weak var speedPosFunctionView: FunctionView!
    
    @IBOutlet weak var ladoSlider: UISlider!

    @IBOutlet weak var posLabel: UILabel!
    
    var cubeModel = CubeModel() // It is created an object of class cubeMode
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // It is stored
        posTimeFunctionView.dataSource = self
        speedTimeFunctionView.dataSource = self
        accTimeFunctionView.dataSource = self
        speedPosFunctionView.dataSource = self
        
        // cubeModel.L = 1.0
        ladoSlider.sendActions(for: .valueChanged)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // The update also display the new
    @IBAction func updateLado(_ sender: UISlider) {
        
        cubeModel.L = Double(sender.value)*100
        
        posTimeFunctionView.setNeedsDisplay()
        speedTimeFunctionView.setNeedsDisplay()
        accTimeFunctionView.setNeedsDisplay()
        speedPosFunctionView.setNeedsDisplay()
    }
    
    func startTimeOfFunctionView(_ functionView: FunctionView) -> Double {
        return 0
    }
    
    func endTimeOfFunctionView(_ functionView: FunctionView) -> Double {
        return 10
    }
    
    /**
     Depend on the FunctionView and time ti gives the matching point.
     */
    func pointOfFunctionView(_ functionView: FunctionView, atTime time: Double) -> Point {
        switch functionView {
        case posTimeFunctionView :
            return Point(x: time, y: cubeModel.posAtTime(time))
        case speedTimeFunctionView :
            return Point(x: time, y: cubeModel.speedAtTime(time))
        case accTimeFunctionView :
            return Point(x: time, y: cubeModel.accAtTime(time))
        case speedPosFunctionView :
            return Point(x: cubeModel.posAtTime(time), y: cubeModel.speedAtTime(time))
        default:
            return Point(x: 0,y: 0) // Whichever point
        }
    }
    
}
