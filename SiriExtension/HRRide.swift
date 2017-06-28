//
//  HRRide.swift
//  HorseRideCore
//
//  Created by Vince Yuan on 6/29/17.
//  Copyright © 2017 Vince Yuan. All rights reserved.
//

import Foundation

enum HRRideType {
    case slowHorse
    case fastHorse
}

struct HRRide {
    var carNumber: String
    var timeInMinutes: Double
    var rideType: HRRideType
    var price: Float
    var currency: String
}

protocol HRRideService {
    func findRide(from: String, to: String, completion: @escaping ([HRRide]) -> Swift.Void)
}

class HRDummyRideService: NSObject, HRRideService {

    func findRide(from: String, to: String, completion: @escaping ([HRRide]) -> Swift.Void) {
        completion(self.dummyRides())
    }

    private func dummyRides() -> [HRRide] {
        let ride1 = HRRide(carNumber: "123",
                         timeInMinutes: 4,
                         rideType: .slowHorse,
                         price: 10,
                         currency: "USD")

        let ride2 = HRRide(carNumber: "11",
                         timeInMinutes: 2,
                         rideType: .fastHorse,
                         price: 15,
                         currency: "USD")

        let ride3 = HRRide(carNumber: "80",
                         timeInMinutes: 7,
                         rideType: .slowHorse,
                         price: 12,
                         currency: "USD")

        return [ ride1, ride2, ride3 ]
    }
}
