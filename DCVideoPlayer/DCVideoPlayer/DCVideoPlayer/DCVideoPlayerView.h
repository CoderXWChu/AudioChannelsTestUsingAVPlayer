//
//  DCVideoPlayerView.h
//  DCVideoPlayer
//
//  Created by DanaChu on 16/8/22.
//  Copyright © 2016年 DanaChu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DCSlider.h"
#import "DCDisplayView.h"
@protocol DCVideoPlayerViewDelegate;

@interface DCVideoPlayerView : UIView

@property (weak, nonatomic) IBOutlet DCDisplayView *displayView;
@property (weak, nonatomic) IBOutlet UIView *captionContainerView;
@property (weak, nonatomic) IBOutlet UIView *playerControlView;

// Top View
@property (weak, nonatomic) IBOutlet UIView *topControlView;
@property (weak, nonatomic) IBOutlet UIButton *dismissButton;
@property (weak, nonatomic) IBOutlet UIButton *FullScreenButton;
@property (weak, nonatomic) IBOutlet UIButton *menuButton;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

// bottom View
@property (weak, nonatomic) IBOutlet UIView *bottomControlView;
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet DCSlider *progressSlider;
@property (weak, nonatomic) IBOutlet UIButton *preButton;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;

// other view
@property (weak, nonatomic) IBOutlet UIButton *bigPlayButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;


@property (nonatomic, weak) id<DCVideoPlayerViewDelegate> delegate;

@property (nonatomic, assign) BOOL controlEnable;
@property (nonatomic, assign) BOOL isLoding;
@property (nonatomic, assign) BOOL isPlaying;

///< default NO;
@property (nonatomic, assign) BOOL hidePreButton;
@property (nonatomic, assign) BOOL hideNextButton;
@property (nonatomic, assign) BOOL hideMenuButton;
@property (nonatomic, assign) BOOL preButtonEnable;
@property (nonatomic, assign) BOOL nextButtonEnable;

+ (instancetype)PlayerView;
+ (instancetype)PlayerViewWithFrame:(CGRect)frame delegate:(id<DCVideoPlayerViewDelegate>)delegate;

- (void)hideControlView;
- (void)showControlView;

- (void)setViewForPrepare;
- (void)setViewForReady;
- (void)setViewForPlay;
- (void)setViewForPause;
- (void)setViewForLoding;

- (void)setTimeLabelWithCurrent:(NSTimeInterval)current total:(NSTimeInterval)total;

@end


@protocol DCVideoPlayerViewDelegate <NSObject>

- (void)playButtonPressed;

- (void)pauseButtonPressed;

- (void)dismissButtonPressed;

- (void)preButtonTaped;

- (void)nextButtonTaped;

- (void)menuButtonTaped;

- (void)playerViewSingleTapped;

- (void)fullScreenButtonTaped:(BOOL)isFullScreen;

- (void)progressSliderValueChanged:(float)value;

- (void)progressSliderTouchEnded:(float)value;

@end
