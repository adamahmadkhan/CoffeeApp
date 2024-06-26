//
//  ViewController.swift
//  ProgressBar
//
//  Created by Adam Khan on 6/10/24.
//

import UIKit

class ViewController: UIViewController,UITextFieldDelegate,UIGestureRecognizerDelegate  {
    
    
    @IBOutlet weak var gestureViewOutlet: UIView!
    @IBOutlet weak var updateProgressValue: UITextField!
    @IBOutlet weak var silderOutlet: UISlider!
    @IBOutlet weak var progressViewValue: NSLayoutConstraint!
    @IBOutlet weak var progressViewBackground: UIView!
    let progressLayer = CAShapeLayer()
    let backgroundLayer = CAShapeLayer()
    var currentProgressValue:Float = 0.0
    let animation = CABasicAnimation(keyPath: "strokeEnd")
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        configureBackgroundLayer()
        confrigureProcessLayer()
        
        //let pinchGestureReconginzer = UIPinchGestureRecognizer(target: self, action: #selector(pinchedView(_:)))
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        gestureViewOutlet.addGestureRecognizer(panGestureRecognizer)
        //panViewOutlet.addGestureRecognizer(pinchGestureReconginzer)
        gestureViewOutlet.isUserInteractionEnabled = true
        
        
        
        updateProgressValue.text = "10"
        progressLayer.strokeEnd = 0.10
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut) // Smooth animation curve
        animation.fillMode = CAMediaTimingFillMode.both
        
        
        //animation.isRemovedOnCompletion = false
        //        UIView.animate(withDuration: 10, animations: {
        //              self.progressViewValue.constant = 100
        //              self.view.layoutIfNeeded()
        //          })
    }
    
    
    @IBAction func handleRolation(_ recognizer: UIRotationGestureRecognizer) {
        if recognizer.state == .began || recognizer.state == .changed {
              recognizer.view?.transform = recognizer.view!.transform.rotated(by: recognizer.rotation)
              recognizer.rotation = 0
           }
    }
    
    
    @IBAction func handlePinch(_ recognizer: UIPinchGestureRecognizer) {
        guard recognizer.view != nil else { return }
        if recognizer.state == .began || recognizer.state == .changed {
            recognizer.view?.transform = (recognizer.view?.transform.scaledBy(x: recognizer.scale , y: recognizer.scale))!
            recognizer.scale = 1.0
        }
    }

    
    @objc func pinchedView(_ sender:UIPinchGestureRecognizer){
        
    }
    
    @objc func handlePan(_ recognizer: UIPanGestureRecognizer) {

        let translation = recognizer.translation(in: view)
        if let view = recognizer.view, let superview = view.superview {
//            let newX = min(max(view.center.x + translation.x, view.bounds.width / 2), superview.bounds.width - view.bounds.width / 2)
//            let newY = min(max(view.center.y + translation.y, view.bounds.height / 2), superview.bounds.height - view.bounds.height / 2)
            let newX = view.center.x + translation.x
            let newY = view.center.y + translation.y
              
           
            if view.frame.maxY + 20 > superview.frame.maxY{
                UIView.animate(withDuration: 0.5) {
                    view.center = CGPoint(x: newX, y: newY - 40)
                    view.layoutIfNeeded()
                }
                print(view,"Bottom",superview.frame.maxY)
                
            }
            
            else if view.frame.minY - 20 < superview.frame.minY {
                UIView.animate(withDuration: 0.5) {
                    view.center = CGPoint(x: newX, y: newY + 40)
                }
                print(view.center,"Top",superview.frame.minY)
            }
            
           else if view.frame.maxX + 20 > superview.frame.maxX{
                UIView.animate(withDuration: 0.5) {
                    view.center = CGPoint(x: newX - 20, y: newY)
                }
                print(view.center,"Right",superview.frame.maxX)
            }
            else if view.frame.minX - 20 < superview.frame.minX {
                UIView.animate(withDuration: 0.5) {
                    view.center = CGPoint(x: newX + 20, y: newY)
                }
                print(view.center,"Left",superview.frame.minX)
            }
            else {
                view.center = CGPoint(x: newX, y: newY)
            }
        }
        
        recognizer.setTranslation(CGPoint.zero, in: view)
    }

    @IBAction func siderValueChanges(_ sender: UISlider) {
//        animateProgress(newValue: CGFloat(silderOutlet.value))
        print(silderOutlet.value)
        let angle = (silderOutlet.value * 360.0)
        
        self.gestureViewOutlet.transform = CGAffineTransform(rotationAngle: CGFloat((angle * Float.pi ) / 180.0 ) )
        print(angle)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        currentProgressValue = Float(textField.text ?? "0") ?? 0.0
        animateProgress(newValue: CGFloat(currentProgressValue/100.0))
    }

    func animateProgress(newValue:CGFloat){
        animation.fromValue = progressLayer.strokeEnd
        animation.duration = 2
        progressLayer.strokeEnd = newValue
        progressLayer.add(animation, forKey: "strokeEndAnimation")
    }
    
    
    func confrigureProcessLayer(){
        updateProgressValue.delegate = self
        progressLayer.strokeColor = UIColor.green.cgColor
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.lineWidth = 10
        progressLayer.strokeStart = 0
        progressLayer.strokeEnd = 0
        progressLayer.lineCap = .round
        progressViewBackground.layer.addSublayer(progressLayer)
        
        let center = CGPoint(x: self.progressViewBackground.frame.width / 2, y: self.progressViewBackground.frame.height / 2)
        let radius = progressViewBackground.bounds.width / 2
        let startAngle = CGFloat((180.0 * Double.pi ) / 180.0 )
        let endAngle = CGFloat((0 * Double.pi ) / 180.0 )
        let path = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        progressLayer.path = path.cgPath
    }
    
    func configureBackgroundLayer(){
        backgroundLayer.strokeColor = UIColor.gray.cgColor
        backgroundLayer.fillColor = UIColor.clear.cgColor
        backgroundLayer.lineWidth = 20
        backgroundLayer.strokeStart = 0
        backgroundLayer.strokeEnd = 1
        backgroundLayer.lineCap = .round
        progressViewBackground.layer.addSublayer(backgroundLayer)
        
        let center = CGPoint(x: (self.progressViewBackground.frame.width / 2), y: (self.progressViewBackground.frame.height / 2))
        let radius = (progressViewBackground.bounds.width / 2 )
        let startAngle = CGFloat(Double.pi)
        let endAngle = CGFloat(2 * Double.pi)
        let path = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        backgroundLayer.path = path.cgPath
    }
    
    
}

