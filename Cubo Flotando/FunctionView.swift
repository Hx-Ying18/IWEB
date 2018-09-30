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
    // It takes teh time from an atribute in the cube Model
    func pOfInterestFunctionView(_ functionView: FunctionView) -> Point
    
}


// Class that draw

@IBDesignable //This makes theses objects to be directly render by the IB into the canvas.
class FunctionView: UIView {
    
    // Some atributes that can be change form the IOB
    
    @IBInspectable
    var color: UIColor = .red
    
    @IBInspectable
    var lw : Double = 1.0

    //Number of points per unit represented
    @IBInspectable
    var scaleX: Double = 1.0 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable
    var scaleY: Double = 1.0 {
        didSet{
            setNeedsDisplay()
        }
    }
    
    @IBInspectable
    var textX: String = "x"
    
    @IBInspectable
    var textY: String = "y"
    
    // It is created an atribute, so to use the functions that matchees.
    weak var dataSource: FunctionViewDataSource!
  
    
    // Bounds defined as atribute
    lazy var xmax = bounds.size.width
    lazy var ymax = bounds.size.height
    
    override func draw(_ rect: CGRect) {
        // Drawing code
        drawAxis()
        drawTrajectory()
        drawPOI()
        drawTicks()
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
        xaxis.lineWidth = CGFloat(lw)
        xaxis.stroke()
        
        UIColor.black.setStroke()
        yaxis.lineWidth = CGFloat(lw)
        yaxis.stroke()
    }
    
    /** Draw the trajectory in the UIView
     */
    
    private func drawTrajectory() {
        
        let path = UIBezierPath()
        
        // let xmax = bounds.size.width
        // let ymax = bounds.size.height
        
        //Initial position
//        var x0 = (xmax/2)
//        var y0 = (ymax/2)
        let t0 = dataSource.startTimeOfFunctionView(self)
        let p = dataSource.pointOfFunctionView(self, atTime: t0)
        path.move(to: CGPoint(x: centerX(p.x), y: centerY(p.y)))
        
        // Se repite dos veces el mismo punto
        
        let tf = dataSource.endTimeOfFunctionView(self)
        // It is draw the path
        for t in stride (from: t0, to: tf, by: 1.5){
            
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
        color.setStroke()
        path.lineWidth = CGFloat(lw)
        path.stroke()
    }
    
    /** Draw POI
 */
    private func drawPOI() {
    
        let p = dataSource.pOfInterestFunctionView(self)
        
        let path = UIBezierPath(ovalIn: CGRect(x: centerX(p.x)-4.0, y: centerY(p.y)-4.0, width: 8, height:8))
        UIColor.black.set()
        path.stroke()
        path.fill()
        
    }
    
    /** Draw ticks
 */
    private func drawTicks() {
        
        let numberOfTicks = 8.0
        
        UIColor.black.set()
        
        let ptsYByTick = Double(bounds.size.height) / numberOfTicks
        let unitsYByTick = (ptsYByTick / scaleY).roundedOneDigit
        for y in stride(from: -numberOfTicks * unitsYByTick, to: numberOfTicks * unitsYByTick, by: unitsYByTick){
            let px = centerX(0)
            let py = centerY(y)
            
            let path = UIBezierPath()
            path.move(to: CGPoint(x: px - 2, y: py))
            path.addLine(to: CGPoint(x: px+2, y: py))
            
            path.stroke()
            }
        
        let ptsXByTick = Double(bounds.size.width) / numberOfTicks
        let unitsXByTick = (ptsXByTick / scaleX).roundedOneDigit
        for x in stride(from: -numberOfTicks * unitsXByTick, to: numberOfTicks * unitsXByTick, by: unitsXByTick){
            let px = centerX(x)
            let py = centerY(0)
            
            let path = UIBezierPath()
            path.move(to: CGPoint(x: px , y: py-2))
            path.addLine(to: CGPoint(x: px, y: py+2))
            
            path.stroke()
        }
    }
    
    /** Draw the text */
    private func drawText() {
        //Is not seen
        // let attrs = [NSAttributedStringKey.font: UIFont.preferredFont(forTextStyle: UIFontTextStyle.caption1)]
        
        let attrs = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 12)]
        
        let offset: CGFloat = 4 // Separation from the text to teh bounds
        
        // It is chosen the texts according to the type of dataSOurce
        
        
        let asX = NSAttributedString(string: textX, attributes: attrs)
        let sizeX = asX.size()
        let posX = CGPoint(x: xmax - sizeX.width - offset, y: ymax/2 + offset)
        asX.draw(at: posX)
        
        
        
        let asY = NSAttributedString(string: textY, attributes: attrs)
        let posY = CGPoint(x: xmax - offset, y: ymax/2 + offset)
        asY.draw(at: posY)
        
    }
    
    // It must be translated the coordinates found by the CubeModel to teh UIView: just centering in the point (xmax/2, ymax/2)
    private func centerX(_ x: Double) -> Double {
        return (Double(x) + Double(xmax/2))
    }
    private func centerY(_ y: Double) -> Double {
        return (Double(y) + Double(ymax/2))
    }
    
}

extension Double{
    var roundedOneDigit: Double {
        get {
            var d = self
            var by = 1.0
            
            while d > 10 {
                d /= 10
                by = by * 10
            }
            while d < 1{
                d *= 10
                by = by / 10
            }
            return d.rounded() * by
        }
    }
}
