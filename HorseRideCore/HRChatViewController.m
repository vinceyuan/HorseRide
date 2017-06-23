//
//  HRChatViewController.m
//  HorseRideCore
//
//  Created by Vince Yuan on 6/23/17.
//  Copyright © 2017 Vince Yuan. All rights reserved.
//

#import "HRChatViewController.h"
#import "HRChatView.h"

@interface HRChatViewController ()

@property (null_resettable, nonatomic, strong) HRChatView *view;

@end

@implementation HRChatViewController

@dynamic view;

- (void)loadView {
    HRChatView *chatView = [[HRChatView alloc] init];
    [self setView:chatView];
}

- (NSString *)messageContent {
    return [[self view] content];
}

- (void)setMessageContent:(NSString *)messageContent {
    [[self view] setContent:messageContent];
}

- (void)setSent:(BOOL)sent {
    [[self view] setSent:sent];
}

- (BOOL)isSent {
    return [[self view] isSent];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
