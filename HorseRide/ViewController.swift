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

        nfcHelper.onNFCResult = onNFCResult(success:type:msg:)

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

    func onNFCResult(success: Bool, type: String, msg: String) {
        if !success {
            return
        }
        DispatchQueue.main.async {
            var realMsg = ""
            if type == "U" && msg.hasPrefix("\u{3}") {
                let start = msg.index(msg.startIndex, offsetBy: 1)
                let end = msg.endIndex
                realMsg = "http://" + msg[start..<end]
            } else if type == "U" && msg.hasPrefix("\u{4}") {
                let start = msg.index(msg.startIndex, offsetBy: 1)
                let end = msg.endIndex
                realMsg = "https://" + msg[start..<end]
            } else if type == "T" {
                let start = msg.index(msg.startIndex, offsetBy: 3)
                let end = msg.endIndex
                realMsg = String(msg[start..<end])
            }
            print(realMsg)

            let when = DispatchTime.now() + 1 // Delay 1 second
            self.nfcPayloadLabel.text = "\(self.nfcPayloadLabel.text!)\n\(realMsg)"
            DispatchQueue.main.asyncAfter(deadline: when) {
                if type == "U" {
                    let url = URL(string: realMsg)
                    UIApplication.shared.open(url!, options: [:], completionHandler: nil)
                } else if type == "T" {
                    let alertController = UIAlertController(title: nil, message: realMsg, preferredStyle: UIAlertControllerStyle.alert)

                    let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                        (result : UIAlertAction) -> Void in
                        print("You pressed OK")
                    }
                    alertController.addAction(okAction)
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }


}

