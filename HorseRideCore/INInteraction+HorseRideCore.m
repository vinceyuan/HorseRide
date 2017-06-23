//
//  INInteraction+HorseRideCore.m
//  HorseRideCore
//
//  Created by Vince Yuan on 6/23/17.
//  Copyright © 2017 Vince Yuan. All rights reserved.
//

#import "INInteraction+HorseRideCore.h"

@interface INIntent (HorseRideCore)

- (BOOL)isSendMessageIntent;
- (INSendMessageIntent *)sendMessageIntent;

@end

@implementation INIntent (HorseRideCore)

- (BOOL)isSendMessageIntent {
    return NO;
}

- (INSendMessageIntent *)sendMessageIntent {
    return nil;
}

@end

@implementation INSendMessageIntent (HorseRideCore)

- (BOOL)isSendMessageIntent {
    return YES;
}

- (INSendMessageIntent *)sendMessageIntent {
    return self;
}

@end

@implementation INInteraction (HorseRideCore)

- (BOOL)representsSendMessageIntent {
    return [[self intent] isSendMessageIntent];
}

- (NSString *)messageContent {
    return [[[self intent] sendMessageIntent] content];
}

@end
