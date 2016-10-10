//
//  DCDisplayView.m
//  DCVideoPlayer
//
//  Created by DanaChu on 16/8/23.
//  Copyright © 2016年 DanaChu. All rights reserved.
//

#import "DCDisplayView.h"
#import <AVFoundation/AVFoundation.h>

@interface DCDisplayView()
@property (nonatomic, weak) AVPlayerLayer *avLayer;
@end

@implementation DCDisplayView

- (void)setDisplayLayer:(AVPlayerLayer *)layer
{
    layer.frame = self.bounds;
    [self.layer addSublayer:layer];
    self.avLayer = layer;
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.avLayer setFrame:self.bounds];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
