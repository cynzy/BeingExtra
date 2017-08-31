//
//  BookingStruct.swift
//  BeingExtra
//
//  Created by Cynthia Zhou on 2017-08-30.
//  Copyright © 2017 Cynthia Zhou. All rights reserved.
//

import Foundation

enum BookingState {
    case booked
    case free
}

struct Booking {
    
    ///returns the date of booking
    let bookedDate: Date
    ///returns the title of the production
    let productionTitle: String
    ///returns the time of crew call
    let crewCall: Int
    ///returns the call time
    let callTime: Int
    ///returns the estimated lunch time (6 hrs after crew call)
    let estimatedLunchTime: String
    ///returns location of the shoot
    let location: String
    ///returns the rental item if the production is renting, returns "no item rental" if no item being rented
    let isRenting: String
    ///retuns ths designated price for the rental
    var rentalPrice: Double?
    ///returns wrap time
    var wrapTime: Int?
    ///returns the earned money of the day (excludes commission)
    var earnedToday: Double?
    
    
    ///init function
    public init(bookedDate: Date,
                productionTitle: String,
                crewCall: Int,
                callTime: Int,
                estimatedLunchTime: String,
                location: String,
                isRenting: String? = nil){
        self.bookedDate = bookedDate
        self.productionTitle = productionTitle
        self.crewCall = crewCall
        self.callTime = callTime
        self.estimatedLunchTime = estimatedLunchTime
        self.location = location
        self.isRenting = isRenting ?? "No item rental requested"
    }
    
    mutating func endOfDay(wraptime: Int, rentalPrice: Double? = nil){
        wrapTime = wraptime
        earnedToday = convertToMoneyEarned(from: (wrapTime! - callTime))
    }

}

func convertToMoneyEarned(from time: Int) -> Double {
    
    let hours = Int(time/100)
    let minutes = time % hours
    let earned: Double
    
    if hours < 8 {
        earned = 12.42 * Double(hours + minutes/60)
    } else if hours >= 8 && hours < 12 {
        earned = 99.36 + 18.63 * Double(hours + minutes/60 - 8)
    } else if hours >= 12 {
        earned = 99.36 + 74.52 + 24.84 * Double(hours + minutes/60 - 12)
    } else {
        earned = 0.00
    }
    
    return earned
}


