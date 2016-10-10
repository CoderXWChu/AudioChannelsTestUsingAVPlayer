//
//  DCVideoPlayerView.m
//  DCVideoPlayer
//
//  Created by DanaChu on 16/8/22.
//  Copyright © 2016年 DanaChu. All rights reserved.
//

#import "DCVideoPlayerView.h"

@interface DCVideoPlayerView()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topMarginConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomMarginConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topControlViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomControlViewHeightConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *menuButtonWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *PreButtonWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nextButtonWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sliderTrailingConstraint;

@property (nonatomic, assign) CGPoint lastPanPoint; ///< 上一个点
@end

@implementation DCVideoPlayerView

- (void)awakeFromNib
{
    [self.playButton setImage:[self imageWithName:@"player_play"] forState:UIControlStateNormal];
    [self.bigPlayButton setImage:[self imageWithName:@"player_play_big"] forState:UIControlStateNormal];
    [self.dismissButton setImage:[self imageWithName:@"player_close"] forState:UIControlStateNormal];
    [self.FullScreenButton setImage:[self imageWithName:@"player_fullscreen"] forState:UIControlStateNormal];
    [self.FullScreenButton setImage:[self imageWithName:@"player_shrinkscreen"] forState:UIControlStateSelected];
    [self.progressSlider setThumbImage:[self imageWithName:@"player_point"] forState:UIControlStateNormal];
    [self.preButton setImage:[self imageWithName:@"player_next"] forState:UIControlStateNormal];
    [self.nextButton setImage:[self imageWithName:@"player_next"] forState:UIControlStateNormal];
    [self.menuButton setImage:[self imageWithName:@"player_next"] forState:UIControlStateNormal];
    
    [self.playButton setTitle:@"" forState:UIControlStateNormal];
    [self.bigPlayButton setTitle:@"" forState:UIControlStateNormal];
    [self.dismissButton setTitle:@"" forState:UIControlStateNormal];
    [self.FullScreenButton setTitle:@"" forState:UIControlStateNormal];
    [self.preButton setTitle:@"" forState:UIControlStateNormal];
    [self.nextButton setTitle:@"" forState:UIControlStateNormal];
    [self.menuButton setTitle:@"" forState:UIControlStateNormal];
    self.titleLabel.text = @"";
    
    [self.progressSlider setMinimumTrackTintColor:[UIColor whiteColor]];
    [self.progressSlider setMaximumTrackTintColor:[[UIColor lightGrayColor] colorWithAlphaComponent:0.5]];
    self.progressSlider.backgroundColor = [UIColor clearColor];
    [self setTimeLabelWithCurrent:0 total:0];
    self.progressSlider.value = 0.f;
    self.progressView.progress = 0.f;
    self.activityIndicator.hidden = YES;
    self.bigPlayButton.hidden = YES;
    
    [self setClipsToBounds:YES];
}

+ (instancetype)PlayerView
{
    return (DCVideoPlayerView *)[[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([DCVideoPlayerView class]) owner:nil options:nil] firstObject];
}

+ (instancetype)PlayerViewWithFrame:(CGRect)frame delegate:(id<DCVideoPlayerViewDelegate>)delegate
{
    DCVideoPlayerView *pv = [self PlayerView];
    pv.frame = frame;
    pv.delegate = delegate;
    return pv;
}

#pragma mark - Action

- (IBAction)PlayButtonTaped{
    
    self.playButton.selected = !self.playButton.selected;
    self.bigPlayButton.selected = !self.bigPlayButton.selected;
    
    if (self.playButton.selected) {
        self.isPlaying = YES;
        self.bigPlayButton.hidden = YES;
        [self.playButton setImage:[self imageWithName:@"player_pause"] forState:UIControlStateNormal];
        [self.bigPlayButton setImage:[self imageWithName:@"player_pause_big"] forState:UIControlStateNormal];
    }else{
        [self.playButton setImage:[self imageWithName:@"player_play"] forState:UIControlStateNormal];
        [self.bigPlayButton setImage:[self imageWithName:@"player_play_big"] forState:UIControlStateNormal];
        self.bigPlayButton.hidden = NO;
        self.isPlaying = NO;
    }
    
    if (_delegate) {
        if (self.playButton.selected){
            [_delegate playButtonPressed];
        }else{
            [_delegate pauseButtonPressed];
        }
    }
}

