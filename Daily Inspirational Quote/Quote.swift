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
    var year: String
    var deadline: NSDate
    var id: String
    
    init(deadline: NSDate, quote: String, author: String, year: String, id: String) {
        self.deadline = deadline
        self.quote = quote
        self.author = author
        self.year = year
        self.id = id
    }
    
    var isOverdue: Bool {
        return (NSDate().compare(self.deadline) == NSComparisonResult.OrderedDescending) // deadline is earlier than current date
    }
}