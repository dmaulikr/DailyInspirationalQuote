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

    let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT

    var idQuote: String = ""
    var quote: String = ""
    var author: String = ""
    var year: String = ""
    var authorField: String = ""
    var yearField: String = ""
    
    var quoteItem: Quote!
    var todaysQuoteItem: Quote!
    var newQuote: Quote!
    var quotes: [Quote] = []
    
    let userDefaults = NSUserDefaults.standardUserDefaults()
    
    let date: NSDate = NSDate()
    let cal: NSCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
    let formatter = NSDateFormatter()


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
            
            if (pickQuote.objectForKey(FIELD_YEAR) as? String != nil) {
                yearField = (pickQuote.objectForKey(FIELD_YEAR) as? String)!
            } else {
                yearField = ""
            }
            
            if authorField != "" || yearField != "" {
                quote = quote + "\r\n\n" + authorField + "\r\n" + yearField
            }
            
            //NSLog("Quote is: " + quote)

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
        yearField = (todaysQuoteItem.year)

        if authorField != "" || yearField != "" {
            quote = quote + "\r\n\n" + authorField + "\r\n" + yearField
        }
        
        //NSLog("Quote is: " + quote)
        
        formatQuote(quote)
        
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
            
            if (pickQuote.objectForKey(FIELD_YEAR) as? String != nil) {
                yearField = (pickQuote.objectForKey(FIELD_YEAR) as? String)!
            } else {
                yearField = ""
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

            quoteItem = Quote(deadline: newDate, quote: quote, author: authorField, year: yearField, id: idQuote)
            
            //NSLog("Date " + dateString)

        }
        return quoteItem
        
    }
    
}

