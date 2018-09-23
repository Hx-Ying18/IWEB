//
//  ViewController.swift
//  Cubo
//
//  Created by Adrian on 23/09/2018.
//  Copyright © 2018 UPM. All rights reserved.
//

import UIKit

class ViewController: UIViewController, FunctionViewDataSource {
    
    // Longitud de lado del cubo
    var L = 50.0 {
        didSet {
            funcView.setNeedsDisplay()
            speedView.setNeedsDisplay()
            acelerationView.setNeedsDisplay()
            speedZView.setNeedsDisplay()
        }
    }
    
    // Frecuencia angular de oscilación
    var w = sqrt(2*Constants.g/50.0)
    
    //Point of interest
    var timePoint = 10.0 {
        didSet {
            funcView.setNeedsDisplay()
            speedView.setNeedsDisplay()
            acelerationView.setNeedsDisplay()
            speedZView.setNeedsDisplay()
        }
    }
    
    //View para la gráfica de la posición del centro de masa del cubo
    @IBOutlet weak var funcView: FunctionView!
    
    //View para la gráfica de la velocidad en el eje z del cubp
    @IBOutlet weak var speedView: FunctionView!
    
    //View para la gráfica de la aceleración en el eje z del cubo
    @IBOutlet weak var acelerationView: FunctionView!
    
    //View para representar la velocidad en función de la posición Z
    @IBOutlet weak var speedZView: FunctionView!
    
    @IBOutlet weak var sizeSlider: UISlider!
    @IBOutlet weak var timeSlider: UISlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        funcView.datasource = self
        speedView.datasource = self
        acelerationView.datasource = self
        speedZView.datasource = self
    }
    
    @IBAction func updateSize (_ sender: UISlider) {
        L = Double(sender.value)
        w = sqrt(2*Constants.g/Double(sender.value))
    }
    
    @IBAction func updatTimePoints(_ sender: UISlider) {
        timePoint = Double(sender.value)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func startIndexFor(_ functionView: FunctionView) -> Double {
        switch functionView {
        case funcView:
            return 0.0;
        case speedView:
            return 0.0;
        case acelerationView:
            return 0.0;
        case speedZView:
            return 0.0;
        default:
            return 0.0
        }
    }
    
    func endIndexFor(_ functionView: FunctionView) -> Double {
        switch functionView {
        case funcView:
            return 50.0;
        case speedView:
            return 50.0;
        case acelerationView:
            return 50.0;
        case speedZView:
            return 3*Double.pi/w;
        default:
            return 50.0;
        }
    }
    
    // el parámetro index representa el instante del tiempo para el que se quiere calcular el valor
    func functionView(_ functionView: FunctionView, pointAt index: Double) -> FunctionPoint {
        switch functionView {
            
        case funcView:
            let x = 4*index
            let y = (1.0/2.0)*L*cos(w*index)
            return FunctionPoint (x: x, y: y);
            
        case speedView:
            let x = 4*index
            let y = -(1.0/2.0)*L*w*sin(w*index)
            return FunctionPoint (x: x, y: y);
            
        case acelerationView:
            let x = 4*index
            let y = -Constants.g*cos(w*index)
            return FunctionPoint (x: x, y: y);
        case speedZView:
            let x = (1.0/2.0)*L*cos(w*index)
            let y = -(1.0/2.0)*L*w*sin(w*index)
            return FunctionPoint (x: x, y: y);
        default:
            return FunctionPoint(x: 0, y: 0);
        }
    }
    
    func pointsOfInterestFor(_ functionView: FunctionView) -> [FunctionPoint] {
        switch functionView {
        case funcView:
            let x = 4*timePoint
            let y = (1.0/2.0)*L*cos(w*timePoint)
            return [FunctionPoint (x: x, y: y)];
            
        case speedView:
            
            let x = 4*timePoint
            let y = -(1.0/2.0)*L*w*sin(w*timePoint)
            return [FunctionPoint (x: x, y: y)];
            
        case acelerationView:
            
            let x = 4*timePoint
            let y = -Constants.g*cos(w*timePoint)
            return [FunctionPoint (x: x, y: y)];
            
        case speedZView:
            
            let x = (1.0/2.0)*L
            let y = 0.0
            return [FunctionPoint (x: x, y: y)];
            
        default:
            return []
            
        }
    }
    
    
}



