//
//  InfoViewController.swift
//  Daily Inspirational Quote
//
//  Created by RJ Militante on 9/2/16.
//  Copyright © 2016 Kraftwerking LLC. All rights reserved.
//


import UIKit

class InfoViewController: UIViewController {
    let gradientLayer = CAGradientLayer()

    override func viewDidLoad() {
        super.viewDidLoad()
        // 1
        self.view.backgroundColor = UIColor.purpleColor()
        
        // 2
        gradientLayer.frame = self.view.bounds
        
        // 3
        let color1 = UIColor.clearColor().CGColor as CGColorRef
        let color2 = UIColor(white: 0.0, alpha: 0.5).CGColor as CGColorRef
        gradientLayer.colors = [color1, color2]
        
        // 4
        gradientLayer.locations = [0.0, 0.80, 0.90, 1.0]
        
        // 5
        self.view.layer.addSublayer(gradientLayer)
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
