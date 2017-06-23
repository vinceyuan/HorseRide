//
//  HRPaymentIntentsHandler.swift
//  SiriExtension
//
//  Created by Vince Yuan on 6/24/17.
//  Copyright © 2017 Vince Yuan. All rights reserved.
//

import UIKit
import Intents
import HorseRideCore

class HRPaymentIntentsHandler: NSObject, INSendPaymentIntentHandling {
    func handle(sendPayment intent: INSendPaymentIntent, completion: @escaping (INSendPaymentIntentResponse) -> Void) {
        // Check that we have valid values for payee and currencyAmount
        guard let payee = intent.payee, let amount = intent.currencyAmount else {
            return completion(INSendPaymentIntentResponse(code: .unspecified, userActivity: nil))
        }
        // Make your payment!
        print("Sending \(amount) payment to \(payee)!")
        completion(INSendPaymentIntentResponse(code: .success, userActivity: nil))
    }
}
