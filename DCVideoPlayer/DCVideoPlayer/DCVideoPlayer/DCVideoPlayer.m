//
//  DCVideoPlayer.m
//
//  Created by DanaChu on 16/8/23.
//  Copyright © 2016年 DanaChu. All rights reserved.
//

#import "DCVideoPlayer.h"
#import "DCObserver.h"

@implementation DCVideoPlayerItem

- (instancetype)initWithTitle:(NSString *)title
                    URLString:(NSString *)urlString
{
    self = [super init];
    if (self) {
        _title = title;
        _url = urlString;
    }
    return self;
}

@end


@interface DCVideoPlayer()
<DCVideoPlayerViewDelegate>

@property (nonatomic, strong) AVPlayer *player; ///<  video player
@property (nonatomic, assign) BOOL hiddenControlView;
@property (nonatomic, strong) id timeObserverOne;
@property (nonatomic, weak) AVPlayerLayer *displayLayer;

@property (nonatomic, strong) CADisplayLink *link;
@property (nonatomic, assign) NSTimeInterval lastTime;

@property (nonatomic, assign) CGRect originFrame;

@end

@implementation DCVideoPlayer

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super init]) {
        _view = [DCVideoPlayerView PlayerView];
        [_view setFrame:frame];
        _view.delegate = self;
        _timeForHideControlView = 10;
        timeCount = _timeForHideControlView;
        _originFrame = frame;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
                        items:(NSArray<DCVideoPlayerItem *> *)items
{
    DCVideoPlayer *p = [self initWithFrame:frame];
    p.items = items;
    return p;
}

- (void)dealloc
{
    [self removeObserverForPlayer];
}

#pragma mark - DCVideoPlayerDelegate

- (void)playButtonPressed
{
    if (self.player.rate == 0.0) {
        [self.player play];
        [self.view setViewForPlay];
    }
}

- (void)pauseButtonPressed
{
    if (self.player.rate == 1.0) {
        [self.player pause];
        [self.view setViewForPause];
    }
}

- (void)dismissButtonPressed
{
    [self fullScreenButtonTaped:NO];
}

- (void)preButtonTaped
{
    [self replaceItemWithIndex:_currentIndex - 1];
}

- (void)nextButtonTaped
{
    [self replaceItemWithIndex:_currentIndex + 1];
}

- (void)menuButtonTaped
{
    
}

- (void)playerViewSingleTapped
{
    if (_view.controlEnable) {
        [_view hideControlView];
    }else{
        [_view showControlView];
    }
}

- (void)fullScreenButtonTaped:(BOOL)isFullScreen
{
    if (isFullScreen) {
        
        if (_delegate) {
            [_delegate player:self screenRotation:UIInterfaceOrientationLandscapeRight];
        }
        self.originFrame = self.view.frame;
        CGFloat height = [[UIScreen mainScreen] bounds].size.width;
        CGFloat width = [[UIScreen mainScreen] bounds].size.height;
        CGRect frame = CGRectMake((height - width) / 2, (width - height) / 2, width, height);;
        [UIView animateWithDuration:0.3f animations:^{
            self.view.frame = frame;
            [self.view setTransform:CGAffineTransformMakeRotation(M_PI_2)];
        } completion:^(BOOL finished) {
        }];
        
    }else{
        if (_delegate) {
            [_delegate player:self screenRotation:UIInterfaceOrientationPortrait];
        }
        [UIView animateWithDuration:0.3f animations:^{
            [self.view setTransform:CGAffineTransformIdentity];
            self.view.frame = self.originFrame;
        } completion:^(BOOL finished) {
        }];
        
    }

}

- (void)progressSliderValueChanged:(float)value
{
    [self resetTimeCount];
    
    double total = CMTimeGetSeconds([self.player.currentItem duration]);
    [self.view setTimeLabelWithCurrent:(value * total) total:total];

}

- (void)progressSliderTouchEnded:(float)value
{
    [_player pause];
    [self.view setViewForLoding];
    if (_player.status == AVPlayerStatusReadyToPlay) {
        double seekTime = CMTimeGetSeconds(_player.currentItem.duration) * value;
        __weak typeof(self) wSelf = self;
        [_player seekToTime:CMTimeMake(seekTime, 1) completionHandler:^(BOOL finished) {
            if (finished) {
                [wSelf.player play];
                [wSelf.view setViewForPlay];
            }
        }];
    }else{
        
        
    }
}

#pragma mark - private

static int timeCount = 0;

- (void)addObserverForPlayer
{
    if(_player){
        AVPlayerItem *currentItem = _player.currentItem;
        __weak typeof(self) wSelf = self;
        _timeObserverOne = [_player addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:nil usingBlock:^(CMTime time) {
             CMTimeGetSeconds(time);
            // calculate the time for slid and timelabel
            double current = CMTimeGetSeconds(time);
            double total = CMTimeGetSeconds([currentItem duration]);
            // set slid
            if(!wSelf.view.progressSlider.isSliding){
                [wSelf.view.progressSlider setValue:current/total];
                // set time label
                [wSelf.view setTimeLabelWithCurrent:current total:total];
            }
            // for the animation of hidden the control view
            if (wSelf.view.controlEnable) {
                timeCount--;
                if (timeCount == 0) [wSelf.view hideControlView];
            }else{
                timeCount = wSelf.timeForHideControlView;
            }
        }];
        
        [_player dc_addObserverBlockForKeyPath:@"status" block:^(id  _Nonnull __weak obj, id  _Nullable oldVal, id  _Nullable newVal) {
            AVPlayerStatus status = [newVal integerValue];
            switch (status) {
                case AVPlayerStatusUnknown:
                    self.view.activityIndicator.hidden = NO;
                    [self.view.activityIndicator startAnimating];
                    break;
                case AVPlayerStatusReadyToPlay:
                    NSLog(@"I'm ready！");
                    break;
                case AVPlayerStatusFailed:
                    
                    break;
            }
            
        }];
        
        [_player.currentItem dc_addObserverBlockForKeyPath:@"loadedTimeRanges" block:^(id  _Nonnull __weak obj, id  _Nullable oldVal, id  _Nullable newVal) {
            
            NSArray *loadedTimeRanges = (NSArray *)newVal;
            CMTimeRange timeRange = [loadedTimeRanges.firstObject CMTimeRangeValue];
            NSTimeInterval startSeconds = CMTimeGetSeconds(timeRange.start);
            NSTimeInterval durationSeconds = CMTimeGetSeconds(timeRange.duration);
            NSTimeInterval total = startSeconds + durationSeconds;
            // set progress view
            float pro = total/CMTimeGetSeconds(self.player.currentItem.duration);
            [self.view.progressView setProgress:pro animated:NO];
        }];
        
        
        [_displayLayer dc_addObserverBlockForKeyPath:@"readyForDisplay" block:^(id  _Nonnull __weak obj, id  _Nullable oldVal, id  _Nullable newVal) {
            
            if (![(NSNumber *)oldVal boolValue] && [(NSNumber *)newVal boolValue] && self.player.rate == 0.f) {
                
                [self.view setViewForReady];
                [_player pause];
                [self.view setViewForPause];
                if (self.player.rate == 0.f && _autoPlayWhenReady) {
                    [_player play];
                    [self.view setViewForPlay];
                }
            }
        }];
        
        [_player dc_addObserverBlockForNotificationName:AVPlayerItemDidPlayToEndTimeNotification block:^(id  _Nullable __weak obj, NSNotification * _Nonnull noti) {
            
            [self replaceItemWithIndex: _currentIndex + 1];
            
        }];
    
        [self dc_addObserverBlockForKeyPath:@"currentIndex" block:^(id  _Nonnull __weak obj, id  _Nullable oldVal, id  _Nullable newVal) {
            
            self.view.preButtonEnable = _currentIndex > 0;
            self.view.nextButtonEnable = _currentIndex < _items.count - 1;
        }];
        
        
        [self link];
        
    }
}

- (void)removeObserverForPlayer
{
    if (_player){
        [self.link invalidate];
        _link = nil;
        [_player removeTimeObserver:_timeObserverOne];
        [_player dc_removeObserverBlocksForKeyPath:@"status"];
        [_player dc_removeObserverBlocksForKeyPath:@"loadedTimeRanges"];
        [_displayLayer dc_removeObserverBlocksForKeyPath:@"readyForDisplay"];
        [_player dc_removeObserverWithNotificationName:AVPlayerItemDidPlayToEndTimeNotification];
        [self dc_removeObserverBlocksForKeyPath:@"currentIndex"];
    }
}

- (void)resetTimeCount
{
    timeCount = _timeForHideControlView;
}

- (void)upadte
{
    if (!self.view.isPlaying) return;
    NSTimeInterval current = CMTimeGetSeconds(self.player.currentTime);

    if (current==self.lastTime) {
        
        self.view.activityIndicator.hidden = NO;
        [self.view.activityIndicator startAnimating];
    }else{
        self.view.activityIndicator.hidden = YES;
        [self.view.activityIndicator stopAnimating];
    }
    self.lastTime = current;
}

- (void)replaceItemWithIndex:(NSUInteger)index
{
    if (index >= self.items.count)
    {
        [self replaceItemWithIndex:0];
        return;
    }
    
    [self.player pause];
    [self.view setViewForPause];
    self.currentIndex = index;
    DCVideoPlayerItem *playerItem = [self.items objectAtIndex:index];
    NSURL *URL = [NSURL URLWithString:playerItem.url];
    AVPlayerItem *item = [AVPlayerItem playerItemWithURL:URL];
    [self removeObserverForPlayer];
    [_player replaceCurrentItemWithPlayerItem:item];
    _view.titleLabel.text = playerItem.title;
    [self addObserverForPlayer];
    [self.view setViewForPrepare];
}

#pragma mark - setter getter

- (void)setItems:(NSArray<DCVideoPlayerItem *> *)items
{
    _items = items;
    DCVideoPlayerItem *playerItem = [items firstObject];
    _view.titleLabel.text = playerItem.title;
    NSURL *URL = [NSURL URLWithString:playerItem.url];
    AVPlayerItem *item = [AVPlayerItem playerItemWithURL:URL];
    if (!_player) {
        _player = [AVPlayer playerWithPlayerItem:item];
        AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:_player];
        playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
        playerLayer.contentsScale = [UIScreen mainScreen].scale;
        playerLayer.frame = self.view.bounds;
        [_view.displayView setDisplayLayer:playerLayer];
        _displayLayer = playerLayer;
    }else{
        [self removeObserverForPlayer];
        [_player replaceCurrentItemWithPlayerItem:item];
    }
    self.currentIndex = 0;
    [self addObserverForPlayer];
    [self.view setViewForPrepare];
}

- (CADisplayLink *)link
{
    if (!_link) {
        _link = [CADisplayLink displayLinkWithTarget:self selector:@selector(upadte)];
        [_link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];

    }
    return _link;
}


@end
