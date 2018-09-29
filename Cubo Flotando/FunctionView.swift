//
//  FunctionView.swift
//  Cubo Flotando
//
//  Created by Adrian on 29/09/2018.
//  Copyright © 2018 Adrián Blázquez León. All rights reserved.
//

import UIKit

// Point
struct Point {
    var x = 0.0
    var y = 0.0
}

// It is created a protocol FunctionVIewDataSOurce so to obtain the data from the view form the view controller. The function get a type func, and depending on it get an star time.
protocol FunctionViewDataSource : class{
    
    func startTimeOfFunctionView(_  functionView: FunctionView) -> Double
    func endTimeOfFunctionView(_ functionView: FunctionView) -> Double
    func pointOfFunctionView(_ functionView: FunctionView, atTime time: Double) -> Point
}


// Class that draw

@IBDesignable //This makes theses objects to be directly render by the IB into the canvas.
class FunctionView: UIView {
    
    // Some atributes that can be change form the IOB
    
    @IBInspectable
    var color: UIColor = .red
    
    @IBInspectable
    var lw : Double = 5
    
    // It is created an atribute, so to use the functions that matchees.
    weak var dataSource: FunctionViewDataSource!
    
    // Bounds defined as atribute
    lazy var xmax = bounds.size.width
    lazy var ymax = bounds.size.height
    
    override func draw(_ rect: CGRect) {
        // Drawing code
        drawAxis()
        drawTrajectory()
    }
    
    /** Draw the axis in the UIView
     */
    
    private func drawAxis(){
        
        // let xmax = bounds.size.width
        // let ymax = bounds.size.height
        
        let xaxis = UIBezierPath()
        let yaxis = UIBezierPath()
        
        xaxis.move(to: CGPoint(x:0, y:(ymax/2)))
        xaxis.addLine(to: CGPoint(x:xmax, y:(ymax/2)))
        
        yaxis.move(to: CGPoint(x:(xmax/2), y:0))
        yaxis.addLine(to: CGPoint(x:(xmax/2), y:ymax))
        
        UIColor.black.setStroke()
        xaxis.lineWidth = 1.0
        xaxis.stroke()
        
        UIColor.black.setStroke()
        yaxis.lineWidth = 1.0
        yaxis.stroke()
    }
    
    /** Draw the trajectory in the UIView
     */
    
    private func drawTrajectory() {
        
        let path = UIBezierPath()
        
        // let xmax = bounds.size.width
        // let ymax = bounds.size.height
        
        //Initial position
        var x0 = (xmax/2)
        var y0 = (ymax/2)
        var t0 = 0.0
        
        path.move(to: CGPoint(x: x0, y: y0))
        
        // It is draw the path
        for t in stride (from: t0, to: 800.0, by: 2.0){
            
            // Find next point
            // var xnext = nextX(t)
            // var ynext = nextY(t)
            
            // pointOfFunctionView, chooses the appropiate function depending of the UIVIew and then the view Controller display it.
            let nextPoint = dataSource.pointOfFunctionView(self, atTime: t)
            
            // All the formulas go to the Cube Model
            // path.addLine(to: CGPoint(x: xnext, y: ynext))
            
            path.addLine(to: CGPoint(x: centerX(nextPoint.x), y: centerY(nextPoint.y)))
            //path.addLine(to: CGPoint(x:xnext, y:ynext))
        }
        UIColor.red.setStroke()
        path.lineWidth = 1.0
        path.stroke()
    }
    
    // It must be translated the coordinates found by the CubeModel to teh UIView: just centering in the point (xmax/2, ymax/2)
    private func centerX(_ x: Double) -> Double {
        return (Double(x) + Double(xmax/2))
    }
    private func centerY(_ y: Double) -> Double {
        return (Double(y) + Double(ymax/2))
    }
    
}
