//
//  QuoteList.swift
//  Daily Inspirational Quote
//
//  Created by RJ Militante on 9/3/16.
//  Copyright © 2016 Kraftwerking LLC. All rights reserved.
//

import Foundation
import UIKit

class QuoteList {
    
    let userDefaults = NSUserDefaults.standardUserDefaults()

    private let savePath = (NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as NSString).stringByAppendingPathComponent("Quote.plist") // ~/Quote.plist
    
    func allItems() -> [Quote] {
        var items: [AnyObject] = self.rawItems()
        return items.map({Quote(deadline: $0["deadline"] as! NSDate, quote: $0["quote"] as! String, author: $0["author"] as! String, year: $0["year"] as! String,  id: $0["id"] as! String!)}).sort({
            return ($0.deadline.compare($1.deadline) == .OrderedAscending)
        })
    }
    
    private func rawItems() -> [AnyObject] {
        var items: Array<AnyObject> = [] // default to an empty array...
        if (NSArray(contentsOfFile: self.savePath) != nil) { // ...because init?(contentsOfFile:) will return nil if file doesn't exist yet
            items = NSArray(contentsOfFile: self.savePath)! as Array<AnyObject> // load stored items, if available
        }
        return items
    }
    
    func setBadgeNumbers() {
        var notifications = UIApplication.sharedApplication().scheduledLocalNotifications! as [UILocalNotification] // all scheduled notifications
        var Quotes: [Quote] = self.allItems()
        
        for notification in notifications {
            var overdueItems = Quotes.filter({ (Quote) -> Bool in // array of to-do items...
                return (Quote.deadline.compare(notification.fireDate!) != .OrderedDescending) // ...where item deadline is before or on notification fire date
            })
            UIApplication.sharedApplication().cancelLocalNotification(notification) // cancel old notification
            notification.applicationIconBadgeNumber = -1 // set new badge number
            UIApplication.sharedApplication().scheduleLocalNotification(notification) // reschedule notification
        }
    }
    
    func addItem(item: Quote) {
        // persist a representation of this Quote item in a plist
        var items: [AnyObject] = self.rawItems()
        items.append(["quote": item.quote, "deadline": item.deadline, "id": item.id, "author": item.author, "year": item.year]) // add a dictionary representing this Quote instance
        (items as NSArray).writeToFile(self.savePath, atomically: true) // items casted as NSArray because writeToFile:atomically: is not available on Swift arrays
        
        if(userDefaults.boolForKey("AlertsOn")){
            // create a corresponding local notification
            let notification = UILocalNotification()
            notification.alertBody = "Daily quote \"\(item.quote)\"" // text that will be displayed in the notification
            notification.alertAction = "open" // text that is displayed after "slide to..." on the lock screen - defaults to "slide to view"
            notification.fireDate = item.deadline // Quote item due date (when notification will be fired)
            notification.soundName = UILocalNotificationDefaultSoundName // play default sound
            notification.userInfo = ["quote": item.quote, "id": item.id, "author": item.author, "year": item.year] // assign a unique identifier to the notification that we can use to retrieve it later
            notification.category = "Quote_CATEGORY"
            
            UIApplication.sharedApplication().scheduleLocalNotification(notification)
            
            self.setBadgeNumbers()
        }

    }
    
    func removeItem(item: Quote) {
        for notification in UIApplication.sharedApplication().scheduledLocalNotifications! as [UILocalNotification] { // loop through notifications...
            if (notification.userInfo!["id"] as! String == item.id) { // ...and cancel the notification that corresponds to this Quote instance (matched by id)
                UIApplication.sharedApplication().cancelLocalNotification(notification) // there should be a maximum of one match on id
                break
            }
        }
        
        var items: [AnyObject] = self.rawItems()
        items = items.filter {($0["id"] as! String? != item.id)} // remove item that matches id
        (items as NSArray).writeToFile(self.savePath, atomically: true) // overwrite Quote.plist with new array
        
        self.setBadgeNumbers()
    }
    
}