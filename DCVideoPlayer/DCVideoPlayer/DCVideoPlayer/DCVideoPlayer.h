//
//  DCVideoPlayer.h
//
//  Created by DanaChu on 16/8/23.
//  Copyright © 2016年 DanaChu. All rights reserved.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "DCVideoPlayerView.h"

@interface DCVideoPlayerItem : NSObject

@property (nonatomic, copy) NSString *url;   ///< url string for video
@property (nonatomic, copy) NSString *title; ///< title

- (instancetype)initWithTitle:(NSString *)title URLString:(NSString *)urlString;

@end


@protocol DCVideoPlayerDelegate;

@interface DCVideoPlayer : NSObject

@property (nonatomic, strong) DCVideoPlayerView *view; ///< view for player
@property (nonatomic, strong) NSArray<DCVideoPlayerItem *> *items; ///< items for video
@property (nonatomic, assign) NSTimeInterval timeForHideControlView; ///< max time for hidden control view
@property (nonatomic, assign) BOOL autoPlayWhenReady; ///< auto play when player is ready. Default: NO;

@property (nonatomic, assign) NSUInteger currentIndex; // current idex of video

@property (nonatomic, weak) id<DCVideoPlayerDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame;
- (instancetype)initWithFrame:(CGRect)frame items:(NSArray<DCVideoPlayerItem *>*)items;

@end

@protocol DCVideoPlayerDelegate <NSObject>

- (void)dismissButtonTaped;

- (void)player:(DCVideoPlayer *)videoPlayer screenRotation:(UIInterfaceOrientation)orientation;

@end
