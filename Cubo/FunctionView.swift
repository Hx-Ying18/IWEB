//
//  FunctionView.swift
//  Cubo
//
//  Created by Adrian on 23/09/2018.
//  Copyright © 2018 UPM. All rights reserved.
//

import UIKit

struct FunctionPoint {
    var x = 0.0
    var y = 0.0
}

protocol FunctionViewDataSource: class {
    func startIndexFor(_ functionView: FunctionView) -> Double
    func endIndexFor(_ functionView: FunctionView) -> Double
    
    func functionView(_ functionView: FunctionView, pointAt index: Double) -> FunctionPoint
    
    func pointsOfInterestFor(_ functionView: FunctionView) -> [FunctionPoint]
}


class FunctionView: UIView {
    
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
    @IBInspectable
    var scale = 1.0
    
    @IBInspectable
    var lw = 3.0
    
    @IBInspectable
    var color: UIColor = .black
    
    // Numero de puntos en el eje X por unidad representada
    @IBInspectable
    var scaleX: Double = 1.0 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    // Numero de puntos en el eje Y por unidad representada
    @IBInspectable
    var scaleY: Double = 1.0 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    weak var datasource: FunctionViewDataSource!
    
    
    
    override func draw(_ rect: CGRect) {
        let path = UIBezierPath()
        
        
        
        let i0 = datasource.startIndexFor(self)
        let i1 = datasource.endIndexFor(self)
        
        let p0 = datasource.functionView(self, pointAt: i0)
        
        let x0 = vx2px(vx: p0.x)
        let y0 = vy2py(vy: p0.y)
        
        path.move(to: CGPoint(x: x0, y: y0))
        
        for i in stride(from: i0, to: i1, by: (i1-i0)/100.0) {
            
            let p = datasource.functionView(self, pointAt: i)
            
            let x = vx2px(vx: p.x)
            let y = vy2py(vy: p.y)
            
            path.addLine(to:  CGPoint(x: x, y: y))
        }
        
        path.lineWidth = CGFloat(lw)
        
        color.setStroke()
        
        path.stroke()
        drawAxis()
        drawTicks()
        drawPOI()
        
        
    }
    
    private func vx2px(vx: Double) -> CGFloat {
        return (CGFloat(vx) + bounds.size.width/2);
    }
    
    private func vy2py(vy: Double) -> CGFloat {
        return (CGFloat(vy) + bounds.size.height/2);
    }
    
    private func drawAxis() {
        
        let width = bounds.size.width
        let height = bounds.size.height
        
        let path1 = UIBezierPath()
        path1.move(to: CGPoint(x: width/2, y: 0))
        path1.addLine(to: CGPoint(x: width/2, y: height))
        
        let path2 = UIBezierPath()
        path2.move(to: CGPoint(x: 0, y: height/2))
        path2.addLine(to: CGPoint(x: width, y: height/2))
        
        UIColor.black.setStroke()
        
        path1.lineWidth = 1
        path1.stroke()
        path2.lineWidth = 1
        path2.stroke()
    }
    
    private func drawTicks() {
        
        let numberOfTicks = 8.0
        
        UIColor.blue.set()
        
        let ptsYByTick = Double(bounds.size.height) / numberOfTicks
        let unitsYByTick = (ptsYByTick / scaleY).rounded()
        for y in stride(from: -numberOfTicks * unitsYByTick, to: numberOfTicks*unitsYByTick, by: unitsYByTick) {
            let px = pointForX(0)
            let py = pointForY(y)
            
            let path = UIBezierPath()
            path.move(to: CGPoint(x: px-2, y: py))
            path.addLine(to: CGPoint(x: px+2, y: py))
            
            path.stroke()
        }
        
        let ptsXByTick = Double(bounds.size.width) / numberOfTicks
        let unitsXByTick = (ptsXByTick / scaleX).rounded()
        for x in stride(from: -numberOfTicks * unitsXByTick, to: numberOfTicks*unitsXByTick, by: unitsXByTick) {
            let px = pointForX(x)
            let py = pointForY(0)
            
            let path = UIBezierPath()
            path.move(to: CGPoint(x: px, y: py-2))
            path.addLine(to: CGPoint(x: px, y: py+2))
            
            path.stroke()
        }
    }
    private func drawPOI() {
        
        for p in datasource.pointsOfInterestFor(self) {
            
            let px = vx2px(vx: p.x)
            let py = vy2py(vy: p.y)
            
            
            
            let path = UIBezierPath(ovalIn: CGRect(x: px-4, y: py-4, width: 8, height: 8))
            
            UIColor.red.set()
            
            path.stroke()
            path.fill()
        }
    }
    
    private func pointForX(_ x: Double) -> CGFloat {
        
        let width = bounds.size.width
        return width/2 + CGFloat(x*scaleX)
    }
    
    private func pointForY(_ y: Double) -> CGFloat {
        
        let height = bounds.size.height
        return height/2 - CGFloat(y*scaleY)
    }
    
}


