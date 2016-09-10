//
//  Quote.swift
//  Daily Inspirational Quote
//
//  Created by RJ Militante on 9/3/16.
//  Copyright © 2016 Kraftwerking LLC. All rights reserved.
//

import Foundation

struct Quote {
    var quote: String
    var author: String
    var deadline: NSDate
    var id: String
    
    init(deadline: NSDate, quote: String, author: String, id: String) {
        self.deadline = deadline
        self.quote = quote
        self.author = author
        self.id = id
    }
    
    var isOverdue: Bool {
        return (NSDate().compare(self.deadline) == NSComparisonResult.OrderedDescending) // deadline is earlier than current date
    }
    
    var isTodaysQuote: Bool {
        let todaysDate = NSDate()
        let unitFlags: NSCalendarUnit = [.Hour, .Day, .Month, .Year]
        let components = NSCalendar.currentCalendar().components(unitFlags, fromDate: todaysDate)
        
        //print(object.deadline)
        //let dateString = formatter.stringFromDate(object.deadline)
        //NSLog(dateString)
        let componentsCurrent = NSCalendar.currentCalendar().components(unitFlags, fromDate: self.deadline)
        //print(componentsCurrent.year)
        //print(componentsCurrent.month)
        //print(componentsCurrent.day)
        if(componentsCurrent.year == components.year && componentsCurrent.month == components.month && componentsCurrent.day == components.day){
            return true
        } else {
            return false
        }
    }
}