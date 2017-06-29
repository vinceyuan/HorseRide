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
    @IBOutlet weak var nfcPayloadLabel: UILabel!

    let nfcHelper = NFCHelper()

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

        nfcHelper.onNFCResult = onNFCResult(success:msg:)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func didPressScanNFCTag(_ sender: Any) {
        print("didPressScanNFCTag")
        self.nfcPayloadLabel.text = ""
                nfcHelper.restartSession()
    }

    func onNFCResult(success: Bool, msg: String) {
        if !success {
            return
        }
        DispatchQueue.main.async {
            self.nfcPayloadLabel.text = "\(self.nfcPayloadLabel.text!)\n\(msg)"
            if msg == "\u{4}grab.com" {
                let url = URL(string: "https://grab.com")
                let when = DispatchTime.now() + 1 // Delay 1 second
                DispatchQueue.main.asyncAfter(deadline: when) {
                    UIApplication.shared.open(url!, options: [:], completionHandler: nil)
                }
            }
        }
    }


}