- (IBAction)dismissButtonTaped {
    
    if (_delegate) {
        [_delegate dismissButtonPressed];
    }
}

- (IBAction)PreButtonTaped:(UIButton *)sender {
    
    if (_delegate) {
        [_delegate preButtonTaped];
    }
}

- (IBAction)nextButtonTaped:(UIButton *)sender {
    
    if (_delegate) {
        [_delegate nextButtonTaped];
    }   
}

- (IBAction)menuButtonTaped:(UIButton *)sender {
    
    if (_delegate) {
        [_delegate menuButtonTaped];
    }
}


- (IBAction)fullScreenButtonTaped {
    
    self.FullScreenButton.selected = !self.FullScreenButton.selected;
    
    if (_delegate) {
        if (self.FullScreenButton.selected){
            [_delegate fullScreenButtonTaped:YES];
        }else{
            [_delegate fullScreenButtonTaped:NO];
        }
    }
    
}

- (IBAction)progressSlidreValueChanged:(UISlider *)sender {
    self.progressSlider.isSliding = YES;
    if (_delegate) {
        [_delegate progressSliderValueChanged:sender.value];
    }
}

- (IBAction)progressSliderTouchEnd:(UISlider *)sender {
    if (_delegate) {
        [_delegate progressSliderTouchEnded:sender.value];
    }
    self.progressSlider.isSliding = NO;
}
- (IBAction)pregressSliderTouchCancel:(id)sender {
    
    self.progressSlider.isSliding = NO;
    
}

- (IBAction)playerViewTaped:(UITapGestureRecognizer *)sender {
    
    if (_delegate) {
        [_delegate playerViewSingleTapped];
    }
}

- (IBAction)playerViewPanAction:(UIPanGestureRecognizer *)sender {
//    
//    if (sender.state == UIGestureRecognizerStateBegan) {
//        
//        CGPoint curPoint = [sender locationInView:self];
//        CGFloat width = self.bounds.size.width;
//        if (curPoint.x > _lastPanPoint.x) {
//            
//        }
//        
//        NSLog(@"%@", NSStringFromCGPoint(curPoint));
//        
//    }
    
    
}

#pragma mark - Public

- (BOOL)controlEnable
{
    return self.topMarginConstraint.constant == 0;
}


- (void)hideControlView
{
    self.topMarginConstraint.constant = - self.topControlViewHeightConstraint.constant;
    self.bottomMarginConstraint.constant = - self.bottomControlViewHeightConstraint.constant;
    [UIView animateWithDuration:0.3 animations:^{
        [self layoutIfNeeded];
    }];
}

- (void)showControlView
{
    self.topMarginConstraint.constant = 0;
    self.bottomMarginConstraint.constant = 0;
    [UIView animateWithDuration:0.3 animations:^{
        [self layoutIfNeeded];
    }];
}


- (void)setViewForPrepare
{
    self.isPlaying = NO;
    self.progressSlider.enabled = NO;
    self.playButton.selected = NO;
    self.playButton.enabled = NO;
    self.bigPlayButton.selected = NO;
    self.bigPlayButton.enabled = NO;
    self.bigPlayButton.hidden = YES;
    self.preButton.enabled = NO;
    self.nextButton.enabled = NO;
    self.menuButton.enabled = NO;
    self.FullScreenButton.enabled = NO;
    self.activityIndicator.hidden = NO;
    [self.activityIndicator startAnimating];
}

