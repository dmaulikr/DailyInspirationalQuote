//
//  ViewController.swift
//  Daily Inspirational Quote
//
//  Created by RJ Militante on 8/24/16.
//  Copyright © 2016 Kraftwerking LLC. All rights reserved.
//

import UIKit
import Social

class MainViewController: UIViewController {
    @IBOutlet var txtQuote: UITextView!
    @IBOutlet var alertsButton: UIButton!
    @IBOutlet var randomButton: UIButton!
    @IBOutlet var fbButtonItem: UIBarButtonItem!
    @IBOutlet var twitterButtonItem: UIBarButtonItem!
    @IBOutlet var shareButtonItem: UIBarButtonItem!
    @IBOutlet var infoButtonItem: UIBarButtonItem!

    
    let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
    
    var idQuote: String = ""
    var quote: String = ""
    var author: String = ""
    var authorField: String = ""
    
    var quoteItem: Quote!
    var todaysQuoteItem: Quote!
    var currentQuoteItem: Quote!
    var newQuote: Quote!
    var quotes: [Quote] = []
    
    let userDefaults = NSUserDefaults.standardUserDefaults()
    
    let date: NSDate = NSDate()
    let cal: NSCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
    let formatter = NSDateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = APP_NAME
        
        //self.view.backgroundColor = UIColor.purpleColor()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "Emo abstract.jpg")!)

        
        
        // Detecting Device and setting constraints
        let device = UIDevice.currentDevice().model
        let index = device.startIndex.advancedBy(4)
        globalDevice.name = device.substringToIndex(index)
        
        if globalDevice.name == "iPad" {
            formatiPad()
        } else {
            formatiPhone()
        }
        
        if let alertDate = userDefaults.objectForKey("AlertDate") as? NSDate {
            NSLog("AlertDate is set")
            NSLog("AlertDate \(alertDate)")
            NSLog("AlertHr \(userDefaults.integerForKey("AlertHr"))")
            NSLog("AlertMin \(userDefaults.integerForKey("AlertMin"))")
            
            NSLog("All items")
            print(QuoteList().allItems())
            
        } else {
            // default value is not set or not an NSDate
            NSLog("AlertDate is not set")
            //set to 9am today
            let newDate: NSDate = cal.dateBySettingHour(9, minute: 0, second: 0, ofDate: date, options: NSCalendarOptions())!
            userDefaults.setBool(true, forKey: "AlertsOn")
            userDefaults.setObject(newDate, forKey: "AlertDate")
            //set alert hr and min
            userDefaults.setInteger(9, forKey: "AlertHr")
            userDefaults.setInteger(0, forKey: "AlertMin")
            //create QuoteList 64 items
            quotes = QuoteList().allItems()
            
            //if empty create new quote list
            if (quotes.count == 0) {
                
                dispatch_async(dispatch_get_global_queue(priority, 0)) {
                    self.createQuoteList()
                    dispatch_async(dispatch_get_main_queue()) {
                        // update some UI
                        self.generateRandomQuote()
                        
                    }
                }
            }
        }
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            self.syncQuoteList()
            dispatch_async(dispatch_get_main_queue()) {
                // update some UI
                self.getTodaysQuote()
                
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func syncQuoteList() {
        NSLog("Sync quotes list")
        
        quotes = QuoteList().allItems()
        //print(quotes[0])
        //print(quotes[0].isOverdue)
        for object in quotes {
            if(object.isOverdue){
                NSLog("Is overdue \(object.id)")
                if(object.isTodaysQuote == false){
                    NSLog("Is not todays quote \(object.id)")
                    QuoteList().removeItem(object)
                }
            }
        }
        
        //NSLog("All items")
        //NSLog(QuoteList().allItems())
        NSLog("Quotes count \(quotes.count)")
        if(quotes.count == 0){
            return
        }
        
        //Testing
        //print(UIApplication.sharedApplication().scheduledLocalNotifications)
        
        
        if(quotes.count <= 64){
            var dt = quotes[quotes.count-1].deadline
            NSLog("Latest deadline \(dt)")
            
            var i = quotes.count + 1
            while i <= 64 {
                //print(i)
                //NSLog("%@",dt);
                //add 24 hr to dt
                //NSLog("old date %@",dt);
                dt = cal.dateByAddingUnit(.Hour, value: 24, toDate: dt, options: [])!
                //NSLog("new date %@",dt);
                
                let qt = getNewQuoteForDate(dt)
                //NSLog("Date %@",dt);
                //NSLog("Quote is \(qt)")
                
                QuoteList().addItem(qt)
                
                i = i + 1
            }
            
        }
        
        
        NSLog("Sync quotes list END")
        
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
            
            if authorField != "" {
                quote = quote + "\r\n\n" + authorField
            }
            
            //NSLog("Quote is: " + quote)
            currentQuoteItem = Quote(deadline: NSDate(), quote: pickQuote.objectForKey(FIELD_QUOTE) as! String, author: authorField, id: idQuote)

            formatQuote(quote)
            
        }
        
    }
    
