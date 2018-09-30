
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
    
    @IBOutlet weak var posLabel: UILabel!
    
    @IBOutlet weak var speedLabel: UILabel!
    
    @IBOutlet weak var accLabel: UILabel!
    
    @IBOutlet weak var timeSlider: UISlider!
    
    @IBOutlet weak var ladoSlider: UISlider!
    
     var cubeModel = CubeModel() // It is created an object of class cubeMode
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // It is stored
        posTimeFunctionView.dataSource = self
        speedTimeFunctionView.dataSource = self
        accTimeFunctionView.dataSource = self
        speedPosFunctionView.dataSource = self
        
        //print("im here")
        
        // cubeModel.L = 1.0
        ladoSlider.sendActions(for: .valueChanged)
        timeSlider.sendActions(for: .valueChanged)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // The update also display the new
    @IBAction func updateLado(_ sender: UISlider) {
        
        cubeModel.L = Double(sender.value)*1000
        
        posTimeFunctionView.setNeedsDisplay()
        speedTimeFunctionView.setNeedsDisplay()
        accTimeFunctionView.setNeedsDisplay()
        speedPosFunctionView.setNeedsDisplay()
    }
    
     // Update the labels with a certain value, and vary the display of an special point.
    @IBAction func updateTime(_ sender: UISlider) {
        cubeModel.interestT = Double(sender.value)*40
        let t = cubeModel.interestT
        // THe pioints of interest are represented and labeled
        
        // Labels are initialized
        posLabel.text = ""
        speedLabel.text = ""
        accLabel.text = ""
        
        // Filled the labels with pos, speed and acc.
        
        let pos = cubeModel.posAtTime(t)
        let speed = cubeModel.speedAtTime(t)
        let acc = cubeModel.accAtTime(t)
        
        // It is formatted as desired.
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        
        if let fpos = formatter.string(from: pos as NSNumber){
            posLabel.text = "\(fpos) m"
        }
        if let fspeed = formatter.string(from: speed as NSNumber){
            speedLabel.text = "\(fspeed) m/s"
        }
        if let facc = formatter.string(from: acc as NSNumber){
            accLabel.text = "\(facc) m/s^2"
        }
        
        posTimeFunctionView.setNeedsDisplay()
        speedTimeFunctionView.setNeedsDisplay()
        accTimeFunctionView.setNeedsDisplay()
        speedPosFunctionView.setNeedsDisplay()
        
    }
    
    func startTimeOfFunctionView(_ functionView: FunctionView) -> Double {
        return 0
    }
    
    func endTimeOfFunctionView(_ functionView: FunctionView) -> Double {
        return 2
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
    
    /**
     Given the FunctionVIew it takes the
     InterestTime and find the interest points, that
     is to say, for every FunctionView.
    */
    func pOfInterestFunctionView(_ functionView: FunctionView) -> Point {
        switch functionView {
        case posTimeFunctionView:
            let t = cubeModel.interestT
            return Point(x: t, y: cubeModel.posAtTime(t))
        case speedTimeFunctionView:
            let t = cubeModel.interestT
            return Point(x: t, y: cubeModel.speedAtTime(t))
        case accTimeFunctionView:
            let t = cubeModel.interestT
            return Point(x: t, y: cubeModel.accAtTime(t))
        default:
            let t = cubeModel.interestT
            return Point(x: cubeModel.posAtTime(t), y: cubeModel.speedAtTime(t))
        }
    }
}
