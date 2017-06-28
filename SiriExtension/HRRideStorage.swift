//
//  HRRideStorage.swift
//  SiriExtension
//
//  Created by Vince Yuan on 6/29/17.
//  Copyright © 2017 Vince Yuan. All rights reserved.
//

import Foundation

class HRRideStorage {

    static let savedRideId = "savedRide"

    class func save(rideInfo: [String : Any]) {
        var newRideInfo = rideInfo
        if let saved = latestRide() {
            newRideInfo.merge(with: saved)
        }
        UserDefaults.standard.set(newRideInfo, forKey: HRRideStorage.savedRideId)
        UserDefaults.standard.synchronize()
    }

    class func removeRide() {
        UserDefaults.standard.set(nil, forKey: HRRideStorage.savedRideId)
        UserDefaults.standard.synchronize()
    }

    class func latestRide() -> [String : Any]? {
        return UserDefaults.standard.value(forKey: HRRideStorage.savedRideId) as? [String : Any]
    }

}

extension Dictionary {

    mutating func merge(with dictionary: Dictionary) {
        for (key, value) in dictionary {
            updateValue(value, forKey: key)
        }
    }

    func merged(with dictionary: Dictionary) -> Dictionary {
        var dict = self
        dict.merge(with: dictionary)
        return dict
    }
}