    func getTodaysQuote(){
        
        quotes = QuoteList().allItems()
        formatter.dateStyle = NSDateFormatterStyle.LongStyle
        formatter.timeStyle = .MediumStyle
        
        for object in quotes {
            if(object.isTodaysQuote){
                todaysQuoteItem = object
                break
            }
        }
        
        //print(todaysQuoteItem.quote)
        idQuote = todaysQuoteItem.id
        quote = todaysQuoteItem.quote
        authorField = (todaysQuoteItem.author)
        
        if authorField != "" {
            quote = quote + "\r\n\n" + authorField
        }
        
        //NSLog("Quote is: " + quote)
        currentQuoteItem = Quote(deadline: NSDate(), quote: todaysQuoteItem.quote, author: authorField, id: idQuote)
        formatQuote(quote)
        
    }
    
    func getQuoteTxt(quoteItem: Quote) -> String{
        
        idQuote = quoteItem.id
        quote = quoteItem.quote
        authorField = (quoteItem.author)
        
        print(authorField)
        
        quote = quote + "\r\n - " +  authorField
        
        NSLog("Quote is: " + quote)
        
        return quote
        
    }
    
    func formatiPad() {
        NSLog("Format iPad")

    }
    
    func formatiPhone() {
        NSLog("Format iPhone")
        //alertsButton.imageEdgeInsets = UIEdgeInsetsMake(45, 45, 45, 45)
        //randomButton.imageEdgeInsets = UIEdgeInsetsMake(45, 45, 45, 45)
        

    }
    
    func formatQuote(quote: String){
        
        
        if globalDevice.name == "iPad" {
            
            NSLog("Formatting for iPad")
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
            NSLog("Formatting for iPhone")

            
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
    
    func createQuoteList() {
        NSLog("Creating quotes list")
        quotes = QuoteList().allItems()
        
        var dt = NSCalendar.currentCalendar().dateByAddingUnit(.Day, value: -1, toDate: NSDate(), options: [])!
        
        for _ in 1...64 {
            //NSLog("%@",dt);
            //add 24 hr to dt
            //NSLog("old date %@",dt);
            dt = cal.dateByAddingUnit(.Hour, value: 24, toDate: dt, options: [])!
            //NSLog("new date %@",dt);
            
            let qt = getNewQuoteForDate(dt)
            //NSLog("Date %@",dt);
            //NSLog("Quote is \(qt)")
            
            QuoteList().addItem(qt)
            
        }
        NSLog("Creating quotes list END")
        
    }
    
    func getNewQuoteForDate(alertDate: NSDate) -> Quote{
        
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
            
            //get midnight of alertDate, add hr and min to create new date
            let dt = cal.startOfDayForDate(alertDate)
            let components = cal.components(([.Day, .Month, .Year]), fromDate: dt)
            components.hour = userDefaults.integerForKey("AlertHr")
            components.minute = userDefaults.integerForKey("AlertMin")
            let newDate = cal.dateFromComponents(components)!
            
            formatter.dateStyle = NSDateFormatterStyle.LongStyle
            formatter.timeStyle = .MediumStyle
            
            //let dateString = formatter.stringFromDate(newDate)
            
            quoteItem = Quote(deadline: newDate, quote: quote, author: authorField, id: idQuote)
            
            //NSLog("Date " + dateString)
            
        }
        return quoteItem
        
    }
    
    @IBAction func shareToFacebook(sender: AnyObject) {
        let shareToFacebook : SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
        shareToFacebook.setInitialText(getQuoteTxt(currentQuoteItem))
        self.presentViewController(shareToFacebook, animated: true, completion: nil)
    }
    
    @IBAction func shareToTwitter(sender: AnyObject) {
        let shareToTwitter : SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
        shareToTwitter.setInitialText(getQuoteTxt(currentQuoteItem))
        self.presentViewController(shareToTwitter, animated: true, completion: nil)
    }
    
    @IBAction func shareButtonClicked(sender: AnyObject) {
        let textToShare = "Swift is awesome!  Check out this website about it!"
        
        if let myWebsite = NSURL(string: "http://www.codingexplorer.com/") {
            let objectsToShare = [textToShare, myWebsite]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            
            activityVC.popoverPresentationController?.sourceView = sender as? UIView
            self.presentViewController(activityVC, animated: true, completion: nil)
        }
    }
}

