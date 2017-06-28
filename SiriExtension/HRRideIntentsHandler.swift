//
//  HRRideIntentsHandler.swift
//  SiriExtension
//
//  Created by Vince Yuan on 6/29/17.
//  Copyright © 2017 Vince Yuan. All rights reserved.
//

import UIKit
import Intents
import CoreLocation
import HorseRideCore

class HRRideIntentsHandler: NSObject, INRequestRideIntentHandling, INGetRideStatusIntentHandling {

    let rideService = HRDummyRideService()
    static let slowHorseIdentifier = "SlowHorse"
    static let fastHorseIdentifier = "FastHorse"
    static let rideOptionKey = "rideOption"
    static let pickupDateKey = "pickupDate"
    static let statusKey = "status"

    // MARK: - INListRideOptionsIntentHandling
    func handle(listRideOptions intent: INListRideOptionsIntent, completion: @escaping (INListRideOptionsIntentResponse) -> Void) {
        let response = INListRideOptionsIntentResponse(code: .success, userActivity: nil)

        let pickupDateSlow = Date(timeIntervalSinceNow: 240)
        let rideOptionSlow = INRideOption(name: "Slow horse", estimatedPickupDate: pickupDateSlow)
        rideOptionSlow.priceRange = INPriceRange(minimumPrice: 10.0, currencyCode: "USD")
        rideOptionSlow.disclaimerMessage = "This horse is slow."
        let pickupDateFast = Date(timeIntervalSinceNow: 120)
        let rideOptionFast = INRideOption(name: "Fast horse", estimatedPickupDate: pickupDateFast)
        rideOptionFast.priceRange = INPriceRange(minimumPrice: 15.0, currencyCode: "USD")
        rideOptionFast.disclaimerMessage = "This horse is fast."

        response.rideOptions = [rideOptionSlow, rideOptionFast]

        completion(response)
    }

    // MARK: - INGetRideStatusIntentHandling
    func handle(getRideStatus intent: INGetRideStatusIntent, completion: @escaping (INGetRideStatusIntentResponse) -> Void) {
        let response = INGetRideStatusIntentResponse(code: .inProgress, userActivity: nil)
        completion(response)
    }

    func startSendingUpdates(forGetRideStatus intent: INGetRideStatusIntent, to observer: INGetRideStatusIntentResponseObserver) {
    }

    func stopSendingUpdates(forGetRideStatus intent: INGetRideStatusIntent) {
    }

    // MARK: - INRequestRideIntentHandling
    func handle(requestRide intent: INRequestRideIntent, completion: @escaping (INRequestRideIntentResponse) -> Void) {
        let response = INRequestRideIntentResponse(code: .success,
                                                   userActivity: nil)
        let rideStatus = INRideStatus()
        rideStatus.phase = INRidePhase.confirmed
        HRRideStorage.save(rideInfo: [ HRRideIntentsHandler.statusKey : true ])
        rideStatus.pickupLocation = intent.pickupLocation
        rideStatus.dropOffLocation = intent.dropOffLocation
        let pickupDate = HRRideStorage.latestRide()?[HRRideIntentsHandler.pickupDateKey] as! Date
        rideStatus.rideOption =
            INRideOption(name: (intent.rideOptionName?.spokenPhrase)!,
                         estimatedPickupDate: pickupDate)

        response.rideStatus = rideStatus
        completion(response)
    }

    func confirm(requestRide intent: INRequestRideIntent,
                 completion: @escaping (INRequestRideIntentResponse) -> Swift.Void) {
        self.handleIntent(requestRide: intent, completion: completion)
    }

