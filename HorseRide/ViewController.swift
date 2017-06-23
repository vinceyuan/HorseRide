//
//  ViewController.swift
//  HorseRide
//
//  Created by Vince Yuan on 6/23/17.
//  Copyright © 2017 Vince Yuan. All rights reserved.
//

import UIKit
import Intents

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Ask permission to access Siri
        INPreferences.requestSiriAuthorization { authorizationStatus in
            switch authorizationStatus {
            case .authorized:
                print("Authorized")
            default:
                print("Not Authorized")
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

