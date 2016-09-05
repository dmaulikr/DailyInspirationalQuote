//
//  ViewController.swift
//  Daily Inspirational Quote
//
//  Created by RJ Militante on 8/24/16.
//  Copyright © 2016 Kraftwerking LLC. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    @IBOutlet var txtQuote: UITextView!
    
    var idQuote: String = ""
    var quote: String = ""
    var author: String = ""
    var year: String = ""
    var authorField: String = ""
    var yearField: String = ""
    
    var isFavourite: Bool = false
    var bannerHeight = 50
    
    let userDefaults = NSUserDefaults.standardUserDefaults()
    
    let gradientLayer = CAGradientLayer()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = APP_NAME
        
        // Detecting Device and setting constraints
        
        let device = UIDevice.currentDevice().model
        let index = device.startIndex.advancedBy(4)
        globalDevice.name = device.substringToIndex(index)
        
        if globalDevice.name == "iPad" {
            //formatiPad()
        } else {
            //formatiPhone()
        }
        
        
        /*
        // 1
        self.view.backgroundColor = UIColor.magentaColor()
        
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
         */
         
        generateRandomQuote()
        
        print("all items")
        print(QuoteList().allItems())
        print("alert date")
        print(globalDevice.alertDate)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func generateRandomQuote(){
        
        if let arrayQuote = NSArray(contentsOfFile: NSBundle.mainBundle().pathForResource("Quotes", ofType: "plist")!) {
            
            let nQuote = UInt32(arrayQuote.count)                      // Convert to Uint32
            let randomQuote = Int(arc4random_uniform(nQuote))          // Range between 0 - nQuote
            let pickQuote: AnyObject = arrayQuote[randomQuote]         // Random Quote
            
            idQuote = pickQuote.objectForKey(FIELD_ID) as! String
            quote = pickQuote.objectForKey(FIELD_QUOTE) as! String
            
            
            if (pickQuote.objectForKey(FIELD_AUTHOR) as? String != nil) {
                authorField = (pickQuote.objectForKey(FIELD_AUTHOR) as? String)!
            } else {
                authorField = ""
            }
            
            if (pickQuote.objectForKey(FIELD_YEAR) as? String != nil) {
                yearField = (pickQuote.objectForKey(FIELD_YEAR) as? String)!
            } else {
                yearField = ""
            }
            
            if authorField != "" || yearField != "" {
                quote = quote + "\r\n\n" + authorField + "\r\n" + yearField
            }
            
            print("Quote is: " + quote)

            formatQuote(quote)
            
        }
        
    }
    
    func formatQuote(quote: String){
        
        
        if globalDevice.name == "iPad" {
            
            // iPAD Formatting
            // ---------------
            let style = NSMutableParagraphStyle()
            style.lineSpacing = 8                                              // Line Height
            let attributes = [NSParagraphStyleAttributeName : style]
            txtQuote.attributedText = NSAttributedString(string: quote, attributes: attributes)
            
            txtQuote.font = FONT_QUOTE_iPad                                     // Font type & Size
            txtQuote.textColor = FONT_QUOTE_COLOR                               // Font Color
            txtQuote.textAlignment = .Center                                    // Alignment
            txtQuote.scrollRangeToVisible(NSMakeRange(0, 0))                    // Scroll to the Top
            
        } else {
            
            // iPhone/iPod Formatting
            // ----------------------
            let style = NSMutableParagraphStyle()
            style.lineSpacing = 3                                               // Line Height
            let attributes = [NSParagraphStyleAttributeName : style]
            txtQuote.attributedText = NSAttributedString(string: quote, attributes: attributes)
            
            let screenSize: CGRect = UIScreen.mainScreen().bounds
            let screenHeight = screenSize.height
            
            if screenHeight == 480.0 {
                txtQuote.font = FONT_QUOTE_iPhone4                                  // Font type & Size iPhone 3.5
            } else {
                txtQuote.font = FONT_QUOTE_iPhone                                   // Font type & Size
            }
            
            txtQuote.textColor = FONT_QUOTE_COLOR                               // Font Color
            txtQuote.textAlignment = .Center                                    // Alignment
            txtQuote.scrollRangeToVisible(NSMakeRange(0, 0))                    // Scroll to the Top
            
        }
        
    }
    
    
    @IBAction func getNewRandomQuote(sender: AnyObject) {

        generateRandomQuote()

    }
    

}

