//
//  IntentViewController.swift
//  SiriExtensionUI
//
//  Created by Vince Yuan on 6/23/17.
//  Copyright © 2017 Vince Yuan. All rights reserved.
//

import IntentsUI
import HorseRideCore

// As an example, this extension's Info.plist has been configured to handle interactions for INSendMessageIntent.
// You will want to replace this or add other intents as appropriate.
// The intents whose interactions you wish to handle must be declared in the extension's Info.plist.

// You can test this example integration by saying things to Siri like:
// "Send a message using <myApp>"

class IntentViewController: UIViewController, INUIHostedViewControlling {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - INUIHostedViewControlling
    
    // Prepare your view controller for the interaction to handle.
    func configure(with interaction: INInteraction, context: INUIHostedViewContext, completion: @escaping (CGSize) -> Void) {
        // Do configuration here, including preparing views and calculating a desired size for presentation.
        var size: CGSize

        // Check if the interaction describes a SendMessageIntent.
        if interaction.representsSendMessageIntent {
            // If it is, let's set up a view controller.
            let chatViewController = HRChatViewController()
            chatViewController.messageContent = interaction.messageContent

            switch interaction.intentHandlingStatus {
            case .unspecified, .inProgress, .ready, .failure:
                chatViewController.isSent = false

            case .success, .deferredToApplication:
                chatViewController.isSent = true
            }

            present(chatViewController, animated: false, completion: nil)

            size = desiredSize
        }
        else {
            // Otherwise, we'll tell the host to draw us at zero size.
            size = CGSize.zero
        }

        completion(size)
    }
    
    var desiredSize: CGSize {
        var size = self.extensionContext!.hostedViewMaximumAllowedSize
        size.height = 280
        return size
    }

    var displaysMessage: Bool {
        return false
    }
}
