
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
    
    @IBOutlet var generalView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        posTimeFunctionView.dataSource = self
        speedTimeFunctionView.dataSource = self
        accTimeFunctionView.dataSource = self
        speedPosFunctionView.dataSource = self
        ladoSlider.sendActions(for: .valueChanged)
        timeSlider.sendActions(for: .valueChanged)
        
        generalView.isUserInteractionEnabled = true
        let LPRecW = UILongPressGestureRecognizer(target: self, action: #selector(LPWidth))
        generalView.addGestureRecognizer(LPRecW)
        
        let tapRecN = UITapGestureRecognizer(target: self, action: #selector(tapNarrow))
        tapRecN.numberOfTapsRequired = 1
        generalView.addGestureRecognizer(tapRecN)
        
        posLabel.setNeedsDisplay()
        speedLabel.setNeedsDisplay()
        accLabel.setNeedsDisplay()
        
    }
    
    @objc func LPWidth(_ sender: UITapGestureRecognizer){
        
        if sender.state != .began {return}
        
        posTimeFunctionView.lw = 5
        speedTimeFunctionView.lw = 5
        accTimeFunctionView.lw = 5
        speedPosFunctionView.lw = 5
    }
    
    @objc func tapNarrow(_ sender: UITapGestureRecognizer){
        posTimeFunctionView.lw = 1
        speedTimeFunctionView.lw = 1
        accTimeFunctionView.lw = 1
        speedPosFunctionView.lw = 1
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
    
     // Update the labels with a certain value, and vary the display of an special point.
    @IBAction func updateTime(_ sender: UISlider) {
        let xmax : Double = (Double(posTimeFunctionView.bounds.size.width)/2) - 0.1
        // All the views have the same width
        cubeModel.interestT = Double(sender.value)*xmax
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
    

    @IBAction func swipeDownRed(_ sender: UISwipeGestureRecognizer) {
        posTimeFunctionView.color = .red
        speedTimeFunctionView.color = .red
        accTimeFunctionView.color = .red
        speedPosFunctionView.color = .red
    }
    
    @IBAction func swipeUpBlue(_ sender: UISwipeGestureRecognizer) {
        // print("Swipe up PTF")
        posTimeFunctionView.color = .blue
        speedTimeFunctionView.color = .blue
        accTimeFunctionView.color = .blue
        speedPosFunctionView.color = .blue

    }
    
    
    
    func startTimeOfFunctionView(_ functionView: FunctionView) -> Double {
        return 0
    }
    
    func endTimeOfFunctionView(_ functionView: FunctionView) -> Double {
        return 300
    }
    
    /**
     Depend on the FunctionView and time ti gives the matching point.
     
     Also it finds the amplitude so to scale properly the axis.
     
     It is aplied an standard scale, so to wacth them properly.
     */
    func pointOfFunctionView(_ functionView: FunctionView, atTime time: Double) -> Point {
        switch functionView {
        case posTimeFunctionView :
            let A = (1/2)*cubeModel.L
            let maxH = 0.95*Double((functionView.ymax/2)) // Dont get to the top
            var scaled = 1.0
            if A > maxH {
                scaled = A/maxH
                functionView.scaleY = scaled
            }
            return Point(x: time, y: (1/scaled)*cubeModel.posAtTime(time))
        case speedTimeFunctionView :
            let A = (1/2)*cubeModel.L*cubeModel.w// Absolute value
            let maxH = 0.95*Double((functionView.ymax/2)) // Dont get to the top
            var scaled = 0.5
            if A > maxH {
                scaled = A/maxH
                functionView.scaleY = scaled
            }
            return Point(x: time, y: (1/scaled)*cubeModel.speedAtTime(time))
        case accTimeFunctionView :
            let A = cubeModel.g// Absolute value
            let maxH = 0.95*Double((functionView.ymax/2)) // Dont get to the top
            var scaled = 0.2
            if A > maxH {
                scaled = A/maxH
                functionView.scaleY = scaled
            }
            return Point(x: time, y: (1/scaled)*cubeModel.accAtTime(time))
        case speedPosFunctionView :
            var scaledX = 0.25
            let Ax = (1/2)*cubeModel.L*(1/scaledX)
            let maxW = 0.95*Double((functionView.xmax/2)) // Dont get to the top
            if Ax > maxW {
                scaledX = 0.25*Ax/maxW
                functionView.scaleX = scaledX
            }
            var scaledY = 0.25
            let Ay = 0.25*(1/2)*cubeModel.L*cubeModel.w// Absolute value
            let maxH = 0.95*Double((functionView.ymax/2)) // Dont get to the top
            if Ay > maxH {
                scaledY = (1/4)*Ay/maxH
                functionView.scaleY = scaledY
            }
            return Point(x: (1/scaledX)*cubeModel.posAtTime(time), y: (1/scaledY)*cubeModel.speedAtTime(time))
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
            let A = (1/2)*cubeModel.L
            let maxH = 0.95*Double((functionView.ymax/2)) // Dont get to the top
            var scaled = 1.0
            if A > maxH {
                scaled = A/maxH
                functionView.scaleY = scaled
            }
            return Point(x: t, y: (1/scaled)*cubeModel.posAtTime(t))
        case speedTimeFunctionView:
            let A = (1/2)*cubeModel.L*cubeModel.w// Absolute value
            let maxH = 0.95*Double((functionView.ymax/2)) // Dont get to the top
            var scaled = 0.5
            if A > maxH {
                scaled = A/maxH
                functionView.scaleY = scaled
            }
            let t = cubeModel.interestT
            return Point(x: t, y: (1/scaled)*cubeModel.speedAtTime(t))
        case accTimeFunctionView:
            let A = cubeModel.g// Absolute value
            let maxH = 0.95*Double((functionView.ymax/2)) // Dont get to the top
            var scaled = 0.2
            if A > maxH {
                scaled = A/maxH
                functionView.scaleY = scaled
            }
            let t = cubeModel.interestT
            return Point(x: t, y: (1/scaled)*cubeModel.accAtTime(t))
        default:
            var scaledX = 0.25
            let t = cubeModel.interestT
            let Ax = (1/scaledX)*(1/2)*cubeModel.L
            let maxW = 0.95*Double((functionView.xmax/2)) // Dont get to the top
            if Ax > maxW {
                scaledX = 0.25*Ax/maxW
                functionView.scaleX = scaledX
            }
             var scaledY = 0.25
            let Ay = (1/scaledY)*(1/2)*cubeModel.L*cubeModel.w// Absolute value
            let maxH = 0.95*Double((functionView.ymax/2)) // Dont get to the top
           
            if Ay > maxH {
                scaledY = 0.25*Ay/maxH
                functionView.scaleY = scaledY
            }
            return Point(x: (1/scaledX)*cubeModel.posAtTime(t), y: (1/scaledY)*cubeModel.speedAtTime(t))
        }
    }
}