- (void)setViewForReady
{
    self.isPlaying = NO;
    self.progressSlider.enabled = YES;
    self.playButton.enabled = YES;
    self.bigPlayButton.enabled = YES;
    self.bigPlayButton.hidden = NO;
    self.preButton.enabled = YES;
    self.nextButton.enabled = YES;
    self.menuButton.enabled = YES;
    self.FullScreenButton.enabled = YES;
    self.activityIndicator.hidden = YES;
    [self.activityIndicator stopAnimating];
}

- (void)setViewForPlay
{
    
    self.isPlaying = YES;
    self.playButton.selected = YES;
    self.bigPlayButton.selected = YES;
    self.bigPlayButton.hidden = YES;
    self.activityIndicator.hidden = YES;
    [self.activityIndicator stopAnimating];
    [self.playButton setImage:[self imageWithName:@"player_pause"] forState:UIControlStateNormal];
    [self.bigPlayButton setImage:[self imageWithName:@"player_pause_big"] forState:UIControlStateNormal];
}

- (void)setViewForPause
{
    self.isPlaying = NO;
    self.playButton.selected = NO;
    self.bigPlayButton.selected = NO;
    self.bigPlayButton.hidden = NO;
    [self.playButton setImage:[self imageWithName:@"player_play"] forState:UIControlStateNormal];
    [self.bigPlayButton setImage:[self imageWithName:@"player_play_big"] forState:UIControlStateNormal];
}

- (void)setViewForLoding
{
//    self.isPlaying = NO;
    self.isLoding = YES;
    self.playButton.selected = YES;
    self.bigPlayButton.selected = YES;
    self.bigPlayButton.hidden = YES;
    self.activityIndicator.hidden = NO;
    [self.activityIndicator startAnimating];
    [self.playButton setImage:[self imageWithName:@"player_pause"] forState:UIControlStateNormal];
    [self.bigPlayButton setImage:[self imageWithName:@"player_pause_big"] forState:UIControlStateNormal];
}


- (void)setTimeLabelWithCurrent:(NSTimeInterval)current total:(NSTimeInterval)total
{
    self.timeLabel.text = [NSString stringWithFormat:@"%@/%@",[self convertTime:current], [self convertTime:total]];
}


#pragma mark - setter getter 

- (void)setHidePreButton:(BOOL)hidePreButton
{
    _hidePreButton = hidePreButton;
    if (hidePreButton) {
        self.PreButtonWidthConstraint.constant = 0;
        [self layoutIfNeeded];
    }
}
- (void)setHideNextButton:(BOOL)hideNextButton
{
    _hideNextButton = hideNextButton;
    if (hideNextButton) {
        self.nextButtonWidthConstraint.constant = 0;
        self.sliderTrailingConstraint.constant = 10;
        [self layoutIfNeeded];
    }
}

- (void)setHideMenuButton:(BOOL)hideMenuButton
{
    _hideMenuButton = hideMenuButton;
    if (hideMenuButton) {
        self.menuButtonWidthConstraint.constant = 0;
        [self layoutIfNeeded];
    }
}

- (void)setPreButtonEnable:(BOOL)preButtonEnable
{
    _preButtonEnable = preButtonEnable;
    self.preButton.enabled = preButtonEnable;
}

- (void)setNextButtonEnable:(BOOL)nextButtonEnable
{
    _nextButtonEnable = nextButtonEnable;
    self.nextButton.enabled = nextButtonEnable;
}


#pragma mark - Private

- (UIImage *)imageWithName:(NSString *)imageName
{
    return [UIImage imageNamed:[NSString stringWithFormat:@"%@@2x.png", imageName]];
}

- (NSString *)convertTime:(CGFloat)second{
    NSDate *d = [NSDate dateWithTimeIntervalSince1970:second];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    if (second/3600 >= 1) {
        [formatter setDateFormat:@"HH:mm:ss"];
    } else {
        [formatter setDateFormat:@"mm:ss"];
    }
    NSString *showtimeNew = [formatter stringFromDate:d];
    return showtimeNew;
}

@end
