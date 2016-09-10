//
//  Config.swift
//  appyQuote
//
//  Created by RJ Militante on 8/24/16.
//  Copyright © 2016 Kraftwerking LLC. All rights reserved.
//

import UIKit
import Foundation


let BLU: UIColor = UIColor(red: (83/255.0), green: (172/255.0), blue: (238/255.0), alpha: 1.0)
let GREEN: UIColor = UIColor(red: (63/255.0), green: (173/255.0), blue: (88/255.0), alpha: 1.0)
let ORANGE: UIColor = UIColor(red: (245/255.0), green: (166/255.0), blue: (35/255.0), alpha: 1.0)
let PINK: UIColor = UIColor(red: (206/255.0), green: (94/255.0), blue: (161/255.0), alpha: 1.0)
let COFFEE: UIColor = UIColor(red: (161/255.0), green: (134/255.0), blue: (112/255.0), alpha: 1.0)
let GRAY: UIColor = UIColor(red: (128/255.0), green: (122/255.0), blue: (130/255.0), alpha: 1.0)
let NAVY: UIColor = UIColor(red: (54/255.0), green: (73/255.0), blue: (95/255.0), alpha: 1.0)
let DARKGRAY: UIColor = UIColor(red: (90/255.0), green: (90/255.0), blue: (90/255.0), alpha: 1)
let WHITE: UIColor = UIColor.whiteColor()



// -------------------------------------------------------------------
// Global variables
// -------------------------------------------------------------------

let APP_NAME: String = "Daily Inspirational Quote"
let SHARED_FROM: String = "Shared with the Daily Inspirational Quote App"

// -------------------------------------------------------------------




// -------------------------------------------------------------------
// - In App Purchase and Ads Settings - Choose enable/disable (true or false)
// -------------------------------------------------------------------

// You can enable or disable In App Purchase and Ads separately.
// So you can choose to have:

// - Ads enabled with the possibility to remove it via IAP (ADS = true - IAP = true)
// - Ads enabled with no possibility to remove it (ADS = true - IAP = false)
// - No Ads and (obviously) No In App Purchase (ADS = false - IAP = false)

// Don't set ADS false and IAP true, or your user will pay for nothing! :)

let IAP_ENABLED = true
let ADS_ENABLED = true

// - Choose which Ads Network use

let iAD_ENABLED = true
let ADMOB_ENABLED = false


// -------------------------------------------------------------------




// -------------------------------------------------------------------
// Insert your In App Purchase Id that you choose in iTunes Connect.
// -------------------------------------------------------------------

let IAP_ID = "xxx.xxxxxxx.xxxxx"

// -------------------------------------------------------------------




// -------------------------------------------------------------------
// - AdMob
// -------------------------------------------------------------------

// Replace the string below with the unit id you've got
// by registering your App on AdMob
// -------------------------------------------------------------------

let ADMOB_UNIT_ID = "ca-app-pub-5109865943077489/8404549657"


// -------------------------------------------------------------------
// - Fields name of Quotes.plist
// -------------------------------------------------------------------
//
// These are the field names accepted by the App
// -------------------------------------------------------------------

let FIELD_ID = "id"
let FIELD_QUOTE = "Quote"
let FIELD_AUTHOR = "Author"

// -------------------------------------------------------------------




// -------------------------------------------------------------------
// UI Colors
// -------------------------------------------------------------------

// - BLU
// - GREEN
// - ORANGE
// - PINK
// - COFFEE
// - GRAY
// - NAVY

/* UPPERCASE! */

// Top Background
let BG_TOP = "BLU"

// Bottom Background
let BG_BOTTOM = "BLU"

// Button Favorite
let BUTTON_FAV = "ORANGE"

// Button Share
let BUTTON_SHARE = "ORANGE"




// -------------------------------------------------------------------
// Navigation Bar
// -------------------------------------------------------------------

// Background and Tint Colors

// - BLU
// - GREEN
// - ORANGE
// - PINK
// - COFFEE
// - GRAY
// - DARKGRAY
// - NAVY
// - WHITE


let NAVBAR_COLOR: UIColor = BLU
let NAVBAR_TINT_COLOR: UIColor = WHITE

// Font type, size and Color
let NAVBAR_FONT: UIFont = UIFont(name: "HelveticaNeue-Light", size: 18)!
let NAVBAR_FONT_COLOR: UIColor = WHITE



// -------------------------------------------------------------------
// Quote font & colors
// -------------------------------------------------------------------

// Font type and size for iPhone and iPad
let FONT_QUOTE_iPhone = UIFont(name: "HelveticaNeue-Light", size: 18)
let FONT_QUOTE_iPhone4 = UIFont(name: "HelveticaNeue-Light", size: 16)
let FONT_QUOTE_iPad = UIFont(name: "HelveticaNeue-Light", size: 28)

// Font Color
let FONT_QUOTE_COLOR = WHITE


// -------------------------------------------------------------------