    private func handleIntent(requestRide intent: INRequestRideIntent,
                              completion: @escaping (INRequestRideIntentResponse) -> Swift.Void) {
        let userActivity =
            NSUserActivity(activityType: NSStringFromClass(INRequestRideIntentResponse.self))
        var response = INRequestRideIntentResponse(code: .success,
                                                   userActivity: userActivity)
        let from = intent.pickupLocation?.name
        let to = intent.dropOffLocation?.name
        var rideType: HRRideType = .slowHorse
        if let phrase = intent.rideOptionName?.spokenPhrase {
            if phrase == HRRideIntentsHandler.fastHorseIdentifier {
                rideType = .fastHorse
            }
        }
        if let from = from, let to = to {
            rideService.findRide(from: from, to: to, completion: { [unowned self] rides in
                if rides.count > 0 {
                    let rideStatus = self.convertRidesToRideStatus(rides: rides,
                                                       from: from,
                                                         to: to,
                                                   rideType: rideType)
                    let rideInfo: [String : Any] =
                        [ HRRideIntentsHandler.rideOptionKey : rideStatus.rideOption!.name,
                          HRRideIntentsHandler.pickupDateKey : rideStatus.rideOption!.estimatedPickupDate]
                    HRRideStorage.removeRide()
                    HRRideStorage.save(rideInfo: rideInfo)
                    response.rideStatus = rideStatus
                    completion(response)
                } else {
                    response = INRequestRideIntentResponse(code: .failure,
                                                           userActivity: userActivity)
                    HRRideStorage.removeRide()
                    completion(response)
                }
            })
        } else {
            response = INRequestRideIntentResponse(code: .failure,
                                                   userActivity: userActivity)
            HRRideStorage.removeRide()
            completion(response)
        }
    }

    func resolvePickupLocation(forRequestRide intent: INRequestRideIntent, with completion: @escaping (INPlacemarkResolutionResult) -> Void) {
        if (intent.pickupLocation == nil) {
            let result = INPlacemarkResolutionResult.needsValue()
            completion(result)
        } else {
            let result = INPlacemarkResolutionResult.success(with: intent.pickupLocation!)
            completion(result)
        }
    }

    func resolveDropOffLocation(forRequestRide intent: INRequestRideIntent, with completion: @escaping (INPlacemarkResolutionResult) -> Void) {
        if (intent.dropOffLocation == nil) {
            let result = INPlacemarkResolutionResult.needsValue()
            completion(result)
        } else {
            let result = INPlacemarkResolutionResult.success(with: intent.dropOffLocation!)
            completion(result)
        }
    }

    private func convertRidesToRideStatus(rides: [HRRide],
                                          from: String,
                                          to: String,
                                          rideType: HRRideType) -> INRideStatus {
        var text = "ride "
        var selectedRide = rides.first!
        for ride in rides {
            if ride.rideType == rideType {
                selectedRide = ride
                break
            }
        }
        let price = "\(selectedRide.price) \(selectedRide.currency)"
        let minutes = Int(selectedRide.timeInMinutes)
        text += "from \(from) to \(to), " +
        "departing in \(minutes) minutes for \(price)"
        let rideStatus = INRideStatus()
        let pickupDate = Date().addingTimeInterval(selectedRide.timeInMinutes * 60)
        rideStatus.rideOption = INRideOption(name: text, estimatedPickupDate: pickupDate)

        return rideStatus
    }

    func resolveRideOptionName(forRequestRide intent: INRequestRideIntent,
                               with completion: @escaping (INSpeakableStringResolutionResult) -> Void) {
        if let rideOption = intent.rideOptionName {
            let result = INSpeakableStringResolutionResult.success(with: rideOption)
            completion(result)
        } else {
            let first = INSpeakableString(identifier: HRRideIntentsHandler.slowHorseIdentifier,
                                          spokenPhrase: "Slow horse",
                                          pronunciationHint: nil)
            let second = INSpeakableString(identifier: HRRideIntentsHandler.fastHorseIdentifier,
                                           spokenPhrase: "Fast horse",
                                           pronunciationHint: nil)
            let result = INSpeakableStringResolutionResult.disambiguation(with: [first, second])
            completion(result)
        }
    }

}
