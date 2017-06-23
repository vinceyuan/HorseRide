//
//  HRChatView.h
//  HorseRideCore
//
//  Created by Vince Yuan on 6/23/17.
//  Copyright © 2017 Vince Yuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HRChatView : UIView

@property (nonatomic, copy) NSString *content;
@property (nonatomic, assign, getter=isSent) BOOL sent;

@end
