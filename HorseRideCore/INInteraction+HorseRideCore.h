//
//  INInteraction+HorseRideCore.h
//  HorseRideCore
//
//  Created by Vince Yuan on 6/23/17.
//  Copyright © 2017 Vince Yuan. All rights reserved.
//

#import <Intents/Intents.h>

@interface INInteraction (HorseRideCore)

@property (nonatomic, assign, readonly) BOOL representsSendMessageIntent;
@property (nonatomic, copy, readonly) NSString *messageContent;

@end
