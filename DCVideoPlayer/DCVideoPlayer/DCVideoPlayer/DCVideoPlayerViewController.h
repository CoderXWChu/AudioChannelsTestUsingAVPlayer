//
//  DCVideoPlayerViewController.h
//  DCVideoPlayer
//
//  Created by DanaChu on 16/8/22.
//  Copyright © 2016年 DanaChu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DCVideoPlayer.h"

@interface DCVideoPlayerViewController : UIViewController

@property (nonatomic, copy, readonly) NSArray<DCVideoPlayerItem *> *items;

@property (nonatomic, assign) BOOL hideMenuButton; ///< hide Menu Button
@property (nonatomic, assign) BOOL hidePreButton; ///< hide pre Button
@property (nonatomic, assign) BOOL hideNextButton; ///< hide Next Button

@property (nonatomic, assign) BOOL autoPlayWhenReady; ///< auto Play When Ready

- (instancetype)initWithURLString:(NSArray *)urls;
- (instancetype)initWithItems:(NSArray <DCVideoPlayerItem *>*)items;

@end

