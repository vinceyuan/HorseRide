//
//  HRChatView.m
//  HorseRideCore
//
//  Created by Vince Yuan on 6/23/17.
//  Copyright © 2017 Vince Yuan. All rights reserved.
//

#import "HRChatView.h"

@implementation HRChatView {
    UILabel *_contentLabel;
    UIImageView *_mockView;

    UIImage *_draftMock;
    UIImage *_sentMock;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _draftMock = [UIImage imageNamed:@"chatmockdraft.jpg"];
        _sentMock = [UIImage imageNamed:@"chatmock.jpg"];

        _mockView = [[UIImageView alloc] initWithImage:_draftMock];
        [_mockView setContentMode:UIViewContentModeScaleToFill];
        [self addSubview:_mockView];

        _contentLabel = [[UILabel alloc] init];
        [_contentLabel setNumberOfLines:0];
        [_contentLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [self addSubview:_contentLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    [_mockView setFrame:[self bounds]];

    [_contentLabel setText:_content];
    _contentLabel.textAlignment = NSTextAlignmentCenter;
    [_contentLabel setFrame:CGRectMake(70.0, 200.0, 150.0, 75.0)];
}

- (void)setSent:(BOOL)sent {
    if (_sent == sent) {
        return;
    }

    _sent = sent;

    UIImage *mockImage = (_sent ? _sentMock : _draftMock);
    [_mockView setImage:mockImage];
}

- (void)setContent:(NSString *)content {
    if ([_content isEqualToString:content]) {
        return;
    }
    _content = content;

    [self setNeedsLayout];
}
@end
