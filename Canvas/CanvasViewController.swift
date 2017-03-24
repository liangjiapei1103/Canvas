//
//  CanvasViewController.swift
//  Canvas
//
//  Created by Jiapei Liang on 3/23/17.
//  Copyright © 2017 Jiapei Liang. All rights reserved.
//

import UIKit

class CanvasViewController: UIViewController {

    @IBOutlet weak var trayView: UIView!
    @IBOutlet weak var trayArrowImageView: UIImageView!
    
    var trayOriginalCenter: CGPoint!
    
    var trayDownOffset: CGFloat!
    var trayUp: CGPoint!
    var trayDown: CGPoint!
    
    var newlyCreatedFace: UIImageView!
    var newlyCreatedFaceOriginalCenter: CGPoint!
    var createdFaceOriginalCenter: CGPoint!
    var createdFace: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        trayDown = CGPoint(x: view.frame.width/2, y:
            view.frame.height + trayView.bounds.height/2 - 40)
        trayUp = CGPoint(x: view.frame.width/2, y: view.frame.height - trayView.bounds.height/2)
        
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
        var height: CGFloat!
        var width: CGFloat!
        
        if UIDevice.current.orientation.isLandscape {
            if view.frame.height > view.frame.width {
                height = view.frame.width
                width = view.frame.height
            } else {
                height = view.frame.height
                width = view.frame.width
            }
        } else {
            if view.frame.height > view.frame.width {
                height = view.frame.height
                width = view.frame.width
            } else {
                height = view.frame.width
                width = view.frame.height
            }
        }
        
        print("height: \(height)")
        print("width: \(width)")
        
