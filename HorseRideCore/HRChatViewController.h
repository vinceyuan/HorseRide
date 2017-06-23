//
//  HRChatViewController.h
//  HorseRideCore
//
//  Created by Vince Yuan on 6/23/17.
//  Copyright © 2017 Vince Yuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HRChatViewController : UIViewController

@property (nonatomic, strong) NSString *messageContent;
@property (nonatomic, assign, getter=isSent) BOOL sent;

@end
