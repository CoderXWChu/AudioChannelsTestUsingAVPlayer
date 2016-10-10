//
//  DCDisplayView.h
//  DCVideoPlayer
//
//  Created by DanaChu on 16/8/23.
//  Copyright © 2016年 DanaChu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AVPlayerLayer;

@interface DCDisplayView : UIView

- (void)setDisplayLayer:(AVPlayerLayer *)layer;

@end
