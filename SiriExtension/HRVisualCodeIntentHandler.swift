//
//  HRVisualCodeIntentHandler.swift
//  SiriExtension
//
//  Created by Vince Yuan on 7/1/17.
//  Copyright © 2017 Vince Yuan. All rights reserved.
//

import UIKit
import Intents
import CoreImage

class HRVisualCodeIntentHandler: NSObject, INGetVisualCodeIntentHandling {

    func handle(getVisualCode intent: INGetVisualCodeIntent,
                completion: @escaping (INGetVisualCodeIntentResponse) -> Void) {

        guard let smallImg = createQRFromString("Vince Yuan") else {
            return completion(INGetVisualCodeIntentResponse(code: .failure, userActivity: nil))
        }

        let transform = CGAffineTransform(scaleX: 5.0, y: 5.0) // Scale by 5 times along both dimensions
        let img = smallImg.applying(transform)

        // Cannot generate UIImage using the following line. It fails UIImagePNGRepresentation().
        //let someImage = UIImage(ciImage: img, scale: 1.0, orientation: UIImageOrientation.down)
        let cgImage = CIContext(options: nil).createCGImage(img, from: img.extent)
        let someImage = UIImage(cgImage: cgImage!)

        let response = INGetVisualCodeIntentResponse(code: .success, userActivity: nil)
        let data = UIImagePNGRepresentation(someImage)
        response.visualCodeImage = INImage(imageData: data!)
        return completion(response)
    }

    func createQRFromString(_ str: String) -> CIImage? {
        let stringData = str.data(using: String.Encoding.utf8)
        let filter = CIFilter(name: "CIQRCodeGenerator")
        filter?.setDefaults()
        filter?.setValue(stringData, forKey: "inputMessage")
        filter?.setValue("H", forKey: "inputCorrectionLevel")
        return filter?.outputImage
    }

}
