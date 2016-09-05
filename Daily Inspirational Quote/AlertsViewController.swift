//
//  AlertsViewController.swift
//  Daily Inspirational Quote
//
//  Created by RJ Militante on 9/2/16.
//  Copyright © 2016 Kraftwerking LLC. All rights reserved.
//

import UIKit

class AlertsViewController: UIViewController {
    

    @IBOutlet var alertPicker: UIDatePicker!
    var idQuote: String = ""
    var quote: String = ""
    var author: String = ""
    var year: String = ""
    var authorField: String = ""
    var yearField: String = ""
    var quoteItem: Quote!
    var newQuote: Quote!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func saveAlerts(sender: AnyObject) {
        
        let newQuote = getNewQuote()
        //print(newQuote.quote)
        
        QuoteList().addItem(newQuote) // schedule a local notification to persist this item
        
        globalDevice.alertDate = alertPicker.date
        
    }
    
    func getNewQuote() -> Quote{
        
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
            
            quoteItem = Quote(deadline: alertPicker.date, quote: quote, author: authorField, year: yearField, id: idQuote)
            
        }
        return quoteItem
        
    }
    
}
