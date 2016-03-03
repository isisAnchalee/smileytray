//
//  ViewController.swift
//  smileytray
//
//  Created by Isis Anchalee on 2/24/16.
//  Copyright © 2016 Isis Anchalee. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var trayView: UIView!
    @IBOutlet var parentView: UIView!
    var trayOriginalCenter: CGPoint!
    var openTray = true
    var newlyCreatedFace: UIImageView!
    var newlyCreatedFaceCenter: CGPoint!
    
    @IBOutlet weak var downArrowImage: UIImageView!
    @IBOutlet weak var tongueSmileyImage: UIImageView!
    @IBOutlet weak var sadSmileyImage: UIImageView!
    @IBOutlet weak var happySmileyImage: UIImageView!
    @IBOutlet weak var excitedSmileyImage: UIImageView!
    @IBOutlet weak var deadSmileyImage: UIImageView!
    @IBOutlet weak var winkSmileyImage: UIImageView!
    
    var trayCenterWhenOpen: CGPoint?
    var trayCenterWhenClosed: CGPoint?
    var velocity: CGPoint?
    var initialSmileyPosition: CGPoint?
    var currentSmileyPosition: CGPoint?

    override func viewDidLoad() {
        super.viewDidLoad()
        loadImages()
        // Do any additional setup after loading the view, typically from a nib.
        let windowRect = parentView.frame
        let windowHeight = CGRectGetMaxY(windowRect)
        trayCenterWhenClosed = CGPoint(x: trayView.center.x, y: (windowHeight + (trayView.frame.height / 3)))
            
        trayCenterWhenOpen = CGPoint(x: trayView.center.x, y: trayView.center.y)
    }
    
    func loadImages(){
        winkSmileyImage.image = UIImage(named: "wink")
        tongueSmileyImage.image = UIImage(named: "tongue")
        sadSmileyImage.image = UIImage(named: "sad")
        happySmileyImage.image = UIImage(named: "happy")
        deadSmileyImage.image = UIImage(named: "dead")
        excitedSmileyImage.image = UIImage(named: "excited")
        downArrowImage.image = UIImage(named: "down_arrow")
    }

    @IBAction func onSmileyDrag(panGestureRecognizer: UIPanGestureRecognizer) {
        let translation = panGestureRecognizer.translationInView(self.view)
        let imageView = panGestureRecognizer.view as! UIImageView

        
        if panGestureRecognizer.state == UIGestureRecognizerState.Began {
            newlyCreatedFace = UIImageView(image: imageView.image)
            parentView.addSubview(newlyCreatedFace)
            newlyCreatedFace.center = imageView.center
            newlyCreatedFace.center.y += trayView.frame.origin.y
            newlyCreatedFaceCenter = newlyCreatedFace.center
        } else if panGestureRecognizer.state == UIGestureRecognizerState.Changed {
            currentSmileyPosition = panGestureRecognizer.locationInView(parentView)
            newlyCreatedFace.center = CGPoint(x: newlyCreatedFaceCenter.x + translation.x, y: newlyCreatedFaceCenter.y + translation.y)
        } else if panGestureRecognizer.state == UIGestureRecognizerState.Ended {
            newlyCreatedFace.center = currentSmileyPosition!
        }
    }
    
    @IBAction func onTap(sender: UITapGestureRecognizer) {
        UIView.animateWithDuration(1.0, delay: 0.0, usingSpringWithDamping: 0.9, initialSpringVelocity: 2.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: ({
            if self.openTray{
                self.trayView.center = self.trayCenterWhenClosed!
            } else {
                self.trayView.center = self.trayCenterWhenOpen!
            }
            self.openTray = !self.openTray
        }), completion: nil)

    }
    
    @IBAction func didDrag(panGestureRecognizer: UIPanGestureRecognizer) {
        let translation = panGestureRecognizer.translationInView(self.view)

        if panGestureRecognizer.state == UIGestureRecognizerState.Began {
            trayOriginalCenter = trayView.center
        } else if panGestureRecognizer.state == UIGestureRecognizerState.Changed {
            trayView.center = CGPoint(x: trayOriginalCenter.x, y: trayOriginalCenter.y + translation.y)
            velocity = panGestureRecognizer.velocityInView(trayView)
        } else if panGestureRecognizer.state == UIGestureRecognizerState.Ended {
            UIView.animateWithDuration(1.0, delay: 0.0, usingSpringWithDamping: 0.9, initialSpringVelocity: 2.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: ({
                if self.velocity?.y > 0 {
                    self.trayView.center = self.trayCenterWhenClosed!
                    self.openTray = false
                } else {
                    self.trayView.center = self.trayCenterWhenOpen!
                    self.openTray = true
                }
            }), completion: nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