        trayDown = CGPoint(x: width/2, y:
            height + trayView.bounds.height/2 - 40)
        trayUp = CGPoint(x: width/2, y: height - trayView.bounds.height/2)
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didPanTray(_ sender: UIPanGestureRecognizer) {
        
        let translation = sender.translation(in: view)
        let velocity = sender.velocity(in: view)
        
        if sender.state == .began {
            print("Gesture began")
            trayOriginalCenter = trayView.center
            print("trayOriginalCenter: \(trayOriginalCenter)")
        } else if sender.state == .changed {
            print("Gesture is changing")
            if velocity.y > 0 {
                trayView.center = CGPoint(x: trayOriginalCenter.x, y: trayOriginalCenter.y + translation.y)
            } else {
                if trayView.center.y < trayUp.y {
                    trayView.center = CGPoint(x: trayOriginalCenter.x, y: trayOriginalCenter.y + translation.y/10)
                } else {
                    trayView.center = CGPoint(x: trayOriginalCenter.x, y: trayOriginalCenter.y + translation.y)
                }
            }
        } else if sender.state == .ended {
            print("Gesture ended")
            
            if velocity.y > 0 {
                // moving down
                
                self.trayArrowImageView.transform = self.trayArrowImageView.transform.rotated(by: CGFloat(M_PI))
                
                // Using Spring Animation
                UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: [], animations: {
                    self.trayView.center = self.trayDown
                }, completion: nil)
            
                
                // Using Regular Animation
                /*
                UIView.animate(withDuration: 0.3, animations: { 
                    self.trayView.center = self.trayDown
                })
                */
                
            } else {
                // moving up
                print("trayDown: \(trayDown)")
                print("trayOriginalCenter: \(trayOriginalCenter)")
                print("self.trayView.center: \(self.trayView.center)")
                if trayOriginalCenter.y == trayDown.y {
                    self.trayArrowImageView.transform = self.trayArrowImageView.transform.rotated(by: CGFloat(M_PI))
                }
                
                // Using Spring Animation
                UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: [], animations: {
                    self.trayView.center = self.trayUp
                }, completion: nil)
                
                // Using Regular Animation
                /*
                UIView.animate(withDuration: 0.3, animations: {
                    self.trayView.center = self.trayUp
                })
                */
                
            }
            
        }
        
    }
    
    @IBAction func didPanFace(_ sender: UIPanGestureRecognizer) {
        
        let translation = sender.translation(in: view)
        let location = sender.location(in: view)
        
        if sender.state == .began {
            print("Gesture began")
            let faceImageView = sender.view as! UIImageView
            newlyCreatedFace = UIImageView(image: faceImageView.image)
            

            let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(didPanNewlyCreatedFace))
            let pinchGestureRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(didPinchNewlyCreatedFace))
            let rotateGestureRecognizer = UIRotationGestureRecognizer(target: self, action: #selector(didRotateNewlyCreatedFace))
            let doubleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didDoubleTabNewlyCreatedFace))
            
            doubleTapGestureRecognizer.numberOfTapsRequired = 2
            
            
            // Attach it to a view of your choice. If it's a UIImageView, remember to enable user interaction
            newlyCreatedFace.isUserInteractionEnabled = true
            newlyCreatedFace.addGestureRecognizer(panGestureRecognizer)
            newlyCreatedFace.addGestureRecognizer(pinchGestureRecognizer)
            newlyCreatedFace.addGestureRecognizer(rotateGestureRecognizer)
            newlyCreatedFace.addGestureRecognizer(doubleTapGestureRecognizer)
            
            view.addSubview(newlyCreatedFace)
            newlyCreatedFace.center = location
            newlyCreatedFaceOriginalCenter = newlyCreatedFace.center

        } else if sender.state == .changed {
            print("Gesture is changing")
            newlyCreatedFace.center = CGPoint(x: newlyCreatedFaceOriginalCenter.x + translation.x, y: newlyCreatedFaceOriginalCenter.y + translation.y)
            
        } else if sender.state == .ended {
            print("Gesture ended")
            
        }
        
    }
    
    
    
    func didPanNewlyCreatedFace(sender: UIPanGestureRecognizer) {

        let translation = sender.translation(in: view)
        let location = sender.location(in: view)
        
        
        
        if sender.state == .began {
            print("Gesture began")

            createdFaceOriginalCenter = location
            print("createdFaceOriginalCenter: \(createdFaceOriginalCenter)")
            createdFace = sender.view as! UIImageView
            
            UIView.animate(withDuration: 0.1, animations: {
                self.createdFace.transform = self.createdFace.transform.scaledBy(x: 3/2, y: 3/2)
            })
            

        } else if sender.state == .changed {
            print("Gesture is changing")
            createdFace.center = CGPoint(x: createdFaceOriginalCenter.x + translation.x, y: createdFaceOriginalCenter.y + translation.y)
            
        } else if sender.state == .ended {
            print("Gesture ended")
            
            print("createdFaceOriginalCenter: \(createdFaceOriginalCenter)")
            
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 1, options: [], animations: {
                self.createdFace.transform = self.createdFace.transform.scaledBy(x: 2/3, y: 2/3)
            }, completion: nil)
            
            UIView.animate(withDuration: 0.3, animations: { 
                if self.createdFace.center.y > self.trayView.frame.origin.y {
                    self.createdFace.center = CGPoint(x: self.createdFaceOriginalCenter.x, y: self.createdFaceOriginalCenter.y)
                }
            })
        
            
            
            
            
        }
    }
    
    func didPinchNewlyCreatedFace(sender: UIPinchGestureRecognizer) {
        let scale = sender.scale
        let imageView = sender.view as! UIImageView
        imageView.transform = imageView.transform.scaledBy(x: scale, y: scale)
        sender.scale = 1
    }
    
    func didRotateNewlyCreatedFace(sender: UIRotationGestureRecognizer) {
        let rotation = sender.rotation
        let imageView = sender.view as! UIImageView
        imageView.transform = imageView.transform.rotated(by: rotation)
        sender.rotation = 0
    }
    
    func didDoubleTabNewlyCreatedFace(sender: UITapGestureRecognizer) {
        sender.view?.removeFromSuperview()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
