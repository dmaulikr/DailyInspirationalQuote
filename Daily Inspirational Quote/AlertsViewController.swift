//
//  AlertsViewController.swift
//  Daily Inspirational Quote
//
//  Created by RJ Militante on 9/2/16.
//  Copyright © 2016 Kraftwerking LLC. All rights reserved.
//

import UIKit

class AlertsViewController: UIViewController {
    

    @IBOutlet var alertSwitch: UISwitch!
    @IBOutlet var alertPicker: UIDatePicker!
    let userDefaults = NSUserDefaults.standardUserDefaults()
    var quotes: [Quote] = []
    let cal: NSCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
    
    let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT


    override func viewDidLoad() {
        super.viewDidLoad()
        if let alertDate = userDefaults.objectForKey("AlertDate") as? NSDate {
            NSLog("AlertDate is set")
            NSLog("AlertDate \(alertDate)")
            NSLog("AlertHr \(userDefaults.integerForKey("AlertHr"))")
            NSLog("AlertMin \(userDefaults.integerForKey("AlertMin"))")

        } else {
            // default value is not set or not an NSDate
            NSLog("AlertDate is not set")
        }
        let dt = userDefaults.objectForKey("AlertDate") as? NSDate
        alertPicker.setDate(dt!, animated: true)
        alertSwitch.setOn(userDefaults.boolForKey("AlertsOn"), animated: true)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func recreateQuoteList() {
        NSLog("Recreating quotes list")
        NSLog("AlertDate \(userDefaults.objectForKey("AlertDate"))")
        NSLog("AlertHr \(userDefaults.integerForKey("AlertHr"))")
        NSLog("AlertMin \(userDefaults.integerForKey("AlertMin"))")
        
        quotes = QuoteList().allItems()
        for object in quotes {
            print(object.id)
            QuoteList().removeItem(object)
            
            //calculate new deadline
            //get midnight of alertDate, add hr and min to create new date
            let dt = cal.startOfDayForDate(object.deadline)
            let components = cal.components(([.Day, .Month, .Year]), fromDate: dt)
            components.hour = userDefaults.integerForKey("AlertHr")
            components.minute = userDefaults.integerForKey("AlertMin")
            let newDate = cal.dateFromComponents(components)!
            
            let qt = Quote.init(deadline: newDate, quote: object.quote, author: object.author, year: object.year, id: object.id)
            QuoteList().addItem(qt)
        }
        
        NSLog("Recreating quotes list END")
        
    }
    
    @IBAction func alertSwitchAction(sender: AnyObject) {
        if(alertSwitch.on){
            NSLog("Alerts on")
            userDefaults.setBool(true, forKey: "AlertsOn")


        } else {
            NSLog("Alerts off")
            userDefaults.setBool(false, forKey: "AlertsOn")
            
        }
        
        let alertDate = alertPicker.date
        NSLog("AlertDate \(alertDate)")
        userDefaults.setObject(alertDate, forKey: "AlertDate")
        userDefaults.setObject(alertDate, forKey: "AlertDate")
        //get hr and min from date
        let calendar = NSCalendar.currentCalendar()
        let comp = calendar.components([.Hour, .Minute], fromDate: alertDate)
        let hour = comp.hour
        let minute = comp.minute
        //set alert hr and min
        userDefaults.setInteger(hour, forKey: "AlertHr")
        userDefaults.setInteger(minute, forKey: "AlertMin")
        
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            //reset deadline hr min in quotelist
            self.recreateQuoteList()
            dispatch_async(dispatch_get_main_queue()) {
                // update some UI
                
            }
        }
    }
    
}
